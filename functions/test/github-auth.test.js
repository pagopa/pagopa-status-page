const assert = require('node:assert/strict');
const { test } = require('node:test');
const { HttpRequest } = require('@azure/functions');
const { createHandler } = require('../src/github-auth');

const origin = 'https://pagopa.github.io';
const env = { GITHUB_CLIENT_ID: 'test-client', ALLOWED_ORIGINS: origin };
const context = { error() {} };

function request(body = {}, overrides = {}) {
  return {
    method: 'POST',
    headers: new Headers({ origin, 'Content-Type': 'application/json' }),
    text: async () => JSON.stringify(body),
    ...overrides,
  };
}

test('preflight permits only the configured origin without calling GitHub', async () => {
  const handler = createHandler('device-code', {
    env,
    fetchGithub: () => assert.fail('Unexpected upstream request'),
  });
  const result = await handler(request({}, { method: 'OPTIONS' }), context);
  assert.equal(result.status, 204);
  assert.equal(result.headers['Access-Control-Allow-Origin'], origin);
  assert.equal(result.headers['Access-Control-Allow-Methods'], 'POST, OPTIONS');
  assert.equal(result.headers.Vary, 'Origin');
});

test('missing, malicious and prefix-matching origins are rejected', async () => {
  const handler = createHandler('token', {
    env,
    fetchGithub: () => assert.fail('Unexpected upstream request'),
  });
  for (const value of ['', 'https://evil.example', `${origin}.evil.example`]) {
    const result = await handler(request({}, {
      headers: new Headers({ origin: value }),
    }), context);
    assert.equal(result.status, 403);
    assert.equal(result.headers['Access-Control-Allow-Origin'], undefined);
  }
});

test('device code uses the server client ID and never forwards arbitrary input', async () => {
  const data = {
    device_code: 'device-code',
    user_code: 'ABCD-EFGH',
    verification_uri: 'https://github.com/login/device',
    interval: 5,
    expires_in: 900,
  };
  const handler = createHandler('device-code', {
    env,
    fetchGithub: async (url, options) => {
      assert.equal(url, 'https://github.com/login/device/code');
      assert.deepEqual(JSON.parse(options.body), { client_id: 'test-client' });
      assert.equal(options.redirect, 'error');
      assert.ok(options.signal instanceof AbortSignal);
      return Response.json(data);
    },
  });
  const result = await handler(request({
    client_id: 'attacker-client', scope: 'repo', url: 'https://evil.example',
  }), context);
  assert.equal(result.status, 200);
  assert.deepEqual(result.jsonBody, data);
  assert.equal(result.headers['Cache-Control'], 'no-store');
});

test('token requests use the device grant and preserve OAuth success and polling errors', async () => {
  for (const data of [
    { access_token: 'test-token', token_type: 'bearer' },
    { error: 'authorization_pending' },
    { error: 'slow_down', interval: 10 },
    { error: 'expired_token', error_description: 'Expired' },
    { error: 'access_denied' },
  ]) {
    const handler = createHandler('token', {
      env,
      fetchGithub: async (url, options) => {
        assert.equal(url, 'https://github.com/login/oauth/access_token');
        assert.deepEqual(JSON.parse(options.body), {
          client_id: 'test-client',
          device_code: 'device_code-123',
          grant_type: 'urn:ietf:params:oauth:grant-type:device_code',
        });
        return Response.json(data);
      },
    });
    const result = await handler(request({
      device_code: 'device_code-123', grant_type: 'attacker-grant',
    }), context);
    assert.equal(result.status, 200);
    assert.deepEqual(result.jsonBody, data);
  }
});

test('invalid device codes and request bodies do not reach GitHub', async () => {
  const handler = createHandler('token', {
    env,
    fetchGithub: () => assert.fail('Unexpected upstream request'),
  });
  for (const body of [
    {}, { device_code: '' }, { device_code: 123 },
    { device_code: 'x'.repeat(257) }, { device_code: 'a b' }, [], null,
  ]) {
    assert.equal((await handler(request(body), context)).status, 400);
  }
  assert.equal((await handler(request({}, {
    text: async () => '{invalid',
  }), context)).status, 400);
  assert.equal((await handler(request({}, {
    text: async () => 'x'.repeat(2049),
  }), context)).status, 413);
  assert.equal((await handler(request({}, {
    headers: new Headers({ origin, 'Content-Type': 'text/plain' }),
  }), context)).status, 415);
});

test('unconfigured client ID and unsupported method produce explicit errors', async () => {
  const handler = createHandler('device-code', {
    env: { ALLOWED_ORIGINS: origin },
    fetchGithub: () => assert.fail('Unexpected upstream request'),
  });
  assert.equal((await handler(request(), context)).status, 503);
  const result = await handler(request({}, { method: 'GET' }), context);
  assert.equal(result.status, 405);
  assert.equal(result.headers.Allow, 'POST, OPTIONS');
});

test('network, timeout and invalid upstream JSON errors are surfaced without secrets', async () => {
  for (const [cause, status] of [
    [new TypeError('network details'), 502],
    [new SyntaxError('response details'), 502],
    [new DOMException('timeout details', 'TimeoutError'), 504],
  ]) {
    const logs = [];
    const handler = createHandler('token', {
      env,
      fetchGithub: async () => { throw cause; },
    });
    const result = await handler(request({ device_code: 'test-code' }), {
      error: (message) => logs.push(message),
    });
    assert.equal(result.status, status);
    assert.equal(result.headers['Access-Control-Allow-Origin'], origin);
    assert.equal(logs.length, 1);
    assert.ok(!JSON.stringify(result).includes('details'));
    assert.ok(!logs.join().includes('details'));
  }
});

test('upstream HTTP failures and malformed response shapes are handled', async () => {
  for (const [upstream, expected] of [
    [Response.json({ error: 'incorrect_client_credentials' }, { status: 401 }), 401],
    [Response.json({ error: 'rate_limit' }, { status: 429 }), 429],
    [Response.json({ internal: 'details' }, { status: 500 }), 502],
    [Response.json([]), 502],
    [Response.json(null), 502],
    [new Response('<html>error</html>'), 502],
  ]) {
    const handler = createHandler('device-code', {
      env,
      fetchGithub: async () => upstream,
    });
    assert.equal((await handler(request(), context)).status, expected);
  }
});

test('unexpected programming errors are not swallowed', async () => {
  const cause = new Error('Unexpected bug');
  const handler = createHandler('device-code', {
    env,
    fetchGithub: async () => { throw cause; },
  });
  await assert.rejects(handler(request(), context), cause);
});

test('handler accepts an Azure Functions HTTP request', async () => {
  const handler = createHandler('token', {
    env,
    fetchGithub: async () => Response.json({ error: 'authorization_pending' }),
  });
  const azureRequest = new HttpRequest({
    method: 'POST',
    url: 'https://auth.example/api/github/token',
    headers: { Origin: origin, 'Content-Type': 'application/json; charset=utf-8' },
    body: { string: JSON.stringify({ device_code: 'test-code' }) },
  });
  const result = await handler(azureRequest, context);
  assert.equal(result.status, 200);
  assert.equal(result.jsonBody.error, 'authorization_pending');
});

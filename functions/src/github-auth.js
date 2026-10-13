const endpoints = {
  'device-code': 'https://github.com/login/device/code',
  token: 'https://github.com/login/oauth/access_token',
};

function createHandler(operation, { env = process.env, fetchGithub = fetch } = {}) {
  if (!Object.hasOwn(endpoints, operation)) {
    throw new Error('Unknown GitHub OAuth operation');
  }

  return async (request, context) => {
    const origin = request.headers.get('origin');
    const allowedOrigins = (env.ALLOWED_ORIGINS ?? 'https://pagopa.github.io')
      .split(',')
      .map((value) => value.trim())
      .filter(Boolean);
    const headers = { 'Cache-Control': 'no-store', Vary: 'Origin' };
    const response = (status, jsonBody) => ({ status, headers, jsonBody });
    const error = (status, code, description) =>
      response(status, { error: code, error_description: description });

    if (!origin || !allowedOrigins.includes(origin)) {
      return error(403, 'origin_not_allowed', 'Origine non autorizzata.');
    }

    headers['Access-Control-Allow-Origin'] = origin;
    headers['Access-Control-Allow-Methods'] = 'POST, OPTIONS';
    headers['Access-Control-Allow-Headers'] = 'Content-Type, Accept';

    if (request.method === 'OPTIONS') {
      return { status: 204, headers };
    }
    if (request.method !== 'POST') {
      headers.Allow = 'POST, OPTIONS';
      return error(405, 'method_not_allowed', 'Metodo non consentito.');
    }
    if (!env.GITHUB_CLIENT_ID?.trim()) {
      context.error('GITHUB_CLIENT_ID is not configured.');
      return error(503, 'login_not_configured', 'Servizio di login non configurato.');
    }
    if (request.headers.get('content-type')?.split(';')[0].trim().toLowerCase() !==
        'application/json') {
      return error(415, 'unsupported_media_type', 'Inviare un corpo JSON.');
    }

    const text = await request.text();
    if (Buffer.byteLength(text, 'utf8') > 2048) {
      return error(413, 'request_too_large', 'Richiesta troppo grande.');
    }
    let body;
    try {
      body = JSON.parse(text);
    } catch (cause) {
      if (!(cause instanceof SyntaxError)) throw cause;
      return error(400, 'invalid_request', 'JSON non valido.');
    }
    if (!body || typeof body !== 'object' || Array.isArray(body)) {
      return error(400, 'invalid_request', 'Inviare un oggetto JSON.');
    }

    // Only server-controlled parameters and a validated device code reach GitHub.
    const payload = { client_id: env.GITHUB_CLIENT_ID.trim() };
    if (operation === 'token') {
      if (typeof body.device_code !== 'string' ||
          !/^[A-Za-z0-9_-]{1,256}$/.test(body.device_code)) {
        return error(400, 'invalid_request', 'device_code non valido.');
      }
      payload.device_code = body.device_code;
      payload.grant_type = 'urn:ietf:params:oauth:grant-type:device_code';
    }

    let upstream;
    let data;
    try {
      upstream = await fetchGithub(endpoints[operation], {
        method: 'POST',
        headers: {
          Accept: 'application/json',
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(payload),
        signal: AbortSignal.timeout(15000),
        redirect: 'error',
      });
      data = await upstream.json();
    } catch (cause) {
      if (cause.name === 'TimeoutError' || cause.name === 'AbortError') {
        context.error('GitHub OAuth request timed out.');
        return error(504, 'github_timeout', 'GitHub non ha risposto in tempo.');
      }
      if (cause instanceof TypeError || cause instanceof SyntaxError) {
        context.error('GitHub OAuth network or JSON response error.');
        return error(502, 'github_unavailable', 'Servizio GitHub non disponibile.');
      }
      throw cause;
    }
    if (!data || typeof data !== 'object' || Array.isArray(data)) {
      return error(502, 'invalid_github_response', 'Risposta GitHub non valida.');
    }
    if (upstream.status >= 500) {
      return error(502, 'github_unavailable', 'Servizio GitHub non disponibile.');
    }

    // OAuth polling errors (authorization_pending, slow_down, etc.) remain intact.
    return response(upstream.status, data);
  };
}

module.exports = { createHandler };

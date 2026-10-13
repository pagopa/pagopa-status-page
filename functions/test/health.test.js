const assert = require('node:assert/strict');
const { test } = require('node:test');
const { healthHandler } = require('../src/health');

test('health endpoint returns a successful healthy status', () => {
  assert.deepEqual(healthHandler(), {
    status: 200,
    jsonBody: { status: 'Healthy' },
  });
});

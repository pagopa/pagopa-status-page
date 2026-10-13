const { app } = require('@azure/functions');
const { createHandler } = require('./github-auth');
const { healthHandler } = require('./health');

for (const operation of ['device-code', 'token']) {
  app.http(`github-${operation}`, {
    route: `api/github/${operation}`,
    methods: ['POST', 'OPTIONS'],
    authLevel: 'anonymous',
    handler: createHandler(operation),
  });
}

app.http('health', {
  route: 'info',
  methods: ['GET'],
  authLevel: 'anonymous',
  handler: healthHandler,
});

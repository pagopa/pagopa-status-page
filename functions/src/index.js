const { app } = require('@azure/functions');
const { createHandler } = require('./github-auth');

for (const operation of ['device-code', 'token']) {
  app.http(`github-${operation}`, {
    route: `github/${operation}`,
    methods: ['POST', 'OPTIONS'],
    authLevel: 'anonymous',
    handler: createHandler(operation),
  });
}

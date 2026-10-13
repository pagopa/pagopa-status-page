function healthHandler() {
  return {
    status: 200,
    jsonBody: { status: 'Healthy' },
  };
}

module.exports = { healthHandler };

# Status Page

A [Status Page](https://pagopa.github.io/pagopa-status-page/#/) for all the pagoPa products

## Getting Started

To run locally:

``` shell
flutter run -d chrome --web-port=8888 \
  --dart-define=GITHUB_AUTH_API_URL=http://localhost:7071/api
```

Start the authentication function first as described below. Disabling browser
security is not needed for GitHub login. Other services called directly by the
page must independently allow the page's origin through their CORS configuration.

# How to Build

1. Run this command:
``` shell
flutter build web --base-href /pagopa-status-page/ \
  --dart-define=GITHUB_AUTH_API_URL=https://<function-app>.azurewebsites.net/api
```
2. Built files are in `/build/web` 

## GitHub authentication Azure Function

GitHub's Device Flow endpoints do not support browser CORS. The Node.js Azure
Function in `functions/` forwards only these two operations to fixed GitHub URLs:

| Endpoint | JSON body | Purpose |
| --- | --- | --- |
| `POST /api/github/device-code` | `{}` | Obtain the user and device codes |
| `POST /api/github/token` | `{"device_code":"..."}` | Poll for authorization |
| `GET /info` | — | Anonymous Azure health check |

The frontend retains the existing polling, cancellation and token storage behavior.
Calls to `api.github.com` still go directly from the browser to GitHub.
No client secret or Function key is required for this Device Flow.

### Local development

Requires Node.js 22 and Azure Functions Core Tools v4.

```shell
cd functions
npm ci
cp local.settings.json.example local.settings.json
npm start
```

In the GitHub application settings, enable **Device Flow** and set
`GITHUB_CLIENT_ID` in `local.settings.json` to that application's client ID.
The example uses the client ID previously configured in the frontend.
`local.settings.json` is ignored by Git and excluded from deployment.

`ALLOWED_ORIGINS` is a comma-separated list of exact origins, without paths or
trailing slashes. The local example permits `https://pagopa.github.io` and
`http://localhost:8888`; use that same port for Flutter.

### Deploy to Azure

For automatic deployment to an existing Function App, use
[Deploy GitHub auth Function](.github/workflows/deploy-function.yml).
It runs on changes to `functions/` in `main` or manually, with tests only on
pull requests. Configure the `dev` environment variables and Azure OIDC
identity using the [pipeline setup guide](.azure/pipeline-setup.md).

The workflow builds and publishes
`ghcr.io/pagopa/pagopa-status-page:latest` (and a commit-SHA tag) to GitHub
Container Registry, then restarts the existing Function App so it pulls the
updated image. Configure the app as a Linux custom-container Function App and
select `ghcr.io/pagopa/pagopa-status-page:latest` in Deployment Center. The
GitHub Container Registry package must be public, or the Function App must have
credentials to pull the private package.

Set `GITHUB_CLIENT_ID` and `ALLOWED_ORIGINS` in the Function App's application
settings, along with `FUNCTIONS_WORKER_RUNTIME=node`. The workflow's `dev`
GitHub environment also needs the Azure OIDC variables documented in the
[pipeline setup guide](.azure/pipeline-setup.md). It does not provision Azure
resources.
The function handles CORS itself, including `OPTIONS`. Leave Azure's platform
CORS allowlist empty to avoid conflicting headers, and never configure `*`.
If an existing app already has platform CORS rules, remove them in its Azure
portal CORS settings before using the function's allowlist.

In the repository's GitHub **Settings > Environments > github-pages > Variables**,
set `GITHUB_AUTH_API_URL` to `https://<function-app>.azurewebsites.net/api` and
rerun the Pages deployment. This is a public URL, not a secret. The Pages workflow
passes it to Flutter at build time. If it is absent or invalid, login displays a
configuration error; guest access remains available.

The endpoints must be anonymous because the frontend is public: a Function key
embedded in the page would not protect them. CORS is a browser restriction, not
authentication against non-browser callers. For a public production deployment,
apply rate limits at an API Management gateway or equivalent ingress; if using
a gateway, configure `GITHUB_AUTH_API_URL` with its API base URL. Do not log
request or response bodies: they contain device codes and access tokens.
Responses are marked `Cache-Control: no-store`.

The access token is still stored in browser local storage, as before. Restrict
application permissions and protect the page against XSS; moving tokens into
server-side sessions would require a separate authentication design.

To run the function's unit tests:

```shell
cd functions
npm test
```

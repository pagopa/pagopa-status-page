FROM mcr.microsoft.com/azure-functions/node:4-node22

ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true

COPY package*.json ${AzureWebJobsScriptRoot}/
RUN cd ${AzureWebJobsScriptRoot} && npm ci --omit=dev

COPY host.json ${AzureWebJobsScriptRoot}/
COPY src ${AzureWebJobsScriptRoot}/src

const dns_d = ".dev.platform.pagopa.it";
const dns_u = ".uat.platform.pagopa.it";
const dns_p = ".platform.pagopa.it";

const apim_d = "https://api${dns_d}";
const apim_u = "https://api${dns_u}";
const apim_p = "https://api${dns_p}";

const basePath = "/shared/statuspage/v1/info?product=";


const lastUpdatedKey = "last-updated";


const projectsCore = {
  "ApiConfig - Cacher (Oracle)": {
    "product": "apiconfigcacheo",
    "repository": "pagopa-api-config-cache",
    "pipeline": "https://github.com/pagopa/pagopa-api-config-cache/actions/workflows/release_deploy.yml",
    "env": "AKS",
    "actions": "GHA"
  },
  "ApiConfig - Cacher (Postgres)": {
    "product": "apiconfigcachep",
    "repository": "pagopa-api-config-cache",
    "pipeline": "https://github.com/pagopa/pagopa-api-config-cache/actions/workflows/release_deploy.yml",
    "env": "AKS",
    "actions": "GHA"
  },
  "ApiConfig - Core": {
    "product": "apiconfig",
    "repository": "pagopa-api-config",
    "pipeline": "https://github.com/pagopa/pagopa-api-config/actions/workflows/release_deploy.yml",
    "env": "AKS",
    "actions": "GHA"
  },
  "ApiConfig - FrontEnd": {
    "type": "frontend",
    "host": "config",
    "repository": "pagopa-api-config-fe",
    "pipeline": "https://github.com/pagopa/pagopa-api-config-fe/actions/workflows/release_deploy.yml",
    "env": "AZ",
    "actions": "GHA"
  },
    "ApiConfig - SelfCare integration": {
    "product": "apiconfigselfcare",
    "repository": "pagopa-api-config-selfcare-integration",
    "pipeline": "https://github.com/pagopa/pagopa-api-config-selfcare-integration/actions/workflows/release_deploy.yml",
    "env": "AKS",
    "actions": "GHA"
  },
  "AFM-Calculator": {
    "product": "afmcalculator",
    "repository": "pagopa-afm-calculator",
    "pipeline": "https://github.com/pagopa/pagopa-afm-calculator/actions/workflows/release_deploy.yml",
    "env": "AKS",
    "actions": "GHA"
  },
  "AFM-Utils": {
    "product": "afmutils",
    "repository": "pagopa-afm-utils",
    "pipeline": "https://github.com/pagopa/pagopa-afm-utils/actions/workflows/release_deploy.yml",
    "env": "AKS",
    "actions": "GHA"
  },
  "AFM-Marketplace": {
    "product": "afmmarketplace",
    "repository": "pagopa-afm-marketplace-be",
    "pipeline": "https://github.com/pagopa/pagopa-afm-marketplace-be/actions/workflows/release_deploy.yml",
    "env": "AKS",
    "actions": "GHA"
  },
  "Authorizer": {
    "product": "authorizer",
    "repository": "pagopa-platform-authorizer",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=1299",
    "env": "AZ",
    "actions": "AZDO"
  },
  "Authorizer Configurator": {
    "product": "authorizerconfig",
    "repository": "pagopa-platform-authorizer-config",
    "pipeline": "https://github.com/pagopa/pagopa-platform-authorizer-config/actions/workflows/release_deploy.yml",
    "env": "AKS",
    "actions": "GHA"
  },
  "BizEvent": {
    "product": "bizevents",
    "repository": "pagopa-biz-events-service",
    "pipeline": "https://github.com/pagopa/pagopa-biz-events-service/actions/workflows/release_deploy.yml",
    "env": "AKS",
    "actions": "GHA"
  },
  "BizEvent - Datastore for positive events": {
    "product": "bizeventsdatastorepos",
    "repository": "pagopa-biz-events-datastore",
    "pipeline": "https://github.com/pagopa/pagopa-biz-events-datastore/actions/workflows/release_deploy.yml",
    "env": "AKS",
    "actions": "GHA"
  },
  "BizEvent - Datastore for negative events": {
    "product": "bizeventsdatastoreneg",
    "repository": "pagopa-negative-biz-events-datastore",
    "pipeline": "https://github.com/pagopa/pagopa-negative-biz-events-datastore/actions/workflows/release_deploy.yml",
    "env": "AKS",
    "actions": "GHA"
  },
  "Canone Unico": {
    "product": "canoneunico",
    "repository": "pagopa-canone-unico",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=585&_a=summary",
    "env": "AZ",
    "actions": "AZDO"
  },
  "FdR - Nodo dei Pagamenti (New)": {
    "product": "fdrndpnew",
    "repository": "pagopa-fdr",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=1224",
    "env": "AKS",
    "actions": "AZDO"
  },
  "GPD - Core": {
    "product": "gpd",
    "repository": "pagopa-debt-position",
    "pipeline": "https://github.com/pagopa/pagopa-debt-position/actions/workflows/release_deploy.yml",
    "env": "AKS",
    "actions": "GHA"
  },
  "GPD - Payments": {
    "product": "gpdpayments",
    "repository": "pagopa-gpd-payments",
    "pipeline": "https://github.com/pagopa/pagopa-gpd-payments/actions/workflows/release_deploy.yml",
    "env": "AKS",
    "actions": "GHA"
  },
  "GPD - Reporting Analysis": {
    "product": "gpdreportinganalysis",
    "repository": "pagopa-gpd-reporting-analysis",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=1308",
    "env": "AZ",
    "actions": "AZDO"
  },
  "GPD - Reporting Batch": {
    "product": "gpdreportingbatch",
    "repository": "pagopa-gpd-reporting-batch",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=1285",
    "env": "AZ",
    "actions": "AZDO"
  },
  "GPD - Reporting Service": {
    "product": "gpdreportingservice",
    "repository": "pagopa-gpd-reporting-service",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=1307",
    "env": "AZ",
    "actions": "AZDO"
  },
  "GPD - Reporting Orgs Enrollment": {
    "product": "gpdenrollment",
    "repository": "pagopa-reporting-orgs-enrollment",
    "pipeline": "https://github.com/pagopa/pagopa-reporting-orgs-enrollment/actions/workflows/release_deploy.yml",
    "env": "AKS",
    "actions": "GHA"
  },
  /* TODO un-comment this when response will be compliant
  "GPS - Donations": {
    "product": "gpsdonation",
    "repository": "pagopa-gps-donation-service",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=747",
    "env": "AKS",
    "actions": "AZDO"
  },
  */
  "GPS - Spontaneous Payments": {
    "product": "gps",
    "repository": "pagopa-spontaneous-payments",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=743",
    "env": "AKS",
    "actions": "AZDO"
  },
  "Mocker - Core": {
    "product": "mocker",
    "repository": "pagopa-mocker",
    "pipeline": "https://github.com/pagopa/pagopa-mocker/actions/workflows/release_deploy.yml",
    "env": "AKS",
    "actions": "GHA"
  },  
  "Mocker - Configurator FrontEnd": {
    "type": "frontend",
    "host": "mocker",
    "repository": "pagopa-mock-config-fe",
    "pipeline": "https://github.com/pagopa/pagopa-mock-config-fen/actions/workflows/release_deploy.yml",
    "env": "AZ",
    "actions": "GHA"
  },
   "PDF Engine": {
    "product": "pdfengine",
    "repository": "pagopa-pdf-engine",
    "pipeline": "https://github.com/pagopa/pagopa-pdf-engine/actions/workflows/release-deploy.yml",
    "env": "AKS",
    "actions": "GHA"
   },
   "PDF Receipt - Datastore": {
    "product": "receiptpdfdatastore",
    "repository": "pagopa-receipt-pdf-datastore",
    "pipeline": "https://github.com/pagopa/pagopa-receipt-pdf-datastore/actions/workflows/release-deploy.yml",
    "env": "AKS",
    "actions": "GHA"
   },
   "PDF Receipt - Generator": {
    "product": "receiptpdfgenerator",
    "repository": "pagopa-receipt-pdf-generator",
    "pipeline": "https://github.com/pagopa/pagopa-receipt-pdf-generator/actions/workflows/release-deploy.yml",
    "env": "AKS",
    "actions": "GHA"
   },
   "PDF Receipt - Notifier": {
    "product": "receiptpdfnotifier",
    "repository": "pagopa-receipt-pdf-notifier",
    "pipeline": "https://github.com/pagopa/pagopa-receipt-pdf-notifier/actions/workflows/release-deploy.yml",
    "env": "AKS",
    "actions": "GHA"
   },
   "PDF Receipt - Service": {
    "product": "receiptpdfservice",
    "repository": "pagopa-receipt-pdf-service",
    "pipeline": "https://github.com/pagopa/pagopa-receipt-pdf-service/actions/workflows/release_deploy.yml",
    "env": "AKS",
    "actions": "GHA"
   },
   "PDF Receipt - Helpdesk": {
    "product": "receiptpdfhelpdesk",
    "repository": "pagopa-receipt-pdf-helpdesk",
    "pipeline": "https://github.com/pagopa/pagopa-receipt-pdf-helpdesk/actions/workflows/release_deploy.yml",
    "env": "AKS",
    "actions": "GHA"
   },
  /*https://github.com/pagopa/pagopa-api-config-selfcare-integration/actions/workflows/release_deploy.yml*/
  /*https://github.com/pagopa/tps://github.com/pagopa/pagopa-api-config-selfcare-integration/actions/workflows/release_deploy.yml/actions/workflows/release_deploy.yml*/
};

const projectsTouchPoint = {
  "ECommerce - Payment Requests Service": {
    "product": "ecommerce",
    "repository":  "pagopa-ecommerce-payment-requests-service",
    "pipeline": "",
  },
};

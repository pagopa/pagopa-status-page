const dns_d = ".dev.platform.pagopa.it";
const dns_u = ".uat.platform.pagopa.it";
const dns_p = ".platform.pagopa.it";

const apim_d = "https://api${dns_d}";
const apim_u = "https://api${dns_u}";
const apim_p = "https://api${dns_p}";

const basePath = "/shared/statuspage/v1/info?product=";


const projectsCore = {
  "ApiConfig - Cacher (Oracle)": {
    "product": "apiconfigcacheo",
    "repository": "pagopa-api-config-cache",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=1236",
  },
  "ApiConfig - Cacher (Postgres)": {
    "product": "apiconfigcachep",
    "repository": "pagopa-api-config-cache",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=1236",
  },
  "ApiConfig - Core": {
    "product": "apiconfig",
    "repository": "pagopa-api-config",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=581",
  },
  "ApiConfig - FrontEnd": {
    "type": "frontend",
    "host": "config",
    "repository": "pagopa-api-config-fe",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=577",
  },
    "ApiConfig - SelfCare integration": {
    "product": "apiconfigselfcare",
    "repository": "pagopa-api-config-selfcare-integration",
    "pipeline": "https://github.com/pagopa/pagopa-api-config-selfcare-integration/actions/workflows/release_deploy.yml",
  },
  "AFM-Calculator": {
    "product": "afmcalculator",
    "repository": "pagopa-afm-calculator",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=800",
  },
  "AFM-Utils": {
    "product": "afmutils",
    "repository": "pagopa-afm-utils",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=929",
  },
  "AFM-Marketplace": {
    "product": "afmmarketplace",
    "repository": "pagopa-afm-marketplace-be",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=801",
  },
  "BizEvent": {
    "product": "bizevents",
    "repository": "pagopa-biz-events-service",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=927",
  },
  /* TODO un-comment this when response will be compliant
  "BizEvent - Datastore for positive events": {
    "product": "bizeventsdatastorepos",
    "repository": "pagopa-biz-events-datastore",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=913",
  },
  */
  /* TODO un-comment this when response will be compliant
  "BizEvent - Datastore for negative events": {
    "product": "bizeventsdatastoreneg",
    "repository": "pagopa-negative-biz-events-datastore",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=1312",
  },
  */
  "FdR - Nodo dei Pagamenti (New)": {
    "product": "fdrndpnew",
    "repository": "pagopa-fdr",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=1224",
  },
  "GPD - Core": {
    "product": "gpd",
    "repository": "pagopa-debt-position",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=617",
  },
  "GPD - Payments": {
    "product": "gpdpayments",
    "repository": "pagopa-gpd-payments",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=982",
  },
  "GPD - Reporting Orgs Enrollment": {
    "product": "gpdenrollment",
    "repository": "pagopa-gpd-reporting-orgs-enrollment",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=846",
  },
  /* TODO un-comment this when response will be compliant
  "GPS - Donations": {
    "product": "gpsdonation",
    "repository": "pagopa-gps-donation-service",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=747",
  },
  */
  "GPS - Spontaneous Payments": {
    "product": "gps",
    "repository": "pagopa-spontaneous-payments",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=743",
  },
  "Mocker - Core": {
    "product": "mocker",
    "repository": "pagopa-mocker",
    "pipeline": "https://github.com/pagopa/pagopa-mocker/actions/workflows/release_deploy.yml",
  },  
  "Mocker - Configurator FrontEnd": {
    "type": "frontend",
    "host": "mocker",
    "repository": "pagopa-mock-config-fe",
    "pipeline": "",
  }, 
  /* TODO un-comment this when response will be compliant
  "PDF Engine": {
    "product": "pdfengine",
    "repository": "pagopa-pdf-engine",
    "pipeline": "https://github.com/pagopa/pagopa-pdf-engine/actions/workflows/release-deploy.yml",
  },
  */
  /* TODO un-comment this when response will be compliant
  "Receipts - PDF Datastore": {
    "product": "receiptpdfdatastore",
    "repository": "pagopa-receipt-pdf-datastore",
    "pipeline": "https://github.com/pagopa/pagopa-receipt-pdf-datastore/actions/workflows/release-deploy.yml",
  },  
  */
};

const projectsTouchPoint = {
  "ECommerce - Payment Requests Service": {
    "product": "ecommerce",
    "repository":  "pagopa-ecommerce-payment-requests-service",
    "pipeline": "",
  },

};

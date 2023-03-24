const dns_d = ".dev.platform.pagopa.it";
const dns_u = ".uat.platform.pagopa.it";
const dns_p = ".platform.pagopa.it";

const apim_d = "https://api${dns_d}";
const apim_u = "https://api${dns_u}";
const apim_p = "https://api${dns_p}";

const basePath = "/shared/statuspage/v1/info?product=";


const projectsCore = {
  "ApiConfig": {
    "product": "apiconfig",
    "repository": "pagopa-api-config",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=581",
  },
  "ApiConfig - FE": {
    "type": "frontend",
    "host": "config",
    "repository": "pagopa-api-config-fe",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=577",
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
  "GPD - Debt Position": {
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
  "GPS - Donations": {
    "product": "gpsdonation",
    "repository": "pagopa-gps-donation-service",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=747",
  },
  "GPS - Spontaneous Payments": {
    "product": "gps",
    "repository": "pagopa-spontaneous-payments",
    "pipeline": "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=743",
  },
};

const projectsTouchPoint = {
  "ECommerce - Payment Requests Service": {
    "product": "ecommerce",
    "repository":  "pagopa-ecommerce-payment-requests-service",
    "pipeline": "",
  },

};

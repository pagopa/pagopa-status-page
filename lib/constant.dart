

const dns_d = "dev.platform.pagopa.it";
const dns_u = "uat.platform.pagopa.it";
const dns_p = "platform.pagopa.it";

const apim_d = "https://api.${dns_d}";
const apim_u = "https://api.${dns_u}";
const apim_p = "https://api.${dns_p}";

const basePath = "/shared/statuspage/v1/info?product=";

const lastUpdatedKey = "last-updated";

const Map<String, List<Map<String, String>>> projectsCore = {
  "Api Config": [
    {
      "name": "ApiConfig - Cacher (Oracle)",
      "product": "apiconfigcacheo",
      "repository": "pagopa-api-config-cache",
      "pipeline":
          "https://github.com/pagopa/pagopa-api-config-cache/actions/workflows/release_deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    },
    {
      "name": "ApiConfig - Cacher (Postgres)",
      "product": "apiconfigcachep",
      "repository": "pagopa-api-config-cache",
      "pipeline":
          "https://github.com/pagopa/pagopa-api-config-cache/actions/workflows/release_deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    },
    {
      "name": "ApiConfig - Core",
      "product": "apiconfig",
      "repository": "pagopa-api-config",
      "pipeline":
          "https://github.com/pagopa/pagopa-api-config/actions/workflows/release_deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    },
    {
      "name": "ApiConfig - FrontEnd",
      "type": "frontend",
      "product": "apiconfig-fe",
      "repository": "pagopa-api-config-fe",
      "pipeline":
          "https://github.com/pagopa/pagopa-api-config-fe/actions/workflows/release_deploy.yml",
      "env": "AZ",
      "actions": "GHA"
    },
    {
      "name": "ApiConfig - SelfCare integration",
      "product": "apiconfigselfcare",
      "repository": "pagopa-api-config-selfcare-integration",
      "pipeline":
          "https://github.com/pagopa/pagopa-api-config-selfcare-integration/actions/workflows/release_deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    }
  ],
  "AFM": [
    {
      "name": "AFM-Calculator",
      "product": "afmcalculator",
      "repository": "pagopa-afm-calculator",
      "pipeline":
          "https://github.com/pagopa/pagopa-afm-calculator/actions/workflows/release_deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    },
    {
      "name": "AFM-Utils",
      "product": "afmutils",
      "repository": "pagopa-afm-utils",
      "pipeline":
          "https://github.com/pagopa/pagopa-afm-utils/actions/workflows/release_deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    },
    {
      "name": "AFM-Marketplace",
      "product": "afmmarketplace",
      "repository": "pagopa-afm-marketplace-be",
      "pipeline":
          "https://github.com/pagopa/pagopa-afm-marketplace-be/actions/workflows/release_deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    },
  ],
  "Authorizer": [
    {
      "name": "Authorizer",
      "product": "authorizer",
      "repository": "pagopa-platform-authorizer",
      "pipeline":
          "https://github.com/pagopa/pagopa-platform-authorizer/actions/workflows/release_deploy_aks.yml",
      "env": "AKS",
      "actions": "GHA"
    },
    {
      "name": "Authorizer Configurator",
      "product": "authorizerconfig",
      "repository": "pagopa-platform-authorizer-config",
      "pipeline":
          "https://github.com/pagopa/pagopa-platform-authorizer-config/actions/workflows/release_deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    },
  ],
  "Biz Event": [
    {
      "name": "BizEvent",
      "product": "bizevents",
      "repository": "pagopa-biz-events-service",
      "pipeline":
          "https://github.com/pagopa/pagopa-biz-events-service/actions/workflows/release_deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    },
    {
      "name": "BizEvent - Datastore for positive events",
      "product": "bizeventsdatastorepos",
      "repository": "pagopa-biz-events-datastore",
      "pipeline":
          "https://github.com/pagopa/pagopa-biz-events-datastore/actions/workflows/release_deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    },
    {
      "name": "BizEvent - Datastore for negative events",
      "product": "bizeventsdatastoreneg",
      "repository": "pagopa-negative-biz-events-datastore",
      "pipeline":
          "https://github.com/pagopa/pagopa-negative-biz-events-datastore/actions/workflows/release_deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    },
  ],
  "GPD": [
    {
      "name": "GPD - Core",
      "product": "gpd",
      "repository": "pagopa-debt-position",
      "pipeline":
          "https://github.com/pagopa/pagopa-debt-position/actions/workflows/release_deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    },
    {
      "name": "GPD - Payments",
      "product": "gpdpayments",
      "repository": "pagopa-gpd-payments",
      "pipeline":
          "https://github.com/pagopa/pagopa-gpd-payments/actions/workflows/release_deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    },
    {
      "name": "GPD - Payments Pull",
      "product": "gpdpaymentspull",
      "repository": "pagopa-gpd-payments-pull",
      "pipeline":
          "https://github.com/pagopa/pagopa-gpd-payments-pull/actions/workflows/release_deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    },
    {
      "name": "GPD - Reporting Analysis",
      "product": "gpdreportinganalysis",
      "repository": "pagopa-gpd-reporting-analysis",
      "pipeline":
          "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=1308",
      "env": "AZ",
      "actions": "AZDO"
    },
    {
      "name": "GPD - Reporting Batch",
      "product": "gpdreportingbatch",
      "repository": "pagopa-gpd-reporting-batch",
      "pipeline":
          "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=1285",
      "env": "AZ",
      "actions": "AZDO"
    },
    {
      "name": "GPD - Reporting Service",
      "product": "gpdreportingservice",
      "repository": "pagopa-gpd-reporting-service",
      "pipeline":
          "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=1307",
      "env": "AZ",
      "actions": "AZDO"
    },
    {
      "name": "GPD - Reporting Orgs Enrollment",
      "product": "gpdenrollment",
      "repository": "pagopa-reporting-orgs-enrollment",
      "pipeline":
          "https://github.com/pagopa/pagopa-reporting-orgs-enrollment/actions/workflows/release_deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    },
    {
      "name": "GPD - Upload",
      "product": "gpdupload",
      "repository": "pagopa-gpd-upload",
      "pipeline":
          "https://github.com/pagopa/pagopa-gpd-upload/actions/workflows/release_deploy.yml",
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
    {
      "name": "GPS - Spontaneous Payments",
      "product": "gps",
      "repository": "pagopa-spontaneous-payments",
      "pipeline":
          "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=743",
      "env": "AKS",
      "actions": "AZDO"
    },
    {
      "name": "Canone Unico",
      "product": "canoneunico",
      "repository": "pagopa-canone-unico",
      "pipeline":
          "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=585&_a=summary",
      "env": "AZ",
      "actions": "AZDO"
    },
  ],
  "Mocker": [
    {
      "name": "Mocker - Core",
      "product": "mocker",
      "repository": "pagopa-mocker",
      "pipeline":
          "https://github.com/pagopa/pagopa-mocker/actions/workflows/release_deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    },
    {
      "name": "Mocker - Configurator FrontEnd",
      "type": "frontend",
      "host": "mocker",
      "product": "mockconfig-fe",
      "repository": "pagopa-mock-config-fe",
      "pipeline":
          "https://github.com/pagopa/pagopa-mock-config-fen/actions/workflows/release_deploy.yml",
      "env": "AZ",
      "actions": "GHA"
    },
  ],
};

const projectsNodo5 = {
    "FdR": [
        {
          "name": "FdR - Nodo dei Pagamenti (New)",
          "product": "fdrndpnew",
          "repository": "pagopa-fdr",
          "pipeline":
              "https://dev.azure.com/pagopaspa/pagoPA-projects/_build?definitionId=1224",
          "env": "AKS",
          "actions": "AZDO"
        },
    ],
    "WISP-Converter": [
        {
          "name": "WISP Converter",
          "product": "wispconverter",
          "repository": "pagopa-wisp-converter",
          "pipeline": "https://github.com/pagopa/pagopa-wisp-converter/actions/workflows/04_release_deploy.yml",
          "env": "AKS",
          "actions": "GHA"
        },
        {
          "name": "WISP SOAP Converter",
          "product": "wispsoapconverter",
          "repository": "pagopa-wisp-soap-converter",
          "pipeline": "https://github.com/pagopa/pagopa-wisp-soap-converter/actions/workflows/release_deploy.yml",
          "env": "AKS",
          "actions": "GHA"
        },
        {
          "name": "WISP Converter Technical Support",
          "product": "wispconverterts",
          "repository": "pagopa-wisp-converter-technical-support",
          "pipeline": "https://github.com/pagopa/pagopa-wisp-converter-technical-support/actions/workflows/04_release_deploy.yml",
          "env": "AKS",
          "actions": "GHA"
        },
    ]
};

const projectsVAS = {
  "Back Office": [
    {
      "name": "BackOffice pagoPA - BackEnd",
      "product": "backofficepagopa",
      "host": "selfcare.%s/ui",
      "repository": "pagopa-selfcare-ms-backoffice-backend",
      "pipeline":
          "https://github.com/pagopa/pagopa-selfcare-ms-backoffice-backend/actions/workflows/release_deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    },
    {
      "name": "BackOffice pagoPA - FrontEnd",
      "type": "frontend",
      "product": "backofficepagopa-fe",
      "repository": "pagopa-selfcare-frontend",
      "pipeline":
          "https://github.com/pagopa/pagopa-selfcare-frontend/actions/workflows/release_deploy.yml",
      "env": "AZ",
      "actions": "GHA"
    },
    {
      "name": "BackOffice External",
      "product": "backofficeexternalpagopa",
      "repository": "pagopa-backoffice-external",
      "pipeline":
          "https://github.com/pagopa/pagopa-backoffice-external/actions/workflows/release_deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    },
  ],
  "PDF": [
    {
      "name": "PDF Engine",
      "product": "pdfengine",
      "repository": "pagopa-pdf-engine",
      "pipeline":
          "https://github.com/pagopa/pagopa-pdf-engine/actions/workflows/release-deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    },
    {
      "name": "PDF Receipt - Datastore",
      "product": "receiptpdfdatastore",
      "repository": "pagopa-receipt-pdf-datastore",
      "pipeline":
          "https://github.com/pagopa/pagopa-receipt-pdf-datastore/actions/workflows/release-deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    },
    {
      "name": "PDF Receipt - Generator",
      "product": "receiptpdfgenerator",
      "repository": "pagopa-receipt-pdf-generator",
      "pipeline":
          "https://github.com/pagopa/pagopa-receipt-pdf-generator/actions/workflows/release-deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    },
    {
      "name": "PDF Receipt - Notifier",
      "product": "receiptpdfnotifier",
      "repository": "pagopa-receipt-pdf-notifier",
      "pipeline":
          "https://github.com/pagopa/pagopa-receipt-pdf-notifier/actions/workflows/release-deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    },
    {
      "name": "PDF Receipt - Service",
      "product": "receiptpdfservice",
      "repository": "pagopa-receipt-pdf-service",
      "pipeline":
          "https://github.com/pagopa/pagopa-receipt-pdf-service/actions/workflows/release_deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    },
    {
      "name": "PDF Receipt - Helpdesk",
      "product": "receiptpdfhelpdesk",
      "repository": "pagopa-receipt-pdf-helpdesk",
      "pipeline":
          "https://github.com/pagopa/pagopa-receipt-pdf-helpdesk/actions/workflows/release_deploy.yml",
      "env": "AKS",
      "actions": "GHA"
    },
  ]
};

const projectsTouchPoint = {
  "ECommerce": [
    {
      "name": "ECommerce - Payment Requests Service",
      "product": "ecommerce",
      "repository": "pagopa-ecommerce-payment-requests-service",
      "pipeline": "",
    },
  ]
};

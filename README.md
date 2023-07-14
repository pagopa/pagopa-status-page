# Status Page

A [Status Page](https://pagopa.github.io/pagopa-status-page/#/) for all the pagoPa products

## Getting Started

To run locally:

``` shell
flutter run -d chrome --web-browser-flag "--disable-web-security" --web-port=8888
```

_Note:_ To disable CORS policy we add the flag `--web-browser-flag "--disable-web-security"`

# How to Build

1. Run this command:
``` shell
flutter build web --base-href /pagopa-status-page/
```
2. Built files are in `/build/web` 

# Status Page

A [Status Page](https://pagopa.github.io/pagopa-status-page/#/) for all the pagoPa products

## Getting Started

To run locally:

``` shell
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

_Note:_ To disable CORS policy we add the flag `--web-browser-flag "--disable-web-security"`

# How to Release

1. Run this command:
``` shell
flutter build web --base-href /pagopa-status-page/
```
2. Copy the content of `/build/web` in `/docs`
``` shell
cp -Rv ./build/web/* ./docs/
```
3. Push your code
4. After a while you can visit the page: https://pagopa.github.io/pagopa-status-page/#/

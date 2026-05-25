fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios sync_certificates

```sh
[bundle exec] fastlane ios sync_certificates
```

Sincroniza certificados y perfiles de aprovisionamiento

### ios flutter_build

```sh
[bundle exec] fastlane ios flutter_build
```

Compila la app con flutter

### ios build

```sh
[bundle exec] fastlane ios build
```

Compila la aplicación

### ios load_api_key

```sh
[bundle exec] fastlane ios load_api_key
```

Carga la API Key de App Store Connect para autenticación

### ios upload

```sh
[bundle exec] fastlane ios upload
```

Sube la aplicación a TestFlight (requiere IPA)

### ios deploy

```sh
[bundle exec] fastlane ios deploy
```

Build completo y upload a TestFlight

----


## Android

### android setup_keystore

```sh
[bundle exec] fastlane android setup_keystore
```

Decodifica el keystore desde base64 y lo deja en un archivo temporal

### android build

```sh
[bundle exec] fastlane android build
```

Compila la app con flutter

### android upload

```sh
[bundle exec] fastlane android upload
```

Sube el AAB a Google Play

### android deploy

```sh
[bundle exec] fastlane android deploy
```

Build completo y upload a Google Play

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).

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

### ios ensure_keychain

```sh
[bundle exec] fastlane ios ensure_keychain
```

Asegura que exista un keychain limpio para importar los certificados de Apple

### ios ensure_wwdr

```sh
[bundle exec] fastlane ios ensure_wwdr
```

Asegura que exista los certificados de Apple en el keychain para que match funcione correctamente

### ios sync_certificates

```sh
[bundle exec] fastlane ios sync_certificates
```

Sincroniza certificados y perfiles de aprovisionamiento

### ios configure_signing

```sh
[bundle exec] fastlane ios configure_signing
```

Configura Signing Settings para Xcode

### ios flutter_build

```sh
[bundle exec] fastlane ios flutter_build
```

Compila la app con flutter para iOS

### ios build

```sh
[bundle exec] fastlane ios build
```

Construye y firma la app para distribución en iOS

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


## Mac

### mac ensure_keychain

```sh
[bundle exec] fastlane mac ensure_keychain
```

Asegura que exista un keychain limpio para importar los certificados de Apple

### mac ensure_wwdr

```sh
[bundle exec] fastlane mac ensure_wwdr
```

Asegura que existan los certificados WWDR de Apple en el keychain

### mac sync_certificates

```sh
[bundle exec] fastlane mac sync_certificates
```

Sincroniza certificados y perfiles de aprovisionamiento para macOS

### mac configure_signing

```sh
[bundle exec] fastlane mac configure_signing
```

Configura Signing Settings para Xcode macOS

### mac flutter_build

```sh
[bundle exec] fastlane mac flutter_build
```

Compila la app con flutter para macOS

### mac build

```sh
[bundle exec] fastlane mac build
```

Construye y firma la app para distribución en macOS

### mac load_api_key

```sh
[bundle exec] fastlane mac load_api_key
```

Carga la API Key de App Store Connect para autenticación

### mac upload

```sh
[bundle exec] fastlane mac upload
```

Sube la aplicación a TestFlight

### mac deploy

```sh
[bundle exec] fastlane mac deploy
```

Build completo y upload a TestFlight

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).

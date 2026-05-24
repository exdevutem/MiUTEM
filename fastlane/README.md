fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

### ios_sync_certificates

```sh
[bundle exec] fastlane ios_sync_certificates
```

Sincroniza certificados y perfiles de aprovisionamiento

### ios_flutter_build

```sh
[bundle exec] fastlane ios_flutter_build
```

Compila la app con flutter

### ios_build

```sh
[bundle exec] fastlane ios_build
```

Compila la aplicación

### ios_load_api_key

```sh
[bundle exec] fastlane ios_load_api_key
```

Carga la API Key de App Store Connect para autenticación

### ios_upload

```sh
[bundle exec] fastlane ios_upload
```

Sube la aplicación a TestFlight (requiere IPA)

### ios_build_and_upload

```sh
[bundle exec] fastlane ios_build_and_upload
```

Build completo y upload a TestFlight

----


## Android

### android android_flutter_build

```sh
[bundle exec] fastlane android android_flutter_build
```

Compila la app con flutter

### android android_upload

```sh
[bundle exec] fastlane android android_upload
```

Sube el AAB a Google Play

### android android_build_and_upload

```sh
[bundle exec] fastlane android android_build_and_upload
```

Build completo y upload a Google Play

----


## iOS

### ios build

```sh
[bundle exec] fastlane ios build
```

Compila la aplicación para iOS

### ios upload

```sh
[bundle exec] fastlane ios upload
```

Sube la aplicación a TestFlight (requiere IPA)

### ios build_and_upload

```sh
[bundle exec] fastlane ios build_and_upload
```

Build completo y upload a TestFlight

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).

# Mi UTEM para Android e iOS

Aplicación multiplataforma hecha por estudiantes de la [Universidad Tecnológica Metropolitana de Chile](https://www.utem.cl/) enfocada en adaptar la [plataforma académica Mi.UTEM](https://mi.utem.cl/) de la institución a dispositivos móviles.

## Requisitos técnicos

- Flutter 3.16.3 o superior.
- Dart 3.2.3 o superior.
- Cualquier IDE compatible con Flutter (Android Studio, VS Code, IDEA, etc).
- Un dispositivo Android o iOS para probar la aplicación. (Para iOS se requiere un Mac, también puedes usar el simulador de iOS y Android).

## Configuración de librerías y dependencias

<!-- Flutterfire -->
<details>
<summary><a href="https://firebase.flutter.dev/docs/cli/" target="_blank">flutterfire</a> CLI</summary>

1. Para usar `flutterfire` debemos tener instalado las herramientas de firebase en nuestro computador, para esto debemos instalar `firebase-tools` usando npm (o puedes usar tu package manager de node preferido):
   ```bash
   npm install -g firebase-tools
   ```
2. Luego de instalar `firebase-tools`, debemos instalar `flutterfire` CLI usando el siguiente comando:
   ```bash
   dart pub global activate flutterfire_cli
   ```
3. Para verificar que `flutterfire` CLI se instaló correctamente, ejecuta el siguiente comando:
   ```bash
   flutterfire --version
   ```
   Deberías ver la versión de `flutterfire` CLI instalada en tu sistema.

</details>

<!-- Ruby -->
<details>
<summary><a href="https://www.ruby-lang.org/en/documentation/installation/" target="_blank">Ruby</a> (Desarrollo para dispositivos Apple)</summary>

> Este es un extracto adaptado desde [mac.install.guide](https://mac.install.guide/ruby/12).
> Recomendamos instalar ruby desde [homebrew](https://brew.sh/) con [chruby](https://github.com/postmodern/chruby) y [ruby-install](https://github.com/postmodern/ruby-install).

1. Primero hay que instalar `ruby-install` y `chruby` usando homebrew:
   ```bash
   brew install ruby-install chruby
   ```
2. Luego debes agregar a tu `~/.zshrc` (o a tu perfil de terminal) las siguientes líneas para configurar `chruby`:
   ```bash
   # Chruby
   source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh
   source $(brew --prefix)/opt/chruby/share/chruby/auto.sh
   chruby ruby-4.0.1 # Reemplaza con la versión de ruby que instalaste
   ```
3. Después de configurar `chruby`, puedes instalar la versión de ruby que necesitas (recomendamos usar la última versión estable) con el siguiente comando:

```bash
ruby-install -U ruby
```

</details>

<!-- Cocoapods -->
<details>
<summary><a href="https://cocoapods.org/" target="_blank">CocoaPods</a> (Desarrollo para dispositivos Apple)</summary>

1. Para usar `CocoaPods` en tu proyecto Flutter, primero debes asegurarte de tener instalado `CocoaPods` en tu sistema. Puedes instalarlo usando el siguiente comando:
   ```bash
   sudo gem install cocoapods
   ```
2. Luego de instalar `CocoaPods`, debes navegar a la carpeta `ios` o `macos` del proyecto y ejecutar el siguiente comando para instalar las dependencias:
   ```bash
   pod install --repo-update
   ```
3. Si estás usando un dispositivo Apple para ejecutar la aplicación, asegúrate de tener Xcode instalado y configurado correctamente en tu sistema.

</details>

## Configuración del Proyecto

> Se asume que ya tienes instalado Flutter, Dart, y las herramientas necesarias para ejecutar aplicaciones Flutter en tu dispositivo como XCode y/o Android Studio.

1. Clona el repositorio en tu computador.
2. Abre el proyecto en un terminal y ejecuta `flutter pub get` para instalar las dependencias.
3. Si ejecutarás la app en un dispositivo Apple en iOS o macOS deberás de ingresar a su carpeta correspondiente y ejecutar `pod install --repo-update` para instalar las dependencias de CocoaPods.
4. Una vez que hayas instalado las dependencias, configura firebase usando `flutterfire`. Sigue las instrucciones de `firebase`

## Configuración de Firebase usando `flutterfire`

1. Para configurar firebase usando `flutterfire`, primero debes ejecutar el siguiente comando en la raíz del proyecto:
   ```bash
   ./scripts/flutterfire-configure all # Puedes agregar --dry-run para ver que comandos se ejecutarán.
   ```
   En Windows usa `scripts\flutterfire-configure.ps1` (PowerShell) o `scripts\flutterfire-configure.bat` (CMD). También puedes indicar un solo entorno con `dev` o `prod` en vez de `all`.

   El script pasa todos los parámetros a `flutterfire config`, así que no te preguntará por plataformas ni por build configurations. Por cada entorno ejecuta `flutterfire` dos veces, una por cada build configuration de Xcode:

   | Entorno | Proyecto Firebase | Build configurations                       | Flavor de Android |
   | ------- | ----------------- | ------------------------------------------ | ----------------- |
   | `dev`   | `miutem-dev`      | `Debug-development`, `Release-development`  | `development`     |
   | `prod`  | `miutem-prod`     | `Debug-production`, `Release-production`    | `production`      |

   Las variantes `Debug-*` son las que permiten ejecutar la app en modo debug (`flutter run`), y las `Release-*` las que se usan para compilar y publicar. Si solo necesitas una de las dos, usa `--build-type`:

   ```bash
   ./scripts/flutterfire-configure all --build-type=Release # Solo Release-development y Release-production
   ./scripts/flutterfire-configure dev --build-type=Debug   # Solo Debug-development
   ```

   Esto es lo que hace el workflow de despliegue, que solo compila en release y por lo tanto no necesita las configuraciones de debug.

   > Si tienes definida la variable de entorno `FIREBASE_TOKEN` (generada con `firebase login:ci`), el script la usará automáticamente. Si no, basta con haber iniciado sesión con `firebase login`.
2. (Paso Extra) Debido a un bug con flutterfire_cli, deberás reordenar en los entornos Apple los scripts, por lo que deberás abrir el archivo `<entorno>/Runner.xcworkspace` con Xcode, luego ir a `Runner` -> `Build Phases` -> `Targets` -> `Runner` y asegurarte de que el script de FlutteFire (los últimos 2) tengan el siguiente orden:
   ```
   [x] FlutterFire: "flutterfire bundle-service-file"
   [x] FlutterFire: "flutterfire upload-crashlytics-symbols"
   ```
   Si no revisas el orden tendrás problemas al compilar ya que el comando para subir los símbolos de crashlytics se ejecutará antes de generar el archivo de configuración de firebase, lo que hará que el comando falle ya que no encontrará el archivo de configuración.
   Mas información del problema la puedes encontrar en la siguiente discusión: [[BUG]: La app no compila por un problema de flutterfire. #29](https://github.com/exdevutem/MiUTEM/discussions/29)

> **IMPORTANTE**: Si algo sale mal no hay problema, el script es idempotente: puedes volver a ejecutarlo las veces que necesites. Sobrescribe los archivos `firebase_options_<env>.dart`, `GoogleService-Info.plist` y `google-services.json` sin tocar ninguna otra parte del código, y acumula las build configurations en `firebase.json` sin borrar las ya existentes.
>
> También puedes revisar el script `scripts/flutterfire-configure` para entender mejor como funciona la configuración de firebase usando `flutterfire`. Con `--dry-run` te muestra los comandos que ejecutaría, y con `-v` el detalle de cada valor que resuelve.

<br/>

## Compilación para Android

Para compilar la aplicación para Android, primero debes asegurarte de tener configurado un dispositivo Android o un emulador. Una vez que tengas eso listo, debes configurar el keystore para firmar la aplicación. Para esto, debes generar un keystore usando el siguiente comando:

```bash
# Sigue las instrucciones para generar el keystore
./scripts/generate-keystore
```

Una vez configurado el keystore y las variables, puedes compilar la aplicación para Android usando el siguiente comando:
En producción:

```bash
flutter build apk --flavor production -t lib/main_prod.dart
```

En desarrollo:

```bash
flutter build apk --flavor development -t lib/main_dev.dart
```

## Ejecución de la aplicación

Una vez que hayas configurado firebase correctamente, puedes ejecutar la aplicación en tu dispositivo usando el siguiente comando:

En producción:

```bash
flutter run --flavor production -t lib/main_prod.dart
```

En desarrollo:

```bash
flutter run --flavor development -t lib/main_dev.dart
```

Si quieres ejecutar la app en un IDE como Android Studio, IntelliJ IDEA o VSCode, puedes usar las configuraciones de ejecución que ya existen para cada entorno. Solo asegúrate de seleccionar la configuración correcta para el entorno que quieres ejecutar (producción o desarrollo).

Para el entorno de desarrollo está la configración `Mi UTEM [development]` y para el entorno de producción está la configuración `Mi UTEM [production]`. Estas configuraciones ya están predefinidas para ejecutar la aplicación con el comando correcto para cada entorno.

## Créditos

Este proyecto fue creado por el Club de Desarrollo Experimental (ExDev) de la Universidad Tecnológica Metropolitana y es mantenido por los propios estudiantes con el apoyo del equipo de SISEI. Mira los perfiles que han contribuido a este proyecto:

<a href="https://github.com/exdevutem/MiUTEM/graphs/contributors">
  <img alt="Contribuidores" src="https://contrib.rocks/image?repo=exdevutem/MiUTEM" />
</a>

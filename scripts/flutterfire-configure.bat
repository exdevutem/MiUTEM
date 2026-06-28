@echo off
::##################################################
:: Script para configurar FlutterFire para múltiples entornos (dev y prod)
:: Autor: Francisco Solis Maturana (Club de Desarrollo Experimental)
:: Uso: flutterfire-configure.bat [dev|prod|all]
:: Argumentos:
::   dev  - Configura FlutterFire para el entorno de desarrollo
::   prod - Configura FlutterFire para el entorno de producción
::   all  - Configura FlutterFire para ambos entornos (dev y prod)
:: Flags:
::   -h, --help    - Muestra esta ayuda
::   -v, --verbose - Muestra información detallada durante la ejecución
::   --dry-run     - Muestra los comandos que se ejecutarían sin ejecutarlos realmente
::##################################################

setlocal enabledelayedexpansion

set "VERBOSE=false"
set "DRY_RUN=false"
set "TARGET_ENV="

:: Parsea argumentos y flags en cualquier orden
:parse_args
if "%~1"=="" goto end_parse

if /i "%~1"=="dev"       ( call :set_env dev   & shift & goto parse_args )
if /i "%~1"=="prod"      ( call :set_env prod  & shift & goto parse_args )
if /i "%~1"=="all"       ( call :set_env all   & shift & goto parse_args )
if /i "%~1"=="-h"        ( call :print_help    & exit /b 0 )
if /i "%~1"=="--help"    ( call :print_help    & exit /b 0 )
if /i "%~1"=="-v"        ( set "VERBOSE=true"  & shift & goto parse_args )
if /i "%~1"=="--verbose" ( set "VERBOSE=true"  & shift & goto parse_args )
if /i "%~1"=="--dry-run" ( set "DRY_RUN=true"  & shift & goto parse_args )

echo Error: argumento no reconocido '%~1'.
call :print_help
exit /b 1

:end_parse

if "%TARGET_ENV%"=="" (
    echo Error: debe indicar un entorno ^(dev, prod o all^).
    call :print_help
    exit /b 1
)

if /i "%TARGET_ENV%"=="all" (
    call :configure_environment dev
    if errorlevel 1 exit /b 1
    call :configure_environment prod
    if errorlevel 1 exit /b 1
) else (
    call :configure_environment %TARGET_ENV%
    if errorlevel 1 exit /b 1
)

exit /b 0

:: -----------------------------------------------
:set_env
if not "%TARGET_ENV%"=="" (
    echo Error: solo se permite un entorno objetivo ^(dev, prod o all^).
    call :print_help
    exit /b 1
)
set "TARGET_ENV=%~1"
shift
goto parse_args

:: -----------------------------------------------
:print_help
echo Uso: flutterfire-configure.bat [dev^|prod^|all] [flags]
echo.
echo Argumentos:
echo   dev                  Configura FlutterFire para el entorno de desarrollo
echo   prod                 Configura FlutterFire para el entorno de produccion
echo   all                  Configura FlutterFire para ambos entornos
echo.
echo Flags:
echo   -h, --help           Muestra esta ayuda
echo   -v, --verbose        Muestra informacion detallada durante la ejecucion
echo   --dry-run            Muestra los comandos sin ejecutarlos
exit /b 0

:: -----------------------------------------------
:log_verbose
if "%VERBOSE%"=="true" echo [verbose] %~1
exit /b 0

:: -----------------------------------------------
:configure_environment
set "ENV=%~1"

echo ================================
echo Configurando FlutterFire para el entorno: %ENV%
echo ================================

set "PROJECT=miutem-%ENV%"
set "OUT=lib/firebase_options_%ENV%.dart"

if /i "%ENV%"=="dev" (
    set "IOS_BUNDLE_ID=cl.utem.miutem.dev"
    set "IOS_OUT=ios/Firebase/development/GoogleService-Info.plist"
    set "IOS_BUILD_CONFIG=Release-development"
    set "MACOS_BUNDLE_ID=cl.utem.miutem.dev"
    set "MACOS_OUT=macos/Firebase/development/GoogleService-Info.plist"
    set "MACOS_BUILD_CONFIG=Release-development"
    set "ANDROID_PACKAGE_NAME=cl.inndev.miutem.dev"
    set "ANDROID_OUT=android/app/src/development/google-services.json"
) else if /i "%ENV%"=="prod" (
    set "IOS_BUNDLE_ID=cl.utem.miutem"
    set "IOS_OUT=ios/Firebase/production/GoogleService-Info.plist"
    set "IOS_BUILD_CONFIG=Release-production"
    set "MACOS_BUNDLE_ID=cl.utem.miutem"
    set "MACOS_OUT=macos/Firebase/production/GoogleService-Info.plist"
    set "MACOS_BUILD_CONFIG=Release-production"
    set "ANDROID_PACKAGE_NAME=cl.inndev.miutem"
    set "ANDROID_OUT=android/app/src/production/google-services.json"
) else (
    echo Error: Entorno no valido. Use 'dev', 'prod' o 'all'.
    exit /b 1
)

call :log_verbose "Proyecto Firebase: !PROJECT!"
call :log_verbose "Salida Dart: !OUT!"
call :log_verbose "iOS bundle id: !IOS_BUNDLE_ID!"
call :log_verbose "iOS build config: !IOS_BUILD_CONFIG!"
call :log_verbose "iOS plist: !IOS_OUT!"
call :log_verbose "macOS bundle id: !MACOS_BUNDLE_ID!"
call :log_verbose "macOS build config: !MACOS_BUILD_CONFIG!"
call :log_verbose "macOS plist: !MACOS_OUT!"
call :log_verbose "Android package: !ANDROID_PACKAGE_NAME!"
call :log_verbose "Android json: !ANDROID_OUT!"

:: Solo si el env "FIREBASE_TOKEN" está definido, se usa el flag --token
set "TOKEN_FLAG="
if not "%FIREBASE_TOKEN%"=="" (
    call :log_verbose "Usando token de Firebase desde la variable de entorno FIREBASE_TOKEN"
    set "TOKEN_FLAG=--token=%FIREBASE_TOKEN%"
)

set "CMD=flutterfire config ^
  --platforms=ios,macos,android,windows ^
  --project=!PROJECT! ^
  --out=!OUT! ^
  --ios-bundle-id=!IOS_BUNDLE_ID! ^
  --ios-out=!IOS_OUT! ^
  --ios-build-config=!IOS_BUILD_CONFIG! ^
  --macos-bundle-id=!MACOS_BUNDLE_ID! ^
  --macos-out=!MACOS_OUT! ^
  --macos-build-config=!MACOS_BUILD_CONFIG! ^
  --android-package-name=!ANDROID_PACKAGE_NAME! ^
  --android-out=!ANDROID_OUT! ^
  !TOKEN_FLAG! ^
  -f"

if "%VERBOSE%"=="true" echo [cmd] !CMD!
if "%DRY_RUN%"=="true" exit /b 0

flutterfire config ^
  --platforms=ios,macos,android,windows ^
  --project=!PROJECT! ^
  --out=!OUT! ^
  --ios-bundle-id=!IOS_BUNDLE_ID! ^
  --ios-out=!IOS_OUT! ^
  --ios-build-config=!IOS_BUILD_CONFIG! ^
  --macos-bundle-id=!MACOS_BUNDLE_ID! ^
  --macos-out=!MACOS_OUT! ^
  --macos-build-config=!MACOS_BUILD_CONFIG! ^
  --android-package-name=!ANDROID_PACKAGE_NAME! ^
  --android-out=!ANDROID_OUT! ^
  !TOKEN_FLAG! ^
  -f

exit /b %errorlevel%

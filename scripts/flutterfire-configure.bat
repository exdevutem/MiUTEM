@echo off
::##################################################
:: Script para configurar FlutterFire para multiples entornos y tipos de build.
:: Autor: Francisco Solis Maturana (Club de Desarrollo Experimental)
:: Uso: flutterfire-configure.bat [dev|prod|all]
:: Argumentos:
::   dev  - Configura FlutterFire para el entorno de desarrollo
::   prod - Configura FlutterFire para el entorno de produccion
::   all  - Configura FlutterFire para ambos entornos (dev y prod)
:: Flags:
::   -h, --help    - Muestra esta ayuda
::   -v, --verbose - Muestra informacion detallada durante la ejecucion
::   --dry-run     - Muestra los comandos que se ejecutarian sin ejecutarlos realmente
::   --build-type=<Debug|Release|all> - Limita las build configurations a generar
::
:: Por cada entorno se registran las build configurations de Xcode
:: Debug-<flavor> y Release-<flavor>, de modo que la app pueda ejecutarse
:: tanto en modo debug como en release.
::##################################################

setlocal enabledelayedexpansion

:: Build configurations de Xcode que se generan por cada entorno.
set "BUILD_TYPES=Debug Release"

set "FIREBASE_PROJECT_PREFIX=miutem"
set "APPLE_BUNDLE_ID=cl.utem.miutem"
set "ANDROID_PACKAGE_NAME=cl.inndev.miutem"

set "VERBOSE=false"
set "DRY_RUN=false"
set "TARGET_ENV="
set "TARGET_BUILD_TYPE=all"

:: Parsea argumentos y flags en cualquier orden
:parse_args
if "%~1"=="" goto end_parse
set "ARG=%~1"

if /i "!ARG:~0,13!"=="--build-type=" goto set_build_type
if /i "%~1"=="-h"        ( call :print_help    & exit /b 0 )
if /i "%~1"=="--help"    ( call :print_help    & exit /b 0 )
if /i "%~1"=="-v"        ( set "VERBOSE=true"  & shift & goto parse_args )
if /i "%~1"=="--verbose" ( set "VERBOSE=true"  & shift & goto parse_args )
if /i "%~1"=="--dry-run" ( set "DRY_RUN=true"  & shift & goto parse_args )
if /i "%~1"=="dev"       goto set_target
if /i "%~1"=="prod"      goto set_target
if /i "%~1"=="all"       goto set_target

echo Error: argumento no reconocido '%~1'.
call :print_help
exit /b 1

:set_target
if not "%TARGET_ENV%"=="" (
    echo Error: solo se permite un entorno objetivo ^(dev, prod o all^).
    call :print_help
    exit /b 1
)
set "TARGET_ENV=%~1"
shift
goto parse_args

:set_build_type
set "BUILD_TYPE_VALUE=!ARG:~13!"
set "RESOLVED_BUILD_TYPE="

:: Resuelve el nombre canonico del build type ("if /i" ignora mayusculas).
if /i "!BUILD_TYPE_VALUE!"=="all" set "RESOLVED_BUILD_TYPE=all"
for %%B in (%BUILD_TYPES%) do (
    if /i "%%B"=="!BUILD_TYPE_VALUE!" set "RESOLVED_BUILD_TYPE=%%B"
)

if not defined RESOLVED_BUILD_TYPE (
    echo Error: build type no valido '!BUILD_TYPE_VALUE!'. Use %BUILD_TYPES% o all.
    call :print_help
    exit /b 1
)

set "TARGET_BUILD_TYPE=!RESOLVED_BUILD_TYPE!"
shift
goto parse_args

:end_parse

:: Filtrar la lista es equivalente a saltar los build types no pedidos.
if /i not "%TARGET_BUILD_TYPE%"=="all" set "BUILD_TYPES=%TARGET_BUILD_TYPE%"

if "%TARGET_ENV%"=="" (
    echo Error: debe indicar un entorno ^(dev, prod o all^).
    call :print_help
    exit /b 1
)

if "%DRY_RUN%"=="false" (
    where flutterfire >nul 2>&1
    if errorlevel 1 (
        echo Error: no se encontro 'flutterfire'. Instalalo con 'dart pub global activate flutterfire_cli'.
        exit /b 1
    )
)

:: Se ejecuta siempre desde la raiz del proyecto, sin importar desde donde se invoque.
:: "setlocal" restaura el directorio original al terminar el script.
cd /d "%~dp0.."

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
echo   --build-type=^<tipo^>  Genera solo Debug, solo Release, o all ^(por defecto: all^)
echo.
echo Cada entorno registra las build configurations Debug-^<flavor^> y Release-^<flavor^>.
exit /b 0

:: -----------------------------------------------
:log_verbose
if "%VERBOSE%"=="true" echo [verbose] %~1
exit /b 0

:: -----------------------------------------------
:configure_environment
set "ENV_NAME=%~1"

if /i "%ENV_NAME%"=="dev" (
    set "FLAVOR=development"
    set "SUFFIX=.dev"
) else if /i "%ENV_NAME%"=="prod" (
    set "FLAVOR=production"
    set "SUFFIX="
) else (
    echo Error: Entorno no valido. Use 'dev', 'prod' o 'all'.
    exit /b 1
)

set "PROJECT=%FIREBASE_PROJECT_PREFIX%-%ENV_NAME%"
set "DART_OUT=lib/firebase_options_%ENV_NAME%.dart"
set "BUNDLE_ID=%APPLE_BUNDLE_ID%!SUFFIX!"
set "PACKAGE_NAME=%ANDROID_PACKAGE_NAME%!SUFFIX!"
set "IOS_OUT=ios/Firebase/!FLAVOR!/GoogleService-Info.plist"
set "MACOS_OUT=macos/Firebase/!FLAVOR!/GoogleService-Info.plist"
set "ANDROID_OUT=android/app/src/!FLAVOR!/google-services.json"

call :log_verbose "Proyecto Firebase: !PROJECT!"
call :log_verbose "Salida Dart: !DART_OUT!"
call :log_verbose "Apple bundle id: !BUNDLE_ID!"
call :log_verbose "iOS plist: !IOS_OUT!"
call :log_verbose "macOS plist: !MACOS_OUT!"
call :log_verbose "Android package: !PACKAGE_NAME!"
call :log_verbose "Android json: !ANDROID_OUT!"

:: Solo si el env "FIREBASE_TOKEN" esta definido, se usa el flag --token
set "TOKEN_FLAG="
if not "%FIREBASE_TOKEN%"=="" (
    call :log_verbose "Usando token de Firebase desde la variable de entorno FIREBASE_TOKEN"
    set "TOKEN_FLAG=--token=%FIREBASE_TOKEN%"
)

for %%B in (%BUILD_TYPES%) do (
    call :run_flutterfire %%B
    if errorlevel 1 exit /b 1
)

exit /b 0

:: -----------------------------------------------
:run_flutterfire
set "BUILD_CONFIG=%~1-!FLAVOR!"

echo ================================
echo Configurando FlutterFire para el entorno: %ENV_NAME% (!BUILD_CONFIG!)
echo ================================

set "CMD=flutterfire config --platforms=ios,macos,android --project=!PROJECT! --out=!DART_OUT! --ios-bundle-id=!BUNDLE_ID! --ios-out=!IOS_OUT! --ios-build-config=!BUILD_CONFIG! --macos-bundle-id=!BUNDLE_ID! --macos-out=!MACOS_OUT! --macos-build-config=!BUILD_CONFIG! --android-package-name=!PACKAGE_NAME! --android-out=!ANDROID_OUT! -f !TOKEN_FLAG!"

set "SHOW_CMD="
if "%VERBOSE%"=="true" set "SHOW_CMD=1"
if "%DRY_RUN%"=="true" set "SHOW_CMD=1"
if defined SHOW_CMD echo [cmd] !CMD!

if "%DRY_RUN%"=="true" exit /b 0

!CMD!
exit /b %errorlevel%

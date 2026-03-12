@echo off
::##################################################
:: Script para configurar FlutterFire para múltiples entornos (dev y prod)
:: Autor: Francisco Solis Maturana (Club de Desarrollo Experimental)
:: Uso: flutterfire-configure.cmd [dev|prod|all]
:: Argumentos:
::   dev  - Configura FlutterFire para el entorno de desarrollo
::   prod - Configura FlutterFire para el entorno de producción
::   all  - Configura FlutterFire para ambos entornos (dev y prod)
:: Flags:
::   /h, /help    - Muestra esta ayuda
::   /v, /verbose - Muestra información detallada durante la ejecución
::   /dry-run     - Muestra los comandos que se ejecutarían sin ejecutarlos realmente
::##################################################

setlocal enabledelayedexpansion

set "TARGET_ENV="
set "VERBOSE=false"
set "DRY_RUN=false"

:: Parsea argumentos
:parse_args
if "%~1"=="" goto args_done

if /i "%~1"=="dev" (
    if defined TARGET_ENV (
        echo Error: solo se permite un entorno objetivo ^(dev, prod o all^).
        call :print_help
        exit /b 1
    )
    set "TARGET_ENV=dev"
    shift
    goto parse_args
)
if /i "%~1"=="prod" (
    if defined TARGET_ENV (
        echo Error: solo se permite un entorno objetivo ^(dev, prod o all^).
        call :print_help
        exit /b 1
    )
    set "TARGET_ENV=prod"
    shift
    goto parse_args
)
if /i "%~1"=="all" (
    if defined TARGET_ENV (
        echo Error: solo se permite un entorno objetivo ^(dev, prod o all^).
        call :print_help
        exit /b 1
    )
    set "TARGET_ENV=all"
    shift
    goto parse_args
)
if /i "%~1"=="/h" goto show_help
if /i "%~1"=="/help" goto show_help
if /i "%~1"=="-h" goto show_help
if /i "%~1"=="--help" goto show_help
if /i "%~1"=="/v" (
    set "VERBOSE=true"
    shift
    goto parse_args
)
if /i "%~1"=="/verbose" (
    set "VERBOSE=true"
    shift
    goto parse_args
)
if /i "%~1"=="-v" (
    set "VERBOSE=true"
    shift
    goto parse_args
)
if /i "%~1"=="--verbose" (
    set "VERBOSE=true"
    shift
    goto parse_args
)
if /i "%~1"=="/dry-run" (
    set "DRY_RUN=true"
    shift
    goto parse_args
)
if /i "%~1"=="--dry-run" (
    set "DRY_RUN=true"
    shift
    goto parse_args
)

echo Error: argumento no reconocido '%~1'.
call :print_help
exit /b 1

:args_done

if not defined TARGET_ENV (
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

endlocal
exit /b 0

:show_help
call :print_help
exit /b 0

:: -----------------------------------------------
:print_help
echo Uso: flutterfire-configure.cmd [dev^|prod^|all] [flags]
echo.
echo Argumentos:
echo   dev                  Configura FlutterFire para el entorno de desarrollo
echo   prod                 Configura FlutterFire para el entorno de produccion
echo   all                  Configura FlutterFire para ambos entornos
echo.
echo Flags:
echo   /h, /help, --help    Muestra esta ayuda
echo   /v, /verbose         Muestra informacion detallada durante la ejecucion
echo   /dry-run, --dry-run  Muestra los comandos sin ejecutarlos
exit /b 0

:: -----------------------------------------------
:configure_environment
set "ENV_NAME=%~1"
echo ================================
echo Configurando FlutterFire para el entorno: %ENV_NAME%
echo ================================

set "PROJECT=miutem-%ENV_NAME%"
set "OUT=lib/firebase_options_%ENV_NAME%.dart"

if /i "%ENV_NAME%"=="dev" (
    set "IOS_BUNDLE_ID=cl.utem.miutem.dev"
    set "IOS_OUT=ios/Firebase/development/GoogleService-Info.plist"
    set "MACOS_BUNDLE_ID=cl.utem.miutem.dev"
    set "MACOS_OUT=macos/Firebase/development/GoogleService-Info.plist"
    set "ANDROID_PACKAGE_NAME=cl.inndev.miutem.dev"
    set "ANDROID_OUT=android/app/src/development/google-services.json"
) else if /i "%ENV_NAME%"=="prod" (
    set "IOS_BUNDLE_ID=cl.utem.miutem"
    set "IOS_OUT=ios/Firebase/production/GoogleService-Info.plist"
    set "MACOS_BUNDLE_ID=cl.utem.miutem"
    set "MACOS_OUT=macos/Firebase/production/GoogleService-Info.plist"
    set "ANDROID_PACKAGE_NAME=cl.inndev.miutem"
    set "ANDROID_OUT=android/app/src/production/google-services.json"
) else (
    echo Error: Entorno no valido. Use 'dev', 'prod' o 'all'.
    exit /b 1
)

if "%VERBOSE%"=="true" (
    echo [verbose] Proyecto Firebase: %PROJECT%
    echo [verbose] Salida Dart: %OUT%
    echo [verbose] iOS bundle id: %IOS_BUNDLE_ID%
    echo [verbose] iOS plist: %IOS_OUT%
    echo [verbose] macOS bundle id: %MACOS_BUNDLE_ID%
    echo [verbose] macOS plist: %MACOS_OUT%
    echo [verbose] Android package: %ANDROID_PACKAGE_NAME%
    echo [verbose] Android json: %ANDROID_OUT%
)

set "CMD=flutterfire config --project=%PROJECT% --out=%OUT% --ios-bundle-id=%IOS_BUNDLE_ID% --ios-out=%IOS_OUT% --macos-bundle-id=%MACOS_BUNDLE_ID% --macos-out=%MACOS_OUT% --android-package-name=%ANDROID_PACKAGE_NAME% --android-out=%ANDROID_OUT%"

if "%VERBOSE%"=="true" echo [cmd] %CMD%
if "%DRY_RUN%"=="true" (
    if not "%VERBOSE%"=="true" echo [cmd] %CMD%
    exit /b 0
)

%CMD%
exit /b %errorlevel%

@echo off
setlocal enabledelayedexpansion

:: --- Configuración de Flags ---
set "TARGET_ENV=%~1"
set "VERBOSE=false"
set "DRY_RUN=false"

:: Validar argumento principal
if "%TARGET_ENV%"=="" goto show_help
if "%TARGET_ENV%"=="/h" goto show_help
if "%TARGET_ENV%"=="--help" goto show_help

:: Validar flags adicionales
:loop
if "%~2"=="" goto start_logic
if /i "%~2"=="-v" set "VERBOSE=true"
if /i "%~2"=="--verbose" set "VERBOSE=true"
if /i "%~2"=="--dry-run" set "DRY_RUN=true"
shift
goto loop

:start_logic
if /i "%TARGET_ENV%"=="all" (
    call :configure_env dev
    call :configure_env prod
) else (
    call :configure_env %TARGET_ENV%
)
goto :eof

:: --- Función de Configuración ---
:configure_env
set "ENV_NAME=%~1"
echo ================================
echo Configurando FlutterFire para: %ENV_NAME%
echo ================================

set "PROJECT=miutem-%ENV_NAME%"
set "OUT=lib/firebase_options_%ENV_NAME%.dart"

if /i "%ENV_NAME%"=="dev" (
    set "ID=cl.utem.miutem.dev"
    set "A_ID=cl.inndev.miutem.dev"
    set "I_OUT=ios/Firebase/development/GoogleService-Info.plist"
    set "A_OUT=android/app/src/development/google-services.json"
) else (
    set "ID=cl.utem.miutem"
    set "A_ID=cl.inndev.miutem"
    set "I_OUT=ios/Firebase/production/GoogleService-Info.plist"
    set "A_OUT=android/app/src/production/google-services.json"
)

set CMD=flutterfire config --project=%PROJECT% --out=%OUT% --ios-bundle-id=%ID% --ios-out=%I_OUT% --macos-bundle-id=%ID% --macos-out=%I_OUT% --android-package-name=%A_ID% --android-out=%A_OUT% --yes

if "%VERBOSE%"=="true" echo [CMD]: %CMD%
if "%DRY_RUN%"=="true" (
    echo [DRY-RUN] No se ejecuto el comando.
) else (
    %CMD%
)
goto :eof

:show_help
echo Uso: flutterfire-configure.cmd [dev^|prod^|all] [--verbose] [--dry-run]
goto :eof

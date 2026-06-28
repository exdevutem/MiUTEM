##################################################
# Script para configurar FlutterFire para múltiples entornos (dev y prod)
# Autor: Francisco Solis Maturana (Club de Desarrollo Experimental)
# Uso: .\flutterfire-configure.ps1 [dev|prod|all]
# Argumentos:
#   dev  - Configura FlutterFire para el entorno de desarrollo
#   prod - Configura FlutterFire para el entorno de producción
#   all  - Configura FlutterFire para ambos entornos (dev y prod)
# Flags:
#   -h, --help    - Muestra esta ayuda
#   -v, --verbose - Muestra información detallada durante la ejecución
#   --dry-run     - Muestra los comandos que se ejecutarían sin ejecutarlos realmente
##################################################

$ENVIRONMENTS = @("dev", "prod")
$VERBOSE = $false
$DRY_RUN = $false
$TARGET_ENV = ""

function Print-Help {
    Write-Host @"
Uso: .\flutterfire-configure.ps1 [dev|prod|all] [flags]

Argumentos:
  dev                  Configura FlutterFire para el entorno de desarrollo
  prod                 Configura FlutterFire para el entorno de producción
  all                  Configura FlutterFire para ambos entornos

Flags:
  -h, --help           Muestra esta ayuda
  -v, --verbose        Muestra información detallada durante la ejecución
  --dry-run            Muestra los comandos sin ejecutarlos
"@
}

function Log-Verbose {
    param([string]$Message)
    if ($VERBOSE) {
        Write-Host "[verbose] $Message"
    }
}

function Run-Cmd {
    param([string[]]$Cmd)

    if ($VERBOSE -or $DRY_RUN) {
        Write-Host "[cmd] $($Cmd -join ' ')"
    }

    if ($DRY_RUN) {
        return
    }

    & $Cmd[0] $Cmd[1..($Cmd.Length - 1)]
}

function Configure-Environment {
    param([string]$Env)

    Write-Host "================================"
    Write-Host "Configurando FlutterFire para el entorno: $Env"
    Write-Host "================================"

    $PROJECT = "miutem-$Env"
    $OUT = "lib/firebase_options_$Env.dart"

    if ($Env -eq "dev") {
        $IOS_BUNDLE_ID = "cl.utem.miutem.dev"
        $IOS_OUT = "ios/Firebase/development/GoogleService-Info.plist"
        $IOS_BUILD_CONFIG = "Release-development"
        $MACOS_BUNDLE_ID = "cl.utem.miutem.dev"
        $MACOS_OUT = "macos/Firebase/development/GoogleService-Info.plist"
        $MACOS_BUILD_CONFIG = "Release-development"
        $ANDROID_PACKAGE_NAME = "cl.inndev.miutem.dev"
        $ANDROID_OUT = "android/app/src/development/google-services.json"
    } elseif ($Env -eq "prod") {
        $IOS_BUNDLE_ID = "cl.utem.miutem"
        $IOS_OUT = "ios/Firebase/production/GoogleService-Info.plist"
        $IOS_BUILD_CONFIG = "Release-production"
        $MACOS_BUNDLE_ID = "cl.utem.miutem"
        $MACOS_OUT = "macos/Firebase/production/GoogleService-Info.plist"
        $MACOS_BUILD_CONFIG = "Release-production"
        $ANDROID_PACKAGE_NAME = "cl.inndev.miutem"
        $ANDROID_OUT = "android/app/src/production/google-services.json"
    } else {
        Write-Host "Error: Entorno no valido. Use 'dev', 'prod' o 'all'."
        exit 1
    }

    Log-Verbose "Proyecto Firebase: $PROJECT"
    Log-Verbose "Salida Dart: $OUT"
    Log-Verbose "iOS bundle id: $IOS_BUNDLE_ID"
    Log-Verbose "iOS build config: $IOS_BUILD_CONFIG"
    Log-Verbose "iOS plist: $IOS_OUT"
    Log-Verbose "macOS bundle id: $MACOS_BUNDLE_ID"
    Log-Verbose "macOS build config: $MACOS_BUILD_CONFIG"
    Log-Verbose "macOS plist: $MACOS_OUT"
    Log-Verbose "Android package: $ANDROID_PACKAGE_NAME"
    Log-Verbose "Android json: $ANDROID_OUT"

    $FIREBASE_TOKEN = $env:FIREBASE_TOKEN

    # Solo si el env "FIREBASE_TOKEN" está definido, se usa el flag --token
    if ($FIREBASE_TOKEN) {
        Log-Verbose "Usando token de Firebase desde la variable de entorno FIREBASE_TOKEN"
    }

    $cmd = @(
        "flutterfire", "config",
        "--platforms=ios,macos,android",
        "--project=$PROJECT",
        "--out=$OUT",
        "--ios-bundle-id=$IOS_BUNDLE_ID",
        "--ios-out=$IOS_OUT",
        "--ios-build-config=$IOS_BUILD_CONFIG",
        "--macos-bundle-id=$MACOS_BUNDLE_ID",
        "--macos-out=$MACOS_OUT",
        "--macos-build-config=$MACOS_BUILD_CONFIG",
        "--android-package-name=$ANDROID_PACKAGE_NAME",
        "--android-out=$ANDROID_OUT",
        "-f"
    )

    if ($FIREBASE_TOKEN) {
        $cmd += "--token=$FIREBASE_TOKEN"
    }

    Run-Cmd -Cmd $cmd
}

# Parsea argumentos y flags en cualquier orden
$i = 0
$args_list = $args

while ($i -lt $args_list.Length) {
    $arg = $args_list[$i]

    switch ($arg) {
        { $_ -in @("dev", "prod", "all") } {
            if ($TARGET_ENV -ne "") {
                Write-Host "Error: solo se permite un entorno objetivo (dev, prod o all)."
                Print-Help
                exit 1
            }
            $TARGET_ENV = $arg
        }
        { $_ -in @("-h", "--help") } {
            Print-Help
            exit 0
        }
        { $_ -in @("-v", "--verbose") } {
            $VERBOSE = $true
        }
        "--dry-run" {
            $DRY_RUN = $true
        }
        default {
            Write-Host "Error: argumento no reconocido '$arg'."
            Print-Help
            exit 1
        }
    }

    $i++
}

if ($TARGET_ENV -eq "") {
    Write-Host "Error: debe indicar un entorno (dev, prod o all)."
    Print-Help
    exit 1
}

if ($TARGET_ENV -eq "all") {
    foreach ($ENV in $ENVIRONMENTS) {
        Configure-Environment -Env $ENV
    }
} else {
    Configure-Environment -Env $TARGET_ENV
}

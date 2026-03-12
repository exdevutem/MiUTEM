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

param (
    [Parameter(Position = 0)]
    [string]$Env = "",

    [Alias("v")]
    [switch]$ShowVerbose,

    [switch]$DryRun,

    [Alias("h")]
    [switch]$Help
)

$ENVIRONMENTS = @("dev", "prod")

function Print-Help {
    Write-Host @"
Uso: .\flutterfire-configure.ps1 [dev|prod|all] [flags]

Argumentos:
  dev                  Configura FlutterFire para el entorno de desarrollo
  prod                 Configura FlutterFire para el entorno de producción
  all                  Configura FlutterFire para ambos entornos

Flags:
  -h, -Help            Muestra esta ayuda
  -v, -Verbose         Muestra información detallada durante la ejecución
  -DryRun              Muestra los comandos sin ejecutarlos
"@
}

function Log-Verbose {
    param([string]$Message)
    if ($ShowVerbose) {
        Write-Host "[verbose] $Message"
    }
}

function Run-Cmd {
    param([string[]]$Cmd)

    if ($ShowVerbose -or $DryRun) {
        Write-Host "[cmd] $($Cmd -join ' ')"
    }

    if ($DryRun) {
        return
    }

    & $Cmd[0] $Cmd[1..($Cmd.Length - 1)]
}

function Configure-Environment {
    param([string]$TargetEnv)

    Write-Host "================================"
    Write-Host "Configurando FlutterFire para el entorno: $TargetEnv"
    Write-Host "================================"

    $Project = "miutem-$TargetEnv"
    $Out = "lib/firebase_options_$TargetEnv.dart"

    if ($TargetEnv -eq "dev") {
        $IosBundleId = "cl.utem.miutem.dev"
        $IosOut = "ios/Firebase/development/GoogleService-Info.plist"
        $MacosBundleId = "cl.utem.miutem.dev"
        $MacosOut = "macos/Firebase/development/GoogleService-Info.plist"
        $AndroidPackageName = "cl.inndev.miutem.dev"
        $AndroidOut = "android/app/src/development/google-services.json"
    } elseif ($TargetEnv -eq "prod") {
        $IosBundleId = "cl.utem.miutem"
        $IosOut = "ios/Firebase/production/GoogleService-Info.plist"
        $MacosBundleId = "cl.utem.miutem"
        $MacosOut = "macos/Firebase/production/GoogleService-Info.plist"
        $AndroidPackageName = "cl.inndev.miutem"
        $AndroidOut = "android/app/src/production/google-services.json"
    } else {
        Write-Host "Error: Entorno no válido. Use 'dev', 'prod' o 'all'."
        exit 1
    }

    Log-Verbose "Proyecto Firebase: $Project"
    Log-Verbose "Salida Dart: $Out"
    Log-Verbose "iOS bundle id: $IosBundleId"
    Log-Verbose "iOS plist: $IosOut"
    Log-Verbose "macOS bundle id: $MacosBundleId"
    Log-Verbose "macOS plist: $MacosOut"
    Log-Verbose "Android package: $AndroidPackageName"
    Log-Verbose "Android json: $AndroidOut"

    Run-Cmd @(
        "flutterfire", "config",
        "--project=$Project",
        "--out=$Out",
        "--ios-bundle-id=$IosBundleId",
        "--ios-out=$IosOut",
        "--macos-bundle-id=$MacosBundleId",
        "--macos-out=$MacosOut",
        "--android-package-name=$AndroidPackageName",
        "--android-out=$AndroidOut"
    )
}

# Mostrar ayuda
if ($Help) {
    Print-Help
    exit 0
}

# Validar entorno
if ($Env -eq "") {
    Write-Host "Error: debe indicar un entorno (dev, prod o all)."
    Print-Help
    exit 1
}

if ($Env -ne "dev" -and $Env -ne "prod" -and $Env -ne "all") {
    Write-Host "Error: argumento no reconocido '$Env'."
    Print-Help
    exit 1
}

if ($Env -eq "all") {
    foreach ($e in $ENVIRONMENTS) {
        Configure-Environment $e
    }
} else {
    Configure-Environment $Env
}

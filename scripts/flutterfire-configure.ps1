##################################################
# Script para configurar FlutterFire para múltiples entornos y tipos de build.
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
#   --build-type=<Debug|Release|all> - Limita las build configurations a generar
#
# Por cada entorno se registran las build configurations de Xcode
# Debug-<flavor> y Release-<flavor>, de modo que la app pueda ejecutarse
# tanto en modo debug como en release.
##################################################

# entorno, flavor y sufijo de bundle id / package name
$ENVIRONMENTS = @(
    [pscustomobject]@{ Name = "dev";  Flavor = "development"; Suffix = ".dev" }
    [pscustomobject]@{ Name = "prod"; Flavor = "production";  Suffix = "" }
)

# Build configurations de Xcode que se generan por cada entorno.
$BUILD_TYPES = @("Debug", "Release")

$FIREBASE_PROJECT_PREFIX = "miutem"
$APPLE_BUNDLE_ID = "cl.utem.miutem"
$ANDROID_PACKAGE_NAME = "cl.inndev.miutem"

$VERBOSE = $false
$DRY_RUN = $false
$TARGET_ENV = ""
$TARGET_BUILD_TYPE = "all"

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
  --build-type=<tipo>  Genera solo Debug, solo Release, o all (por defecto: all)

Cada entorno registra las build configurations Debug-<flavor> y Release-<flavor>.
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

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: '$($Cmd -join ' ')' fallo con codigo $LASTEXITCODE."
        exit $LASTEXITCODE
    }
}

function Configure-Environment {
    param([pscustomobject]$Environment)

    $project = "$FIREBASE_PROJECT_PREFIX-$($Environment.Name)"
    $dartOut = "lib/firebase_options_$($Environment.Name).dart"
    $bundleId = "$APPLE_BUNDLE_ID$($Environment.Suffix)"
    $packageName = "$ANDROID_PACKAGE_NAME$($Environment.Suffix)"
    $iosOut = "ios/Firebase/$($Environment.Flavor)/GoogleService-Info.plist"
    $macosOut = "macos/Firebase/$($Environment.Flavor)/GoogleService-Info.plist"
    $androidOut = "android/app/src/$($Environment.Flavor)/google-services.json"

    Log-Verbose "Proyecto Firebase: $project"
    Log-Verbose "Salida Dart: $dartOut"
    Log-Verbose "Apple bundle id: $bundleId"
    Log-Verbose "iOS plist: $iosOut"
    Log-Verbose "macOS plist: $macosOut"
    Log-Verbose "Android package: $packageName"
    Log-Verbose "Android json: $androidOut"

    # Solo si el env "FIREBASE_TOKEN" está definido, se usa el flag --token
    $firebaseToken = $env:FIREBASE_TOKEN
    if ($firebaseToken) {
        Log-Verbose "Usando token de Firebase desde la variable de entorno FIREBASE_TOKEN"
    }

    foreach ($buildType in $BUILD_TYPES) {
        if ($TARGET_BUILD_TYPE -ne "all" -and $buildType -ne $TARGET_BUILD_TYPE) {
            continue
        }

        $buildConfig = "$buildType-$($Environment.Flavor)"

        Write-Host "================================"
        Write-Host "Configurando FlutterFire para el entorno: $($Environment.Name) ($buildConfig)"
        Write-Host "================================"

        $cmd = @(
            "flutterfire", "config",
            "--platforms=ios,macos,android",
            "--project=$project",
            "--out=$dartOut",
            "--ios-bundle-id=$bundleId",
            "--ios-out=$iosOut",
            "--ios-build-config=$buildConfig",
            "--macos-bundle-id=$bundleId",
            "--macos-out=$macosOut",
            "--macos-build-config=$buildConfig",
            "--android-package-name=$packageName",
            "--android-out=$androidOut",
            "-f"
        )

        if ($firebaseToken) {
            $cmd += "--token=$firebaseToken"
        }

        Run-Cmd -Cmd $cmd
    }
}

# Parsea argumentos y flags en cualquier orden
foreach ($arg in $args) {
    switch -Exact ($arg) {
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
        { $_ -like "--build-type=*" } {
            $value = $arg.Substring("--build-type=".Length)

            if ($value -eq "all") {
                $TARGET_BUILD_TYPE = "all"
            } else {
                # "-eq" no distingue mayusculas, asi que devuelve el nombre canonico.
                $canonical = $BUILD_TYPES | Where-Object { $_ -eq $value } | Select-Object -First 1

                if (-not $canonical) {
                    Write-Host "Error: build type no valido '$value'. Use $($BUILD_TYPES -join ', ') o all."
                    Print-Help
                    exit 1
                }

                $TARGET_BUILD_TYPE = $canonical
            }
        }
        { $ENVIRONMENTS.Name -contains $_ -or $_ -eq "all" } {
            if ($TARGET_ENV -ne "") {
                Write-Host "Error: solo se permite un entorno objetivo (dev, prod o all)."
                Print-Help
                exit 1
            }
            $TARGET_ENV = $arg
        }
        default {
            Write-Host "Error: argumento no reconocido '$arg'."
            Print-Help
            exit 1
        }
    }
}

if ($TARGET_ENV -eq "") {
    Write-Host "Error: debe indicar un entorno (dev, prod o all)."
    Print-Help
    exit 1
}

if (-not $DRY_RUN -and -not (Get-Command flutterfire -ErrorAction SilentlyContinue)) {
    Write-Host "Error: no se encontro 'flutterfire'. Instalalo con 'dart pub global activate flutterfire_cli'."
    exit 1
}

# Se ejecuta siempre desde la raíz del proyecto, sin importar desde dónde se invoque.
Push-Location (Split-Path -Parent $PSScriptRoot)
try {
    foreach ($environment in $ENVIRONMENTS) {
        if ($TARGET_ENV -eq "all" -or $environment.Name -eq $TARGET_ENV) {
            Configure-Environment -Environment $environment
        }
    }
} finally {
    Pop-Location
}

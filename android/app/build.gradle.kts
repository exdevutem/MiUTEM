import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.fromTarget("17")
    }
}

android {
    namespace = "cl.inndev.miutem"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = project.findProperty("android.ndkVersion") as String? ?: "29.0.14206865"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    val keystoreProperties = Properties()
    val keystorePropertiesFile = rootProject.file("key.properties")
    if (keystorePropertiesFile.exists()) {
        keystoreProperties.load(FileInputStream(keystorePropertiesFile))
    }

    val resolvedStoreFile = System.getenv("MIUTEM_KEYSTORE_PATH")
        ?: (project.findProperty("MIUTEM_KEYSTORE_PATH") as String?)
        ?: (keystoreProperties["storeFile"] as String?)
    val resolvedStorePassword = System.getenv("MIUTEM_KEYSTORE_PASSWORD")
        ?: (project.findProperty("MIUTEM_KEYSTORE_PASSWORD") as String?)
        ?: (keystoreProperties["storePassword"] as String?)
    val resolvedKeyAlias = System.getenv("MIUTEM_KEY_ALIAS")
        ?: (project.findProperty("MIUTEM_KEY_ALIAS") as String?)
        ?: (keystoreProperties["keyAlias"] as String?)
    val resolvedKeyPassword = System.getenv("MIUTEM_KEY_PASSWORD")
        ?: (project.findProperty("MIUTEM_KEY_PASSWORD") as String?)
        ?: (keystoreProperties["keyPassword"] as String?)
    val useDebugSigning = System.getenv("MIUTEM_USE_DEBUG_SIGNING")?.toBoolean() ?: false

    signingConfigs {
        create("release") {
            keyAlias = resolvedKeyAlias
            keyPassword = resolvedKeyPassword
            storeFile = resolvedStoreFile?.let { file(it) }
            storePassword = resolvedStorePassword
        }
        // Sin keystore propio se deja el `debug` tal cual lo trae AGP, que apunta a
        // ~/.android/debug.keystore y lo crea la primera vez que lo necesita. Fijarle el
        // `storeFile` a mano lo convierte en un keystore del usuario y Gradle exige que ya
        // exista: en una máquina limpia —los runners de CI lo son— el build muere con
        // "Keystore file '~/.android/debug.keystore' not found for signing config 'debug'".
        getByName("debug") {
            if (!useDebugSigning && resolvedStoreFile != null) {
                keyAlias = resolvedKeyAlias ?: "androiddebugkey"
                keyPassword = resolvedKeyPassword ?: "android"
                storeFile = file(resolvedStoreFile)
                storePassword = resolvedStorePassword ?: "android"
            }
        }
    }

    defaultConfig {
        applicationId = "cl.inndev.miutem"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // El runner con el que screengrab ejecuta el recorrido de las capturas.
        // https://docs.fastlane.tools/getting-started/android/screenshots/
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildFeatures {
        resValues = true
    }

    buildTypes {
        named("release") {
            signingConfig = signingConfigs.getByName("release")
        }

        named("debug") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    flavorDimensions += "default"

    productFlavors {
        create("development") {
            dimension = "default"
            resValue(type = "string", name = "app_name", value = "Mi UTEM Dev")
            applicationIdSuffix = ".dev"
        }
        create("production") {
            dimension = "default"
            resValue(type = "string", name = "app_name", value = "Mi UTEM")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Capturas de pantalla para Google Play. La dependencia es la que pide la guía de
    // fastlane: https://docs.fastlane.tools/getting-started/android/screenshots/
    androidTestImplementation("tools.fastlane:screengrab:2.1.1")

    // El POM de screengrab declara todas sus dependencias con alcance de ejecución, así que
    // están en el APK de tests pero no al compilar el recorrido. JUnit y el registro de
    // instrumentación igual se resuelven porque el plugin integration_test los expone por
    // el classpath de la app; UI Automator no lo trae nadie más y hay que pedirlo acá.
    //
    // En la misma versión que ya resuelve screengrab: AGP alinea el classpath de
    // compilación de los tests con el de ejecución, y pedir otra versión termina en
    // "cannot find a version ... by consistent resolution".
    androidTestImplementation("androidx.test.uiautomator:uiautomator:2.2.0")
}

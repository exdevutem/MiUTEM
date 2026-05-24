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
    ndkVersion = "29.0.14206865"

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

    val debugKeystore = file("${System.getProperty("user.home")}/.android/debug.keystore")

    signingConfigs {
        create("release") {
            keyAlias = resolvedKeyAlias
            keyPassword = resolvedKeyPassword
            storeFile = resolvedStoreFile?.let { file(it) }
            storePassword = resolvedStorePassword
        }
        getByName("debug") {
            keyAlias = if (useDebugSigning) "androiddebugkey" else (resolvedKeyAlias ?: "androiddebugkey")
            keyPassword = if (useDebugSigning) "android" else (resolvedKeyPassword ?: "android")
            storeFile = if (useDebugSigning) debugKeystore else (resolvedStoreFile?.let { file(it) } ?: debugKeystore)
            storePassword = if (useDebugSigning) "android" else (resolvedStorePassword ?: "android")
        }
    }

    defaultConfig {
        applicationId = "cl.inndev.miutem"
        
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
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

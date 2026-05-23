import org.jetbrains.kotlin.gradle.dsl.JvmTarget
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
        jvmTarget = JvmTarget.fromTarget("17")
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

    val resolvedStoreFile = System.getenv("MIUTEM_KEYSTORE_PATH") ?: keystoreProperties["storeFile"] as String?
    val resolvedStorePassword = System.getenv("MIUTEM_KEYSTORE_PASSWORD") ?: keystoreProperties["storePassword"] as String?
    val resolvedKeyAlias = System.getenv("MIUTEM_KEY_ALIAS") ?: keystoreProperties["keyAlias"] as String?
    val resolvedKeyPassword = System.getenv("MIUTEM_KEY_PASSWORD") ?: keystoreProperties["keyPassword"] as String?

    signingConfigs {
        create("release") {
            keyAlias = resolvedKeyAlias
            keyPassword = resolvedKeyPassword
            storeFile = resolvedStoreFile?.let { file(it) }
            storePassword = resolvedStorePassword
        }
    }

    defaultConfig {
        applicationId = "cl.inndev.miutem"
        
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        named("release") {
            signingConfig = signingConfigs.getByName("release")
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

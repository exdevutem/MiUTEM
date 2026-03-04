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


android {
    namespace = "cl.inndev.miutem"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    // AQUI SE TIENE QUE USAR LA CONFIGURACION DEL KEYSTORE QUE TIENE LA APP OFICIAL
    defaultConfig {
        applicationId = "cl.inndev.miutem"
        
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        named("release") {
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

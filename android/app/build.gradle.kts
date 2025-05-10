plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Firebase
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter plugin (must be last)
}

android {
    namespace = "com.example.eleaning"
    compileSdk = 35

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.eleaning"
        minSdk = 23
        targetSdk = 34 // Hardcoded to avoid issues
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
       release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so flutter run --release works.
            signingConfig = signingConfigs.getByName("debug")
        }

    }
}

dependencies {
    implementation("com.facebook.android:facebook-login:16.1.2") // Updated Facebook SDK
}

flutter {
    source = "../.."
}

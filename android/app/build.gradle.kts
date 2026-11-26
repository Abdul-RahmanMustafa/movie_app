import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val developmentSigningPropertiesFile =
    rootProject.file("development-signing.properties")
val developmentSigningProperties = Properties()
val hasDevelopmentSigningConfiguration = developmentSigningPropertiesFile.isFile

if (hasDevelopmentSigningConfiguration) {
    developmentSigningPropertiesFile.inputStream().use {
        developmentSigningProperties.load(it)
    }
}

fun requiredDevelopmentSigningProperty(name: String): String {
    val value = developmentSigningProperties.getProperty(name)?.trim()
    if (value.isNullOrEmpty()) {
        throw GradleException(
            "Missing '$name' in ${developmentSigningPropertiesFile.path}",
        )
    }
    return value
}

val developmentKeystoreFile =
    if (hasDevelopmentSigningConfiguration) {
        rootProject.file(requiredDevelopmentSigningProperty("storeFile"))
    } else {
        null
    }

if (hasDevelopmentSigningConfiguration && developmentKeystoreFile?.isFile != true) {
    throw GradleException(
        "Development keystore not found at ${developmentKeystoreFile?.path}",
    )
}

android {
    namespace = "com.example.movie_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.movie_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasDevelopmentSigningConfiguration) {
            create("development") {
                storeFile = requireNotNull(developmentKeystoreFile)
                storePassword = requiredDevelopmentSigningProperty("storePassword")
                keyAlias = requiredDevelopmentSigningProperty("keyAlias")
                keyPassword = requiredDevelopmentSigningProperty("keyPassword")
            }
        }
    }

    buildTypes {
        debug {
            // Opt in to the shared development certificate when its ignored
            // local configuration exists. Otherwise, keep Flutter's standard
            // per-machine debug signing behavior.
            if (hasDevelopmentSigningConfiguration) {
                signingConfig = signingConfigs.getByName("development")
            }
        }

        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

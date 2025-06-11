import java.util.Properties
import java.nio.charset.Charset

val mapsProperties = Properties()
val localMapsPropertiesFile = rootProject.file("secret.properties")
if (localMapsPropertiesFile.exists()) {
    project.logger.info("Load maps properties from local file")
    localMapsPropertiesFile.reader(Charset.forName("UTF-8")).use { reader ->
        mapsProperties.load(reader)
    }
} else {
    project.logger.info("Load maps properties from environment")
    try {
        mapsProperties["MAPS_API_KEY"] = System.getenv("MAPS_API_KEY")
    } catch (e: NullPointerException) {
        project.logger.warn("Failed to load MAPS_API_KEY from environment.", e)
    }
}

val mapsApiKey = mapsProperties.getProperty("MAPS_API_KEY") ?: run {
    project.logger.error("Google Maps Api Key not configured. Set it in `secret.properties` or in the environment variable `MAPS_API_KEY`")
    ""
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.android"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.android"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["googleMapsApiKey"] = mapsApiKey
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

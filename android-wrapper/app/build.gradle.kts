import java.net.URI

plugins { id("com.android.application"); id("org.jetbrains.kotlin.android") }
val webAppUrl = providers.gradleProperty("WEB_APP_URL").orElse("https://example.invalid").get()
val parsedUrl = URI(webAppUrl)
require(parsedUrl.scheme == "https" && parsedUrl.host != null) { "WEB_APP_URL must be an HTTPS URL" }
android {
    namespace = "com.nocturne.store"
    compileSdk = 35
    defaultConfig {
        applicationId = "com.nocturne.store"
        minSdk = 23
        targetSdk = 35
        versionCode = 1
        versionName = "1.0.0"
        buildConfigField("String", "WEB_APP_URL", "\"$webAppUrl\"")
        buildConfigField("String", "WEB_APP_HOST", "\"${parsedUrl.host}\"")
    }
    buildFeatures { buildConfig = true }
}

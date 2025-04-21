# Flutter ProGuard rules
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**
-keep class androidx.lifecycle.** { *; }
-dontwarn androidx.lifecycle.**

# Keep your model classes (adjust based on your package)
-keep class com.makinglifeeasie.closetconscious.models.** { *; }

# Supabase specific ProGuard rules
-keep class io.supabase.** { *; }
-dontwarn io.supabase.**

# Keep Kotlin coroutines if used
-keepclassmembers class kotlinx.coroutines.** { *; }

-keep class com.google.android.gms.** { *; }
-keep class com.google.firebase.** { *; }
-keep class com.google.api.** { *; }
-dontwarn com.google.**

# image_picker specific rules
-keep class io.flutter.plugins.imagepicker.** { *; }
-dontwarn io.flutter.plugins.imagepicker.**

# Android XML parser classes that image_picker might rely on
-dontwarn android.content.res.XmlBlock$Parser

# Keep all classes in org.xmlpull.v1 for XML parsing
-keep class org.xmlpull.v1.** { *; }
-dontwarn org.xmlpull.v1.**

# General Android SDK rules (prevent stripping of core classes)
-keep class android.** { *; }
-dontwarn android.**

# WorkManager rules — required for background job execution
-keep class androidx.work.** { *; }
-dontwarn androidx.work.**

# flutter_local_notifications plugin
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn com.dexterous.flutterlocalnotifications.**

# Optional: your app-specific classes used in background execution
-keep class com.makinglifeeasie.closetconscious.** { *; }
-dontwarn com.makinglifeeasie.closetconscious.**

# Logger package (if needed, generally safe)
-keep class com.orhanobut.logger.** { *; }
-dontwarn com.orhanobut.logger.**

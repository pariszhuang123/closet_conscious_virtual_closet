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

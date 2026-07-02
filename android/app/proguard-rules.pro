# Flutter engine
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# App entry point
-keep class com.dcs.srgapp.MainActivity { *; }

# ✅ Play Core — missing classes fix
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }
-dontwarn io.flutter.embedding.android.FlutterPlayStoreSplitApplication
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# Dio / OkHttp
-dontwarn okhttp3.**
-dontwarn okio.**

# Annotations
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions
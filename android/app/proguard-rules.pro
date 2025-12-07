# -------------------------------------------
# Flutter + ML Kit release build rules
# -------------------------------------------

# Keep ML Kit vision text recognition classes
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

# Keep Google Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Keep Flutter core classes
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# Keep Flutter plugin registration
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

# Prevent removing any entry points
-keep class * extends io.flutter.embedding.android.FlutterActivity { *; }
-keep class * extends io.flutter.embedding.engine.FlutterEngine { *; }

# Optional: for Firebase or ML model dependencies
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

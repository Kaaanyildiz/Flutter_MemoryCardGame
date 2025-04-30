# Flutter proguard rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase if used later
-keep class com.google.firebase.** { *; }

# Prevent R8 from removing annotations from Crashlytics
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

# For native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep JSON classes if using any JSON parsing libraries
-keep class org.json.** { *; }
-keep class com.google.gson.** { *; }

# Prevent proguard from stripping interface information from data classes
-keep class * implements java.io.Serializable { *; }

# Preserve the special static methods that are required in all enumeration classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
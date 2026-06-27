# ProGuard / R8 rules for Lumina (feu_evangile_flutter)
# =====================================================

# --- Isar ---
# Keep Isar generated database models
-keep class * extends dev.isar.IsarCollection { *; }
-keepclassmembers class * { @dev.isar.IsarCollection *; }

# --- google_sign_in v7+ ---
# Empêche R8 de supprimer/obfusquer les classes Google Sign-In.
# Sans ces règles, le consentement Google peut échouer silencieusement en release.
-keep class com.google.android.gms.auth.api.signin.** { *; }
-keep class com.google.android.gms.common.api.** { *; }
-keep class com.google.android.gms.common.internal.** { *; }
-dontwarn com.google.android.gms.**

# --- firebase_core ---
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# --- General ---
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
-keepattributes *Annotation*

# Prevent R8 from stripping data classes used with JSON/Freezed
-keepclassmembers,allowobfuscation class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# ProGuard / R8 rules for Lumina (feu_evangile_flutter)
# =====================================================

# --- Isar ---
# Keep Isar generated database models
-keep class * extends dev.isar.IsarCollection { *; }
-keepclassmembers class * { @dev.isar.IsarCollection *; }

# --- General ---
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
-keepattributes *Annotation*

# Prevent R8 from stripping data classes used with JSON/Freezed
-keepclassmembers,allowobfuscation class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

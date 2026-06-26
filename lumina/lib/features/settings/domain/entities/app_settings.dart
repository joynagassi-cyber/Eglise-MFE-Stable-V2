import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

enum SyncConnectionType {
  wifiOnly,
  all, // WiFi + Mobile Data
}

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    // Display
    @Default('system') String themeMode, // light, dark, system
    @Default('fr') String locale,
    @Default(false) bool compactMode,

    // Notifications
    @Default(true) bool pushNotificationsEnabled,
    @Default(true) bool emailNotificationsEnabled,
    @Default(true) bool birthdayReminders,
    @Default(true) bool eventReminders,
    @Default(true) bool financeAlerts,

    // Sync
    @Default(true) bool autoSync,
    @Default(30) int syncIntervalMinutes,
    @Default(SyncConnectionType.wifiOnly) SyncConnectionType syncConnectionType,

    // Privacy
    @Default(true) bool showProfilePhoto,
    @Default(true) bool showPhoneNumber,
    @Default(true) bool showEmail,

    // Data
    @Default(false) bool cloudBackupEnabled,
    DateTime? lastBackupAt,
    String? backupFrequency, // daily, weekly, monthly
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}
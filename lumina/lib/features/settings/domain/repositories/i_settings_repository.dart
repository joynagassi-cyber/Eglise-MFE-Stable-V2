import '../entities/app_settings.dart';

abstract class ISettingsRepository {
  /// Load settings (from local storage)
  Future<AppSettings> loadSettings();

  /// Save settings (to local storage + optional remote sync)
  Future<void> saveSettings(AppSettings settings);

  /// Reset to defaults
  Future<void> resetToDefaults();

  /// Export settings as JSON
  Future<Map<String, dynamic>> exportSettings();

  /// Import settings from JSON
  Future<void> importSettings(Map<String, dynamic> json);
}
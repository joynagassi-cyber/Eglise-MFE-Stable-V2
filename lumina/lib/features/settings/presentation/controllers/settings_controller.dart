import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import 'package:lumina/features/settings/domain/entities/app_settings.dart';

part 'settings_controller.g.dart';

@riverpod
class SettingsController extends _$SettingsController {
  @override
  Future<AppSettings> build() async {
    final repo = ref.watch(settingsRepositoryProvider);
    return repo.loadSettings();
  }

  Future<void> updateSettings(AppSettings settings) async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.saveSettings(settings);
    state = AsyncValue.data(settings);
  }

  Future<void> updateTheme(String themeMode) async {
    final current = state.valueOrNull ?? const AppSettings();
    await updateSettings(current.copyWith(themeMode: themeMode));
  }

  Future<void> updateLocale(String locale) async {
    final current = state.valueOrNull ?? const AppSettings();
    await updateSettings(current.copyWith(locale: locale));
  }

  Future<void> togglePushNotifications(bool enabled) async {
    final current = state.valueOrNull ?? const AppSettings();
    await updateSettings(current.copyWith(pushNotificationsEnabled: enabled));
  }

  Future<void> toggleAutoSync(bool enabled) async {
    final current = state.valueOrNull ?? const AppSettings();
    await updateSettings(current.copyWith(autoSync: enabled));
  }

  Future<void> updateSyncConnectionType(SyncConnectionType type) async {
    final current = state.valueOrNull ?? const AppSettings();
    await updateSettings(current.copyWith(syncConnectionType: type));
  }

  Future<void> toggleCompactMode(bool enabled) async {
    final current = state.valueOrNull ?? const AppSettings();
    await updateSettings(current.copyWith(compactMode: enabled));
  }

  Future<void> toggleEmailNotifications(bool enabled) async {
    final current = state.valueOrNull ?? const AppSettings();
    await updateSettings(current.copyWith(emailNotificationsEnabled: enabled));
  }

  Future<void> toggleBirthdayReminders(bool enabled) async {
    final current = state.valueOrNull ?? const AppSettings();
    await updateSettings(current.copyWith(birthdayReminders: enabled));
  }

  Future<void> toggleEventReminders(bool enabled) async {
    final current = state.valueOrNull ?? const AppSettings();
    await updateSettings(current.copyWith(eventReminders: enabled));
  }

  Future<void> toggleFinanceAlerts(bool enabled) async {
    final current = state.valueOrNull ?? const AppSettings();
    await updateSettings(current.copyWith(financeAlerts: enabled));
  }

  Future<void> setSyncOnlyOnWifi(bool enabled) async {
    final current = state.value;
    if (current == null) return;
    await updateSettings(current.copyWith(
      syncConnectionType:
          enabled ? SyncConnectionType.wifiOnly : SyncConnectionType.all,
    ));
  }

  Future<void> toggleShowProfilePhoto(bool enabled) async {
    final current = state.valueOrNull ?? const AppSettings();
    await updateSettings(current.copyWith(showProfilePhoto: enabled));
  }

  Future<void> toggleShowPhoneNumber(bool enabled) async {
    final current = state.valueOrNull ?? const AppSettings();
    await updateSettings(current.copyWith(showPhoneNumber: enabled));
  }

  Future<void> toggleShowEmail(bool enabled) async {
    final current = state.valueOrNull ?? const AppSettings();
    await updateSettings(current.copyWith(showEmail: enabled));
  }

  Future<void> toggleCloudBackup(bool enabled) async {
    final current = state.valueOrNull ?? const AppSettings();
    await updateSettings(current.copyWith(cloudBackupEnabled: enabled));
  }

  Future<void> updateBackupFrequency(String frequency) async {
    final current = state.valueOrNull ?? const AppSettings();
    await updateSettings(current.copyWith(backupFrequency: frequency));
  }

  Future<void> resetToDefaults() async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.resetToDefaults();
    state = const AsyncValue.data(AppSettings());
  }
}

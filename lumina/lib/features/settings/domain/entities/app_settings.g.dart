// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AppSettingsImpl(
      themeMode: json['theme_mode'] as String? ?? 'system',
      locale: json['locale'] as String? ?? 'fr',
      compactMode: json['compact_mode'] as bool? ?? false,
      pushNotificationsEnabled:
          json['push_notifications_enabled'] as bool? ?? true,
      emailNotificationsEnabled:
          json['email_notifications_enabled'] as bool? ?? true,
      birthdayReminders: json['birthday_reminders'] as bool? ?? true,
      eventReminders: json['event_reminders'] as bool? ?? true,
      financeAlerts: json['finance_alerts'] as bool? ?? true,
      autoSync: json['auto_sync'] as bool? ?? true,
      syncIntervalMinutes:
          (json['sync_interval_minutes'] as num?)?.toInt() ?? 30,
      syncConnectionType: $enumDecodeNullable(
              _$SyncConnectionTypeEnumMap, json['sync_connection_type']) ??
          SyncConnectionType.wifiOnly,
      showProfilePhoto: json['show_profile_photo'] as bool? ?? true,
      showPhoneNumber: json['show_phone_number'] as bool? ?? true,
      showEmail: json['show_email'] as bool? ?? true,
      cloudBackupEnabled: json['cloud_backup_enabled'] as bool? ?? false,
      lastBackupAt: json['last_backup_at'] == null
          ? null
          : DateTime.parse(json['last_backup_at'] as String),
      backupFrequency: json['backup_frequency'] as String?,
    );

Map<String, dynamic> _$$AppSettingsImplToJson(_$AppSettingsImpl instance) =>
    <String, dynamic>{
      'theme_mode': instance.themeMode,
      'locale': instance.locale,
      'compact_mode': instance.compactMode,
      'push_notifications_enabled': instance.pushNotificationsEnabled,
      'email_notifications_enabled': instance.emailNotificationsEnabled,
      'birthday_reminders': instance.birthdayReminders,
      'event_reminders': instance.eventReminders,
      'finance_alerts': instance.financeAlerts,
      'auto_sync': instance.autoSync,
      'sync_interval_minutes': instance.syncIntervalMinutes,
      'sync_connection_type':
          _$SyncConnectionTypeEnumMap[instance.syncConnectionType]!,
      'show_profile_photo': instance.showProfilePhoto,
      'show_phone_number': instance.showPhoneNumber,
      'show_email': instance.showEmail,
      'cloud_backup_enabled': instance.cloudBackupEnabled,
      'last_backup_at': instance.lastBackupAt?.toIso8601String(),
      'backup_frequency': instance.backupFrequency,
    };

const _$SyncConnectionTypeEnumMap = {
  SyncConnectionType.wifiOnly: 'wifiOnly',
  SyncConnectionType.all: 'all',
};

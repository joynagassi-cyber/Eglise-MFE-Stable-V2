// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
// Display
  String get themeMode =>
      throw _privateConstructorUsedError; // light, dark, system
  String get locale => throw _privateConstructorUsedError;
  bool get compactMode => throw _privateConstructorUsedError; // Notifications
  bool get pushNotificationsEnabled => throw _privateConstructorUsedError;
  bool get emailNotificationsEnabled => throw _privateConstructorUsedError;
  bool get birthdayReminders => throw _privateConstructorUsedError;
  bool get eventReminders => throw _privateConstructorUsedError;
  bool get financeAlerts => throw _privateConstructorUsedError; // Sync
  bool get autoSync => throw _privateConstructorUsedError;
  int get syncIntervalMinutes => throw _privateConstructorUsedError;
  SyncConnectionType get syncConnectionType =>
      throw _privateConstructorUsedError; // Privacy
  bool get showProfilePhoto => throw _privateConstructorUsedError;
  bool get showPhoneNumber => throw _privateConstructorUsedError;
  bool get showEmail => throw _privateConstructorUsedError; // Data
  bool get cloudBackupEnabled => throw _privateConstructorUsedError;
  DateTime? get lastBackupAt => throw _privateConstructorUsedError;
  String? get backupFrequency => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
          AppSettings value, $Res Function(AppSettings) then) =
      _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call(
      {String themeMode,
      String locale,
      bool compactMode,
      bool pushNotificationsEnabled,
      bool emailNotificationsEnabled,
      bool birthdayReminders,
      bool eventReminders,
      bool financeAlerts,
      bool autoSync,
      int syncIntervalMinutes,
      SyncConnectionType syncConnectionType,
      bool showProfilePhoto,
      bool showPhoneNumber,
      bool showEmail,
      bool cloudBackupEnabled,
      DateTime? lastBackupAt,
      String? backupFrequency});
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? locale = null,
    Object? compactMode = null,
    Object? pushNotificationsEnabled = null,
    Object? emailNotificationsEnabled = null,
    Object? birthdayReminders = null,
    Object? eventReminders = null,
    Object? financeAlerts = null,
    Object? autoSync = null,
    Object? syncIntervalMinutes = null,
    Object? syncConnectionType = null,
    Object? showProfilePhoto = null,
    Object? showPhoneNumber = null,
    Object? showEmail = null,
    Object? cloudBackupEnabled = null,
    Object? lastBackupAt = freezed,
    Object? backupFrequency = freezed,
  }) {
    return _then(_value.copyWith(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as String,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      compactMode: null == compactMode
          ? _value.compactMode
          : compactMode // ignore: cast_nullable_to_non_nullable
              as bool,
      pushNotificationsEnabled: null == pushNotificationsEnabled
          ? _value.pushNotificationsEnabled
          : pushNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      emailNotificationsEnabled: null == emailNotificationsEnabled
          ? _value.emailNotificationsEnabled
          : emailNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      birthdayReminders: null == birthdayReminders
          ? _value.birthdayReminders
          : birthdayReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      eventReminders: null == eventReminders
          ? _value.eventReminders
          : eventReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      financeAlerts: null == financeAlerts
          ? _value.financeAlerts
          : financeAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
      autoSync: null == autoSync
          ? _value.autoSync
          : autoSync // ignore: cast_nullable_to_non_nullable
              as bool,
      syncIntervalMinutes: null == syncIntervalMinutes
          ? _value.syncIntervalMinutes
          : syncIntervalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      syncConnectionType: null == syncConnectionType
          ? _value.syncConnectionType
          : syncConnectionType // ignore: cast_nullable_to_non_nullable
              as SyncConnectionType,
      showProfilePhoto: null == showProfilePhoto
          ? _value.showProfilePhoto
          : showProfilePhoto // ignore: cast_nullable_to_non_nullable
              as bool,
      showPhoneNumber: null == showPhoneNumber
          ? _value.showPhoneNumber
          : showPhoneNumber // ignore: cast_nullable_to_non_nullable
              as bool,
      showEmail: null == showEmail
          ? _value.showEmail
          : showEmail // ignore: cast_nullable_to_non_nullable
              as bool,
      cloudBackupEnabled: null == cloudBackupEnabled
          ? _value.cloudBackupEnabled
          : cloudBackupEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      lastBackupAt: freezed == lastBackupAt
          ? _value.lastBackupAt
          : lastBackupAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      backupFrequency: freezed == backupFrequency
          ? _value.backupFrequency
          : backupFrequency // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
          _$AppSettingsImpl value, $Res Function(_$AppSettingsImpl) then) =
      __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String themeMode,
      String locale,
      bool compactMode,
      bool pushNotificationsEnabled,
      bool emailNotificationsEnabled,
      bool birthdayReminders,
      bool eventReminders,
      bool financeAlerts,
      bool autoSync,
      int syncIntervalMinutes,
      SyncConnectionType syncConnectionType,
      bool showProfilePhoto,
      bool showPhoneNumber,
      bool showEmail,
      bool cloudBackupEnabled,
      DateTime? lastBackupAt,
      String? backupFrequency});
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
      _$AppSettingsImpl _value, $Res Function(_$AppSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? locale = null,
    Object? compactMode = null,
    Object? pushNotificationsEnabled = null,
    Object? emailNotificationsEnabled = null,
    Object? birthdayReminders = null,
    Object? eventReminders = null,
    Object? financeAlerts = null,
    Object? autoSync = null,
    Object? syncIntervalMinutes = null,
    Object? syncConnectionType = null,
    Object? showProfilePhoto = null,
    Object? showPhoneNumber = null,
    Object? showEmail = null,
    Object? cloudBackupEnabled = null,
    Object? lastBackupAt = freezed,
    Object? backupFrequency = freezed,
  }) {
    return _then(_$AppSettingsImpl(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as String,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      compactMode: null == compactMode
          ? _value.compactMode
          : compactMode // ignore: cast_nullable_to_non_nullable
              as bool,
      pushNotificationsEnabled: null == pushNotificationsEnabled
          ? _value.pushNotificationsEnabled
          : pushNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      emailNotificationsEnabled: null == emailNotificationsEnabled
          ? _value.emailNotificationsEnabled
          : emailNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      birthdayReminders: null == birthdayReminders
          ? _value.birthdayReminders
          : birthdayReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      eventReminders: null == eventReminders
          ? _value.eventReminders
          : eventReminders // ignore: cast_nullable_to_non_nullable
              as bool,
      financeAlerts: null == financeAlerts
          ? _value.financeAlerts
          : financeAlerts // ignore: cast_nullable_to_non_nullable
              as bool,
      autoSync: null == autoSync
          ? _value.autoSync
          : autoSync // ignore: cast_nullable_to_non_nullable
              as bool,
      syncIntervalMinutes: null == syncIntervalMinutes
          ? _value.syncIntervalMinutes
          : syncIntervalMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      syncConnectionType: null == syncConnectionType
          ? _value.syncConnectionType
          : syncConnectionType // ignore: cast_nullable_to_non_nullable
              as SyncConnectionType,
      showProfilePhoto: null == showProfilePhoto
          ? _value.showProfilePhoto
          : showProfilePhoto // ignore: cast_nullable_to_non_nullable
              as bool,
      showPhoneNumber: null == showPhoneNumber
          ? _value.showPhoneNumber
          : showPhoneNumber // ignore: cast_nullable_to_non_nullable
              as bool,
      showEmail: null == showEmail
          ? _value.showEmail
          : showEmail // ignore: cast_nullable_to_non_nullable
              as bool,
      cloudBackupEnabled: null == cloudBackupEnabled
          ? _value.cloudBackupEnabled
          : cloudBackupEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      lastBackupAt: freezed == lastBackupAt
          ? _value.lastBackupAt
          : lastBackupAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      backupFrequency: freezed == backupFrequency
          ? _value.backupFrequency
          : backupFrequency // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsImpl implements _AppSettings {
  const _$AppSettingsImpl(
      {this.themeMode = 'system',
      this.locale = 'fr',
      this.compactMode = false,
      this.pushNotificationsEnabled = true,
      this.emailNotificationsEnabled = true,
      this.birthdayReminders = true,
      this.eventReminders = true,
      this.financeAlerts = true,
      this.autoSync = true,
      this.syncIntervalMinutes = 30,
      this.syncConnectionType = SyncConnectionType.wifiOnly,
      this.showProfilePhoto = true,
      this.showPhoneNumber = true,
      this.showEmail = true,
      this.cloudBackupEnabled = false,
      this.lastBackupAt,
      this.backupFrequency});

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

// Display
  @override
  @JsonKey()
  final String themeMode;
// light, dark, system
  @override
  @JsonKey()
  final String locale;
  @override
  @JsonKey()
  final bool compactMode;
// Notifications
  @override
  @JsonKey()
  final bool pushNotificationsEnabled;
  @override
  @JsonKey()
  final bool emailNotificationsEnabled;
  @override
  @JsonKey()
  final bool birthdayReminders;
  @override
  @JsonKey()
  final bool eventReminders;
  @override
  @JsonKey()
  final bool financeAlerts;
// Sync
  @override
  @JsonKey()
  final bool autoSync;
  @override
  @JsonKey()
  final int syncIntervalMinutes;
  @override
  @JsonKey()
  final SyncConnectionType syncConnectionType;
// Privacy
  @override
  @JsonKey()
  final bool showProfilePhoto;
  @override
  @JsonKey()
  final bool showPhoneNumber;
  @override
  @JsonKey()
  final bool showEmail;
// Data
  @override
  @JsonKey()
  final bool cloudBackupEnabled;
  @override
  final DateTime? lastBackupAt;
  @override
  final String? backupFrequency;

  @override
  String toString() {
    return 'AppSettings(themeMode: $themeMode, locale: $locale, compactMode: $compactMode, pushNotificationsEnabled: $pushNotificationsEnabled, emailNotificationsEnabled: $emailNotificationsEnabled, birthdayReminders: $birthdayReminders, eventReminders: $eventReminders, financeAlerts: $financeAlerts, autoSync: $autoSync, syncIntervalMinutes: $syncIntervalMinutes, syncConnectionType: $syncConnectionType, showProfilePhoto: $showProfilePhoto, showPhoneNumber: $showPhoneNumber, showEmail: $showEmail, cloudBackupEnabled: $cloudBackupEnabled, lastBackupAt: $lastBackupAt, backupFrequency: $backupFrequency)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.compactMode, compactMode) ||
                other.compactMode == compactMode) &&
            (identical(
                    other.pushNotificationsEnabled, pushNotificationsEnabled) ||
                other.pushNotificationsEnabled == pushNotificationsEnabled) &&
            (identical(other.emailNotificationsEnabled,
                    emailNotificationsEnabled) ||
                other.emailNotificationsEnabled == emailNotificationsEnabled) &&
            (identical(other.birthdayReminders, birthdayReminders) ||
                other.birthdayReminders == birthdayReminders) &&
            (identical(other.eventReminders, eventReminders) ||
                other.eventReminders == eventReminders) &&
            (identical(other.financeAlerts, financeAlerts) ||
                other.financeAlerts == financeAlerts) &&
            (identical(other.autoSync, autoSync) ||
                other.autoSync == autoSync) &&
            (identical(other.syncIntervalMinutes, syncIntervalMinutes) ||
                other.syncIntervalMinutes == syncIntervalMinutes) &&
            (identical(other.syncConnectionType, syncConnectionType) ||
                other.syncConnectionType == syncConnectionType) &&
            (identical(other.showProfilePhoto, showProfilePhoto) ||
                other.showProfilePhoto == showProfilePhoto) &&
            (identical(other.showPhoneNumber, showPhoneNumber) ||
                other.showPhoneNumber == showPhoneNumber) &&
            (identical(other.showEmail, showEmail) ||
                other.showEmail == showEmail) &&
            (identical(other.cloudBackupEnabled, cloudBackupEnabled) ||
                other.cloudBackupEnabled == cloudBackupEnabled) &&
            (identical(other.lastBackupAt, lastBackupAt) ||
                other.lastBackupAt == lastBackupAt) &&
            (identical(other.backupFrequency, backupFrequency) ||
                other.backupFrequency == backupFrequency));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      themeMode,
      locale,
      compactMode,
      pushNotificationsEnabled,
      emailNotificationsEnabled,
      birthdayReminders,
      eventReminders,
      financeAlerts,
      autoSync,
      syncIntervalMinutes,
      syncConnectionType,
      showProfilePhoto,
      showPhoneNumber,
      showEmail,
      cloudBackupEnabled,
      lastBackupAt,
      backupFrequency);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(
      this,
    );
  }
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings(
      {final String themeMode,
      final String locale,
      final bool compactMode,
      final bool pushNotificationsEnabled,
      final bool emailNotificationsEnabled,
      final bool birthdayReminders,
      final bool eventReminders,
      final bool financeAlerts,
      final bool autoSync,
      final int syncIntervalMinutes,
      final SyncConnectionType syncConnectionType,
      final bool showProfilePhoto,
      final bool showPhoneNumber,
      final bool showEmail,
      final bool cloudBackupEnabled,
      final DateTime? lastBackupAt,
      final String? backupFrequency}) = _$AppSettingsImpl;

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  @override // Display
  String get themeMode;
  @override // light, dark, system
  String get locale;
  @override
  bool get compactMode;
  @override // Notifications
  bool get pushNotificationsEnabled;
  @override
  bool get emailNotificationsEnabled;
  @override
  bool get birthdayReminders;
  @override
  bool get eventReminders;
  @override
  bool get financeAlerts;
  @override // Sync
  bool get autoSync;
  @override
  int get syncIntervalMinutes;
  @override
  SyncConnectionType get syncConnectionType;
  @override // Privacy
  bool get showProfilePhoto;
  @override
  bool get showPhoneNumber;
  @override
  bool get showEmail;
  @override // Data
  bool get cloudBackupEnabled;
  @override
  DateTime? get lastBackupAt;
  @override
  String? get backupFrequency;
  @override
  @JsonKey(ignore: true)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

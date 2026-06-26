// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PhoneNumber _$PhoneNumberFromJson(Map<String, dynamic> json) {
  return _PhoneNumber.fromJson(json);
}

/// @nodoc
mixin _$PhoneNumber {
  String get number => throw _privateConstructorUsedError;
  String get countryCode => throw _privateConstructorUsedError;
  PhoneType get type => throw _privateConstructorUsedError;
  bool get hasWhatsApp => throw _privateConstructorUsedError;
  bool get hasTelegram => throw _privateConstructorUsedError;
  bool get isPrimary => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  bool get canReceiveSms => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PhoneNumberCopyWith<PhoneNumber> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhoneNumberCopyWith<$Res> {
  factory $PhoneNumberCopyWith(
          PhoneNumber value, $Res Function(PhoneNumber) then) =
      _$PhoneNumberCopyWithImpl<$Res, PhoneNumber>;
  @useResult
  $Res call(
      {String number,
      String countryCode,
      PhoneType type,
      bool hasWhatsApp,
      bool hasTelegram,
      bool isPrimary,
      bool isVerified,
      bool canReceiveSms});
}

/// @nodoc
class _$PhoneNumberCopyWithImpl<$Res, $Val extends PhoneNumber>
    implements $PhoneNumberCopyWith<$Res> {
  _$PhoneNumberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = null,
    Object? countryCode = null,
    Object? type = null,
    Object? hasWhatsApp = null,
    Object? hasTelegram = null,
    Object? isPrimary = null,
    Object? isVerified = null,
    Object? canReceiveSms = null,
  }) {
    return _then(_value.copyWith(
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PhoneType,
      hasWhatsApp: null == hasWhatsApp
          ? _value.hasWhatsApp
          : hasWhatsApp // ignore: cast_nullable_to_non_nullable
              as bool,
      hasTelegram: null == hasTelegram
          ? _value.hasTelegram
          : hasTelegram // ignore: cast_nullable_to_non_nullable
              as bool,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      canReceiveSms: null == canReceiveSms
          ? _value.canReceiveSms
          : canReceiveSms // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PhoneNumberImplCopyWith<$Res>
    implements $PhoneNumberCopyWith<$Res> {
  factory _$$PhoneNumberImplCopyWith(
          _$PhoneNumberImpl value, $Res Function(_$PhoneNumberImpl) then) =
      __$$PhoneNumberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String number,
      String countryCode,
      PhoneType type,
      bool hasWhatsApp,
      bool hasTelegram,
      bool isPrimary,
      bool isVerified,
      bool canReceiveSms});
}

/// @nodoc
class __$$PhoneNumberImplCopyWithImpl<$Res>
    extends _$PhoneNumberCopyWithImpl<$Res, _$PhoneNumberImpl>
    implements _$$PhoneNumberImplCopyWith<$Res> {
  __$$PhoneNumberImplCopyWithImpl(
      _$PhoneNumberImpl _value, $Res Function(_$PhoneNumberImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = null,
    Object? countryCode = null,
    Object? type = null,
    Object? hasWhatsApp = null,
    Object? hasTelegram = null,
    Object? isPrimary = null,
    Object? isVerified = null,
    Object? canReceiveSms = null,
  }) {
    return _then(_$PhoneNumberImpl(
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String,
      countryCode: null == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PhoneType,
      hasWhatsApp: null == hasWhatsApp
          ? _value.hasWhatsApp
          : hasWhatsApp // ignore: cast_nullable_to_non_nullable
              as bool,
      hasTelegram: null == hasTelegram
          ? _value.hasTelegram
          : hasTelegram // ignore: cast_nullable_to_non_nullable
              as bool,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      canReceiveSms: null == canReceiveSms
          ? _value.canReceiveSms
          : canReceiveSms // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PhoneNumberImpl extends _PhoneNumber {
  const _$PhoneNumberImpl(
      {required this.number,
      this.countryCode = '+225',
      this.type = PhoneType.mobile,
      this.hasWhatsApp = false,
      this.hasTelegram = false,
      this.isPrimary = true,
      this.isVerified = true,
      this.canReceiveSms = true})
      : super._();

  factory _$PhoneNumberImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhoneNumberImplFromJson(json);

  @override
  final String number;
  @override
  @JsonKey()
  final String countryCode;
  @override
  @JsonKey()
  final PhoneType type;
  @override
  @JsonKey()
  final bool hasWhatsApp;
  @override
  @JsonKey()
  final bool hasTelegram;
  @override
  @JsonKey()
  final bool isPrimary;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  @JsonKey()
  final bool canReceiveSms;

  @override
  String toString() {
    return 'PhoneNumber(number: $number, countryCode: $countryCode, type: $type, hasWhatsApp: $hasWhatsApp, hasTelegram: $hasTelegram, isPrimary: $isPrimary, isVerified: $isVerified, canReceiveSms: $canReceiveSms)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhoneNumberImpl &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.hasWhatsApp, hasWhatsApp) ||
                other.hasWhatsApp == hasWhatsApp) &&
            (identical(other.hasTelegram, hasTelegram) ||
                other.hasTelegram == hasTelegram) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.canReceiveSms, canReceiveSms) ||
                other.canReceiveSms == canReceiveSms));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, number, countryCode, type,
      hasWhatsApp, hasTelegram, isPrimary, isVerified, canReceiveSms);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PhoneNumberImplCopyWith<_$PhoneNumberImpl> get copyWith =>
      __$$PhoneNumberImplCopyWithImpl<_$PhoneNumberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhoneNumberImplToJson(
      this,
    );
  }
}

abstract class _PhoneNumber extends PhoneNumber {
  const factory _PhoneNumber(
      {required final String number,
      final String countryCode,
      final PhoneType type,
      final bool hasWhatsApp,
      final bool hasTelegram,
      final bool isPrimary,
      final bool isVerified,
      final bool canReceiveSms}) = _$PhoneNumberImpl;
  const _PhoneNumber._() : super._();

  factory _PhoneNumber.fromJson(Map<String, dynamic> json) =
      _$PhoneNumberImpl.fromJson;

  @override
  String get number;
  @override
  String get countryCode;
  @override
  PhoneType get type;
  @override
  bool get hasWhatsApp;
  @override
  bool get hasTelegram;
  @override
  bool get isPrimary;
  @override
  bool get isVerified;
  @override
  bool get canReceiveSms;
  @override
  @JsonKey(ignore: true)
  _$$PhoneNumberImplCopyWith<_$PhoneNumberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ContactInfo _$ContactInfoFromJson(Map<String, dynamic> json) {
  return _ContactInfo.fromJson(json);
}

/// @nodoc
mixin _$ContactInfo {
// Téléphones
  List<PhoneNumber> get phones => throw _privateConstructorUsedError;
  String? get whatsappNumber => throw _privateConstructorUsedError;
  String? get telegramUsername => throw _privateConstructorUsedError; // Emails
  String? get primaryEmail => throw _privateConstructorUsedError;
  String? get secondaryEmail => throw _privateConstructorUsedError;
  bool get emailVerified =>
      throw _privateConstructorUsedError; // Réseaux sociaux
  String? get facebookUrl => throw _privateConstructorUsedError;
  String? get instagramHandle => throw _privateConstructorUsedError;
  String? get twitterHandle => throw _privateConstructorUsedError;
  String? get linkedInUrl =>
      throw _privateConstructorUsedError; // Contact d'urgence
  String? get emergencyContactName => throw _privateConstructorUsedError;
  String? get emergencyContactPhone => throw _privateConstructorUsedError;
  String? get emergencyContactRelation =>
      throw _privateConstructorUsedError; // Préférences de contact
  bool get acceptsWhatsApp => throw _privateConstructorUsedError;
  bool get acceptsSms => throw _privateConstructorUsedError;
  bool get acceptsEmail => throw _privateConstructorUsedError;
  bool get acceptsPhoneCall => throw _privateConstructorUsedError;
  String? get preferredContactMethod => throw _privateConstructorUsedError;
  String? get preferredContactTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContactInfoCopyWith<ContactInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactInfoCopyWith<$Res> {
  factory $ContactInfoCopyWith(
          ContactInfo value, $Res Function(ContactInfo) then) =
      _$ContactInfoCopyWithImpl<$Res, ContactInfo>;
  @useResult
  $Res call(
      {List<PhoneNumber> phones,
      String? whatsappNumber,
      String? telegramUsername,
      String? primaryEmail,
      String? secondaryEmail,
      bool emailVerified,
      String? facebookUrl,
      String? instagramHandle,
      String? twitterHandle,
      String? linkedInUrl,
      String? emergencyContactName,
      String? emergencyContactPhone,
      String? emergencyContactRelation,
      bool acceptsWhatsApp,
      bool acceptsSms,
      bool acceptsEmail,
      bool acceptsPhoneCall,
      String? preferredContactMethod,
      String? preferredContactTime});
}

/// @nodoc
class _$ContactInfoCopyWithImpl<$Res, $Val extends ContactInfo>
    implements $ContactInfoCopyWith<$Res> {
  _$ContactInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phones = null,
    Object? whatsappNumber = freezed,
    Object? telegramUsername = freezed,
    Object? primaryEmail = freezed,
    Object? secondaryEmail = freezed,
    Object? emailVerified = null,
    Object? facebookUrl = freezed,
    Object? instagramHandle = freezed,
    Object? twitterHandle = freezed,
    Object? linkedInUrl = freezed,
    Object? emergencyContactName = freezed,
    Object? emergencyContactPhone = freezed,
    Object? emergencyContactRelation = freezed,
    Object? acceptsWhatsApp = null,
    Object? acceptsSms = null,
    Object? acceptsEmail = null,
    Object? acceptsPhoneCall = null,
    Object? preferredContactMethod = freezed,
    Object? preferredContactTime = freezed,
  }) {
    return _then(_value.copyWith(
      phones: null == phones
          ? _value.phones
          : phones // ignore: cast_nullable_to_non_nullable
              as List<PhoneNumber>,
      whatsappNumber: freezed == whatsappNumber
          ? _value.whatsappNumber
          : whatsappNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      telegramUsername: freezed == telegramUsername
          ? _value.telegramUsername
          : telegramUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryEmail: freezed == primaryEmail
          ? _value.primaryEmail
          : primaryEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      secondaryEmail: freezed == secondaryEmail
          ? _value.secondaryEmail
          : secondaryEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      facebookUrl: freezed == facebookUrl
          ? _value.facebookUrl
          : facebookUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      instagramHandle: freezed == instagramHandle
          ? _value.instagramHandle
          : instagramHandle // ignore: cast_nullable_to_non_nullable
              as String?,
      twitterHandle: freezed == twitterHandle
          ? _value.twitterHandle
          : twitterHandle // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedInUrl: freezed == linkedInUrl
          ? _value.linkedInUrl
          : linkedInUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactName: freezed == emergencyContactName
          ? _value.emergencyContactName
          : emergencyContactName // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactPhone: freezed == emergencyContactPhone
          ? _value.emergencyContactPhone
          : emergencyContactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactRelation: freezed == emergencyContactRelation
          ? _value.emergencyContactRelation
          : emergencyContactRelation // ignore: cast_nullable_to_non_nullable
              as String?,
      acceptsWhatsApp: null == acceptsWhatsApp
          ? _value.acceptsWhatsApp
          : acceptsWhatsApp // ignore: cast_nullable_to_non_nullable
              as bool,
      acceptsSms: null == acceptsSms
          ? _value.acceptsSms
          : acceptsSms // ignore: cast_nullable_to_non_nullable
              as bool,
      acceptsEmail: null == acceptsEmail
          ? _value.acceptsEmail
          : acceptsEmail // ignore: cast_nullable_to_non_nullable
              as bool,
      acceptsPhoneCall: null == acceptsPhoneCall
          ? _value.acceptsPhoneCall
          : acceptsPhoneCall // ignore: cast_nullable_to_non_nullable
              as bool,
      preferredContactMethod: freezed == preferredContactMethod
          ? _value.preferredContactMethod
          : preferredContactMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      preferredContactTime: freezed == preferredContactTime
          ? _value.preferredContactTime
          : preferredContactTime // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactInfoImplCopyWith<$Res>
    implements $ContactInfoCopyWith<$Res> {
  factory _$$ContactInfoImplCopyWith(
          _$ContactInfoImpl value, $Res Function(_$ContactInfoImpl) then) =
      __$$ContactInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<PhoneNumber> phones,
      String? whatsappNumber,
      String? telegramUsername,
      String? primaryEmail,
      String? secondaryEmail,
      bool emailVerified,
      String? facebookUrl,
      String? instagramHandle,
      String? twitterHandle,
      String? linkedInUrl,
      String? emergencyContactName,
      String? emergencyContactPhone,
      String? emergencyContactRelation,
      bool acceptsWhatsApp,
      bool acceptsSms,
      bool acceptsEmail,
      bool acceptsPhoneCall,
      String? preferredContactMethod,
      String? preferredContactTime});
}

/// @nodoc
class __$$ContactInfoImplCopyWithImpl<$Res>
    extends _$ContactInfoCopyWithImpl<$Res, _$ContactInfoImpl>
    implements _$$ContactInfoImplCopyWith<$Res> {
  __$$ContactInfoImplCopyWithImpl(
      _$ContactInfoImpl _value, $Res Function(_$ContactInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phones = null,
    Object? whatsappNumber = freezed,
    Object? telegramUsername = freezed,
    Object? primaryEmail = freezed,
    Object? secondaryEmail = freezed,
    Object? emailVerified = null,
    Object? facebookUrl = freezed,
    Object? instagramHandle = freezed,
    Object? twitterHandle = freezed,
    Object? linkedInUrl = freezed,
    Object? emergencyContactName = freezed,
    Object? emergencyContactPhone = freezed,
    Object? emergencyContactRelation = freezed,
    Object? acceptsWhatsApp = null,
    Object? acceptsSms = null,
    Object? acceptsEmail = null,
    Object? acceptsPhoneCall = null,
    Object? preferredContactMethod = freezed,
    Object? preferredContactTime = freezed,
  }) {
    return _then(_$ContactInfoImpl(
      phones: null == phones
          ? _value._phones
          : phones // ignore: cast_nullable_to_non_nullable
              as List<PhoneNumber>,
      whatsappNumber: freezed == whatsappNumber
          ? _value.whatsappNumber
          : whatsappNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      telegramUsername: freezed == telegramUsername
          ? _value.telegramUsername
          : telegramUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryEmail: freezed == primaryEmail
          ? _value.primaryEmail
          : primaryEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      secondaryEmail: freezed == secondaryEmail
          ? _value.secondaryEmail
          : secondaryEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      facebookUrl: freezed == facebookUrl
          ? _value.facebookUrl
          : facebookUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      instagramHandle: freezed == instagramHandle
          ? _value.instagramHandle
          : instagramHandle // ignore: cast_nullable_to_non_nullable
              as String?,
      twitterHandle: freezed == twitterHandle
          ? _value.twitterHandle
          : twitterHandle // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedInUrl: freezed == linkedInUrl
          ? _value.linkedInUrl
          : linkedInUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactName: freezed == emergencyContactName
          ? _value.emergencyContactName
          : emergencyContactName // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactPhone: freezed == emergencyContactPhone
          ? _value.emergencyContactPhone
          : emergencyContactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactRelation: freezed == emergencyContactRelation
          ? _value.emergencyContactRelation
          : emergencyContactRelation // ignore: cast_nullable_to_non_nullable
              as String?,
      acceptsWhatsApp: null == acceptsWhatsApp
          ? _value.acceptsWhatsApp
          : acceptsWhatsApp // ignore: cast_nullable_to_non_nullable
              as bool,
      acceptsSms: null == acceptsSms
          ? _value.acceptsSms
          : acceptsSms // ignore: cast_nullable_to_non_nullable
              as bool,
      acceptsEmail: null == acceptsEmail
          ? _value.acceptsEmail
          : acceptsEmail // ignore: cast_nullable_to_non_nullable
              as bool,
      acceptsPhoneCall: null == acceptsPhoneCall
          ? _value.acceptsPhoneCall
          : acceptsPhoneCall // ignore: cast_nullable_to_non_nullable
              as bool,
      preferredContactMethod: freezed == preferredContactMethod
          ? _value.preferredContactMethod
          : preferredContactMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      preferredContactTime: freezed == preferredContactTime
          ? _value.preferredContactTime
          : preferredContactTime // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactInfoImpl extends _ContactInfo {
  const _$ContactInfoImpl(
      {final List<PhoneNumber> phones = const [],
      this.whatsappNumber,
      this.telegramUsername,
      this.primaryEmail,
      this.secondaryEmail,
      this.emailVerified = false,
      this.facebookUrl,
      this.instagramHandle,
      this.twitterHandle,
      this.linkedInUrl,
      this.emergencyContactName,
      this.emergencyContactPhone,
      this.emergencyContactRelation,
      this.acceptsWhatsApp = true,
      this.acceptsSms = true,
      this.acceptsEmail = true,
      this.acceptsPhoneCall = true,
      this.preferredContactMethod,
      this.preferredContactTime})
      : _phones = phones,
        super._();

  factory _$ContactInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactInfoImplFromJson(json);

// Téléphones
  final List<PhoneNumber> _phones;
// Téléphones
  @override
  @JsonKey()
  List<PhoneNumber> get phones {
    if (_phones is EqualUnmodifiableListView) return _phones;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_phones);
  }

  @override
  final String? whatsappNumber;
  @override
  final String? telegramUsername;
// Emails
  @override
  final String? primaryEmail;
  @override
  final String? secondaryEmail;
  @override
  @JsonKey()
  final bool emailVerified;
// Réseaux sociaux
  @override
  final String? facebookUrl;
  @override
  final String? instagramHandle;
  @override
  final String? twitterHandle;
  @override
  final String? linkedInUrl;
// Contact d'urgence
  @override
  final String? emergencyContactName;
  @override
  final String? emergencyContactPhone;
  @override
  final String? emergencyContactRelation;
// Préférences de contact
  @override
  @JsonKey()
  final bool acceptsWhatsApp;
  @override
  @JsonKey()
  final bool acceptsSms;
  @override
  @JsonKey()
  final bool acceptsEmail;
  @override
  @JsonKey()
  final bool acceptsPhoneCall;
  @override
  final String? preferredContactMethod;
  @override
  final String? preferredContactTime;

  @override
  String toString() {
    return 'ContactInfo(phones: $phones, whatsappNumber: $whatsappNumber, telegramUsername: $telegramUsername, primaryEmail: $primaryEmail, secondaryEmail: $secondaryEmail, emailVerified: $emailVerified, facebookUrl: $facebookUrl, instagramHandle: $instagramHandle, twitterHandle: $twitterHandle, linkedInUrl: $linkedInUrl, emergencyContactName: $emergencyContactName, emergencyContactPhone: $emergencyContactPhone, emergencyContactRelation: $emergencyContactRelation, acceptsWhatsApp: $acceptsWhatsApp, acceptsSms: $acceptsSms, acceptsEmail: $acceptsEmail, acceptsPhoneCall: $acceptsPhoneCall, preferredContactMethod: $preferredContactMethod, preferredContactTime: $preferredContactTime)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactInfoImpl &&
            const DeepCollectionEquality().equals(other._phones, _phones) &&
            (identical(other.whatsappNumber, whatsappNumber) ||
                other.whatsappNumber == whatsappNumber) &&
            (identical(other.telegramUsername, telegramUsername) ||
                other.telegramUsername == telegramUsername) &&
            (identical(other.primaryEmail, primaryEmail) ||
                other.primaryEmail == primaryEmail) &&
            (identical(other.secondaryEmail, secondaryEmail) ||
                other.secondaryEmail == secondaryEmail) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.facebookUrl, facebookUrl) ||
                other.facebookUrl == facebookUrl) &&
            (identical(other.instagramHandle, instagramHandle) ||
                other.instagramHandle == instagramHandle) &&
            (identical(other.twitterHandle, twitterHandle) ||
                other.twitterHandle == twitterHandle) &&
            (identical(other.linkedInUrl, linkedInUrl) ||
                other.linkedInUrl == linkedInUrl) &&
            (identical(other.emergencyContactName, emergencyContactName) ||
                other.emergencyContactName == emergencyContactName) &&
            (identical(other.emergencyContactPhone, emergencyContactPhone) ||
                other.emergencyContactPhone == emergencyContactPhone) &&
            (identical(
                    other.emergencyContactRelation, emergencyContactRelation) ||
                other.emergencyContactRelation == emergencyContactRelation) &&
            (identical(other.acceptsWhatsApp, acceptsWhatsApp) ||
                other.acceptsWhatsApp == acceptsWhatsApp) &&
            (identical(other.acceptsSms, acceptsSms) ||
                other.acceptsSms == acceptsSms) &&
            (identical(other.acceptsEmail, acceptsEmail) ||
                other.acceptsEmail == acceptsEmail) &&
            (identical(other.acceptsPhoneCall, acceptsPhoneCall) ||
                other.acceptsPhoneCall == acceptsPhoneCall) &&
            (identical(other.preferredContactMethod, preferredContactMethod) ||
                other.preferredContactMethod == preferredContactMethod) &&
            (identical(other.preferredContactTime, preferredContactTime) ||
                other.preferredContactTime == preferredContactTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        const DeepCollectionEquality().hash(_phones),
        whatsappNumber,
        telegramUsername,
        primaryEmail,
        secondaryEmail,
        emailVerified,
        facebookUrl,
        instagramHandle,
        twitterHandle,
        linkedInUrl,
        emergencyContactName,
        emergencyContactPhone,
        emergencyContactRelation,
        acceptsWhatsApp,
        acceptsSms,
        acceptsEmail,
        acceptsPhoneCall,
        preferredContactMethod,
        preferredContactTime
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactInfoImplCopyWith<_$ContactInfoImpl> get copyWith =>
      __$$ContactInfoImplCopyWithImpl<_$ContactInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactInfoImplToJson(
      this,
    );
  }
}

abstract class _ContactInfo extends ContactInfo {
  const factory _ContactInfo(
      {final List<PhoneNumber> phones,
      final String? whatsappNumber,
      final String? telegramUsername,
      final String? primaryEmail,
      final String? secondaryEmail,
      final bool emailVerified,
      final String? facebookUrl,
      final String? instagramHandle,
      final String? twitterHandle,
      final String? linkedInUrl,
      final String? emergencyContactName,
      final String? emergencyContactPhone,
      final String? emergencyContactRelation,
      final bool acceptsWhatsApp,
      final bool acceptsSms,
      final bool acceptsEmail,
      final bool acceptsPhoneCall,
      final String? preferredContactMethod,
      final String? preferredContactTime}) = _$ContactInfoImpl;
  const _ContactInfo._() : super._();

  factory _ContactInfo.fromJson(Map<String, dynamic> json) =
      _$ContactInfoImpl.fromJson;

  @override // Téléphones
  List<PhoneNumber> get phones;
  @override
  String? get whatsappNumber;
  @override
  String? get telegramUsername;
  @override // Emails
  String? get primaryEmail;
  @override
  String? get secondaryEmail;
  @override
  bool get emailVerified;
  @override // Réseaux sociaux
  String? get facebookUrl;
  @override
  String? get instagramHandle;
  @override
  String? get twitterHandle;
  @override
  String? get linkedInUrl;
  @override // Contact d'urgence
  String? get emergencyContactName;
  @override
  String? get emergencyContactPhone;
  @override
  String? get emergencyContactRelation;
  @override // Préférences de contact
  bool get acceptsWhatsApp;
  @override
  bool get acceptsSms;
  @override
  bool get acceptsEmail;
  @override
  bool get acceptsPhoneCall;
  @override
  String? get preferredContactMethod;
  @override
  String? get preferredContactTime;
  @override
  @JsonKey(ignore: true)
  _$$ContactInfoImplCopyWith<_$ContactInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

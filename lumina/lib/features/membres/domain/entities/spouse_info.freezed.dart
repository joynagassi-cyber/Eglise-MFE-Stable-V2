// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spouse_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SpouseInfo _$SpouseInfoFromJson(Map<String, dynamic> json) {
  return _SpouseInfo.fromJson(json);
}

/// @nodoc
mixin _$SpouseInfo {
// Lien avec membre si le conjoint est dans l'église
  String? get memberId => throw _privateConstructorUsedError;
  bool get isMember => throw _privateConstructorUsedError; // Identité
  String get lastName => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String? get middleName => throw _privateConstructorUsedError;
  String? get maidenName =>
      throw _privateConstructorUsedError; // Nom de jeune fille
  String? get title => throw _privateConstructorUsedError;
  Gender get gender => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError; // Naissance
  DateTime? get birthDate => throw _privateConstructorUsedError;
  String? get birthPlace => throw _privateConstructorUsedError; // Contact
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get whatsapp => throw _privateConstructorUsedError; // Profession
  String? get profession => throw _privateConstructorUsedError;
  String? get employer => throw _privateConstructorUsedError; // Spiritualité
  bool get isChristian => throw _privateConstructorUsedError;
  String? get denomination =>
      throw _privateConstructorUsedError; // Si dans autre confession
  String? get churchName =>
      throw _privateConstructorUsedError; // Si dans autre église
  bool get isBaptized => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpouseInfoCopyWith<SpouseInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpouseInfoCopyWith<$Res> {
  factory $SpouseInfoCopyWith(
          SpouseInfo value, $Res Function(SpouseInfo) then) =
      _$SpouseInfoCopyWithImpl<$Res, SpouseInfo>;
  @useResult
  $Res call(
      {String? memberId,
      bool isMember,
      String lastName,
      String firstName,
      String? middleName,
      String? maidenName,
      String? title,
      Gender gender,
      String? photoUrl,
      DateTime? birthDate,
      String? birthPlace,
      String? phone,
      String? email,
      String? whatsapp,
      String? profession,
      String? employer,
      bool isChristian,
      String? denomination,
      String? churchName,
      bool isBaptized});
}

/// @nodoc
class _$SpouseInfoCopyWithImpl<$Res, $Val extends SpouseInfo>
    implements $SpouseInfoCopyWith<$Res> {
  _$SpouseInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = freezed,
    Object? isMember = null,
    Object? lastName = null,
    Object? firstName = null,
    Object? middleName = freezed,
    Object? maidenName = freezed,
    Object? title = freezed,
    Object? gender = null,
    Object? photoUrl = freezed,
    Object? birthDate = freezed,
    Object? birthPlace = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? whatsapp = freezed,
    Object? profession = freezed,
    Object? employer = freezed,
    Object? isChristian = null,
    Object? denomination = freezed,
    Object? churchName = freezed,
    Object? isBaptized = null,
  }) {
    return _then(_value.copyWith(
      memberId: freezed == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String?,
      isMember: null == isMember
          ? _value.isMember
          : isMember // ignore: cast_nullable_to_non_nullable
              as bool,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      middleName: freezed == middleName
          ? _value.middleName
          : middleName // ignore: cast_nullable_to_non_nullable
              as String?,
      maidenName: freezed == maidenName
          ? _value.maidenName
          : maidenName // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as Gender,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      birthPlace: freezed == birthPlace
          ? _value.birthPlace
          : birthPlace // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      whatsapp: freezed == whatsapp
          ? _value.whatsapp
          : whatsapp // ignore: cast_nullable_to_non_nullable
              as String?,
      profession: freezed == profession
          ? _value.profession
          : profession // ignore: cast_nullable_to_non_nullable
              as String?,
      employer: freezed == employer
          ? _value.employer
          : employer // ignore: cast_nullable_to_non_nullable
              as String?,
      isChristian: null == isChristian
          ? _value.isChristian
          : isChristian // ignore: cast_nullable_to_non_nullable
              as bool,
      denomination: freezed == denomination
          ? _value.denomination
          : denomination // ignore: cast_nullable_to_non_nullable
              as String?,
      churchName: freezed == churchName
          ? _value.churchName
          : churchName // ignore: cast_nullable_to_non_nullable
              as String?,
      isBaptized: null == isBaptized
          ? _value.isBaptized
          : isBaptized // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpouseInfoImplCopyWith<$Res>
    implements $SpouseInfoCopyWith<$Res> {
  factory _$$SpouseInfoImplCopyWith(
          _$SpouseInfoImpl value, $Res Function(_$SpouseInfoImpl) then) =
      __$$SpouseInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? memberId,
      bool isMember,
      String lastName,
      String firstName,
      String? middleName,
      String? maidenName,
      String? title,
      Gender gender,
      String? photoUrl,
      DateTime? birthDate,
      String? birthPlace,
      String? phone,
      String? email,
      String? whatsapp,
      String? profession,
      String? employer,
      bool isChristian,
      String? denomination,
      String? churchName,
      bool isBaptized});
}

/// @nodoc
class __$$SpouseInfoImplCopyWithImpl<$Res>
    extends _$SpouseInfoCopyWithImpl<$Res, _$SpouseInfoImpl>
    implements _$$SpouseInfoImplCopyWith<$Res> {
  __$$SpouseInfoImplCopyWithImpl(
      _$SpouseInfoImpl _value, $Res Function(_$SpouseInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = freezed,
    Object? isMember = null,
    Object? lastName = null,
    Object? firstName = null,
    Object? middleName = freezed,
    Object? maidenName = freezed,
    Object? title = freezed,
    Object? gender = null,
    Object? photoUrl = freezed,
    Object? birthDate = freezed,
    Object? birthPlace = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? whatsapp = freezed,
    Object? profession = freezed,
    Object? employer = freezed,
    Object? isChristian = null,
    Object? denomination = freezed,
    Object? churchName = freezed,
    Object? isBaptized = null,
  }) {
    return _then(_$SpouseInfoImpl(
      memberId: freezed == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String?,
      isMember: null == isMember
          ? _value.isMember
          : isMember // ignore: cast_nullable_to_non_nullable
              as bool,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      middleName: freezed == middleName
          ? _value.middleName
          : middleName // ignore: cast_nullable_to_non_nullable
              as String?,
      maidenName: freezed == maidenName
          ? _value.maidenName
          : maidenName // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as Gender,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      birthPlace: freezed == birthPlace
          ? _value.birthPlace
          : birthPlace // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      whatsapp: freezed == whatsapp
          ? _value.whatsapp
          : whatsapp // ignore: cast_nullable_to_non_nullable
              as String?,
      profession: freezed == profession
          ? _value.profession
          : profession // ignore: cast_nullable_to_non_nullable
              as String?,
      employer: freezed == employer
          ? _value.employer
          : employer // ignore: cast_nullable_to_non_nullable
              as String?,
      isChristian: null == isChristian
          ? _value.isChristian
          : isChristian // ignore: cast_nullable_to_non_nullable
              as bool,
      denomination: freezed == denomination
          ? _value.denomination
          : denomination // ignore: cast_nullable_to_non_nullable
              as String?,
      churchName: freezed == churchName
          ? _value.churchName
          : churchName // ignore: cast_nullable_to_non_nullable
              as String?,
      isBaptized: null == isBaptized
          ? _value.isBaptized
          : isBaptized // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpouseInfoImpl extends _SpouseInfo {
  const _$SpouseInfoImpl(
      {this.memberId,
      this.isMember = false,
      required this.lastName,
      required this.firstName,
      this.middleName,
      this.maidenName,
      this.title,
      required this.gender,
      this.photoUrl,
      this.birthDate,
      this.birthPlace,
      this.phone,
      this.email,
      this.whatsapp,
      this.profession,
      this.employer,
      this.isChristian = true,
      this.denomination,
      this.churchName,
      this.isBaptized = false})
      : super._();

  factory _$SpouseInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpouseInfoImplFromJson(json);

// Lien avec membre si le conjoint est dans l'église
  @override
  final String? memberId;
  @override
  @JsonKey()
  final bool isMember;
// Identité
  @override
  final String lastName;
  @override
  final String firstName;
  @override
  final String? middleName;
  @override
  final String? maidenName;
// Nom de jeune fille
  @override
  final String? title;
  @override
  final Gender gender;
  @override
  final String? photoUrl;
// Naissance
  @override
  final DateTime? birthDate;
  @override
  final String? birthPlace;
// Contact
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? whatsapp;
// Profession
  @override
  final String? profession;
  @override
  final String? employer;
// Spiritualité
  @override
  @JsonKey()
  final bool isChristian;
  @override
  final String? denomination;
// Si dans autre confession
  @override
  final String? churchName;
// Si dans autre église
  @override
  @JsonKey()
  final bool isBaptized;

  @override
  String toString() {
    return 'SpouseInfo(memberId: $memberId, isMember: $isMember, lastName: $lastName, firstName: $firstName, middleName: $middleName, maidenName: $maidenName, title: $title, gender: $gender, photoUrl: $photoUrl, birthDate: $birthDate, birthPlace: $birthPlace, phone: $phone, email: $email, whatsapp: $whatsapp, profession: $profession, employer: $employer, isChristian: $isChristian, denomination: $denomination, churchName: $churchName, isBaptized: $isBaptized)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpouseInfoImpl &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.isMember, isMember) ||
                other.isMember == isMember) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.middleName, middleName) ||
                other.middleName == middleName) &&
            (identical(other.maidenName, maidenName) ||
                other.maidenName == maidenName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.birthPlace, birthPlace) ||
                other.birthPlace == birthPlace) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.whatsapp, whatsapp) ||
                other.whatsapp == whatsapp) &&
            (identical(other.profession, profession) ||
                other.profession == profession) &&
            (identical(other.employer, employer) ||
                other.employer == employer) &&
            (identical(other.isChristian, isChristian) ||
                other.isChristian == isChristian) &&
            (identical(other.denomination, denomination) ||
                other.denomination == denomination) &&
            (identical(other.churchName, churchName) ||
                other.churchName == churchName) &&
            (identical(other.isBaptized, isBaptized) ||
                other.isBaptized == isBaptized));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        memberId,
        isMember,
        lastName,
        firstName,
        middleName,
        maidenName,
        title,
        gender,
        photoUrl,
        birthDate,
        birthPlace,
        phone,
        email,
        whatsapp,
        profession,
        employer,
        isChristian,
        denomination,
        churchName,
        isBaptized
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpouseInfoImplCopyWith<_$SpouseInfoImpl> get copyWith =>
      __$$SpouseInfoImplCopyWithImpl<_$SpouseInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpouseInfoImplToJson(
      this,
    );
  }
}

abstract class _SpouseInfo extends SpouseInfo {
  const factory _SpouseInfo(
      {final String? memberId,
      final bool isMember,
      required final String lastName,
      required final String firstName,
      final String? middleName,
      final String? maidenName,
      final String? title,
      required final Gender gender,
      final String? photoUrl,
      final DateTime? birthDate,
      final String? birthPlace,
      final String? phone,
      final String? email,
      final String? whatsapp,
      final String? profession,
      final String? employer,
      final bool isChristian,
      final String? denomination,
      final String? churchName,
      final bool isBaptized}) = _$SpouseInfoImpl;
  const _SpouseInfo._() : super._();

  factory _SpouseInfo.fromJson(Map<String, dynamic> json) =
      _$SpouseInfoImpl.fromJson;

  @override // Lien avec membre si le conjoint est dans l'église
  String? get memberId;
  @override
  bool get isMember;
  @override // Identité
  String get lastName;
  @override
  String get firstName;
  @override
  String? get middleName;
  @override
  String? get maidenName;
  @override // Nom de jeune fille
  String? get title;
  @override
  Gender get gender;
  @override
  String? get photoUrl;
  @override // Naissance
  DateTime? get birthDate;
  @override
  String? get birthPlace;
  @override // Contact
  String? get phone;
  @override
  String? get email;
  @override
  String? get whatsapp;
  @override // Profession
  String? get profession;
  @override
  String? get employer;
  @override // Spiritualité
  bool get isChristian;
  @override
  String? get denomination;
  @override // Si dans autre confession
  String? get churchName;
  @override // Si dans autre église
  bool get isBaptized;
  @override
  @JsonKey(ignore: true)
  _$$SpouseInfoImplCopyWith<_$SpouseInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

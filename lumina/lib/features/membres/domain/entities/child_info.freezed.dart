// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChildInfo _$ChildInfoFromJson(Map<String, dynamic> json) {
  return _ChildInfo.fromJson(json);
}

/// @nodoc
mixin _$ChildInfo {
// Lien si l'enfant est aussi membre
  String? get memberId => throw _privateConstructorUsedError;
  bool get isMember => throw _privateConstructorUsedError; // Identité
  String get lastName => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String? get middleName => throw _privateConstructorUsedError;
  Gender get gender => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError; // Naissance
  DateTime? get birthDate => throw _privateConstructorUsedError;
  String? get birthPlace => throw _privateConstructorUsedError; // Statut
  ChildStatus get status => throw _privateConstructorUsedError;
  bool get isDependent => throw _privateConstructorUsedError; // À charge
  bool get isAdopted => throw _privateConstructorUsedError;
  bool get isStepChild => throw _privateConstructorUsedError;
  int get birthOrder => throw _privateConstructorUsedError; // Rang de naissance
// Si décédé
  DateTime? get deathDate => throw _privateConstructorUsedError; // Éducation
  String? get schoolName => throw _privateConstructorUsedError;
  String? get gradeLevel => throw _privateConstructorUsedError; // Spiritualité
  bool get isConverted => throw _privateConstructorUsedError;
  bool get isBaptized => throw _privateConstructorUsedError;
  DateTime? get baptismDate => throw _privateConstructorUsedError;
  bool get attendsSundaySchool => throw _privateConstructorUsedError;
  String? get sundaySchoolClass =>
      throw _privateConstructorUsedError; // Contact (si adulte)
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChildInfoCopyWith<ChildInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChildInfoCopyWith<$Res> {
  factory $ChildInfoCopyWith(ChildInfo value, $Res Function(ChildInfo) then) =
      _$ChildInfoCopyWithImpl<$Res, ChildInfo>;
  @useResult
  $Res call(
      {String? memberId,
      bool isMember,
      String lastName,
      String firstName,
      String? middleName,
      Gender gender,
      String? photoUrl,
      DateTime? birthDate,
      String? birthPlace,
      ChildStatus status,
      bool isDependent,
      bool isAdopted,
      bool isStepChild,
      int birthOrder,
      DateTime? deathDate,
      String? schoolName,
      String? gradeLevel,
      bool isConverted,
      bool isBaptized,
      DateTime? baptismDate,
      bool attendsSundaySchool,
      String? sundaySchoolClass,
      String? phone,
      String? email,
      String? address});
}

/// @nodoc
class _$ChildInfoCopyWithImpl<$Res, $Val extends ChildInfo>
    implements $ChildInfoCopyWith<$Res> {
  _$ChildInfoCopyWithImpl(this._value, this._then);

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
    Object? gender = null,
    Object? photoUrl = freezed,
    Object? birthDate = freezed,
    Object? birthPlace = freezed,
    Object? status = null,
    Object? isDependent = null,
    Object? isAdopted = null,
    Object? isStepChild = null,
    Object? birthOrder = null,
    Object? deathDate = freezed,
    Object? schoolName = freezed,
    Object? gradeLevel = freezed,
    Object? isConverted = null,
    Object? isBaptized = null,
    Object? baptismDate = freezed,
    Object? attendsSundaySchool = null,
    Object? sundaySchoolClass = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ChildStatus,
      isDependent: null == isDependent
          ? _value.isDependent
          : isDependent // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdopted: null == isAdopted
          ? _value.isAdopted
          : isAdopted // ignore: cast_nullable_to_non_nullable
              as bool,
      isStepChild: null == isStepChild
          ? _value.isStepChild
          : isStepChild // ignore: cast_nullable_to_non_nullable
              as bool,
      birthOrder: null == birthOrder
          ? _value.birthOrder
          : birthOrder // ignore: cast_nullable_to_non_nullable
              as int,
      deathDate: freezed == deathDate
          ? _value.deathDate
          : deathDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      schoolName: freezed == schoolName
          ? _value.schoolName
          : schoolName // ignore: cast_nullable_to_non_nullable
              as String?,
      gradeLevel: freezed == gradeLevel
          ? _value.gradeLevel
          : gradeLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      isConverted: null == isConverted
          ? _value.isConverted
          : isConverted // ignore: cast_nullable_to_non_nullable
              as bool,
      isBaptized: null == isBaptized
          ? _value.isBaptized
          : isBaptized // ignore: cast_nullable_to_non_nullable
              as bool,
      baptismDate: freezed == baptismDate
          ? _value.baptismDate
          : baptismDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      attendsSundaySchool: null == attendsSundaySchool
          ? _value.attendsSundaySchool
          : attendsSundaySchool // ignore: cast_nullable_to_non_nullable
              as bool,
      sundaySchoolClass: freezed == sundaySchoolClass
          ? _value.sundaySchoolClass
          : sundaySchoolClass // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChildInfoImplCopyWith<$Res>
    implements $ChildInfoCopyWith<$Res> {
  factory _$$ChildInfoImplCopyWith(
          _$ChildInfoImpl value, $Res Function(_$ChildInfoImpl) then) =
      __$$ChildInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? memberId,
      bool isMember,
      String lastName,
      String firstName,
      String? middleName,
      Gender gender,
      String? photoUrl,
      DateTime? birthDate,
      String? birthPlace,
      ChildStatus status,
      bool isDependent,
      bool isAdopted,
      bool isStepChild,
      int birthOrder,
      DateTime? deathDate,
      String? schoolName,
      String? gradeLevel,
      bool isConverted,
      bool isBaptized,
      DateTime? baptismDate,
      bool attendsSundaySchool,
      String? sundaySchoolClass,
      String? phone,
      String? email,
      String? address});
}

/// @nodoc
class __$$ChildInfoImplCopyWithImpl<$Res>
    extends _$ChildInfoCopyWithImpl<$Res, _$ChildInfoImpl>
    implements _$$ChildInfoImplCopyWith<$Res> {
  __$$ChildInfoImplCopyWithImpl(
      _$ChildInfoImpl _value, $Res Function(_$ChildInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = freezed,
    Object? isMember = null,
    Object? lastName = null,
    Object? firstName = null,
    Object? middleName = freezed,
    Object? gender = null,
    Object? photoUrl = freezed,
    Object? birthDate = freezed,
    Object? birthPlace = freezed,
    Object? status = null,
    Object? isDependent = null,
    Object? isAdopted = null,
    Object? isStepChild = null,
    Object? birthOrder = null,
    Object? deathDate = freezed,
    Object? schoolName = freezed,
    Object? gradeLevel = freezed,
    Object? isConverted = null,
    Object? isBaptized = null,
    Object? baptismDate = freezed,
    Object? attendsSundaySchool = null,
    Object? sundaySchoolClass = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
  }) {
    return _then(_$ChildInfoImpl(
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ChildStatus,
      isDependent: null == isDependent
          ? _value.isDependent
          : isDependent // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdopted: null == isAdopted
          ? _value.isAdopted
          : isAdopted // ignore: cast_nullable_to_non_nullable
              as bool,
      isStepChild: null == isStepChild
          ? _value.isStepChild
          : isStepChild // ignore: cast_nullable_to_non_nullable
              as bool,
      birthOrder: null == birthOrder
          ? _value.birthOrder
          : birthOrder // ignore: cast_nullable_to_non_nullable
              as int,
      deathDate: freezed == deathDate
          ? _value.deathDate
          : deathDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      schoolName: freezed == schoolName
          ? _value.schoolName
          : schoolName // ignore: cast_nullable_to_non_nullable
              as String?,
      gradeLevel: freezed == gradeLevel
          ? _value.gradeLevel
          : gradeLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      isConverted: null == isConverted
          ? _value.isConverted
          : isConverted // ignore: cast_nullable_to_non_nullable
              as bool,
      isBaptized: null == isBaptized
          ? _value.isBaptized
          : isBaptized // ignore: cast_nullable_to_non_nullable
              as bool,
      baptismDate: freezed == baptismDate
          ? _value.baptismDate
          : baptismDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      attendsSundaySchool: null == attendsSundaySchool
          ? _value.attendsSundaySchool
          : attendsSundaySchool // ignore: cast_nullable_to_non_nullable
              as bool,
      sundaySchoolClass: freezed == sundaySchoolClass
          ? _value.sundaySchoolClass
          : sundaySchoolClass // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChildInfoImpl extends _ChildInfo {
  const _$ChildInfoImpl(
      {this.memberId,
      this.isMember = false,
      required this.lastName,
      required this.firstName,
      this.middleName,
      required this.gender,
      this.photoUrl,
      this.birthDate,
      this.birthPlace,
      this.status = ChildStatus.living,
      this.isDependent = true,
      this.isAdopted = false,
      this.isStepChild = false,
      this.birthOrder = 1,
      this.deathDate,
      this.schoolName,
      this.gradeLevel,
      this.isConverted = false,
      this.isBaptized = false,
      this.baptismDate,
      this.attendsSundaySchool = false,
      this.sundaySchoolClass,
      this.phone,
      this.email,
      this.address})
      : super._();

  factory _$ChildInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChildInfoImplFromJson(json);

// Lien si l'enfant est aussi membre
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
  final Gender gender;
  @override
  final String? photoUrl;
// Naissance
  @override
  final DateTime? birthDate;
  @override
  final String? birthPlace;
// Statut
  @override
  @JsonKey()
  final ChildStatus status;
  @override
  @JsonKey()
  final bool isDependent;
// À charge
  @override
  @JsonKey()
  final bool isAdopted;
  @override
  @JsonKey()
  final bool isStepChild;
  @override
  @JsonKey()
  final int birthOrder;
// Rang de naissance
// Si décédé
  @override
  final DateTime? deathDate;
// Éducation
  @override
  final String? schoolName;
  @override
  final String? gradeLevel;
// Spiritualité
  @override
  @JsonKey()
  final bool isConverted;
  @override
  @JsonKey()
  final bool isBaptized;
  @override
  final DateTime? baptismDate;
  @override
  @JsonKey()
  final bool attendsSundaySchool;
  @override
  final String? sundaySchoolClass;
// Contact (si adulte)
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? address;

  @override
  String toString() {
    return 'ChildInfo(memberId: $memberId, isMember: $isMember, lastName: $lastName, firstName: $firstName, middleName: $middleName, gender: $gender, photoUrl: $photoUrl, birthDate: $birthDate, birthPlace: $birthPlace, status: $status, isDependent: $isDependent, isAdopted: $isAdopted, isStepChild: $isStepChild, birthOrder: $birthOrder, deathDate: $deathDate, schoolName: $schoolName, gradeLevel: $gradeLevel, isConverted: $isConverted, isBaptized: $isBaptized, baptismDate: $baptismDate, attendsSundaySchool: $attendsSundaySchool, sundaySchoolClass: $sundaySchoolClass, phone: $phone, email: $email, address: $address)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChildInfoImpl &&
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
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.birthPlace, birthPlace) ||
                other.birthPlace == birthPlace) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isDependent, isDependent) ||
                other.isDependent == isDependent) &&
            (identical(other.isAdopted, isAdopted) ||
                other.isAdopted == isAdopted) &&
            (identical(other.isStepChild, isStepChild) ||
                other.isStepChild == isStepChild) &&
            (identical(other.birthOrder, birthOrder) ||
                other.birthOrder == birthOrder) &&
            (identical(other.deathDate, deathDate) ||
                other.deathDate == deathDate) &&
            (identical(other.schoolName, schoolName) ||
                other.schoolName == schoolName) &&
            (identical(other.gradeLevel, gradeLevel) ||
                other.gradeLevel == gradeLevel) &&
            (identical(other.isConverted, isConverted) ||
                other.isConverted == isConverted) &&
            (identical(other.isBaptized, isBaptized) ||
                other.isBaptized == isBaptized) &&
            (identical(other.baptismDate, baptismDate) ||
                other.baptismDate == baptismDate) &&
            (identical(other.attendsSundaySchool, attendsSundaySchool) ||
                other.attendsSundaySchool == attendsSundaySchool) &&
            (identical(other.sundaySchoolClass, sundaySchoolClass) ||
                other.sundaySchoolClass == sundaySchoolClass) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.address, address) || other.address == address));
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
        gender,
        photoUrl,
        birthDate,
        birthPlace,
        status,
        isDependent,
        isAdopted,
        isStepChild,
        birthOrder,
        deathDate,
        schoolName,
        gradeLevel,
        isConverted,
        isBaptized,
        baptismDate,
        attendsSundaySchool,
        sundaySchoolClass,
        phone,
        email,
        address
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChildInfoImplCopyWith<_$ChildInfoImpl> get copyWith =>
      __$$ChildInfoImplCopyWithImpl<_$ChildInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChildInfoImplToJson(
      this,
    );
  }
}

abstract class _ChildInfo extends ChildInfo {
  const factory _ChildInfo(
      {final String? memberId,
      final bool isMember,
      required final String lastName,
      required final String firstName,
      final String? middleName,
      required final Gender gender,
      final String? photoUrl,
      final DateTime? birthDate,
      final String? birthPlace,
      final ChildStatus status,
      final bool isDependent,
      final bool isAdopted,
      final bool isStepChild,
      final int birthOrder,
      final DateTime? deathDate,
      final String? schoolName,
      final String? gradeLevel,
      final bool isConverted,
      final bool isBaptized,
      final DateTime? baptismDate,
      final bool attendsSundaySchool,
      final String? sundaySchoolClass,
      final String? phone,
      final String? email,
      final String? address}) = _$ChildInfoImpl;
  const _ChildInfo._() : super._();

  factory _ChildInfo.fromJson(Map<String, dynamic> json) =
      _$ChildInfoImpl.fromJson;

  @override // Lien si l'enfant est aussi membre
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
  Gender get gender;
  @override
  String? get photoUrl;
  @override // Naissance
  DateTime? get birthDate;
  @override
  String? get birthPlace;
  @override // Statut
  ChildStatus get status;
  @override
  bool get isDependent;
  @override // À charge
  bool get isAdopted;
  @override
  bool get isStepChild;
  @override
  int get birthOrder;
  @override // Rang de naissance
// Si décédé
  DateTime? get deathDate;
  @override // Éducation
  String? get schoolName;
  @override
  String? get gradeLevel;
  @override // Spiritualité
  bool get isConverted;
  @override
  bool get isBaptized;
  @override
  DateTime? get baptismDate;
  @override
  bool get attendsSundaySchool;
  @override
  String? get sundaySchoolClass;
  @override // Contact (si adulte)
  String? get phone;
  @override
  String? get email;
  @override
  String? get address;
  @override
  @JsonKey(ignore: true)
  _$$ChildInfoImplCopyWith<_$ChildInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

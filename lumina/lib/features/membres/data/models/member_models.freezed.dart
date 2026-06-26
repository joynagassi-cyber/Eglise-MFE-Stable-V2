// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Member _$MemberFromJson(Map<String, dynamic> json) {
  return _Member.fromJson(json);
}

/// @nodoc
mixin _$Member {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'church_id')
  String get churchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String get lastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_name')
  String? get displayName => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError; // male, female
  @JsonKey(name: 'birth_date')
  DateTime? get birthDate => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_url')
  String? get photoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_r2_key')
  String? get photoR2Key => throw _privateConstructorUsedError;
  @JsonKey(name: 'member_number')
  String? get memberNumber => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'membership_date')
  DateTime? get membershipDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'baptism_date')
  DateTime? get baptismDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'shepherd_id')
  String? get shepherdId => throw _privateConstructorUsedError;
  @JsonKey(name: 'family_id')
  String? get familyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'marital_status')
  String? get maritalStatus => throw _privateConstructorUsedError;
  String? get occupation => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MemberCopyWith<Member> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberCopyWith<$Res> {
  factory $MemberCopyWith(Member value, $Res Function(Member) then) =
      _$MemberCopyWithImpl<$Res, Member>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'church_id') String churchId,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      @JsonKey(name: 'display_name') String? displayName,
      String? gender,
      @JsonKey(name: 'birth_date') DateTime? birthDate,
      String? phone,
      String? email,
      String? address,
      @JsonKey(name: 'photo_url') String? photoUrl,
      @JsonKey(name: 'photo_r2_key') String? photoR2Key,
      @JsonKey(name: 'member_number') String? memberNumber,
      String status,
      @JsonKey(name: 'membership_date') DateTime? membershipDate,
      @JsonKey(name: 'baptism_date') DateTime? baptismDate,
      @JsonKey(name: 'shepherd_id') String? shepherdId,
      @JsonKey(name: 'family_id') String? familyId,
      @JsonKey(name: 'marital_status') String? maritalStatus,
      String? occupation,
      String? notes,
      List<String>? tags,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$MemberCopyWithImpl<$Res, $Val extends Member>
    implements $MemberCopyWith<$Res> {
  _$MemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? userId = freezed,
    Object? firstName = null,
    Object? lastName = null,
    Object? displayName = freezed,
    Object? gender = freezed,
    Object? birthDate = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? photoUrl = freezed,
    Object? photoR2Key = freezed,
    Object? memberNumber = freezed,
    Object? status = null,
    Object? membershipDate = freezed,
    Object? baptismDate = freezed,
    Object? shepherdId = freezed,
    Object? familyId = freezed,
    Object? maritalStatus = freezed,
    Object? occupation = freezed,
    Object? notes = freezed,
    Object? tags = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      photoR2Key: freezed == photoR2Key
          ? _value.photoR2Key
          : photoR2Key // ignore: cast_nullable_to_non_nullable
              as String?,
      memberNumber: freezed == memberNumber
          ? _value.memberNumber
          : memberNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      membershipDate: freezed == membershipDate
          ? _value.membershipDate
          : membershipDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      baptismDate: freezed == baptismDate
          ? _value.baptismDate
          : baptismDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      shepherdId: freezed == shepherdId
          ? _value.shepherdId
          : shepherdId // ignore: cast_nullable_to_non_nullable
              as String?,
      familyId: freezed == familyId
          ? _value.familyId
          : familyId // ignore: cast_nullable_to_non_nullable
              as String?,
      maritalStatus: freezed == maritalStatus
          ? _value.maritalStatus
          : maritalStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      occupation: freezed == occupation
          ? _value.occupation
          : occupation // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MemberImplCopyWith<$Res> implements $MemberCopyWith<$Res> {
  factory _$$MemberImplCopyWith(
          _$MemberImpl value, $Res Function(_$MemberImpl) then) =
      __$$MemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'church_id') String churchId,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      @JsonKey(name: 'display_name') String? displayName,
      String? gender,
      @JsonKey(name: 'birth_date') DateTime? birthDate,
      String? phone,
      String? email,
      String? address,
      @JsonKey(name: 'photo_url') String? photoUrl,
      @JsonKey(name: 'photo_r2_key') String? photoR2Key,
      @JsonKey(name: 'member_number') String? memberNumber,
      String status,
      @JsonKey(name: 'membership_date') DateTime? membershipDate,
      @JsonKey(name: 'baptism_date') DateTime? baptismDate,
      @JsonKey(name: 'shepherd_id') String? shepherdId,
      @JsonKey(name: 'family_id') String? familyId,
      @JsonKey(name: 'marital_status') String? maritalStatus,
      String? occupation,
      String? notes,
      List<String>? tags,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$MemberImplCopyWithImpl<$Res>
    extends _$MemberCopyWithImpl<$Res, _$MemberImpl>
    implements _$$MemberImplCopyWith<$Res> {
  __$$MemberImplCopyWithImpl(
      _$MemberImpl _value, $Res Function(_$MemberImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? userId = freezed,
    Object? firstName = null,
    Object? lastName = null,
    Object? displayName = freezed,
    Object? gender = freezed,
    Object? birthDate = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? photoUrl = freezed,
    Object? photoR2Key = freezed,
    Object? memberNumber = freezed,
    Object? status = null,
    Object? membershipDate = freezed,
    Object? baptismDate = freezed,
    Object? shepherdId = freezed,
    Object? familyId = freezed,
    Object? maritalStatus = freezed,
    Object? occupation = freezed,
    Object? notes = freezed,
    Object? tags = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$MemberImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      photoR2Key: freezed == photoR2Key
          ? _value.photoR2Key
          : photoR2Key // ignore: cast_nullable_to_non_nullable
              as String?,
      memberNumber: freezed == memberNumber
          ? _value.memberNumber
          : memberNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      membershipDate: freezed == membershipDate
          ? _value.membershipDate
          : membershipDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      baptismDate: freezed == baptismDate
          ? _value.baptismDate
          : baptismDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      shepherdId: freezed == shepherdId
          ? _value.shepherdId
          : shepherdId // ignore: cast_nullable_to_non_nullable
              as String?,
      familyId: freezed == familyId
          ? _value.familyId
          : familyId // ignore: cast_nullable_to_non_nullable
              as String?,
      maritalStatus: freezed == maritalStatus
          ? _value.maritalStatus
          : maritalStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      occupation: freezed == occupation
          ? _value.occupation
          : occupation // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberImpl implements _Member {
  const _$MemberImpl(
      {required this.id,
      @JsonKey(name: 'church_id') required this.churchId,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'first_name') required this.firstName,
      @JsonKey(name: 'last_name') required this.lastName,
      @JsonKey(name: 'display_name') this.displayName,
      this.gender,
      @JsonKey(name: 'birth_date') this.birthDate,
      this.phone,
      this.email,
      this.address,
      @JsonKey(name: 'photo_url') this.photoUrl,
      @JsonKey(name: 'photo_r2_key') this.photoR2Key,
      @JsonKey(name: 'member_number') this.memberNumber,
      this.status = 'active',
      @JsonKey(name: 'membership_date') this.membershipDate,
      @JsonKey(name: 'baptism_date') this.baptismDate,
      @JsonKey(name: 'shepherd_id') this.shepherdId,
      @JsonKey(name: 'family_id') this.familyId,
      @JsonKey(name: 'marital_status') this.maritalStatus,
      this.occupation,
      this.notes,
      final List<String>? tags,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _tags = tags;

  factory _$MemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'church_id')
  final String churchId;
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  @JsonKey(name: 'first_name')
  final String firstName;
  @override
  @JsonKey(name: 'last_name')
  final String lastName;
  @override
  @JsonKey(name: 'display_name')
  final String? displayName;
  @override
  final String? gender;
// male, female
  @override
  @JsonKey(name: 'birth_date')
  final DateTime? birthDate;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? address;
  @override
  @JsonKey(name: 'photo_url')
  final String? photoUrl;
  @override
  @JsonKey(name: 'photo_r2_key')
  final String? photoR2Key;
  @override
  @JsonKey(name: 'member_number')
  final String? memberNumber;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'membership_date')
  final DateTime? membershipDate;
  @override
  @JsonKey(name: 'baptism_date')
  final DateTime? baptismDate;
  @override
  @JsonKey(name: 'shepherd_id')
  final String? shepherdId;
  @override
  @JsonKey(name: 'family_id')
  final String? familyId;
  @override
  @JsonKey(name: 'marital_status')
  final String? maritalStatus;
  @override
  final String? occupation;
  @override
  final String? notes;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Member(id: $id, churchId: $churchId, userId: $userId, firstName: $firstName, lastName: $lastName, displayName: $displayName, gender: $gender, birthDate: $birthDate, phone: $phone, email: $email, address: $address, photoUrl: $photoUrl, photoR2Key: $photoR2Key, memberNumber: $memberNumber, status: $status, membershipDate: $membershipDate, baptismDate: $baptismDate, shepherdId: $shepherdId, familyId: $familyId, maritalStatus: $maritalStatus, occupation: $occupation, notes: $notes, tags: $tags, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.photoR2Key, photoR2Key) ||
                other.photoR2Key == photoR2Key) &&
            (identical(other.memberNumber, memberNumber) ||
                other.memberNumber == memberNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.membershipDate, membershipDate) ||
                other.membershipDate == membershipDate) &&
            (identical(other.baptismDate, baptismDate) ||
                other.baptismDate == baptismDate) &&
            (identical(other.shepherdId, shepherdId) ||
                other.shepherdId == shepherdId) &&
            (identical(other.familyId, familyId) ||
                other.familyId == familyId) &&
            (identical(other.maritalStatus, maritalStatus) ||
                other.maritalStatus == maritalStatus) &&
            (identical(other.occupation, occupation) ||
                other.occupation == occupation) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        churchId,
        userId,
        firstName,
        lastName,
        displayName,
        gender,
        birthDate,
        phone,
        email,
        address,
        photoUrl,
        photoR2Key,
        memberNumber,
        status,
        membershipDate,
        baptismDate,
        shepherdId,
        familyId,
        maritalStatus,
        occupation,
        notes,
        const DeepCollectionEquality().hash(_tags),
        isActive,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberImplCopyWith<_$MemberImpl> get copyWith =>
      __$$MemberImplCopyWithImpl<_$MemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberImplToJson(
      this,
    );
  }
}

abstract class _Member implements Member {
  const factory _Member(
      {required final String id,
      @JsonKey(name: 'church_id') required final String churchId,
      @JsonKey(name: 'user_id') final String? userId,
      @JsonKey(name: 'first_name') required final String firstName,
      @JsonKey(name: 'last_name') required final String lastName,
      @JsonKey(name: 'display_name') final String? displayName,
      final String? gender,
      @JsonKey(name: 'birth_date') final DateTime? birthDate,
      final String? phone,
      final String? email,
      final String? address,
      @JsonKey(name: 'photo_url') final String? photoUrl,
      @JsonKey(name: 'photo_r2_key') final String? photoR2Key,
      @JsonKey(name: 'member_number') final String? memberNumber,
      final String status,
      @JsonKey(name: 'membership_date') final DateTime? membershipDate,
      @JsonKey(name: 'baptism_date') final DateTime? baptismDate,
      @JsonKey(name: 'shepherd_id') final String? shepherdId,
      @JsonKey(name: 'family_id') final String? familyId,
      @JsonKey(name: 'marital_status') final String? maritalStatus,
      final String? occupation,
      final String? notes,
      final List<String>? tags,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt}) = _$MemberImpl;

  factory _Member.fromJson(Map<String, dynamic> json) = _$MemberImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'church_id')
  String get churchId;
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  @JsonKey(name: 'first_name')
  String get firstName;
  @override
  @JsonKey(name: 'last_name')
  String get lastName;
  @override
  @JsonKey(name: 'display_name')
  String? get displayName;
  @override
  String? get gender;
  @override // male, female
  @JsonKey(name: 'birth_date')
  DateTime? get birthDate;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  String? get address;
  @override
  @JsonKey(name: 'photo_url')
  String? get photoUrl;
  @override
  @JsonKey(name: 'photo_r2_key')
  String? get photoR2Key;
  @override
  @JsonKey(name: 'member_number')
  String? get memberNumber;
  @override
  String get status;
  @override
  @JsonKey(name: 'membership_date')
  DateTime? get membershipDate;
  @override
  @JsonKey(name: 'baptism_date')
  DateTime? get baptismDate;
  @override
  @JsonKey(name: 'shepherd_id')
  String? get shepherdId;
  @override
  @JsonKey(name: 'family_id')
  String? get familyId;
  @override
  @JsonKey(name: 'marital_status')
  String? get maritalStatus;
  @override
  String? get occupation;
  @override
  String? get notes;
  @override
  List<String>? get tags;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$MemberImplCopyWith<_$MemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FamilyRelationship _$FamilyRelationshipFromJson(Map<String, dynamic> json) {
  return _FamilyRelationship.fromJson(json);
}

/// @nodoc
mixin _$FamilyRelationship {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'church_id')
  String get churchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'member_id')
  String get memberId => throw _privateConstructorUsedError;
  @JsonKey(name: 'related_member_id')
  String get relatedMemberId => throw _privateConstructorUsedError;
  @JsonKey(name: 'relationship_type')
  String get relationshipType =>
      throw _privateConstructorUsedError; // spouse, parent, child, sibling, other
  @JsonKey(name: 'is_primary')
  bool get isPrimary => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FamilyRelationshipCopyWith<FamilyRelationship> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FamilyRelationshipCopyWith<$Res> {
  factory $FamilyRelationshipCopyWith(
          FamilyRelationship value, $Res Function(FamilyRelationship) then) =
      _$FamilyRelationshipCopyWithImpl<$Res, FamilyRelationship>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'church_id') String churchId,
      @JsonKey(name: 'member_id') String memberId,
      @JsonKey(name: 'related_member_id') String relatedMemberId,
      @JsonKey(name: 'relationship_type') String relationshipType,
      @JsonKey(name: 'is_primary') bool isPrimary,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$FamilyRelationshipCopyWithImpl<$Res, $Val extends FamilyRelationship>
    implements $FamilyRelationshipCopyWith<$Res> {
  _$FamilyRelationshipCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? memberId = null,
    Object? relatedMemberId = null,
    Object? relationshipType = null,
    Object? isPrimary = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      relatedMemberId: null == relatedMemberId
          ? _value.relatedMemberId
          : relatedMemberId // ignore: cast_nullable_to_non_nullable
              as String,
      relationshipType: null == relationshipType
          ? _value.relationshipType
          : relationshipType // ignore: cast_nullable_to_non_nullable
              as String,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FamilyRelationshipImplCopyWith<$Res>
    implements $FamilyRelationshipCopyWith<$Res> {
  factory _$$FamilyRelationshipImplCopyWith(_$FamilyRelationshipImpl value,
          $Res Function(_$FamilyRelationshipImpl) then) =
      __$$FamilyRelationshipImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'church_id') String churchId,
      @JsonKey(name: 'member_id') String memberId,
      @JsonKey(name: 'related_member_id') String relatedMemberId,
      @JsonKey(name: 'relationship_type') String relationshipType,
      @JsonKey(name: 'is_primary') bool isPrimary,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$FamilyRelationshipImplCopyWithImpl<$Res>
    extends _$FamilyRelationshipCopyWithImpl<$Res, _$FamilyRelationshipImpl>
    implements _$$FamilyRelationshipImplCopyWith<$Res> {
  __$$FamilyRelationshipImplCopyWithImpl(_$FamilyRelationshipImpl _value,
      $Res Function(_$FamilyRelationshipImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? memberId = null,
    Object? relatedMemberId = null,
    Object? relationshipType = null,
    Object? isPrimary = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$FamilyRelationshipImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      relatedMemberId: null == relatedMemberId
          ? _value.relatedMemberId
          : relatedMemberId // ignore: cast_nullable_to_non_nullable
              as String,
      relationshipType: null == relationshipType
          ? _value.relationshipType
          : relationshipType // ignore: cast_nullable_to_non_nullable
              as String,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FamilyRelationshipImpl implements _FamilyRelationship {
  const _$FamilyRelationshipImpl(
      {required this.id,
      @JsonKey(name: 'church_id') required this.churchId,
      @JsonKey(name: 'member_id') required this.memberId,
      @JsonKey(name: 'related_member_id') required this.relatedMemberId,
      @JsonKey(name: 'relationship_type') required this.relationshipType,
      @JsonKey(name: 'is_primary') this.isPrimary = false,
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$FamilyRelationshipImpl.fromJson(Map<String, dynamic> json) =>
      _$$FamilyRelationshipImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'church_id')
  final String churchId;
  @override
  @JsonKey(name: 'member_id')
  final String memberId;
  @override
  @JsonKey(name: 'related_member_id')
  final String relatedMemberId;
  @override
  @JsonKey(name: 'relationship_type')
  final String relationshipType;
// spouse, parent, child, sibling, other
  @override
  @JsonKey(name: 'is_primary')
  final bool isPrimary;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'FamilyRelationship(id: $id, churchId: $churchId, memberId: $memberId, relatedMemberId: $relatedMemberId, relationshipType: $relationshipType, isPrimary: $isPrimary, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FamilyRelationshipImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.relatedMemberId, relatedMemberId) ||
                other.relatedMemberId == relatedMemberId) &&
            (identical(other.relationshipType, relationshipType) ||
                other.relationshipType == relationshipType) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, churchId, memberId,
      relatedMemberId, relationshipType, isPrimary, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FamilyRelationshipImplCopyWith<_$FamilyRelationshipImpl> get copyWith =>
      __$$FamilyRelationshipImplCopyWithImpl<_$FamilyRelationshipImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FamilyRelationshipImplToJson(
      this,
    );
  }
}

abstract class _FamilyRelationship implements FamilyRelationship {
  const factory _FamilyRelationship(
      {required final String id,
      @JsonKey(name: 'church_id') required final String churchId,
      @JsonKey(name: 'member_id') required final String memberId,
      @JsonKey(name: 'related_member_id') required final String relatedMemberId,
      @JsonKey(name: 'relationship_type')
      required final String relationshipType,
      @JsonKey(name: 'is_primary') final bool isPrimary,
      @JsonKey(name: 'created_at')
      final DateTime? createdAt}) = _$FamilyRelationshipImpl;

  factory _FamilyRelationship.fromJson(Map<String, dynamic> json) =
      _$FamilyRelationshipImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'church_id')
  String get churchId;
  @override
  @JsonKey(name: 'member_id')
  String get memberId;
  @override
  @JsonKey(name: 'related_member_id')
  String get relatedMemberId;
  @override
  @JsonKey(name: 'relationship_type')
  String get relationshipType;
  @override // spouse, parent, child, sibling, other
  @JsonKey(name: 'is_primary')
  bool get isPrimary;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$FamilyRelationshipImplCopyWith<_$FamilyRelationshipImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MemberHistory _$MemberHistoryFromJson(Map<String, dynamic> json) {
  return _MemberHistory.fromJson(json);
}

/// @nodoc
mixin _$MemberHistory {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'church_id')
  String get churchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'member_id')
  String get memberId => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_type')
  String get eventType =>
      throw _privateConstructorUsedError; // created, updated, status_changed, baptized, married, transferred, deleted
  @JsonKey(name: 'event_date')
  DateTime get eventDate => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'performed_by')
  String? get performedBy => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MemberHistoryCopyWith<MemberHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberHistoryCopyWith<$Res> {
  factory $MemberHistoryCopyWith(
          MemberHistory value, $Res Function(MemberHistory) then) =
      _$MemberHistoryCopyWithImpl<$Res, MemberHistory>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'church_id') String churchId,
      @JsonKey(name: 'member_id') String memberId,
      @JsonKey(name: 'event_type') String eventType,
      @JsonKey(name: 'event_date') DateTime eventDate,
      String? description,
      @JsonKey(name: 'performed_by') String? performedBy,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$MemberHistoryCopyWithImpl<$Res, $Val extends MemberHistory>
    implements $MemberHistoryCopyWith<$Res> {
  _$MemberHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? memberId = null,
    Object? eventType = null,
    Object? eventDate = null,
    Object? description = freezed,
    Object? performedBy = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String,
      eventDate: null == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      performedBy: freezed == performedBy
          ? _value.performedBy
          : performedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MemberHistoryImplCopyWith<$Res>
    implements $MemberHistoryCopyWith<$Res> {
  factory _$$MemberHistoryImplCopyWith(
          _$MemberHistoryImpl value, $Res Function(_$MemberHistoryImpl) then) =
      __$$MemberHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'church_id') String churchId,
      @JsonKey(name: 'member_id') String memberId,
      @JsonKey(name: 'event_type') String eventType,
      @JsonKey(name: 'event_date') DateTime eventDate,
      String? description,
      @JsonKey(name: 'performed_by') String? performedBy,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$MemberHistoryImplCopyWithImpl<$Res>
    extends _$MemberHistoryCopyWithImpl<$Res, _$MemberHistoryImpl>
    implements _$$MemberHistoryImplCopyWith<$Res> {
  __$$MemberHistoryImplCopyWithImpl(
      _$MemberHistoryImpl _value, $Res Function(_$MemberHistoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? memberId = null,
    Object? eventType = null,
    Object? eventDate = null,
    Object? description = freezed,
    Object? performedBy = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$MemberHistoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String,
      eventDate: null == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      performedBy: freezed == performedBy
          ? _value.performedBy
          : performedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberHistoryImpl implements _MemberHistory {
  const _$MemberHistoryImpl(
      {required this.id,
      @JsonKey(name: 'church_id') required this.churchId,
      @JsonKey(name: 'member_id') required this.memberId,
      @JsonKey(name: 'event_type') required this.eventType,
      @JsonKey(name: 'event_date') required this.eventDate,
      this.description,
      @JsonKey(name: 'performed_by') this.performedBy,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$MemberHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberHistoryImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'church_id')
  final String churchId;
  @override
  @JsonKey(name: 'member_id')
  final String memberId;
  @override
  @JsonKey(name: 'event_type')
  final String eventType;
// created, updated, status_changed, baptized, married, transferred, deleted
  @override
  @JsonKey(name: 'event_date')
  final DateTime eventDate;
  @override
  final String? description;
  @override
  @JsonKey(name: 'performed_by')
  final String? performedBy;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'MemberHistory(id: $id, churchId: $churchId, memberId: $memberId, eventType: $eventType, eventDate: $eventDate, description: $description, performedBy: $performedBy, metadata: $metadata)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.eventDate, eventDate) ||
                other.eventDate == eventDate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.performedBy, performedBy) ||
                other.performedBy == performedBy) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      churchId,
      memberId,
      eventType,
      eventDate,
      description,
      performedBy,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberHistoryImplCopyWith<_$MemberHistoryImpl> get copyWith =>
      __$$MemberHistoryImplCopyWithImpl<_$MemberHistoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberHistoryImplToJson(
      this,
    );
  }
}

abstract class _MemberHistory implements MemberHistory {
  const factory _MemberHistory(
      {required final String id,
      @JsonKey(name: 'church_id') required final String churchId,
      @JsonKey(name: 'member_id') required final String memberId,
      @JsonKey(name: 'event_type') required final String eventType,
      @JsonKey(name: 'event_date') required final DateTime eventDate,
      final String? description,
      @JsonKey(name: 'performed_by') final String? performedBy,
      final Map<String, dynamic>? metadata}) = _$MemberHistoryImpl;

  factory _MemberHistory.fromJson(Map<String, dynamic> json) =
      _$MemberHistoryImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'church_id')
  String get churchId;
  @override
  @JsonKey(name: 'member_id')
  String get memberId;
  @override
  @JsonKey(name: 'event_type')
  String get eventType;
  @override // created, updated, status_changed, baptized, married, transferred, deleted
  @JsonKey(name: 'event_date')
  DateTime get eventDate;
  @override
  String? get description;
  @override
  @JsonKey(name: 'performed_by')
  String? get performedBy;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$MemberHistoryImplCopyWith<_$MemberHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SpiritualTracking _$SpiritualTrackingFromJson(Map<String, dynamic> json) {
  return _SpiritualTracking.fromJson(json);
}

/// @nodoc
mixin _$SpiritualTracking {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'church_id')
  String get churchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'member_id')
  String get memberId => throw _privateConstructorUsedError;
  @JsonKey(name: 'shepherd_id')
  String? get shepherdId => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_contact_date')
  DateTime? get lastContactDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_follow_up_date')
  DateTime? get nextFollowUpDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'spiritual_level')
  String? get spiritualLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'prayer_requests')
  String? get prayerRequests => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'growth_milestones')
  List<String>? get growthMilestones => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpiritualTrackingCopyWith<SpiritualTracking> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpiritualTrackingCopyWith<$Res> {
  factory $SpiritualTrackingCopyWith(
          SpiritualTracking value, $Res Function(SpiritualTracking) then) =
      _$SpiritualTrackingCopyWithImpl<$Res, SpiritualTracking>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'church_id') String churchId,
      @JsonKey(name: 'member_id') String memberId,
      @JsonKey(name: 'shepherd_id') String? shepherdId,
      @JsonKey(name: 'last_contact_date') DateTime? lastContactDate,
      @JsonKey(name: 'next_follow_up_date') DateTime? nextFollowUpDate,
      @JsonKey(name: 'spiritual_level') String? spiritualLevel,
      @JsonKey(name: 'prayer_requests') String? prayerRequests,
      String? notes,
      @JsonKey(name: 'growth_milestones') List<String>? growthMilestones,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$SpiritualTrackingCopyWithImpl<$Res, $Val extends SpiritualTracking>
    implements $SpiritualTrackingCopyWith<$Res> {
  _$SpiritualTrackingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? memberId = null,
    Object? shepherdId = freezed,
    Object? lastContactDate = freezed,
    Object? nextFollowUpDate = freezed,
    Object? spiritualLevel = freezed,
    Object? prayerRequests = freezed,
    Object? notes = freezed,
    Object? growthMilestones = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      shepherdId: freezed == shepherdId
          ? _value.shepherdId
          : shepherdId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastContactDate: freezed == lastContactDate
          ? _value.lastContactDate
          : lastContactDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextFollowUpDate: freezed == nextFollowUpDate
          ? _value.nextFollowUpDate
          : nextFollowUpDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      spiritualLevel: freezed == spiritualLevel
          ? _value.spiritualLevel
          : spiritualLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      prayerRequests: freezed == prayerRequests
          ? _value.prayerRequests
          : prayerRequests // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      growthMilestones: freezed == growthMilestones
          ? _value.growthMilestones
          : growthMilestones // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpiritualTrackingImplCopyWith<$Res>
    implements $SpiritualTrackingCopyWith<$Res> {
  factory _$$SpiritualTrackingImplCopyWith(_$SpiritualTrackingImpl value,
          $Res Function(_$SpiritualTrackingImpl) then) =
      __$$SpiritualTrackingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'church_id') String churchId,
      @JsonKey(name: 'member_id') String memberId,
      @JsonKey(name: 'shepherd_id') String? shepherdId,
      @JsonKey(name: 'last_contact_date') DateTime? lastContactDate,
      @JsonKey(name: 'next_follow_up_date') DateTime? nextFollowUpDate,
      @JsonKey(name: 'spiritual_level') String? spiritualLevel,
      @JsonKey(name: 'prayer_requests') String? prayerRequests,
      String? notes,
      @JsonKey(name: 'growth_milestones') List<String>? growthMilestones,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$SpiritualTrackingImplCopyWithImpl<$Res>
    extends _$SpiritualTrackingCopyWithImpl<$Res, _$SpiritualTrackingImpl>
    implements _$$SpiritualTrackingImplCopyWith<$Res> {
  __$$SpiritualTrackingImplCopyWithImpl(_$SpiritualTrackingImpl _value,
      $Res Function(_$SpiritualTrackingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? memberId = null,
    Object? shepherdId = freezed,
    Object? lastContactDate = freezed,
    Object? nextFollowUpDate = freezed,
    Object? spiritualLevel = freezed,
    Object? prayerRequests = freezed,
    Object? notes = freezed,
    Object? growthMilestones = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$SpiritualTrackingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      shepherdId: freezed == shepherdId
          ? _value.shepherdId
          : shepherdId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastContactDate: freezed == lastContactDate
          ? _value.lastContactDate
          : lastContactDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nextFollowUpDate: freezed == nextFollowUpDate
          ? _value.nextFollowUpDate
          : nextFollowUpDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      spiritualLevel: freezed == spiritualLevel
          ? _value.spiritualLevel
          : spiritualLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      prayerRequests: freezed == prayerRequests
          ? _value.prayerRequests
          : prayerRequests // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      growthMilestones: freezed == growthMilestones
          ? _value._growthMilestones
          : growthMilestones // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpiritualTrackingImpl implements _SpiritualTracking {
  const _$SpiritualTrackingImpl(
      {required this.id,
      @JsonKey(name: 'church_id') required this.churchId,
      @JsonKey(name: 'member_id') required this.memberId,
      @JsonKey(name: 'shepherd_id') this.shepherdId,
      @JsonKey(name: 'last_contact_date') this.lastContactDate,
      @JsonKey(name: 'next_follow_up_date') this.nextFollowUpDate,
      @JsonKey(name: 'spiritual_level') this.spiritualLevel,
      @JsonKey(name: 'prayer_requests') this.prayerRequests,
      this.notes,
      @JsonKey(name: 'growth_milestones') final List<String>? growthMilestones,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _growthMilestones = growthMilestones;

  factory _$SpiritualTrackingImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpiritualTrackingImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'church_id')
  final String churchId;
  @override
  @JsonKey(name: 'member_id')
  final String memberId;
  @override
  @JsonKey(name: 'shepherd_id')
  final String? shepherdId;
  @override
  @JsonKey(name: 'last_contact_date')
  final DateTime? lastContactDate;
  @override
  @JsonKey(name: 'next_follow_up_date')
  final DateTime? nextFollowUpDate;
  @override
  @JsonKey(name: 'spiritual_level')
  final String? spiritualLevel;
  @override
  @JsonKey(name: 'prayer_requests')
  final String? prayerRequests;
  @override
  final String? notes;
  final List<String>? _growthMilestones;
  @override
  @JsonKey(name: 'growth_milestones')
  List<String>? get growthMilestones {
    final value = _growthMilestones;
    if (value == null) return null;
    if (_growthMilestones is EqualUnmodifiableListView)
      return _growthMilestones;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'SpiritualTracking(id: $id, churchId: $churchId, memberId: $memberId, shepherdId: $shepherdId, lastContactDate: $lastContactDate, nextFollowUpDate: $nextFollowUpDate, spiritualLevel: $spiritualLevel, prayerRequests: $prayerRequests, notes: $notes, growthMilestones: $growthMilestones, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpiritualTrackingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.shepherdId, shepherdId) ||
                other.shepherdId == shepherdId) &&
            (identical(other.lastContactDate, lastContactDate) ||
                other.lastContactDate == lastContactDate) &&
            (identical(other.nextFollowUpDate, nextFollowUpDate) ||
                other.nextFollowUpDate == nextFollowUpDate) &&
            (identical(other.spiritualLevel, spiritualLevel) ||
                other.spiritualLevel == spiritualLevel) &&
            (identical(other.prayerRequests, prayerRequests) ||
                other.prayerRequests == prayerRequests) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality()
                .equals(other._growthMilestones, _growthMilestones) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      churchId,
      memberId,
      shepherdId,
      lastContactDate,
      nextFollowUpDate,
      spiritualLevel,
      prayerRequests,
      notes,
      const DeepCollectionEquality().hash(_growthMilestones),
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpiritualTrackingImplCopyWith<_$SpiritualTrackingImpl> get copyWith =>
      __$$SpiritualTrackingImplCopyWithImpl<_$SpiritualTrackingImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpiritualTrackingImplToJson(
      this,
    );
  }
}

abstract class _SpiritualTracking implements SpiritualTracking {
  const factory _SpiritualTracking(
      {required final String id,
      @JsonKey(name: 'church_id') required final String churchId,
      @JsonKey(name: 'member_id') required final String memberId,
      @JsonKey(name: 'shepherd_id') final String? shepherdId,
      @JsonKey(name: 'last_contact_date') final DateTime? lastContactDate,
      @JsonKey(name: 'next_follow_up_date') final DateTime? nextFollowUpDate,
      @JsonKey(name: 'spiritual_level') final String? spiritualLevel,
      @JsonKey(name: 'prayer_requests') final String? prayerRequests,
      final String? notes,
      @JsonKey(name: 'growth_milestones') final List<String>? growthMilestones,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$SpiritualTrackingImpl;

  factory _SpiritualTracking.fromJson(Map<String, dynamic> json) =
      _$SpiritualTrackingImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'church_id')
  String get churchId;
  @override
  @JsonKey(name: 'member_id')
  String get memberId;
  @override
  @JsonKey(name: 'shepherd_id')
  String? get shepherdId;
  @override
  @JsonKey(name: 'last_contact_date')
  DateTime? get lastContactDate;
  @override
  @JsonKey(name: 'next_follow_up_date')
  DateTime? get nextFollowUpDate;
  @override
  @JsonKey(name: 'spiritual_level')
  String? get spiritualLevel;
  @override
  @JsonKey(name: 'prayer_requests')
  String? get prayerRequests;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'growth_milestones')
  List<String>? get growthMilestones;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$SpiritualTrackingImplCopyWith<_$SpiritualTrackingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

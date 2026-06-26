// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shepherd.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Shepherd _$ShepherdFromJson(Map<String, dynamic> json) {
  return _Shepherd.fromJson(json);
}

/// @nodoc
mixin _$Shepherd {
  String get id => throw _privateConstructorUsedError;
  String get churchId => throw _privateConstructorUsedError;
  String get memberId =>
      throw _privateConstructorUsedError; // Member details (denormalized for easy listing)
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String get level =>
      throw _privateConstructorUsedError; // DEBUTANT, CONFIRME, ANCIEN
  List<String> get specialties =>
      throw _privateConstructorUsedError; // JEUNESSE, COUPLES, DELIVRANCE, etc.
  List<String> get supervisedGroupIds => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  DateTime? get ordainedAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ShepherdCopyWith<Shepherd> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShepherdCopyWith<$Res> {
  factory $ShepherdCopyWith(Shepherd value, $Res Function(Shepherd) then) =
      _$ShepherdCopyWithImpl<$Res, Shepherd>;
  @useResult
  $Res call(
      {String id,
      String churchId,
      String memberId,
      String? firstName,
      String? lastName,
      String? photoUrl,
      String level,
      List<String> specialties,
      List<String> supervisedGroupIds,
      String? bio,
      DateTime? ordainedAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ShepherdCopyWithImpl<$Res, $Val extends Shepherd>
    implements $ShepherdCopyWith<$Res> {
  _$ShepherdCopyWithImpl(this._value, this._then);

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
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? photoUrl = freezed,
    Object? level = null,
    Object? specialties = null,
    Object? supervisedGroupIds = null,
    Object? bio = freezed,
    Object? ordainedAt = freezed,
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
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      specialties: null == specialties
          ? _value.specialties
          : specialties // ignore: cast_nullable_to_non_nullable
              as List<String>,
      supervisedGroupIds: null == supervisedGroupIds
          ? _value.supervisedGroupIds
          : supervisedGroupIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      ordainedAt: freezed == ordainedAt
          ? _value.ordainedAt
          : ordainedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$ShepherdImplCopyWith<$Res>
    implements $ShepherdCopyWith<$Res> {
  factory _$$ShepherdImplCopyWith(
          _$ShepherdImpl value, $Res Function(_$ShepherdImpl) then) =
      __$$ShepherdImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String churchId,
      String memberId,
      String? firstName,
      String? lastName,
      String? photoUrl,
      String level,
      List<String> specialties,
      List<String> supervisedGroupIds,
      String? bio,
      DateTime? ordainedAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ShepherdImplCopyWithImpl<$Res>
    extends _$ShepherdCopyWithImpl<$Res, _$ShepherdImpl>
    implements _$$ShepherdImplCopyWith<$Res> {
  __$$ShepherdImplCopyWithImpl(
      _$ShepherdImpl _value, $Res Function(_$ShepherdImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? memberId = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? photoUrl = freezed,
    Object? level = null,
    Object? specialties = null,
    Object? supervisedGroupIds = null,
    Object? bio = freezed,
    Object? ordainedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ShepherdImpl(
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
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      specialties: null == specialties
          ? _value._specialties
          : specialties // ignore: cast_nullable_to_non_nullable
              as List<String>,
      supervisedGroupIds: null == supervisedGroupIds
          ? _value._supervisedGroupIds
          : supervisedGroupIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      ordainedAt: freezed == ordainedAt
          ? _value.ordainedAt
          : ordainedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$ShepherdImpl implements _Shepherd {
  const _$ShepherdImpl(
      {required this.id,
      required this.churchId,
      required this.memberId,
      this.firstName,
      this.lastName,
      this.photoUrl,
      this.level = 'DEBUTANT',
      final List<String> specialties = const [],
      final List<String> supervisedGroupIds = const [],
      this.bio,
      this.ordainedAt,
      this.createdAt,
      this.updatedAt})
      : _specialties = specialties,
        _supervisedGroupIds = supervisedGroupIds;

  factory _$ShepherdImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShepherdImplFromJson(json);

  @override
  final String id;
  @override
  final String churchId;
  @override
  final String memberId;
// Member details (denormalized for easy listing)
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? photoUrl;
  @override
  @JsonKey()
  final String level;
// DEBUTANT, CONFIRME, ANCIEN
  final List<String> _specialties;
// DEBUTANT, CONFIRME, ANCIEN
  @override
  @JsonKey()
  List<String> get specialties {
    if (_specialties is EqualUnmodifiableListView) return _specialties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specialties);
  }

// JEUNESSE, COUPLES, DELIVRANCE, etc.
  final List<String> _supervisedGroupIds;
// JEUNESSE, COUPLES, DELIVRANCE, etc.
  @override
  @JsonKey()
  List<String> get supervisedGroupIds {
    if (_supervisedGroupIds is EqualUnmodifiableListView)
      return _supervisedGroupIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_supervisedGroupIds);
  }

  @override
  final String? bio;
  @override
  final DateTime? ordainedAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Shepherd(id: $id, churchId: $churchId, memberId: $memberId, firstName: $firstName, lastName: $lastName, photoUrl: $photoUrl, level: $level, specialties: $specialties, supervisedGroupIds: $supervisedGroupIds, bio: $bio, ordainedAt: $ordainedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShepherdImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.level, level) || other.level == level) &&
            const DeepCollectionEquality()
                .equals(other._specialties, _specialties) &&
            const DeepCollectionEquality()
                .equals(other._supervisedGroupIds, _supervisedGroupIds) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.ordainedAt, ordainedAt) ||
                other.ordainedAt == ordainedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
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
      firstName,
      lastName,
      photoUrl,
      level,
      const DeepCollectionEquality().hash(_specialties),
      const DeepCollectionEquality().hash(_supervisedGroupIds),
      bio,
      ordainedAt,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShepherdImplCopyWith<_$ShepherdImpl> get copyWith =>
      __$$ShepherdImplCopyWithImpl<_$ShepherdImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShepherdImplToJson(
      this,
    );
  }
}

abstract class _Shepherd implements Shepherd {
  const factory _Shepherd(
      {required final String id,
      required final String churchId,
      required final String memberId,
      final String? firstName,
      final String? lastName,
      final String? photoUrl,
      final String level,
      final List<String> specialties,
      final List<String> supervisedGroupIds,
      final String? bio,
      final DateTime? ordainedAt,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ShepherdImpl;

  factory _Shepherd.fromJson(Map<String, dynamic> json) =
      _$ShepherdImpl.fromJson;

  @override
  String get id;
  @override
  String get churchId;
  @override
  String get memberId;
  @override // Member details (denormalized for easy listing)
  String? get firstName;
  @override
  String? get lastName;
  @override
  String? get photoUrl;
  @override
  String get level;
  @override // DEBUTANT, CONFIRME, ANCIEN
  List<String> get specialties;
  @override // JEUNESSE, COUPLES, DELIVRANCE, etc.
  List<String> get supervisedGroupIds;
  @override
  String? get bio;
  @override
  DateTime? get ordainedAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ShepherdImplCopyWith<_$ShepherdImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

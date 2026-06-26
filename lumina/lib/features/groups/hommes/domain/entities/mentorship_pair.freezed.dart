// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mentorship_pair.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MentorshipPair _$MentorshipPairFromJson(Map<String, dynamic> json) {
  return _MentorshipPair.fromJson(json);
}

/// @nodoc
mixin _$MentorshipPair {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'group_id')
  String get groupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'church_id')
  String get churchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'mentor_id')
  String get mentorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'mentee_id')
  String get menteeId => throw _privateConstructorUsedError;
  MentorshipStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_session_at')
  DateTime? get nextSessionAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_session_at')
  DateTime? get lastSessionAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Joined fields from Supabase
  @JsonKey(name: 'mentor_name')
  String? get mentorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'mentee_name')
  String? get menteeName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MentorshipPairCopyWith<MentorshipPair> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MentorshipPairCopyWith<$Res> {
  factory $MentorshipPairCopyWith(
          MentorshipPair value, $Res Function(MentorshipPair) then) =
      _$MentorshipPairCopyWithImpl<$Res, MentorshipPair>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'group_id') String groupId,
      @JsonKey(name: 'church_id') String churchId,
      @JsonKey(name: 'mentor_id') String mentorId,
      @JsonKey(name: 'mentee_id') String menteeId,
      MentorshipStatus status,
      @JsonKey(name: 'next_session_at') DateTime? nextSessionAt,
      @JsonKey(name: 'last_session_at') DateTime? lastSessionAt,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'mentor_name') String? mentorName,
      @JsonKey(name: 'mentee_name') String? menteeName});
}

/// @nodoc
class _$MentorshipPairCopyWithImpl<$Res, $Val extends MentorshipPair>
    implements $MentorshipPairCopyWith<$Res> {
  _$MentorshipPairCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupId = null,
    Object? churchId = null,
    Object? mentorId = null,
    Object? menteeId = null,
    Object? status = null,
    Object? nextSessionAt = freezed,
    Object? lastSessionAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? mentorName = freezed,
    Object? menteeName = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      mentorId: null == mentorId
          ? _value.mentorId
          : mentorId // ignore: cast_nullable_to_non_nullable
              as String,
      menteeId: null == menteeId
          ? _value.menteeId
          : menteeId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MentorshipStatus,
      nextSessionAt: freezed == nextSessionAt
          ? _value.nextSessionAt
          : nextSessionAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSessionAt: freezed == lastSessionAt
          ? _value.lastSessionAt
          : lastSessionAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      mentorName: freezed == mentorName
          ? _value.mentorName
          : mentorName // ignore: cast_nullable_to_non_nullable
              as String?,
      menteeName: freezed == menteeName
          ? _value.menteeName
          : menteeName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MentorshipPairImplCopyWith<$Res>
    implements $MentorshipPairCopyWith<$Res> {
  factory _$$MentorshipPairImplCopyWith(_$MentorshipPairImpl value,
          $Res Function(_$MentorshipPairImpl) then) =
      __$$MentorshipPairImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'group_id') String groupId,
      @JsonKey(name: 'church_id') String churchId,
      @JsonKey(name: 'mentor_id') String mentorId,
      @JsonKey(name: 'mentee_id') String menteeId,
      MentorshipStatus status,
      @JsonKey(name: 'next_session_at') DateTime? nextSessionAt,
      @JsonKey(name: 'last_session_at') DateTime? lastSessionAt,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'mentor_name') String? mentorName,
      @JsonKey(name: 'mentee_name') String? menteeName});
}

/// @nodoc
class __$$MentorshipPairImplCopyWithImpl<$Res>
    extends _$MentorshipPairCopyWithImpl<$Res, _$MentorshipPairImpl>
    implements _$$MentorshipPairImplCopyWith<$Res> {
  __$$MentorshipPairImplCopyWithImpl(
      _$MentorshipPairImpl _value, $Res Function(_$MentorshipPairImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupId = null,
    Object? churchId = null,
    Object? mentorId = null,
    Object? menteeId = null,
    Object? status = null,
    Object? nextSessionAt = freezed,
    Object? lastSessionAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? mentorName = freezed,
    Object? menteeName = freezed,
  }) {
    return _then(_$MentorshipPairImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      mentorId: null == mentorId
          ? _value.mentorId
          : mentorId // ignore: cast_nullable_to_non_nullable
              as String,
      menteeId: null == menteeId
          ? _value.menteeId
          : menteeId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MentorshipStatus,
      nextSessionAt: freezed == nextSessionAt
          ? _value.nextSessionAt
          : nextSessionAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSessionAt: freezed == lastSessionAt
          ? _value.lastSessionAt
          : lastSessionAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      mentorName: freezed == mentorName
          ? _value.mentorName
          : mentorName // ignore: cast_nullable_to_non_nullable
              as String?,
      menteeName: freezed == menteeName
          ? _value.menteeName
          : menteeName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MentorshipPairImpl extends _MentorshipPair {
  const _$MentorshipPairImpl(
      {required this.id,
      @JsonKey(name: 'group_id') required this.groupId,
      @JsonKey(name: 'church_id') required this.churchId,
      @JsonKey(name: 'mentor_id') required this.mentorId,
      @JsonKey(name: 'mentee_id') required this.menteeId,
      this.status = MentorshipStatus.active,
      @JsonKey(name: 'next_session_at') this.nextSessionAt,
      @JsonKey(name: 'last_session_at') this.lastSessionAt,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'mentor_name') this.mentorName,
      @JsonKey(name: 'mentee_name') this.menteeName})
      : super._();

  factory _$MentorshipPairImpl.fromJson(Map<String, dynamic> json) =>
      _$$MentorshipPairImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'group_id')
  final String groupId;
  @override
  @JsonKey(name: 'church_id')
  final String churchId;
  @override
  @JsonKey(name: 'mentor_id')
  final String mentorId;
  @override
  @JsonKey(name: 'mentee_id')
  final String menteeId;
  @override
  @JsonKey()
  final MentorshipStatus status;
  @override
  @JsonKey(name: 'next_session_at')
  final DateTime? nextSessionAt;
  @override
  @JsonKey(name: 'last_session_at')
  final DateTime? lastSessionAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
// Joined fields from Supabase
  @override
  @JsonKey(name: 'mentor_name')
  final String? mentorName;
  @override
  @JsonKey(name: 'mentee_name')
  final String? menteeName;

  @override
  String toString() {
    return 'MentorshipPair(id: $id, groupId: $groupId, churchId: $churchId, mentorId: $mentorId, menteeId: $menteeId, status: $status, nextSessionAt: $nextSessionAt, lastSessionAt: $lastSessionAt, createdAt: $createdAt, updatedAt: $updatedAt, mentorName: $mentorName, menteeName: $menteeName)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MentorshipPairImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.mentorId, mentorId) ||
                other.mentorId == mentorId) &&
            (identical(other.menteeId, menteeId) ||
                other.menteeId == menteeId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.nextSessionAt, nextSessionAt) ||
                other.nextSessionAt == nextSessionAt) &&
            (identical(other.lastSessionAt, lastSessionAt) ||
                other.lastSessionAt == lastSessionAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.mentorName, mentorName) ||
                other.mentorName == mentorName) &&
            (identical(other.menteeName, menteeName) ||
                other.menteeName == menteeName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      groupId,
      churchId,
      mentorId,
      menteeId,
      status,
      nextSessionAt,
      lastSessionAt,
      createdAt,
      updatedAt,
      mentorName,
      menteeName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MentorshipPairImplCopyWith<_$MentorshipPairImpl> get copyWith =>
      __$$MentorshipPairImplCopyWithImpl<_$MentorshipPairImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MentorshipPairImplToJson(
      this,
    );
  }
}

abstract class _MentorshipPair extends MentorshipPair {
  const factory _MentorshipPair(
          {required final String id,
          @JsonKey(name: 'group_id') required final String groupId,
          @JsonKey(name: 'church_id') required final String churchId,
          @JsonKey(name: 'mentor_id') required final String mentorId,
          @JsonKey(name: 'mentee_id') required final String menteeId,
          final MentorshipStatus status,
          @JsonKey(name: 'next_session_at') final DateTime? nextSessionAt,
          @JsonKey(name: 'last_session_at') final DateTime? lastSessionAt,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt,
          @JsonKey(name: 'mentor_name') final String? mentorName,
          @JsonKey(name: 'mentee_name') final String? menteeName}) =
      _$MentorshipPairImpl;
  const _MentorshipPair._() : super._();

  factory _MentorshipPair.fromJson(Map<String, dynamic> json) =
      _$MentorshipPairImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'group_id')
  String get groupId;
  @override
  @JsonKey(name: 'church_id')
  String get churchId;
  @override
  @JsonKey(name: 'mentor_id')
  String get mentorId;
  @override
  @JsonKey(name: 'mentee_id')
  String get menteeId;
  @override
  MentorshipStatus get status;
  @override
  @JsonKey(name: 'next_session_at')
  DateTime? get nextSessionAt;
  @override
  @JsonKey(name: 'last_session_at')
  DateTime? get lastSessionAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override // Joined fields from Supabase
  @JsonKey(name: 'mentor_name')
  String? get mentorName;
  @override
  @JsonKey(name: 'mentee_name')
  String? get menteeName;
  @override
  @JsonKey(ignore: true)
  _$$MentorshipPairImplCopyWith<_$MentorshipPairImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

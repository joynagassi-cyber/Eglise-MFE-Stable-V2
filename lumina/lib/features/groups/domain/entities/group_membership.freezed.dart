// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_membership.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GroupMembership _$GroupMembershipFromJson(Map<String, dynamic> json) {
  return _GroupMembership.fromJson(json);
}

/// @nodoc
mixin _$GroupMembership {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'church_id')
  String get churchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'group_id')
  String get groupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'member_id')
  String get memberId => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: GroupRole.member)
  GroupRole get role => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: MembershipStatus.pending)
  MembershipStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'joined_at')
  DateTime? get joinedAt => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get memberName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GroupMembershipCopyWith<GroupMembership> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupMembershipCopyWith<$Res> {
  factory $GroupMembershipCopyWith(
          GroupMembership value, $Res Function(GroupMembership) then) =
      _$GroupMembershipCopyWithImpl<$Res, GroupMembership>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'church_id') String churchId,
      @JsonKey(name: 'group_id') String groupId,
      @JsonKey(name: 'member_id') String memberId,
      @JsonKey(unknownEnumValue: GroupRole.member) GroupRole role,
      @JsonKey(unknownEnumValue: MembershipStatus.pending)
      MembershipStatus status,
      @JsonKey(name: 'joined_at') DateTime? joinedAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      String? memberName});
}

/// @nodoc
class _$GroupMembershipCopyWithImpl<$Res, $Val extends GroupMembership>
    implements $GroupMembershipCopyWith<$Res> {
  _$GroupMembershipCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? groupId = null,
    Object? memberId = null,
    Object? role = null,
    Object? status = null,
    Object? joinedAt = freezed,
    Object? memberName = freezed,
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
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as GroupRole,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MembershipStatus,
      joinedAt: freezed == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      memberName: freezed == memberName
          ? _value.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupMembershipImplCopyWith<$Res>
    implements $GroupMembershipCopyWith<$Res> {
  factory _$$GroupMembershipImplCopyWith(_$GroupMembershipImpl value,
          $Res Function(_$GroupMembershipImpl) then) =
      __$$GroupMembershipImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'church_id') String churchId,
      @JsonKey(name: 'group_id') String groupId,
      @JsonKey(name: 'member_id') String memberId,
      @JsonKey(unknownEnumValue: GroupRole.member) GroupRole role,
      @JsonKey(unknownEnumValue: MembershipStatus.pending)
      MembershipStatus status,
      @JsonKey(name: 'joined_at') DateTime? joinedAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      String? memberName});
}

/// @nodoc
class __$$GroupMembershipImplCopyWithImpl<$Res>
    extends _$GroupMembershipCopyWithImpl<$Res, _$GroupMembershipImpl>
    implements _$$GroupMembershipImplCopyWith<$Res> {
  __$$GroupMembershipImplCopyWithImpl(
      _$GroupMembershipImpl _value, $Res Function(_$GroupMembershipImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? groupId = null,
    Object? memberId = null,
    Object? role = null,
    Object? status = null,
    Object? joinedAt = freezed,
    Object? memberName = freezed,
  }) {
    return _then(_$GroupMembershipImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as GroupRole,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MembershipStatus,
      joinedAt: freezed == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      memberName: freezed == memberName
          ? _value.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupMembershipImpl implements _GroupMembership {
  const _$GroupMembershipImpl(
      {required this.id,
      @JsonKey(name: 'church_id') required this.churchId,
      @JsonKey(name: 'group_id') required this.groupId,
      @JsonKey(name: 'member_id') required this.memberId,
      @JsonKey(unknownEnumValue: GroupRole.member) this.role = GroupRole.member,
      @JsonKey(unknownEnumValue: MembershipStatus.pending)
      this.status = MembershipStatus.pending,
      @JsonKey(name: 'joined_at') this.joinedAt,
      @JsonKey(includeFromJson: false, includeToJson: false) this.memberName});

  factory _$GroupMembershipImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupMembershipImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'church_id')
  final String churchId;
  @override
  @JsonKey(name: 'group_id')
  final String groupId;
  @override
  @JsonKey(name: 'member_id')
  final String memberId;
  @override
  @JsonKey(unknownEnumValue: GroupRole.member)
  final GroupRole role;
  @override
  @JsonKey(unknownEnumValue: MembershipStatus.pending)
  final MembershipStatus status;
  @override
  @JsonKey(name: 'joined_at')
  final DateTime? joinedAt;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? memberName;

  @override
  String toString() {
    return 'GroupMembership(id: $id, churchId: $churchId, groupId: $groupId, memberId: $memberId, role: $role, status: $status, joinedAt: $joinedAt, memberName: $memberName)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupMembershipImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt) &&
            (identical(other.memberName, memberName) ||
                other.memberName == memberName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, churchId, groupId, memberId,
      role, status, joinedAt, memberName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupMembershipImplCopyWith<_$GroupMembershipImpl> get copyWith =>
      __$$GroupMembershipImplCopyWithImpl<_$GroupMembershipImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupMembershipImplToJson(
      this,
    );
  }
}

abstract class _GroupMembership implements GroupMembership {
  const factory _GroupMembership(
      {required final String id,
      @JsonKey(name: 'church_id') required final String churchId,
      @JsonKey(name: 'group_id') required final String groupId,
      @JsonKey(name: 'member_id') required final String memberId,
      @JsonKey(unknownEnumValue: GroupRole.member) final GroupRole role,
      @JsonKey(unknownEnumValue: MembershipStatus.pending)
      final MembershipStatus status,
      @JsonKey(name: 'joined_at') final DateTime? joinedAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final String? memberName}) = _$GroupMembershipImpl;

  factory _GroupMembership.fromJson(Map<String, dynamic> json) =
      _$GroupMembershipImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'church_id')
  String get churchId;
  @override
  @JsonKey(name: 'group_id')
  String get groupId;
  @override
  @JsonKey(name: 'member_id')
  String get memberId;
  @override
  @JsonKey(unknownEnumValue: GroupRole.member)
  GroupRole get role;
  @override
  @JsonKey(unknownEnumValue: MembershipStatus.pending)
  MembershipStatus get status;
  @override
  @JsonKey(name: 'joined_at')
  DateTime? get joinedAt;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get memberName;
  @override
  @JsonKey(ignore: true)
  _$$GroupMembershipImplCopyWith<_$GroupMembershipImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

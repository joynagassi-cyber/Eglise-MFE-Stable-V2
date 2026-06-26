// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_attendance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GroupAttendance _$GroupAttendanceFromJson(Map<String, dynamic> json) {
  return _GroupAttendance.fromJson(json);
}

/// @nodoc
mixin _$GroupAttendance {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'church_id')
  String get churchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'group_id')
  String get groupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'member_id')
  String get memberId => throw _privateConstructorUsedError;
  @JsonKey(name: 'attendance_date')
  DateTime get attendanceDate => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: AttendanceStatus.present)
  AttendanceStatus get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GroupAttendanceCopyWith<GroupAttendance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupAttendanceCopyWith<$Res> {
  factory $GroupAttendanceCopyWith(
          GroupAttendance value, $Res Function(GroupAttendance) then) =
      _$GroupAttendanceCopyWithImpl<$Res, GroupAttendance>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'church_id') String churchId,
      @JsonKey(name: 'group_id') String groupId,
      @JsonKey(name: 'member_id') String memberId,
      @JsonKey(name: 'attendance_date') DateTime attendanceDate,
      @JsonKey(unknownEnumValue: AttendanceStatus.present)
      AttendanceStatus status,
      String? notes,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$GroupAttendanceCopyWithImpl<$Res, $Val extends GroupAttendance>
    implements $GroupAttendanceCopyWith<$Res> {
  _$GroupAttendanceCopyWithImpl(this._value, this._then);

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
    Object? attendanceDate = null,
    Object? status = null,
    Object? notes = freezed,
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
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      attendanceDate: null == attendanceDate
          ? _value.attendanceDate
          : attendanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AttendanceStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$GroupAttendanceImplCopyWith<$Res>
    implements $GroupAttendanceCopyWith<$Res> {
  factory _$$GroupAttendanceImplCopyWith(_$GroupAttendanceImpl value,
          $Res Function(_$GroupAttendanceImpl) then) =
      __$$GroupAttendanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'church_id') String churchId,
      @JsonKey(name: 'group_id') String groupId,
      @JsonKey(name: 'member_id') String memberId,
      @JsonKey(name: 'attendance_date') DateTime attendanceDate,
      @JsonKey(unknownEnumValue: AttendanceStatus.present)
      AttendanceStatus status,
      String? notes,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$GroupAttendanceImplCopyWithImpl<$Res>
    extends _$GroupAttendanceCopyWithImpl<$Res, _$GroupAttendanceImpl>
    implements _$$GroupAttendanceImplCopyWith<$Res> {
  __$$GroupAttendanceImplCopyWithImpl(
      _$GroupAttendanceImpl _value, $Res Function(_$GroupAttendanceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? groupId = null,
    Object? memberId = null,
    Object? attendanceDate = null,
    Object? status = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$GroupAttendanceImpl(
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
      attendanceDate: null == attendanceDate
          ? _value.attendanceDate
          : attendanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AttendanceStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$GroupAttendanceImpl implements _GroupAttendance {
  const _$GroupAttendanceImpl(
      {required this.id,
      @JsonKey(name: 'church_id') required this.churchId,
      @JsonKey(name: 'group_id') required this.groupId,
      @JsonKey(name: 'member_id') required this.memberId,
      @JsonKey(name: 'attendance_date') required this.attendanceDate,
      @JsonKey(unknownEnumValue: AttendanceStatus.present)
      this.status = AttendanceStatus.present,
      this.notes,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$GroupAttendanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupAttendanceImplFromJson(json);

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
  @JsonKey(name: 'attendance_date')
  final DateTime attendanceDate;
  @override
  @JsonKey(unknownEnumValue: AttendanceStatus.present)
  final AttendanceStatus status;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'GroupAttendance(id: $id, churchId: $churchId, groupId: $groupId, memberId: $memberId, attendanceDate: $attendanceDate, status: $status, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupAttendanceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.attendanceDate, attendanceDate) ||
                other.attendanceDate == attendanceDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, churchId, groupId, memberId,
      attendanceDate, status, notes, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupAttendanceImplCopyWith<_$GroupAttendanceImpl> get copyWith =>
      __$$GroupAttendanceImplCopyWithImpl<_$GroupAttendanceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupAttendanceImplToJson(
      this,
    );
  }
}

abstract class _GroupAttendance implements GroupAttendance {
  const factory _GroupAttendance(
      {required final String id,
      @JsonKey(name: 'church_id') required final String churchId,
      @JsonKey(name: 'group_id') required final String groupId,
      @JsonKey(name: 'member_id') required final String memberId,
      @JsonKey(name: 'attendance_date') required final DateTime attendanceDate,
      @JsonKey(unknownEnumValue: AttendanceStatus.present)
      final AttendanceStatus status,
      final String? notes,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$GroupAttendanceImpl;

  factory _GroupAttendance.fromJson(Map<String, dynamic> json) =
      _$GroupAttendanceImpl.fromJson;

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
  @JsonKey(name: 'attendance_date')
  DateTime get attendanceDate;
  @override
  @JsonKey(unknownEnumValue: AttendanceStatus.present)
  AttendanceStatus get status;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$GroupAttendanceImplCopyWith<_$GroupAttendanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

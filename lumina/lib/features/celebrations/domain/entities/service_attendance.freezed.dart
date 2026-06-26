// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_attendance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ServiceAttendance _$ServiceAttendanceFromJson(Map<String, dynamic> json) {
  return _ServiceAttendance.fromJson(json);
}

/// @nodoc
mixin _$ServiceAttendance {
  String get id => throw _privateConstructorUsedError;
  String get serviceId => throw _privateConstructorUsedError;
  String get memberId => throw _privateConstructorUsedError;
  String? get memberName =>
      throw _privateConstructorUsedError; // Snapshot in case member is deleted
  DateTime? get checkInTime => throw _privateConstructorUsedError;
  bool get isPresent => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ServiceAttendanceCopyWith<ServiceAttendance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceAttendanceCopyWith<$Res> {
  factory $ServiceAttendanceCopyWith(
          ServiceAttendance value, $Res Function(ServiceAttendance) then) =
      _$ServiceAttendanceCopyWithImpl<$Res, ServiceAttendance>;
  @useResult
  $Res call(
      {String id,
      String serviceId,
      String memberId,
      String? memberName,
      DateTime? checkInTime,
      bool isPresent,
      String? notes});
}

/// @nodoc
class _$ServiceAttendanceCopyWithImpl<$Res, $Val extends ServiceAttendance>
    implements $ServiceAttendanceCopyWith<$Res> {
  _$ServiceAttendanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serviceId = null,
    Object? memberId = null,
    Object? memberName = freezed,
    Object? checkInTime = freezed,
    Object? isPresent = null,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      serviceId: null == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      memberName: freezed == memberName
          ? _value.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String?,
      checkInTime: freezed == checkInTime
          ? _value.checkInTime
          : checkInTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isPresent: null == isPresent
          ? _value.isPresent
          : isPresent // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServiceAttendanceImplCopyWith<$Res>
    implements $ServiceAttendanceCopyWith<$Res> {
  factory _$$ServiceAttendanceImplCopyWith(_$ServiceAttendanceImpl value,
          $Res Function(_$ServiceAttendanceImpl) then) =
      __$$ServiceAttendanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String serviceId,
      String memberId,
      String? memberName,
      DateTime? checkInTime,
      bool isPresent,
      String? notes});
}

/// @nodoc
class __$$ServiceAttendanceImplCopyWithImpl<$Res>
    extends _$ServiceAttendanceCopyWithImpl<$Res, _$ServiceAttendanceImpl>
    implements _$$ServiceAttendanceImplCopyWith<$Res> {
  __$$ServiceAttendanceImplCopyWithImpl(_$ServiceAttendanceImpl _value,
      $Res Function(_$ServiceAttendanceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? serviceId = null,
    Object? memberId = null,
    Object? memberName = freezed,
    Object? checkInTime = freezed,
    Object? isPresent = null,
    Object? notes = freezed,
  }) {
    return _then(_$ServiceAttendanceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      serviceId: null == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      memberName: freezed == memberName
          ? _value.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String?,
      checkInTime: freezed == checkInTime
          ? _value.checkInTime
          : checkInTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isPresent: null == isPresent
          ? _value.isPresent
          : isPresent // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceAttendanceImpl implements _ServiceAttendance {
  const _$ServiceAttendanceImpl(
      {required this.id,
      required this.serviceId,
      required this.memberId,
      this.memberName,
      this.checkInTime,
      this.isPresent = true,
      this.notes});

  factory _$ServiceAttendanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceAttendanceImplFromJson(json);

  @override
  final String id;
  @override
  final String serviceId;
  @override
  final String memberId;
  @override
  final String? memberName;
// Snapshot in case member is deleted
  @override
  final DateTime? checkInTime;
  @override
  @JsonKey()
  final bool isPresent;
  @override
  final String? notes;

  @override
  String toString() {
    return 'ServiceAttendance(id: $id, serviceId: $serviceId, memberId: $memberId, memberName: $memberName, checkInTime: $checkInTime, isPresent: $isPresent, notes: $notes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceAttendanceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.memberName, memberName) ||
                other.memberName == memberName) &&
            (identical(other.checkInTime, checkInTime) ||
                other.checkInTime == checkInTime) &&
            (identical(other.isPresent, isPresent) ||
                other.isPresent == isPresent) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, serviceId, memberId,
      memberName, checkInTime, isPresent, notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceAttendanceImplCopyWith<_$ServiceAttendanceImpl> get copyWith =>
      __$$ServiceAttendanceImplCopyWithImpl<_$ServiceAttendanceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceAttendanceImplToJson(
      this,
    );
  }
}

abstract class _ServiceAttendance implements ServiceAttendance {
  const factory _ServiceAttendance(
      {required final String id,
      required final String serviceId,
      required final String memberId,
      final String? memberName,
      final DateTime? checkInTime,
      final bool isPresent,
      final String? notes}) = _$ServiceAttendanceImpl;

  factory _ServiceAttendance.fromJson(Map<String, dynamic> json) =
      _$ServiceAttendanceImpl.fromJson;

  @override
  String get id;
  @override
  String get serviceId;
  @override
  String get memberId;
  @override
  String? get memberName;
  @override // Snapshot in case member is deleted
  DateTime? get checkInTime;
  @override
  bool get isPresent;
  @override
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$ServiceAttendanceImplCopyWith<_$ServiceAttendanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

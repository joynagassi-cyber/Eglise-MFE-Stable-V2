// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rehearsal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Rehearsal _$RehearsalFromJson(Map<String, dynamic> json) {
  return _Rehearsal.fromJson(json);
}

/// @nodoc
mixin _$Rehearsal {
  String get id => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get groupId => throw _privateConstructorUsedError;
  String get churchId => throw _privateConstructorUsedError;
  String? get eventId => throw _privateConstructorUsedError;
  int get attendanceCount => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RehearsalCopyWith<Rehearsal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RehearsalCopyWith<$Res> {
  factory $RehearsalCopyWith(Rehearsal value, $Res Function(Rehearsal) then) =
      _$RehearsalCopyWithImpl<$Res, Rehearsal>;
  @useResult
  $Res call(
      {String id,
      DateTime date,
      String? location,
      String? description,
      String groupId,
      String churchId,
      String? eventId,
      int attendanceCount,
      DateTime? createdAt});
}

/// @nodoc
class _$RehearsalCopyWithImpl<$Res, $Val extends Rehearsal>
    implements $RehearsalCopyWith<$Res> {
  _$RehearsalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? location = freezed,
    Object? description = freezed,
    Object? groupId = null,
    Object? churchId = null,
    Object? eventId = freezed,
    Object? attendanceCount = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
      attendanceCount: null == attendanceCount
          ? _value.attendanceCount
          : attendanceCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RehearsalImplCopyWith<$Res>
    implements $RehearsalCopyWith<$Res> {
  factory _$$RehearsalImplCopyWith(
          _$RehearsalImpl value, $Res Function(_$RehearsalImpl) then) =
      __$$RehearsalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime date,
      String? location,
      String? description,
      String groupId,
      String churchId,
      String? eventId,
      int attendanceCount,
      DateTime? createdAt});
}

/// @nodoc
class __$$RehearsalImplCopyWithImpl<$Res>
    extends _$RehearsalCopyWithImpl<$Res, _$RehearsalImpl>
    implements _$$RehearsalImplCopyWith<$Res> {
  __$$RehearsalImplCopyWithImpl(
      _$RehearsalImpl _value, $Res Function(_$RehearsalImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? location = freezed,
    Object? description = freezed,
    Object? groupId = null,
    Object? churchId = null,
    Object? eventId = freezed,
    Object? attendanceCount = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$RehearsalImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
      attendanceCount: null == attendanceCount
          ? _value.attendanceCount
          : attendanceCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RehearsalImpl extends _Rehearsal {
  const _$RehearsalImpl(
      {required this.id,
      required this.date,
      this.location,
      this.description,
      required this.groupId,
      required this.churchId,
      this.eventId,
      this.attendanceCount = 0,
      this.createdAt})
      : super._();

  factory _$RehearsalImpl.fromJson(Map<String, dynamic> json) =>
      _$$RehearsalImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime date;
  @override
  final String? location;
  @override
  final String? description;
  @override
  final String groupId;
  @override
  final String churchId;
  @override
  final String? eventId;
  @override
  @JsonKey()
  final int attendanceCount;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Rehearsal(id: $id, date: $date, location: $location, description: $description, groupId: $groupId, churchId: $churchId, eventId: $eventId, attendanceCount: $attendanceCount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RehearsalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.attendanceCount, attendanceCount) ||
                other.attendanceCount == attendanceCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, date, location, description,
      groupId, churchId, eventId, attendanceCount, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RehearsalImplCopyWith<_$RehearsalImpl> get copyWith =>
      __$$RehearsalImplCopyWithImpl<_$RehearsalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RehearsalImplToJson(
      this,
    );
  }
}

abstract class _Rehearsal extends Rehearsal {
  const factory _Rehearsal(
      {required final String id,
      required final DateTime date,
      final String? location,
      final String? description,
      required final String groupId,
      required final String churchId,
      final String? eventId,
      final int attendanceCount,
      final DateTime? createdAt}) = _$RehearsalImpl;
  const _Rehearsal._() : super._();

  factory _Rehearsal.fromJson(Map<String, dynamic> json) =
      _$RehearsalImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get date;
  @override
  String? get location;
  @override
  String? get description;
  @override
  String get groupId;
  @override
  String get churchId;
  @override
  String? get eventId;
  @override
  int get attendanceCount;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$RehearsalImplCopyWith<_$RehearsalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

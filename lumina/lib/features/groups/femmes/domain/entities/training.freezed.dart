// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'training.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Training _$TrainingFromJson(Map<String, dynamic> json) {
  return _Training.fromJson(json);
}

/// @nodoc
mixin _$Training {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'church_id')
  String get churchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'group_id')
  String get groupId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get trainer => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_session')
  DateTime? get nextSession => throw _privateConstructorUsedError;
  int? get capacity => throw _privateConstructorUsedError;
  @JsonKey(name: 'enrolled_count')
  int get enrolledCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TrainingCopyWith<Training> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainingCopyWith<$Res> {
  factory $TrainingCopyWith(Training value, $Res Function(Training) then) =
      _$TrainingCopyWithImpl<$Res, Training>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'church_id') String churchId,
      @JsonKey(name: 'group_id') String groupId,
      String title,
      String? description,
      String? trainer,
      @JsonKey(name: 'next_session') DateTime? nextSession,
      int? capacity,
      @JsonKey(name: 'enrolled_count') int enrolledCount,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$TrainingCopyWithImpl<$Res, $Val extends Training>
    implements $TrainingCopyWith<$Res> {
  _$TrainingCopyWithImpl(this._value, this._then);

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
    Object? title = null,
    Object? description = freezed,
    Object? trainer = freezed,
    Object? nextSession = freezed,
    Object? capacity = freezed,
    Object? enrolledCount = null,
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
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      trainer: freezed == trainer
          ? _value.trainer
          : trainer // ignore: cast_nullable_to_non_nullable
              as String?,
      nextSession: freezed == nextSession
          ? _value.nextSession
          : nextSession // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      capacity: freezed == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int?,
      enrolledCount: null == enrolledCount
          ? _value.enrolledCount
          : enrolledCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrainingImplCopyWith<$Res>
    implements $TrainingCopyWith<$Res> {
  factory _$$TrainingImplCopyWith(
          _$TrainingImpl value, $Res Function(_$TrainingImpl) then) =
      __$$TrainingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'church_id') String churchId,
      @JsonKey(name: 'group_id') String groupId,
      String title,
      String? description,
      String? trainer,
      @JsonKey(name: 'next_session') DateTime? nextSession,
      int? capacity,
      @JsonKey(name: 'enrolled_count') int enrolledCount,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$TrainingImplCopyWithImpl<$Res>
    extends _$TrainingCopyWithImpl<$Res, _$TrainingImpl>
    implements _$$TrainingImplCopyWith<$Res> {
  __$$TrainingImplCopyWithImpl(
      _$TrainingImpl _value, $Res Function(_$TrainingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? groupId = null,
    Object? title = null,
    Object? description = freezed,
    Object? trainer = freezed,
    Object? nextSession = freezed,
    Object? capacity = freezed,
    Object? enrolledCount = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$TrainingImpl(
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      trainer: freezed == trainer
          ? _value.trainer
          : trainer // ignore: cast_nullable_to_non_nullable
              as String?,
      nextSession: freezed == nextSession
          ? _value.nextSession
          : nextSession // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      capacity: freezed == capacity
          ? _value.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as int?,
      enrolledCount: null == enrolledCount
          ? _value.enrolledCount
          : enrolledCount // ignore: cast_nullable_to_non_nullable
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
class _$TrainingImpl implements _Training {
  const _$TrainingImpl(
      {required this.id,
      @JsonKey(name: 'church_id') required this.churchId,
      @JsonKey(name: 'group_id') required this.groupId,
      required this.title,
      this.description,
      this.trainer,
      @JsonKey(name: 'next_session') this.nextSession,
      this.capacity,
      @JsonKey(name: 'enrolled_count') this.enrolledCount = 0,
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$TrainingImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrainingImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'church_id')
  final String churchId;
  @override
  @JsonKey(name: 'group_id')
  final String groupId;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? trainer;
  @override
  @JsonKey(name: 'next_session')
  final DateTime? nextSession;
  @override
  final int? capacity;
  @override
  @JsonKey(name: 'enrolled_count')
  final int enrolledCount;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Training(id: $id, churchId: $churchId, groupId: $groupId, title: $title, description: $description, trainer: $trainer, nextSession: $nextSession, capacity: $capacity, enrolledCount: $enrolledCount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.trainer, trainer) || other.trainer == trainer) &&
            (identical(other.nextSession, nextSession) ||
                other.nextSession == nextSession) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.enrolledCount, enrolledCount) ||
                other.enrolledCount == enrolledCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, churchId, groupId, title,
      description, trainer, nextSession, capacity, enrolledCount, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainingImplCopyWith<_$TrainingImpl> get copyWith =>
      __$$TrainingImplCopyWithImpl<_$TrainingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrainingImplToJson(
      this,
    );
  }
}

abstract class _Training implements Training {
  const factory _Training(
      {required final String id,
      @JsonKey(name: 'church_id') required final String churchId,
      @JsonKey(name: 'group_id') required final String groupId,
      required final String title,
      final String? description,
      final String? trainer,
      @JsonKey(name: 'next_session') final DateTime? nextSession,
      final int? capacity,
      @JsonKey(name: 'enrolled_count') final int enrolledCount,
      @JsonKey(name: 'created_at') final DateTime? createdAt}) = _$TrainingImpl;

  factory _Training.fromJson(Map<String, dynamic> json) =
      _$TrainingImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'church_id')
  String get churchId;
  @override
  @JsonKey(name: 'group_id')
  String get groupId;
  @override
  String get title;
  @override
  String? get description;
  @override
  String? get trainer;
  @override
  @JsonKey(name: 'next_session')
  DateTime? get nextSession;
  @override
  int? get capacity;
  @override
  @JsonKey(name: 'enrolled_count')
  int get enrolledCount;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$TrainingImplCopyWith<_$TrainingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

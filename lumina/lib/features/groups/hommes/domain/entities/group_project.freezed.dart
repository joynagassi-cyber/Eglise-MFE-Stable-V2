// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_project.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GroupProject _$GroupProjectFromJson(Map<String, dynamic> json) {
  return _GroupProject.fromJson(json);
}

/// @nodoc
mixin _$GroupProject {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'group_id')
  String get groupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'church_id')
  String get churchId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'budget_target')
  int get budgetTarget => throw _privateConstructorUsedError;
  @JsonKey(name: 'budget_spent')
  int get budgetSpent => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date')
  DateTime? get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  DateTime? get endDate => throw _privateConstructorUsedError;
  ProjectStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GroupProjectCopyWith<GroupProject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupProjectCopyWith<$Res> {
  factory $GroupProjectCopyWith(
          GroupProject value, $Res Function(GroupProject) then) =
      _$GroupProjectCopyWithImpl<$Res, GroupProject>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'group_id') String groupId,
      @JsonKey(name: 'church_id') String churchId,
      String title,
      String? description,
      @JsonKey(name: 'budget_target') int budgetTarget,
      @JsonKey(name: 'budget_spent') int budgetSpent,
      @JsonKey(name: 'start_date') DateTime? startDate,
      @JsonKey(name: 'end_date') DateTime? endDate,
      ProjectStatus status,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$GroupProjectCopyWithImpl<$Res, $Val extends GroupProject>
    implements $GroupProjectCopyWith<$Res> {
  _$GroupProjectCopyWithImpl(this._value, this._then);

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
    Object? title = null,
    Object? description = freezed,
    Object? budgetTarget = null,
    Object? budgetSpent = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      budgetTarget: null == budgetTarget
          ? _value.budgetTarget
          : budgetTarget // ignore: cast_nullable_to_non_nullable
              as int,
      budgetSpent: null == budgetSpent
          ? _value.budgetSpent
          : budgetSpent // ignore: cast_nullable_to_non_nullable
              as int,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProjectStatus,
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
abstract class _$$GroupProjectImplCopyWith<$Res>
    implements $GroupProjectCopyWith<$Res> {
  factory _$$GroupProjectImplCopyWith(
          _$GroupProjectImpl value, $Res Function(_$GroupProjectImpl) then) =
      __$$GroupProjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'group_id') String groupId,
      @JsonKey(name: 'church_id') String churchId,
      String title,
      String? description,
      @JsonKey(name: 'budget_target') int budgetTarget,
      @JsonKey(name: 'budget_spent') int budgetSpent,
      @JsonKey(name: 'start_date') DateTime? startDate,
      @JsonKey(name: 'end_date') DateTime? endDate,
      ProjectStatus status,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$GroupProjectImplCopyWithImpl<$Res>
    extends _$GroupProjectCopyWithImpl<$Res, _$GroupProjectImpl>
    implements _$$GroupProjectImplCopyWith<$Res> {
  __$$GroupProjectImplCopyWithImpl(
      _$GroupProjectImpl _value, $Res Function(_$GroupProjectImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupId = null,
    Object? churchId = null,
    Object? title = null,
    Object? description = freezed,
    Object? budgetTarget = null,
    Object? budgetSpent = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$GroupProjectImpl(
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      budgetTarget: null == budgetTarget
          ? _value.budgetTarget
          : budgetTarget // ignore: cast_nullable_to_non_nullable
              as int,
      budgetSpent: null == budgetSpent
          ? _value.budgetSpent
          : budgetSpent // ignore: cast_nullable_to_non_nullable
              as int,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ProjectStatus,
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
class _$GroupProjectImpl extends _GroupProject {
  const _$GroupProjectImpl(
      {required this.id,
      @JsonKey(name: 'group_id') required this.groupId,
      @JsonKey(name: 'church_id') required this.churchId,
      required this.title,
      this.description,
      @JsonKey(name: 'budget_target') this.budgetTarget = 0,
      @JsonKey(name: 'budget_spent') this.budgetSpent = 0,
      @JsonKey(name: 'start_date') this.startDate,
      @JsonKey(name: 'end_date') this.endDate,
      this.status = ProjectStatus.planned,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : super._();

  factory _$GroupProjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupProjectImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'group_id')
  final String groupId;
  @override
  @JsonKey(name: 'church_id')
  final String churchId;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'budget_target')
  final int budgetTarget;
  @override
  @JsonKey(name: 'budget_spent')
  final int budgetSpent;
  @override
  @JsonKey(name: 'start_date')
  final DateTime? startDate;
  @override
  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  @override
  @JsonKey()
  final ProjectStatus status;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'GroupProject(id: $id, groupId: $groupId, churchId: $churchId, title: $title, description: $description, budgetTarget: $budgetTarget, budgetSpent: $budgetSpent, startDate: $startDate, endDate: $endDate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupProjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.budgetTarget, budgetTarget) ||
                other.budgetTarget == budgetTarget) &&
            (identical(other.budgetSpent, budgetSpent) ||
                other.budgetSpent == budgetSpent) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.status, status) || other.status == status) &&
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
      groupId,
      churchId,
      title,
      description,
      budgetTarget,
      budgetSpent,
      startDate,
      endDate,
      status,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupProjectImplCopyWith<_$GroupProjectImpl> get copyWith =>
      __$$GroupProjectImplCopyWithImpl<_$GroupProjectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupProjectImplToJson(
      this,
    );
  }
}

abstract class _GroupProject extends GroupProject {
  const factory _GroupProject(
          {required final String id,
          @JsonKey(name: 'group_id') required final String groupId,
          @JsonKey(name: 'church_id') required final String churchId,
          required final String title,
          final String? description,
          @JsonKey(name: 'budget_target') final int budgetTarget,
          @JsonKey(name: 'budget_spent') final int budgetSpent,
          @JsonKey(name: 'start_date') final DateTime? startDate,
          @JsonKey(name: 'end_date') final DateTime? endDate,
          final ProjectStatus status,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$GroupProjectImpl;
  const _GroupProject._() : super._();

  factory _GroupProject.fromJson(Map<String, dynamic> json) =
      _$GroupProjectImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'group_id')
  String get groupId;
  @override
  @JsonKey(name: 'church_id')
  String get churchId;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'budget_target')
  int get budgetTarget;
  @override
  @JsonKey(name: 'budget_spent')
  int get budgetSpent;
  @override
  @JsonKey(name: 'start_date')
  DateTime? get startDate;
  @override
  @JsonKey(name: 'end_date')
  DateTime? get endDate;
  @override
  ProjectStatus get status;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$GroupProjectImplCopyWith<_$GroupProjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

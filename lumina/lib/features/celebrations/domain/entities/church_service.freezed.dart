// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'church_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChurchService _$ChurchServiceFromJson(Map<String, dynamic> json) {
  return _ChurchService.fromJson(json);
}

/// @nodoc
mixin _$ChurchService {
  String get id => throw _privateConstructorUsedError;
  String get churchId => throw _privateConstructorUsedError;
  ServiceType get type => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get theme => throw _privateConstructorUsedError;
  String? get preacherId => throw _privateConstructorUsedError; // Name or ID
  String? get preacherName => throw _privateConstructorUsedError;
  int get attendanceCount => throw _privateConstructorUsedError;
  int get menCount => throw _privateConstructorUsedError;
  int get womenCount => throw _privateConstructorUsedError;
  int get childrenCount => throw _privateConstructorUsedError;
  int get menVisitorsCount => throw _privateConstructorUsedError; // New
  int get womenVisitorsCount => throw _privateConstructorUsedError; // New
  int get childrenVisitorsCount => throw _privateConstructorUsedError; // New
  List<String> get notes => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChurchServiceCopyWith<ChurchService> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChurchServiceCopyWith<$Res> {
  factory $ChurchServiceCopyWith(
          ChurchService value, $Res Function(ChurchService) then) =
      _$ChurchServiceCopyWithImpl<$Res, ChurchService>;
  @useResult
  $Res call(
      {String id,
      String churchId,
      ServiceType type,
      DateTime date,
      String? title,
      String? theme,
      String? preacherId,
      String? preacherName,
      int attendanceCount,
      int menCount,
      int womenCount,
      int childrenCount,
      int menVisitorsCount,
      int womenVisitorsCount,
      int childrenVisitorsCount,
      List<String> notes,
      bool isCompleted,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ChurchServiceCopyWithImpl<$Res, $Val extends ChurchService>
    implements $ChurchServiceCopyWith<$Res> {
  _$ChurchServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? type = null,
    Object? date = null,
    Object? title = freezed,
    Object? theme = freezed,
    Object? preacherId = freezed,
    Object? preacherName = freezed,
    Object? attendanceCount = null,
    Object? menCount = null,
    Object? womenCount = null,
    Object? childrenCount = null,
    Object? menVisitorsCount = null,
    Object? womenVisitorsCount = null,
    Object? childrenVisitorsCount = null,
    Object? notes = null,
    Object? isCompleted = null,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ServiceType,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      theme: freezed == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String?,
      preacherId: freezed == preacherId
          ? _value.preacherId
          : preacherId // ignore: cast_nullable_to_non_nullable
              as String?,
      preacherName: freezed == preacherName
          ? _value.preacherName
          : preacherName // ignore: cast_nullable_to_non_nullable
              as String?,
      attendanceCount: null == attendanceCount
          ? _value.attendanceCount
          : attendanceCount // ignore: cast_nullable_to_non_nullable
              as int,
      menCount: null == menCount
          ? _value.menCount
          : menCount // ignore: cast_nullable_to_non_nullable
              as int,
      womenCount: null == womenCount
          ? _value.womenCount
          : womenCount // ignore: cast_nullable_to_non_nullable
              as int,
      childrenCount: null == childrenCount
          ? _value.childrenCount
          : childrenCount // ignore: cast_nullable_to_non_nullable
              as int,
      menVisitorsCount: null == menVisitorsCount
          ? _value.menVisitorsCount
          : menVisitorsCount // ignore: cast_nullable_to_non_nullable
              as int,
      womenVisitorsCount: null == womenVisitorsCount
          ? _value.womenVisitorsCount
          : womenVisitorsCount // ignore: cast_nullable_to_non_nullable
              as int,
      childrenVisitorsCount: null == childrenVisitorsCount
          ? _value.childrenVisitorsCount
          : childrenVisitorsCount // ignore: cast_nullable_to_non_nullable
              as int,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ChurchServiceImplCopyWith<$Res>
    implements $ChurchServiceCopyWith<$Res> {
  factory _$$ChurchServiceImplCopyWith(
          _$ChurchServiceImpl value, $Res Function(_$ChurchServiceImpl) then) =
      __$$ChurchServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String churchId,
      ServiceType type,
      DateTime date,
      String? title,
      String? theme,
      String? preacherId,
      String? preacherName,
      int attendanceCount,
      int menCount,
      int womenCount,
      int childrenCount,
      int menVisitorsCount,
      int womenVisitorsCount,
      int childrenVisitorsCount,
      List<String> notes,
      bool isCompleted,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ChurchServiceImplCopyWithImpl<$Res>
    extends _$ChurchServiceCopyWithImpl<$Res, _$ChurchServiceImpl>
    implements _$$ChurchServiceImplCopyWith<$Res> {
  __$$ChurchServiceImplCopyWithImpl(
      _$ChurchServiceImpl _value, $Res Function(_$ChurchServiceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? type = null,
    Object? date = null,
    Object? title = freezed,
    Object? theme = freezed,
    Object? preacherId = freezed,
    Object? preacherName = freezed,
    Object? attendanceCount = null,
    Object? menCount = null,
    Object? womenCount = null,
    Object? childrenCount = null,
    Object? menVisitorsCount = null,
    Object? womenVisitorsCount = null,
    Object? childrenVisitorsCount = null,
    Object? notes = null,
    Object? isCompleted = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ChurchServiceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ServiceType,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      theme: freezed == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String?,
      preacherId: freezed == preacherId
          ? _value.preacherId
          : preacherId // ignore: cast_nullable_to_non_nullable
              as String?,
      preacherName: freezed == preacherName
          ? _value.preacherName
          : preacherName // ignore: cast_nullable_to_non_nullable
              as String?,
      attendanceCount: null == attendanceCount
          ? _value.attendanceCount
          : attendanceCount // ignore: cast_nullable_to_non_nullable
              as int,
      menCount: null == menCount
          ? _value.menCount
          : menCount // ignore: cast_nullable_to_non_nullable
              as int,
      womenCount: null == womenCount
          ? _value.womenCount
          : womenCount // ignore: cast_nullable_to_non_nullable
              as int,
      childrenCount: null == childrenCount
          ? _value.childrenCount
          : childrenCount // ignore: cast_nullable_to_non_nullable
              as int,
      menVisitorsCount: null == menVisitorsCount
          ? _value.menVisitorsCount
          : menVisitorsCount // ignore: cast_nullable_to_non_nullable
              as int,
      womenVisitorsCount: null == womenVisitorsCount
          ? _value.womenVisitorsCount
          : womenVisitorsCount // ignore: cast_nullable_to_non_nullable
              as int,
      childrenVisitorsCount: null == childrenVisitorsCount
          ? _value.childrenVisitorsCount
          : childrenVisitorsCount // ignore: cast_nullable_to_non_nullable
              as int,
      notes: null == notes
          ? _value._notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
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
class _$ChurchServiceImpl implements _ChurchService {
  const _$ChurchServiceImpl(
      {required this.id,
      required this.churchId,
      required this.type,
      required this.date,
      this.title,
      this.theme,
      this.preacherId,
      this.preacherName,
      this.attendanceCount = 0,
      this.menCount = 0,
      this.womenCount = 0,
      this.childrenCount = 0,
      this.menVisitorsCount = 0,
      this.womenVisitorsCount = 0,
      this.childrenVisitorsCount = 0,
      final List<String> notes = const [],
      this.isCompleted = false,
      this.createdAt,
      this.updatedAt})
      : _notes = notes;

  factory _$ChurchServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChurchServiceImplFromJson(json);

  @override
  final String id;
  @override
  final String churchId;
  @override
  final ServiceType type;
  @override
  final DateTime date;
  @override
  final String? title;
  @override
  final String? theme;
  @override
  final String? preacherId;
// Name or ID
  @override
  final String? preacherName;
  @override
  @JsonKey()
  final int attendanceCount;
  @override
  @JsonKey()
  final int menCount;
  @override
  @JsonKey()
  final int womenCount;
  @override
  @JsonKey()
  final int childrenCount;
  @override
  @JsonKey()
  final int menVisitorsCount;
// New
  @override
  @JsonKey()
  final int womenVisitorsCount;
// New
  @override
  @JsonKey()
  final int childrenVisitorsCount;
// New
  final List<String> _notes;
// New
  @override
  @JsonKey()
  List<String> get notes {
    if (_notes is EqualUnmodifiableListView) return _notes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notes);
  }

  @override
  @JsonKey()
  final bool isCompleted;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ChurchService(id: $id, churchId: $churchId, type: $type, date: $date, title: $title, theme: $theme, preacherId: $preacherId, preacherName: $preacherName, attendanceCount: $attendanceCount, menCount: $menCount, womenCount: $womenCount, childrenCount: $childrenCount, menVisitorsCount: $menVisitorsCount, womenVisitorsCount: $womenVisitorsCount, childrenVisitorsCount: $childrenVisitorsCount, notes: $notes, isCompleted: $isCompleted, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChurchServiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.preacherId, preacherId) ||
                other.preacherId == preacherId) &&
            (identical(other.preacherName, preacherName) ||
                other.preacherName == preacherName) &&
            (identical(other.attendanceCount, attendanceCount) ||
                other.attendanceCount == attendanceCount) &&
            (identical(other.menCount, menCount) ||
                other.menCount == menCount) &&
            (identical(other.womenCount, womenCount) ||
                other.womenCount == womenCount) &&
            (identical(other.childrenCount, childrenCount) ||
                other.childrenCount == childrenCount) &&
            (identical(other.menVisitorsCount, menVisitorsCount) ||
                other.menVisitorsCount == menVisitorsCount) &&
            (identical(other.womenVisitorsCount, womenVisitorsCount) ||
                other.womenVisitorsCount == womenVisitorsCount) &&
            (identical(other.childrenVisitorsCount, childrenVisitorsCount) ||
                other.childrenVisitorsCount == childrenVisitorsCount) &&
            const DeepCollectionEquality().equals(other._notes, _notes) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
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
        type,
        date,
        title,
        theme,
        preacherId,
        preacherName,
        attendanceCount,
        menCount,
        womenCount,
        childrenCount,
        menVisitorsCount,
        womenVisitorsCount,
        childrenVisitorsCount,
        const DeepCollectionEquality().hash(_notes),
        isCompleted,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChurchServiceImplCopyWith<_$ChurchServiceImpl> get copyWith =>
      __$$ChurchServiceImplCopyWithImpl<_$ChurchServiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChurchServiceImplToJson(
      this,
    );
  }
}

abstract class _ChurchService implements ChurchService {
  const factory _ChurchService(
      {required final String id,
      required final String churchId,
      required final ServiceType type,
      required final DateTime date,
      final String? title,
      final String? theme,
      final String? preacherId,
      final String? preacherName,
      final int attendanceCount,
      final int menCount,
      final int womenCount,
      final int childrenCount,
      final int menVisitorsCount,
      final int womenVisitorsCount,
      final int childrenVisitorsCount,
      final List<String> notes,
      final bool isCompleted,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ChurchServiceImpl;

  factory _ChurchService.fromJson(Map<String, dynamic> json) =
      _$ChurchServiceImpl.fromJson;

  @override
  String get id;
  @override
  String get churchId;
  @override
  ServiceType get type;
  @override
  DateTime get date;
  @override
  String? get title;
  @override
  String? get theme;
  @override
  String? get preacherId;
  @override // Name or ID
  String? get preacherName;
  @override
  int get attendanceCount;
  @override
  int get menCount;
  @override
  int get womenCount;
  @override
  int get childrenCount;
  @override
  int get menVisitorsCount;
  @override // New
  int get womenVisitorsCount;
  @override // New
  int get childrenVisitorsCount;
  @override // New
  List<String> get notes;
  @override
  bool get isCompleted;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ChurchServiceImplCopyWith<_$ChurchServiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

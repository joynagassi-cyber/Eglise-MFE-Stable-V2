// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pedagogic_resource.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PedagogicResource _$PedagogicResourceFromJson(Map<String, dynamic> json) {
  return _PedagogicResource.fromJson(json);
}

/// @nodoc
mixin _$PedagogicResource {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'church_id')
  String get churchId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get category =>
      throw _privateConstructorUsedError; // 'lesson', 'game', 'media'
  String? get fileUrl => throw _privateConstructorUsedError;
  String? get ageRange => throw _privateConstructorUsedError;
  String? get contentSummary => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PedagogicResourceCopyWith<PedagogicResource> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PedagogicResourceCopyWith<$Res> {
  factory $PedagogicResourceCopyWith(
          PedagogicResource value, $Res Function(PedagogicResource) then) =
      _$PedagogicResourceCopyWithImpl<$Res, PedagogicResource>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'church_id') String churchId,
      String title,
      String category,
      String? fileUrl,
      String? ageRange,
      String? contentSummary,
      DateTime createdAt});
}

/// @nodoc
class _$PedagogicResourceCopyWithImpl<$Res, $Val extends PedagogicResource>
    implements $PedagogicResourceCopyWith<$Res> {
  _$PedagogicResourceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? title = null,
    Object? category = null,
    Object? fileUrl = freezed,
    Object? ageRange = freezed,
    Object? contentSummary = freezed,
    Object? createdAt = null,
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      ageRange: freezed == ageRange
          ? _value.ageRange
          : ageRange // ignore: cast_nullable_to_non_nullable
              as String?,
      contentSummary: freezed == contentSummary
          ? _value.contentSummary
          : contentSummary // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PedagogicResourceImplCopyWith<$Res>
    implements $PedagogicResourceCopyWith<$Res> {
  factory _$$PedagogicResourceImplCopyWith(_$PedagogicResourceImpl value,
          $Res Function(_$PedagogicResourceImpl) then) =
      __$$PedagogicResourceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'church_id') String churchId,
      String title,
      String category,
      String? fileUrl,
      String? ageRange,
      String? contentSummary,
      DateTime createdAt});
}

/// @nodoc
class __$$PedagogicResourceImplCopyWithImpl<$Res>
    extends _$PedagogicResourceCopyWithImpl<$Res, _$PedagogicResourceImpl>
    implements _$$PedagogicResourceImplCopyWith<$Res> {
  __$$PedagogicResourceImplCopyWithImpl(_$PedagogicResourceImpl _value,
      $Res Function(_$PedagogicResourceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? title = null,
    Object? category = null,
    Object? fileUrl = freezed,
    Object? ageRange = freezed,
    Object? contentSummary = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$PedagogicResourceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      fileUrl: freezed == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      ageRange: freezed == ageRange
          ? _value.ageRange
          : ageRange // ignore: cast_nullable_to_non_nullable
              as String?,
      contentSummary: freezed == contentSummary
          ? _value.contentSummary
          : contentSummary // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PedagogicResourceImpl implements _PedagogicResource {
  const _$PedagogicResourceImpl(
      {required this.id,
      @JsonKey(name: 'church_id') required this.churchId,
      required this.title,
      required this.category,
      this.fileUrl,
      this.ageRange,
      this.contentSummary,
      required this.createdAt});

  factory _$PedagogicResourceImpl.fromJson(Map<String, dynamic> json) =>
      _$$PedagogicResourceImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'church_id')
  final String churchId;
  @override
  final String title;
  @override
  final String category;
// 'lesson', 'game', 'media'
  @override
  final String? fileUrl;
  @override
  final String? ageRange;
  @override
  final String? contentSummary;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'PedagogicResource(id: $id, churchId: $churchId, title: $title, category: $category, fileUrl: $fileUrl, ageRange: $ageRange, contentSummary: $contentSummary, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PedagogicResourceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.ageRange, ageRange) ||
                other.ageRange == ageRange) &&
            (identical(other.contentSummary, contentSummary) ||
                other.contentSummary == contentSummary) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, churchId, title, category,
      fileUrl, ageRange, contentSummary, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PedagogicResourceImplCopyWith<_$PedagogicResourceImpl> get copyWith =>
      __$$PedagogicResourceImplCopyWithImpl<_$PedagogicResourceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PedagogicResourceImplToJson(
      this,
    );
  }
}

abstract class _PedagogicResource implements PedagogicResource {
  const factory _PedagogicResource(
      {required final String id,
      @JsonKey(name: 'church_id') required final String churchId,
      required final String title,
      required final String category,
      final String? fileUrl,
      final String? ageRange,
      final String? contentSummary,
      required final DateTime createdAt}) = _$PedagogicResourceImpl;

  factory _PedagogicResource.fromJson(Map<String, dynamic> json) =
      _$PedagogicResourceImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'church_id')
  String get churchId;
  @override
  String get title;
  @override
  String get category;
  @override // 'lesson', 'game', 'media'
  String? get fileUrl;
  @override
  String? get ageRange;
  @override
  String? get contentSummary;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$PedagogicResourceImplCopyWith<_$PedagogicResourceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

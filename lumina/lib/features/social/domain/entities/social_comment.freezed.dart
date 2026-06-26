// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SocialComment _$SocialCommentFromJson(Map<String, dynamic> json) {
  return _SocialComment.fromJson(json);
}

/// @nodoc
mixin _$SocialComment {
  String get id => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;
  String? get authorAvatarUrl => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SocialCommentCopyWith<SocialComment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialCommentCopyWith<$Res> {
  factory $SocialCommentCopyWith(
          SocialComment value, $Res Function(SocialComment) then) =
      _$SocialCommentCopyWithImpl<$Res, SocialComment>;
  @useResult
  $Res call(
      {String id,
      String postId,
      String authorId,
      String authorName,
      String? authorAvatarUrl,
      String content,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$SocialCommentCopyWithImpl<$Res, $Val extends SocialComment>
    implements $SocialCommentCopyWith<$Res> {
  _$SocialCommentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? authorAvatarUrl = freezed,
    Object? content = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorAvatarUrl: freezed == authorAvatarUrl
          ? _value.authorAvatarUrl
          : authorAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SocialCommentImplCopyWith<$Res>
    implements $SocialCommentCopyWith<$Res> {
  factory _$$SocialCommentImplCopyWith(
          _$SocialCommentImpl value, $Res Function(_$SocialCommentImpl) then) =
      __$$SocialCommentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String postId,
      String authorId,
      String authorName,
      String? authorAvatarUrl,
      String content,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$SocialCommentImplCopyWithImpl<$Res>
    extends _$SocialCommentCopyWithImpl<$Res, _$SocialCommentImpl>
    implements _$$SocialCommentImplCopyWith<$Res> {
  __$$SocialCommentImplCopyWithImpl(
      _$SocialCommentImpl _value, $Res Function(_$SocialCommentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? authorAvatarUrl = freezed,
    Object? content = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$SocialCommentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorAvatarUrl: freezed == authorAvatarUrl
          ? _value.authorAvatarUrl
          : authorAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialCommentImpl implements _SocialComment {
  const _$SocialCommentImpl(
      {required this.id,
      required this.postId,
      required this.authorId,
      required this.authorName,
      this.authorAvatarUrl,
      required this.content,
      required this.createdAt,
      this.updatedAt});

  factory _$SocialCommentImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialCommentImplFromJson(json);

  @override
  final String id;
  @override
  final String postId;
  @override
  final String authorId;
  @override
  final String authorName;
  @override
  final String? authorAvatarUrl;
  @override
  final String content;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'SocialComment(id: $id, postId: $postId, authorId: $authorId, authorName: $authorName, authorAvatarUrl: $authorAvatarUrl, content: $content, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialCommentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorAvatarUrl, authorAvatarUrl) ||
                other.authorAvatarUrl == authorAvatarUrl) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, postId, authorId, authorName,
      authorAvatarUrl, content, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialCommentImplCopyWith<_$SocialCommentImpl> get copyWith =>
      __$$SocialCommentImplCopyWithImpl<_$SocialCommentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialCommentImplToJson(
      this,
    );
  }
}

abstract class _SocialComment implements SocialComment {
  const factory _SocialComment(
      {required final String id,
      required final String postId,
      required final String authorId,
      required final String authorName,
      final String? authorAvatarUrl,
      required final String content,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$SocialCommentImpl;

  factory _SocialComment.fromJson(Map<String, dynamic> json) =
      _$SocialCommentImpl.fromJson;

  @override
  String get id;
  @override
  String get postId;
  @override
  String get authorId;
  @override
  String get authorName;
  @override
  String? get authorAvatarUrl;
  @override
  String get content;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$SocialCommentImplCopyWith<_$SocialCommentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

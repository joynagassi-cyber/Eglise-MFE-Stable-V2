// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SocialPost _$SocialPostFromJson(Map<String, dynamic> json) {
  return _SocialPost.fromJson(json);
}

/// @nodoc
mixin _$SocialPost {
  String get id => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;
  String? get authorAvatarUrl => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<String> get imageUrls => throw _privateConstructorUsedError;
  int get likesCount => throw _privateConstructorUsedError;
  int get commentsCount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // AI Social Features
  bool get isAiGenerated => throw _privateConstructorUsedError;
  String? get aiBibleVerse =>
      throw _privateConstructorUsedError; // "Psaume 23:4"
  String? get aiBibleText =>
      throw _privateConstructorUsedError; // Texte du verset
  String get status =>
      throw _privateConstructorUsedError; // published, flagged, deleted
  int? get moderationScore => throw _privateConstructorUsedError; // 0-100
  String? get moderationReason => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SocialPostCopyWith<SocialPost> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialPostCopyWith<$Res> {
  factory $SocialPostCopyWith(
          SocialPost value, $Res Function(SocialPost) then) =
      _$SocialPostCopyWithImpl<$Res, SocialPost>;
  @useResult
  $Res call(
      {String id,
      String authorId,
      String authorName,
      String? authorAvatarUrl,
      String content,
      List<String> imageUrls,
      int likesCount,
      int commentsCount,
      DateTime createdAt,
      DateTime? updatedAt,
      bool isAiGenerated,
      String? aiBibleVerse,
      String? aiBibleText,
      String status,
      int? moderationScore,
      String? moderationReason});
}

/// @nodoc
class _$SocialPostCopyWithImpl<$Res, $Val extends SocialPost>
    implements $SocialPostCopyWith<$Res> {
  _$SocialPostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? authorAvatarUrl = freezed,
    Object? content = null,
    Object? imageUrls = null,
    Object? likesCount = null,
    Object? commentsCount = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? isAiGenerated = null,
    Object? aiBibleVerse = freezed,
    Object? aiBibleText = freezed,
    Object? status = null,
    Object? moderationScore = freezed,
    Object? moderationReason = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentsCount: null == commentsCount
          ? _value.commentsCount
          : commentsCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isAiGenerated: null == isAiGenerated
          ? _value.isAiGenerated
          : isAiGenerated // ignore: cast_nullable_to_non_nullable
              as bool,
      aiBibleVerse: freezed == aiBibleVerse
          ? _value.aiBibleVerse
          : aiBibleVerse // ignore: cast_nullable_to_non_nullable
              as String?,
      aiBibleText: freezed == aiBibleText
          ? _value.aiBibleText
          : aiBibleText // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      moderationScore: freezed == moderationScore
          ? _value.moderationScore
          : moderationScore // ignore: cast_nullable_to_non_nullable
              as int?,
      moderationReason: freezed == moderationReason
          ? _value.moderationReason
          : moderationReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SocialPostImplCopyWith<$Res>
    implements $SocialPostCopyWith<$Res> {
  factory _$$SocialPostImplCopyWith(
          _$SocialPostImpl value, $Res Function(_$SocialPostImpl) then) =
      __$$SocialPostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String authorId,
      String authorName,
      String? authorAvatarUrl,
      String content,
      List<String> imageUrls,
      int likesCount,
      int commentsCount,
      DateTime createdAt,
      DateTime? updatedAt,
      bool isAiGenerated,
      String? aiBibleVerse,
      String? aiBibleText,
      String status,
      int? moderationScore,
      String? moderationReason});
}

/// @nodoc
class __$$SocialPostImplCopyWithImpl<$Res>
    extends _$SocialPostCopyWithImpl<$Res, _$SocialPostImpl>
    implements _$$SocialPostImplCopyWith<$Res> {
  __$$SocialPostImplCopyWithImpl(
      _$SocialPostImpl _value, $Res Function(_$SocialPostImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? authorAvatarUrl = freezed,
    Object? content = null,
    Object? imageUrls = null,
    Object? likesCount = null,
    Object? commentsCount = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? isAiGenerated = null,
    Object? aiBibleVerse = freezed,
    Object? aiBibleText = freezed,
    Object? status = null,
    Object? moderationScore = freezed,
    Object? moderationReason = freezed,
  }) {
    return _then(_$SocialPostImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentsCount: null == commentsCount
          ? _value.commentsCount
          : commentsCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isAiGenerated: null == isAiGenerated
          ? _value.isAiGenerated
          : isAiGenerated // ignore: cast_nullable_to_non_nullable
              as bool,
      aiBibleVerse: freezed == aiBibleVerse
          ? _value.aiBibleVerse
          : aiBibleVerse // ignore: cast_nullable_to_non_nullable
              as String?,
      aiBibleText: freezed == aiBibleText
          ? _value.aiBibleText
          : aiBibleText // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      moderationScore: freezed == moderationScore
          ? _value.moderationScore
          : moderationScore // ignore: cast_nullable_to_non_nullable
              as int?,
      moderationReason: freezed == moderationReason
          ? _value.moderationReason
          : moderationReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialPostImpl implements _SocialPost {
  const _$SocialPostImpl(
      {required this.id,
      required this.authorId,
      required this.authorName,
      this.authorAvatarUrl,
      required this.content,
      final List<String> imageUrls = const [],
      this.likesCount = 0,
      this.commentsCount = 0,
      required this.createdAt,
      this.updatedAt,
      this.isAiGenerated = false,
      this.aiBibleVerse,
      this.aiBibleText,
      this.status = 'published',
      this.moderationScore,
      this.moderationReason})
      : _imageUrls = imageUrls;

  factory _$SocialPostImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialPostImplFromJson(json);

  @override
  final String id;
  @override
  final String authorId;
  @override
  final String authorName;
  @override
  final String? authorAvatarUrl;
  @override
  final String content;
  final List<String> _imageUrls;
  @override
  @JsonKey()
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  @JsonKey()
  final int likesCount;
  @override
  @JsonKey()
  final int commentsCount;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
// AI Social Features
  @override
  @JsonKey()
  final bool isAiGenerated;
  @override
  final String? aiBibleVerse;
// "Psaume 23:4"
  @override
  final String? aiBibleText;
// Texte du verset
  @override
  @JsonKey()
  final String status;
// published, flagged, deleted
  @override
  final int? moderationScore;
// 0-100
  @override
  final String? moderationReason;

  @override
  String toString() {
    return 'SocialPost(id: $id, authorId: $authorId, authorName: $authorName, authorAvatarUrl: $authorAvatarUrl, content: $content, imageUrls: $imageUrls, likesCount: $likesCount, commentsCount: $commentsCount, createdAt: $createdAt, updatedAt: $updatedAt, isAiGenerated: $isAiGenerated, aiBibleVerse: $aiBibleVerse, aiBibleText: $aiBibleText, status: $status, moderationScore: $moderationScore, moderationReason: $moderationReason)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialPostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorAvatarUrl, authorAvatarUrl) ||
                other.authorAvatarUrl == authorAvatarUrl) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            (identical(other.likesCount, likesCount) ||
                other.likesCount == likesCount) &&
            (identical(other.commentsCount, commentsCount) ||
                other.commentsCount == commentsCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isAiGenerated, isAiGenerated) ||
                other.isAiGenerated == isAiGenerated) &&
            (identical(other.aiBibleVerse, aiBibleVerse) ||
                other.aiBibleVerse == aiBibleVerse) &&
            (identical(other.aiBibleText, aiBibleText) ||
                other.aiBibleText == aiBibleText) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.moderationScore, moderationScore) ||
                other.moderationScore == moderationScore) &&
            (identical(other.moderationReason, moderationReason) ||
                other.moderationReason == moderationReason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      authorId,
      authorName,
      authorAvatarUrl,
      content,
      const DeepCollectionEquality().hash(_imageUrls),
      likesCount,
      commentsCount,
      createdAt,
      updatedAt,
      isAiGenerated,
      aiBibleVerse,
      aiBibleText,
      status,
      moderationScore,
      moderationReason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialPostImplCopyWith<_$SocialPostImpl> get copyWith =>
      __$$SocialPostImplCopyWithImpl<_$SocialPostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialPostImplToJson(
      this,
    );
  }
}

abstract class _SocialPost implements SocialPost {
  const factory _SocialPost(
      {required final String id,
      required final String authorId,
      required final String authorName,
      final String? authorAvatarUrl,
      required final String content,
      final List<String> imageUrls,
      final int likesCount,
      final int commentsCount,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final bool isAiGenerated,
      final String? aiBibleVerse,
      final String? aiBibleText,
      final String status,
      final int? moderationScore,
      final String? moderationReason}) = _$SocialPostImpl;

  factory _SocialPost.fromJson(Map<String, dynamic> json) =
      _$SocialPostImpl.fromJson;

  @override
  String get id;
  @override
  String get authorId;
  @override
  String get authorName;
  @override
  String? get authorAvatarUrl;
  @override
  String get content;
  @override
  List<String> get imageUrls;
  @override
  int get likesCount;
  @override
  int get commentsCount;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override // AI Social Features
  bool get isAiGenerated;
  @override
  String? get aiBibleVerse;
  @override // "Psaume 23:4"
  String? get aiBibleText;
  @override // Texte du verset
  String get status;
  @override // published, flagged, deleted
  int? get moderationScore;
  @override // 0-100
  String? get moderationReason;
  @override
  @JsonKey(ignore: true)
  _$$SocialPostImplCopyWith<_$SocialPostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

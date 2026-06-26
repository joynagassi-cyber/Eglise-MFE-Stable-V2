import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_post.freezed.dart';
part 'social_post.g.dart';

@freezed
class SocialPost with _$SocialPost {
  const factory SocialPost({
    required String id,
    required String authorId,
    required String authorName,
    String? authorAvatarUrl,
    required String content,
    @Default([]) List<String> imageUrls,
    @Default(0) int likesCount,
    @Default(0) int commentsCount,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _SocialPost;

  factory SocialPost.fromJson(Map<String, dynamic> json) =>
      _$SocialPostFromJson(json);
}
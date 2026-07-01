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

    // AI Social Features
    @Default(false) bool isAiGenerated,
    String? aiBibleVerse,      // "Psaume 23:4"
    String? aiBibleText,       // Texte du verset
    @Default('published') String status, // published, flagged, deleted
    int? moderationScore,      // 0-100
    String? moderationReason,  // Raison du flag
  }) = _SocialPost;

  factory SocialPost.fromJson(Map<String, dynamic> json) =>
      _$SocialPostFromJson(json);
}
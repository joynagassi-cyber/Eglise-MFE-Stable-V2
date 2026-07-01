import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:lumina/core/logging/app_logger.dart';
import '../../domain/entities/social_post.dart';

part 'social_post_model.g.dart';

@collection
class SocialPostModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String remoteId;

  @Index()
  String? churchId;

  late String authorId;
  String? authorName;
  String? authorAvatarUrl;

  late String content;
  List<String> imageUrls = [];

  int likesCount = 0;
  int commentsCount = 0;

  DateTime? createdAt;
  DateTime? updatedAt;

  // AI Social Features
  bool isAiGenerated = false;
  String? aiBibleVerse;
  String? aiBibleText;
  String status = 'published';
  int? moderationScore;
  String? moderationReason;
  DateTime? moderatedAt;

  // Sync fields
  bool isSynced = true;
  bool isDeleted = false;
  DateTime? lastSyncedAt;

  String? jsonData;

  SocialPost toEntity() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return SocialPost.fromJson(jsonDecode(jsonData!));
      } catch (e, stack) {
        AppLogger.e(
            'Error parsing SocialPostModel', 'SOCIAL_POST_MODEL', e, stack);
      }
    }
    return SocialPost(
      id: remoteId,
      authorId: authorId,
      authorName: authorName ?? 'Anonyme',
      authorAvatarUrl: authorAvatarUrl,
      content: content,
      imageUrls: imageUrls,
      likesCount: likesCount,
      commentsCount: commentsCount,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt,
      isAiGenerated: isAiGenerated,
      aiBibleVerse: aiBibleVerse,
      aiBibleText: aiBibleText,
      status: status,
      moderationScore: moderationScore,
      moderationReason: moderationReason,
    );
  }

  static SocialPostModel fromEntity(SocialPost post) {
    final model = SocialPostModel();
    model.isarId = Isar.autoIncrement;
    model.remoteId = post.id;
    model.authorId = post.authorId;
    model.authorName = post.authorName;
    model.authorAvatarUrl = post.authorAvatarUrl;
    model.content = post.content;
    model.imageUrls = post.imageUrls;
    model.likesCount = post.likesCount;
    model.commentsCount = post.commentsCount;
    model.createdAt = post.createdAt;
    model.updatedAt = post.updatedAt;

    // AI Fields
    model.isAiGenerated = post.isAiGenerated;
    model.aiBibleVerse = post.aiBibleVerse;
    model.aiBibleText = post.aiBibleText;
    model.status = post.status;
    model.moderationScore = post.moderationScore;
    model.moderationReason = post.moderationReason;

    model.isSynced = false;
    model.jsonData = jsonEncode(post.toJson());

    return model;
  }
}
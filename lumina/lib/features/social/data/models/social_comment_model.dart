import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:lumina/core/logging/app_logger.dart';
import '../../domain/entities/social_comment.dart';

part 'social_comment_model.g.dart';

@collection
class SocialCommentModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String remoteId; // Supabase ID or temporary ID

  @Index()
  late String postId;

  @Index()
  String? churchId;

  late String authorId;
  String? authorName;
  String? authorAvatarUrl;

  late String content;

  DateTime? createdAt;
  DateTime? updatedAt;

  // Sync fields
  bool isSynced = true;
  bool isDeleted = false;
  DateTime? lastSyncedAt;

  String? jsonData;

  SocialComment toEntity() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return SocialComment.fromJson(json.decode(jsonData!));
      } catch (e, st) {
        AppLogger.e('Erreur parsing jsonData pour SocialComment', 'SocialCommentModel', e, st);
      }
    }
    return SocialComment(
      id: remoteId,
      postId: postId,
      authorId: authorId,
      authorName: authorName ?? 'Anonyme',
      authorAvatarUrl: authorAvatarUrl,
      content: content,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt,
    );
  }

  static SocialCommentModel fromEntity(SocialComment comment) {
    // Note: We don't set Isar ID here if it's new, we let Isar handle it or autoIncrement defaults.
    // If updating, we'd need the logic to find existing, but usually we just overwrite properties.
    final model = SocialCommentModel();
    model.remoteId = comment.id;
    model.postId = comment.postId;
    model.authorId = comment.authorId;
    model.authorName = comment.authorName;
    model.authorAvatarUrl = comment.authorAvatarUrl;
    model.content = comment.content;
    model.createdAt = comment.createdAt;
    model.updatedAt = comment.updatedAt;

    model.isSynced = false;
    model.jsonData = json.encode(comment.toJson());

    return model;
  }
}
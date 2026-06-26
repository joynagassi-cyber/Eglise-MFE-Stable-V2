import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_comment.freezed.dart';
part 'social_comment.g.dart';

@freezed
class SocialComment with _$SocialComment {
  const factory SocialComment({
    required String id,
    required String postId,
    required String authorId,
    required String authorName,
    String? authorAvatarUrl,
    required String content,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _SocialComment;

  factory SocialComment.fromJson(Map<String, dynamic> json) =>
      _$SocialCommentFromJson(json);
}
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SocialCommentImpl _$$SocialCommentImplFromJson(Map<String, dynamic> json) =>
    _$SocialCommentImpl(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      authorId: json['author_id'] as String,
      authorName: json['author_name'] as String,
      authorAvatarUrl: json['author_avatar_url'] as String?,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$SocialCommentImplToJson(_$SocialCommentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'post_id': instance.postId,
      'author_id': instance.authorId,
      'author_name': instance.authorName,
      'author_avatar_url': instance.authorAvatarUrl,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

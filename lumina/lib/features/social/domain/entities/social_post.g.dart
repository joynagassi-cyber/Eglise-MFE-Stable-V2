// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SocialPostImpl _$$SocialPostImplFromJson(Map<String, dynamic> json) =>
    _$SocialPostImpl(
      id: json['id'] as String,
      authorId: json['author_id'] as String,
      authorName: json['author_name'] as String,
      authorAvatarUrl: json['author_avatar_url'] as String?,
      content: json['content'] as String,
      imageUrls: (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
      commentsCount: (json['comments_count'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      isAiGenerated: json['is_ai_generated'] as bool? ?? false,
      aiBibleVerse: json['ai_bible_verse'] as String?,
      aiBibleText: json['ai_bible_text'] as String?,
      status: json['status'] as String? ?? 'published',
      moderationScore: (json['moderation_score'] as num?)?.toInt(),
      moderationReason: json['moderation_reason'] as String?,
    );

Map<String, dynamic> _$$SocialPostImplToJson(_$SocialPostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author_id': instance.authorId,
      'author_name': instance.authorName,
      'author_avatar_url': instance.authorAvatarUrl,
      'content': instance.content,
      'image_urls': instance.imageUrls,
      'likes_count': instance.likesCount,
      'comments_count': instance.commentsCount,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'is_ai_generated': instance.isAiGenerated,
      'ai_bible_verse': instance.aiBibleVerse,
      'ai_bible_text': instance.aiBibleText,
      'status': instance.status,
      'moderation_score': instance.moderationScore,
      'moderation_reason': instance.moderationReason,
    };

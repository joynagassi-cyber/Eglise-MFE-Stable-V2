// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppNotificationEntityImpl _$$AppNotificationEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$AppNotificationEntityImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      linkUrl: json['link_url'] as String?,
      payload: json['payload'] as Map<String, dynamic>? ?? const {},
      isRead: json['is_read'] as bool? ?? false,
      readAt: json['read_at'] == null
          ? null
          : DateTime.parse(json['read_at'] as String),
      priority: json['priority'] as String? ?? 'NORMAL',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$AppNotificationEntityImplToJson(
        _$AppNotificationEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'message': instance.message,
      'type': instance.type,
      'link_url': instance.linkUrl,
      'payload': instance.payload,
      'is_read': instance.isRead,
      'read_at': instance.readAt?.toIso8601String(),
      'priority': instance.priority,
      'created_at': instance.createdAt?.toIso8601String(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_vigil.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrayerVigilImpl _$$PrayerVigilImplFromJson(Map<String, dynamic> json) =>
    _$PrayerVigilImpl(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      groupId: json['group_id'] as String,
      eventId: json['event_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      participantsCount: (json['participants_count'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'scheduled',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PrayerVigilImplToJson(_$PrayerVigilImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'group_id': instance.groupId,
      'event_id': instance.eventId,
      'title': instance.title,
      'description': instance.description,
      'start_time': instance.startTime.toIso8601String(),
      'end_time': instance.endTime.toIso8601String(),
      'participants_count': instance.participantsCount,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

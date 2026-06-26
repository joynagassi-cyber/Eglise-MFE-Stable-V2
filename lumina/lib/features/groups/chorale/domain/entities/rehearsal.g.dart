// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rehearsal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RehearsalImpl _$$RehearsalImplFromJson(Map<String, dynamic> json) =>
    _$RehearsalImpl(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      location: json['location'] as String?,
      description: json['description'] as String?,
      groupId: json['group_id'] as String,
      churchId: json['church_id'] as String,
      eventId: json['event_id'] as String?,
      attendanceCount: (json['attendance_count'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$RehearsalImplToJson(_$RehearsalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'location': instance.location,
      'description': instance.description,
      'group_id': instance.groupId,
      'church_id': instance.churchId,
      'event_id': instance.eventId,
      'attendance_count': instance.attendanceCount,
      'created_at': instance.createdAt?.toIso8601String(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrainingImpl _$$TrainingImplFromJson(Map<String, dynamic> json) =>
    _$TrainingImpl(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      groupId: json['group_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      trainer: json['trainer'] as String?,
      nextSession: json['next_session'] == null
          ? null
          : DateTime.parse(json['next_session'] as String),
      capacity: (json['capacity'] as num?)?.toInt(),
      enrolledCount: (json['enrolled_count'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$TrainingImplToJson(_$TrainingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'group_id': instance.groupId,
      'title': instance.title,
      'description': instance.description,
      'trainer': instance.trainer,
      'next_session': instance.nextSession?.toIso8601String(),
      'capacity': instance.capacity,
      'enrolled_count': instance.enrolledCount,
      'created_at': instance.createdAt?.toIso8601String(),
    };

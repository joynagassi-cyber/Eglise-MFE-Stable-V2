// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permanent_prayer_subject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PermanentPrayerSubjectImpl _$$PermanentPrayerSubjectImplFromJson(
        Map<String, dynamic> json) =>
    _$PermanentPrayerSubjectImpl(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      groupId: json['group_id'] as String,
      category: json['category'] as String,
      subject: json['subject'] as String,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PermanentPrayerSubjectImplToJson(
        _$PermanentPrayerSubjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'group_id': instance.groupId,
      'category': instance.category,
      'subject': instance.subject,
      'description': instance.description,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pedagogic_resource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PedagogicResourceImpl _$$PedagogicResourceImplFromJson(
        Map<String, dynamic> json) =>
    _$PedagogicResourceImpl(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      fileUrl: json['file_url'] as String?,
      ageRange: json['age_range'] as String?,
      contentSummary: json['content_summary'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$PedagogicResourceImplToJson(
        _$PedagogicResourceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'title': instance.title,
      'category': instance.category,
      'file_url': instance.fileUrl,
      'age_range': instance.ageRange,
      'content_summary': instance.contentSummary,
      'created_at': instance.createdAt.toIso8601String(),
    };

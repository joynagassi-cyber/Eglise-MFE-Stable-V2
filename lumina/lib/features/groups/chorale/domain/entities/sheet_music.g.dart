// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sheet_music.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SheetMusicImpl _$$SheetMusicImplFromJson(Map<String, dynamic> json) =>
    _$SheetMusicImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      composer: json['composer'] as String?,
      category: json['category'] as String?,
      fileUrl: json['file_url'] as String,
      groupId: json['group_id'] as String,
      churchId: json['church_id'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      createdBy: json['created_by'] as String?,
    );

Map<String, dynamic> _$$SheetMusicImplToJson(_$SheetMusicImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'composer': instance.composer,
      'category': instance.category,
      'file_url': instance.fileUrl,
      'group_id': instance.groupId,
      'church_id': instance.churchId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'created_by': instance.createdBy,
    };

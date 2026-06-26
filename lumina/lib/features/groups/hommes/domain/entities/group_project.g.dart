// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupProjectImpl _$$GroupProjectImplFromJson(Map<String, dynamic> json) =>
    _$GroupProjectImpl(
      id: json['id'] as String,
      groupId: json['group_id'] as String,
      churchId: json['church_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      budgetTarget: (json['budget_target'] as num?)?.toInt() ?? 0,
      budgetSpent: (json['budget_spent'] as num?)?.toInt() ?? 0,
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      status: $enumDecodeNullable(_$ProjectStatusEnumMap, json['status']) ??
          ProjectStatus.planned,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$GroupProjectImplToJson(_$GroupProjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'group_id': instance.groupId,
      'church_id': instance.churchId,
      'title': instance.title,
      'description': instance.description,
      'budget_target': instance.budgetTarget,
      'budget_spent': instance.budgetSpent,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'status': _$ProjectStatusEnumMap[instance.status]!,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$ProjectStatusEnumMap = {
  ProjectStatus.planned: 'planned',
  ProjectStatus.inProgress: 'in_progress',
  ProjectStatus.completed: 'completed',
};

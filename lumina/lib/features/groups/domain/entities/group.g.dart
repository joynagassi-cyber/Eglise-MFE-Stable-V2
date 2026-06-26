// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupImpl _$$GroupImplFromJson(Map<String, dynamic> json) => _$GroupImpl(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      name: json['label'] as String,
      description: json['description'] as String?,
      type: $enumDecodeNullable(_$GroupTypeEnumMap, json['code'],
              unknownValue: GroupType.autre) ??
          GroupType.autre,
      leaderId: json['leader_id'] as String?,
      location: json['location'] as String?,
      scheduleDescription: json['schedule_description'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$GroupImplToJson(_$GroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'label': instance.name,
      'description': instance.description,
      'code': _$GroupTypeEnumMap[instance.type]!,
      'leader_id': instance.leaderId,
      'location': instance.location,
      'schedule_description': instance.scheduleDescription,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'is_active': instance.isActive,
    };

const _$GroupTypeEnumMap = {
  GroupType.cellule: 'cellule',
  GroupType.ministere: 'ministere',
  GroupType.equipe: 'equipe',
  GroupType.chorale: 'chorale',
  GroupType.hommes: 'hommes',
  GroupType.femmes: 'femmes',
  GroupType.jeunesse: 'jeunesse',
  GroupType.enfants: 'enfants',
  GroupType.intercession: 'intercession',
  GroupType.autre: 'autre',
};

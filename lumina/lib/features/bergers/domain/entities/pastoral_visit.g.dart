// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pastoral_visit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PastoralVisitImpl _$$PastoralVisitImplFromJson(Map<String, dynamic> json) =>
    _$PastoralVisitImpl(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      shepherdId: json['shepherd_id'] as String,
      memberId: json['member_id'] as String,
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String,
      status: json['status'] as String? ?? 'NORMAL',
      nextVisitDate: json['next_visit_date'] == null
          ? null
          : DateTime.parse(json['next_visit_date'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PastoralVisitImplToJson(_$PastoralVisitImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'shepherd_id': instance.shepherdId,
      'member_id': instance.memberId,
      'date': instance.date.toIso8601String(),
      'notes': instance.notes,
      'status': instance.status,
      'next_visit_date': instance.nextVisitDate?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

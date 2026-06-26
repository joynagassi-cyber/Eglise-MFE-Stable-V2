// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventImpl _$$EventImplFromJson(Map<String, dynamic> json) => _$EventImpl(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      type: const EventTypeConverter().fromJson(json['type'] as String),
      title: json['title'] as String,
      description: json['description'] as String?,
      date: DateTime.parse(json['date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      location: json['location'] as String?,
      managerId: json['manager_id'] as String?,
      officiantName: json['officiant_name'] as String?,
      estimatedParticipants: (json['estimated_participants'] as num?)?.toInt(),
      actualParticipants: (json['actual_participants'] as num?)?.toInt(),
      maxSeats: (json['max_seats'] as num?)?.toInt(),
      estimatedBudget: (json['estimated_budget'] as num?)?.toDouble(),
      actualBudget: (json['actual_budget'] as num?)?.toDouble(),
      budgetAccountId: json['budget_account_id'] as String?,
      participantsIds: (json['participants_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      status: json['status'] as String? ?? '',
      color: json['color'] as String? ?? '',
      notes: json['notes'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      createdBy: json['created_by'] as String?,
      updatedBy: json['updated_by'] as String?,
    );

Map<String, dynamic> _$$EventImplToJson(_$EventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'type': const EventTypeConverter().toJson(instance.type),
      'title': instance.title,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'location': instance.location,
      'manager_id': instance.managerId,
      'officiant_name': instance.officiantName,
      'estimated_participants': instance.estimatedParticipants,
      'actual_participants': instance.actualParticipants,
      'max_seats': instance.maxSeats,
      'estimated_budget': instance.estimatedBudget,
      'actual_budget': instance.actualBudget,
      'budget_account_id': instance.budgetAccountId,
      'participants_ids': instance.participantsIds,
      'status': instance.status,
      'color': instance.color,
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
    };

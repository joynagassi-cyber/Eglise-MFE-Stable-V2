// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApprovalRequestImpl _$$ApprovalRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ApprovalRequestImpl(
      id: json['id'] as String,
      entityType: json['entity_type'] as String,
      entityId: json['entity_id'] as String,
      entityLabel: json['entity_label'] as String?,
      entityAmount: (json['entity_amount'] as num?)?.toDouble(),
      status: json['status'] as String,
      currentStepOrder: (json['current_step_order'] as num).toInt(),
      totalSteps: (json['total_steps'] as num).toInt(),
      requestedAt: DateTime.parse(json['requested_at'] as String),
    );

Map<String, dynamic> _$$ApprovalRequestImplToJson(
        _$ApprovalRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entity_type': instance.entityType,
      'entity_id': instance.entityId,
      'entity_label': instance.entityLabel,
      'entity_amount': instance.entityAmount,
      'status': instance.status,
      'current_step_order': instance.currentStepOrder,
      'total_steps': instance.totalSteps,
      'requested_at': instance.requestedAt.toIso8601String(),
    };

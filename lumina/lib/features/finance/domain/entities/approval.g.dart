// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApprovalImpl _$$ApprovalImplFromJson(Map<String, dynamic> json) =>
    _$ApprovalImpl(
      id: json['id'] as String,
      transactionId: json['transaction_id'] as String,
      approverId: json['approver_id'] as String,
      roleUsed: json['role_used'] as String,
      decision: $enumDecode(_$ApprovalDecisionEnumMap, json['decision']),
      approverName: json['approver_name'] as String?,
      comment: json['comment'] as String?,
      decidedAt: DateTime.parse(json['decided_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$ApprovalImplToJson(_$ApprovalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transaction_id': instance.transactionId,
      'approver_id': instance.approverId,
      'role_used': instance.roleUsed,
      'decision': _$ApprovalDecisionEnumMap[instance.decision]!,
      'approver_name': instance.approverName,
      'comment': instance.comment,
      'decided_at': instance.decidedAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$ApprovalDecisionEnumMap = {
  ApprovalDecision.approved: 'approved',
  ApprovalDecision.rejected: 'rejected',
};

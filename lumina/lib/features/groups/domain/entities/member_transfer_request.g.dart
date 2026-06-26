// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_transfer_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemberTransferRequestImpl _$$MemberTransferRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$MemberTransferRequestImpl(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      memberId: json['member_id'] as String,
      fromGroupId: json['from_group_id'] as String,
      toGroupId: json['to_group_id'] as String?,
      requesterId: json['requester_id'] as String,
      reason: json['reason'] as String?,
      status: $enumDecodeNullable(_$TransferStatusEnumMap, json['status'],
              unknownValue: TransferStatus.pending) ??
          TransferStatus.pending,
      notes: json['notes'] as String?,
      approvedBy: json['approved_by'] as String?,
      approvedAt: json['approved_at'] == null
          ? null
          : DateTime.parse(json['approved_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$MemberTransferRequestImplToJson(
        _$MemberTransferRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'member_id': instance.memberId,
      'from_group_id': instance.fromGroupId,
      'to_group_id': instance.toGroupId,
      'requester_id': instance.requesterId,
      'reason': instance.reason,
      'status': _$TransferStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'approved_by': instance.approvedBy,
      'approved_at': instance.approvedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$TransferStatusEnumMap = {
  TransferStatus.pending: 'PENDING',
  TransferStatus.approved: 'APPROVED',
  TransferStatus.rejected: 'REJECTED',
  TransferStatus.cancelled: 'CANCELLED',
};

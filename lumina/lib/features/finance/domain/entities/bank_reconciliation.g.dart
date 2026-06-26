// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_reconciliation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BankReconciliationImpl _$$BankReconciliationImplFromJson(
        Map<String, dynamic> json) =>
    _$BankReconciliationImpl(
      id: json['id'] as String,
      bankAccountId: json['bank_account_id'] as String,
      churchId: json['church_id'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      startBalance: (json['start_balance'] as num).toDouble(),
      endBalance: (json['end_balance'] as num).toDouble(),
      calculatedBalance:
          (json['calculated_balance'] as num?)?.toDouble() ?? 0.0,
      status:
          $enumDecodeNullable(_$ReconciliationStatusEnumMap, json['status']) ??
              ReconciliationStatus.draft,
      matchedCount: (json['matched_count'] as num?)?.toInt() ?? 0,
      unmatchedCount: (json['unmatched_count'] as num?)?.toInt() ?? 0,
      totalImported: (json['total_imported'] as num?)?.toInt() ?? 0,
      csvFileName: json['csv_file_name'] as String?,
      notes: json['notes'] as String?,
      reconciledBy: json['reconciled_by'] as String?,
      reconciledAt: json['reconciled_at'] == null
          ? null
          : DateTime.parse(json['reconciled_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$BankReconciliationImplToJson(
        _$BankReconciliationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bank_account_id': instance.bankAccountId,
      'church_id': instance.churchId,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'start_balance': instance.startBalance,
      'end_balance': instance.endBalance,
      'calculated_balance': instance.calculatedBalance,
      'status': _$ReconciliationStatusEnumMap[instance.status]!,
      'matched_count': instance.matchedCount,
      'unmatched_count': instance.unmatchedCount,
      'total_imported': instance.totalImported,
      'csv_file_name': instance.csvFileName,
      'notes': instance.notes,
      'reconciled_by': instance.reconciledBy,
      'reconciled_at': instance.reconciledAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$ReconciliationStatusEnumMap = {
  ReconciliationStatus.draft: 'draft',
  ReconciliationStatus.inProgress: 'inProgress',
  ReconciliationStatus.completed: 'completed',
  ReconciliationStatus.cancelled: 'cancelled',
};

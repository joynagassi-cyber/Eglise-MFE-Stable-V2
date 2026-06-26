// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecurringTransactionImpl _$$RecurringTransactionImplFromJson(
        Map<String, dynamic> json) =>
    _$RecurringTransactionImpl(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      accountId: json['account_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      categoryId: json['category_id'] as String?,
      categoryName: json['category_name'] as String?,
      description: json['description'] as String,
      frequency: $enumDecode(_$RecurringFrequencyEnumMap, json['frequency']),
      intervalValue: (json['interval_value'] as num?)?.toInt() ?? 1,
      startDate: DateTime.parse(json['start_date'] as String),
      nextOccurrence: DateTime.parse(json['next_occurrence'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      createdBy: json['created_by'] as String?,
    );

Map<String, dynamic> _$$RecurringTransactionImplToJson(
        _$RecurringTransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'account_id': instance.accountId,
      'amount': instance.amount,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'description': instance.description,
      'frequency': _$RecurringFrequencyEnumMap[instance.frequency]!,
      'interval_value': instance.intervalValue,
      'start_date': instance.startDate.toIso8601String(),
      'next_occurrence': instance.nextOccurrence.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'created_by': instance.createdBy,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.income: 'income',
  TransactionType.expense: 'expense',
  TransactionType.transfer: 'transfer',
};

const _$RecurringFrequencyEnumMap = {
  RecurringFrequency.weekly: 'WEEKLY',
  RecurringFrequency.monthly: 'MONTHLY',
  RecurringFrequency.quarterly: 'QUARTERLY',
  RecurringFrequency.yearly: 'YEARLY',
};

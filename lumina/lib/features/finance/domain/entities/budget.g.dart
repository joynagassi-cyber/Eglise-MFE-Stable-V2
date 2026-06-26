// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BudgetImpl _$$BudgetImplFromJson(Map<String, dynamic> json) => _$BudgetImpl(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      categoryId: json['category_id'] as String,
      period: $enumDecode(_$BudgetPeriodEnumMap, json['period']),
      year: (json['year'] as num).toInt(),
      fiscalYear: (json['fiscal_year'] as num?)?.toInt(),
      month: (json['month'] as num?)?.toInt(),
      quarter: (json['quarter'] as num?)?.toInt(),
      plannedAmount: (json['planned_amount'] as num).toDouble(),
      actualAmount: (json['actual_amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'active',
      isApproved: json['is_approved'] as bool? ?? false,
      approvedBy: json['approved_by'] as String?,
      approvedAt: json['approved_at'] == null
          ? null
          : DateTime.parse(json['approved_at'] as String),
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      notes: json['notes'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$BudgetImplToJson(_$BudgetImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'category_id': instance.categoryId,
      'period': _$BudgetPeriodEnumMap[instance.period]!,
      'year': instance.year,
      'fiscal_year': instance.fiscalYear,
      'month': instance.month,
      'quarter': instance.quarter,
      'planned_amount': instance.plannedAmount,
      'actual_amount': instance.actualAmount,
      'status': instance.status,
      'is_approved': instance.isApproved,
      'approved_by': instance.approvedBy,
      'approved_at': instance.approvedAt?.toIso8601String(),
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$BudgetPeriodEnumMap = {
  BudgetPeriod.monthly: 'monthly',
  BudgetPeriod.quarterly: 'quarterly',
  BudgetPeriod.annual: 'annual',
};

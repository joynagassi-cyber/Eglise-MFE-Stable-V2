// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bilan_breakdown_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BilanBreakdownItemImpl _$$BilanBreakdownItemImplFromJson(
        Map<String, dynamic> json) =>
    _$BilanBreakdownItemImpl(
      key: json['key'] as String,
      totalIncome: (json['total_income'] as num?)?.toDouble() ?? 0,
      totalExpense: (json['total_expense'] as num?)?.toDouble() ?? 0,
      transactionCount: (json['transaction_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$BilanBreakdownItemImplToJson(
        _$BilanBreakdownItemImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'total_income': instance.totalIncome,
      'total_expense': instance.totalExpense,
      'transaction_count': instance.transactionCount,
    };

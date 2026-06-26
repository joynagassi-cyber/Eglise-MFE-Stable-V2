// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FinancialAccountImpl _$$FinancialAccountImplFromJson(
        Map<String, dynamic> json) =>
    _$FinancialAccountImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$FinancialAccountTypeEnumMap, json['type']),
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String?,
      bankName: json['bank_name'] as String?,
      accountNumber: json['account_number'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isManual: json['is_manual'] as bool? ?? false,
      isLocked: json['is_locked'] as bool? ?? false,
      description: json['description'] as String?,
      groupId: json['group_id'] as String?,
    );

Map<String, dynamic> _$$FinancialAccountImplToJson(
        _$FinancialAccountImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$FinancialAccountTypeEnumMap[instance.type]!,
      'balance': instance.balance,
      'currency': instance.currency,
      'bank_name': instance.bankName,
      'account_number': instance.accountNumber,
      'is_active': instance.isActive,
      'is_manual': instance.isManual,
      'is_locked': instance.isLocked,
      'description': instance.description,
      'group_id': instance.groupId,
    };

const _$FinancialAccountTypeEnumMap = {
  FinancialAccountType.cash: 'CASH',
  FinancialAccountType.bank: 'BANK',
  FinancialAccountType.mobileMoney: 'MOBILE_MONEY',
};

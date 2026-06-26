// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BankAccountImpl _$$BankAccountImplFromJson(Map<String, dynamic> json) =>
    _$BankAccountImpl(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      name: json['name'] as String,
      accountType:
          $enumDecodeNullable(_$BankAccountTypeEnumMap, json['account_type']) ??
              BankAccountType.bank,
      currency: json['currency'] as String? ?? 'XAF',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      initialBalance: (json['initial_balance'] as num?)?.toDouble() ?? 0.0,
      bankName: json['bank_name'] as String?,
      accountNumber: json['account_number'] as String?,
      iban: json['iban'] as String?,
      swift: json['swift'] as String?,
      description: json['description'] as String?,
      groupId: json['group_id'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$BankAccountImplToJson(_$BankAccountImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'name': instance.name,
      'account_type': _$BankAccountTypeEnumMap[instance.accountType]!,
      'currency': instance.currency,
      'balance': instance.balance,
      'initial_balance': instance.initialBalance,
      'bank_name': instance.bankName,
      'account_number': instance.accountNumber,
      'iban': instance.iban,
      'swift': instance.swift,
      'description': instance.description,
      'group_id': instance.groupId,
      'is_active': instance.isActive,
      'is_default': instance.isDefault,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$BankAccountTypeEnumMap = {
  BankAccountType.cash: 'cash',
  BankAccountType.bank: 'bank',
  BankAccountType.mobileMoney: 'mobileMoney',
  BankAccountType.savings: 'savings',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FinanceTransactionImpl _$$FinanceTransactionImplFromJson(
        Map<String, dynamic> json) =>
    _$FinanceTransactionImpl(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'XAF',
      exchangeRate: (json['exchange_rate'] as num?)?.toDouble() ?? 1.0,
      amountBaseCurrency: (json['amount_base_currency'] as num?)?.toDouble(),
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String,
      category: json['category'] as String?,
      categoryId: json['category_id'] as String?,
      paymentMethod:
          $enumDecode(_$PaymentMethodEnumMap, json['payment_method']),
      accountId: json['account_id'] as String?,
      relatedMemberId: json['related_member_id'] as String?,
      createdByUserId: json['created_by_user_id'] as String?,
      toAccountId: json['to_account_id'] as String?,
      referenceNumber: json['reference_number'] as String?,
      notes: json['notes'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      proofImages: (json['proof_images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      status: $enumDecodeNullable(_$TransactionStatusEnumMap, json['status']) ??
          TransactionStatus.draft,
      groupId: json['group_id'] as String?,
      missionId: json['mission_id'] as String?,
      complianceTags: (json['compliance_tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      complianceChecked: json['compliance_checked'] as bool? ?? false,
      validatedAt: json['validated_at'] == null
          ? null
          : DateTime.parse(json['validated_at'] as String),
      validatedBy: json['validated_by'] as String?,
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
      lastModifiedBy: json['last_modified_by'] as String?,
      lastModifiedAt: json['last_modified_at'] == null
          ? null
          : DateTime.parse(json['last_modified_at'] as String),
      lastModifiedByName: json['last_modified_by_name'] as String?,
      lastModifiedByRole: json['last_modified_by_role'] as String?,
      isReconciled: json['is_reconciled'] as bool? ?? false,
      reconciledAt: json['reconciled_at'] == null
          ? null
          : DateTime.parse(json['reconciled_at'] as String),
      reconciledBy: json['reconciled_by'] as String?,
    );

Map<String, dynamic> _$$FinanceTransactionImplToJson(
        _$FinanceTransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'currency': instance.currency,
      'exchange_rate': instance.exchangeRate,
      'amount_base_currency': instance.amountBaseCurrency,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'date': instance.date.toIso8601String(),
      'description': instance.description,
      'category': instance.category,
      'category_id': instance.categoryId,
      'payment_method': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'account_id': instance.accountId,
      'related_member_id': instance.relatedMemberId,
      'created_by_user_id': instance.createdByUserId,
      'to_account_id': instance.toAccountId,
      'reference_number': instance.referenceNumber,
      'notes': instance.notes,
      'tags': instance.tags,
      'attachments': instance.attachments,
      'proof_images': instance.proofImages,
      'status': _$TransactionStatusEnumMap[instance.status]!,
      'group_id': instance.groupId,
      'mission_id': instance.missionId,
      'compliance_tags': instance.complianceTags,
      'compliance_checked': instance.complianceChecked,
      'validated_at': instance.validatedAt?.toIso8601String(),
      'validated_by': instance.validatedBy,
      'approved_by': instance.approvedBy,
      'approved_at': instance.approvedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'last_modified_by': instance.lastModifiedBy,
      'last_modified_at': instance.lastModifiedAt?.toIso8601String(),
      'last_modified_by_name': instance.lastModifiedByName,
      'last_modified_by_role': instance.lastModifiedByRole,
      'is_reconciled': instance.isReconciled,
      'reconciled_at': instance.reconciledAt?.toIso8601String(),
      'reconciled_by': instance.reconciledBy,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.income: 'income',
  TransactionType.expense: 'expense',
  TransactionType.transfer: 'transfer',
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.mobileMoney: 'mobileMoney',
  PaymentMethod.bankTransfer: 'bankTransfer',
  PaymentMethod.check: 'check',
  PaymentMethod.other: 'other',
};

const _$TransactionStatusEnumMap = {
  TransactionStatus.draft: 'draft',
  TransactionStatus.pending: 'pending',
  TransactionStatus.validated: 'validated',
  TransactionStatus.rejected: 'rejected',
  TransactionStatus.sealed: 'sealed',
  TransactionStatus.archived: 'archived',
};

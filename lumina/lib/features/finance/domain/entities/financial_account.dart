// lib/features/finance/domain/entities/financial_account.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_account.freezed.dart';
part 'financial_account.g.dart';

enum FinancialAccountType {
  @JsonValue('CASH')
  cash,
  @JsonValue('BANK')
  bank,
  @JsonValue('MOBILE_MONEY')
  mobileMoney,
}

@freezed
class FinancialAccount with _$FinancialAccount {
  const factory FinancialAccount({
    required String id,
    required String name,
    required FinancialAccountType type,
    @Default(0.0) double balance,
    String? currency, // 'XOF', 'EUR', 'USD' (Default XOF)
    String? bankName,
    String? accountNumber,
    @Default(true) bool isActive,
    @Default(false) bool isManual,
    @Default(false) bool isLocked,
    String? description,
    String? groupId,
  }) = _FinancialAccount;

  factory FinancialAccount.fromJson(Map<String, dynamic> json) =>
      _$FinancialAccountFromJson(json);
}
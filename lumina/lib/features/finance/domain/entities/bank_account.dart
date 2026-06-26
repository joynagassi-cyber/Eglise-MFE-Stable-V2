// lib/features/finance/domain/entities/bank_account.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_account.freezed.dart';
part 'bank_account.g.dart';

enum BankAccountType {
  cash('Caisse'),
  bank('Compte Bancaire'),
  mobileMoney('Mobile Money'),
  savings('Épargne');

  final String label;
  const BankAccountType(this.label);
}

@freezed
class BankAccount with _$BankAccount {
  const BankAccount._();

  const factory BankAccount({
    required String id,
    required String churchId,
    required String name,
    @Default(BankAccountType.bank) BankAccountType accountType,
    @Default('XAF') String currency,
    @Default(0.0) double balance,
    @Default(0.0) double initialBalance,
    String? bankName,
    String? accountNumber,
    String? iban,
    String? swift,
    String? description,
    String? groupId,
    @Default(true) bool isActive,
    @Default(false) bool isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BankAccount;

  factory BankAccount.fromJson(Map<String, dynamic> json) =>
      _$BankAccountFromJson(json);

  /// Solde formaté avec devise
  String get formattedBalance => '${balance.toStringAsFixed(0)} $currency';

  /// Numéro de compte masqué (ex: ****1234)
  String get maskedAccountNumber {
    if (accountNumber == null || accountNumber!.length < 4) {
      return accountNumber ?? '';
    }
    return '****${accountNumber!.substring(accountNumber!.length - 4)}';
  }
}
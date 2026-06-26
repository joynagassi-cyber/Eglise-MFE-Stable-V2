// lib/features/finance/data/models/financial_account_model.dart
import 'package:isar/isar.dart';
import '../../domain/entities/financial_account.dart';

part 'financial_account_model.g.dart';

@collection
class FinancialAccountModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id; // UUID

  late String name;

  late double balance;

  late String type; // CASH, BANK, MOBILE_MONEY

  String? currency;

  String? bankName;

  String? accountNumber;

  late bool isActive;

  late bool isManual;

  late bool isLocked;

  String? description;

  String? groupId;

  late DateTime updatedAt;

  // Pattern Local-First 2026
  int version = 1;
  bool isDeleted = false;
  String deviceId = 'unknown';

  // Sync status
  bool isSynced = false;
  DateTime? lastSyncedAt;

  /// Mapper vers le domaine
  FinancialAccount toDomain() {
    return FinancialAccount(
      id: id,
      name: name,
      balance: balance,
      type: _stringToType(type),
      currency: currency,
      bankName: bankName,
      accountNumber: accountNumber,
      isActive: isActive,
      isManual: isManual,
      isLocked: isLocked,
      description: description,
      groupId: groupId,
    );
  }

  /// Mapper depuis le domaine
  static FinancialAccountModel fromDomain(FinancialAccount account) {
    return FinancialAccountModel()
      ..id = account.id
      ..name = account.name
      ..balance = account.balance
      ..type = account.type.name.toUpperCase()
      ..currency = account.currency
      ..bankName = account.bankName
      ..accountNumber = account.accountNumber
      ..isActive = account.isActive
      ..isManual = account.isManual
      ..isLocked = account.isLocked
      ..description = account.description
      ..groupId = account.groupId
      ..updatedAt = DateTime.now()
      ..isSynced = true;
  }

  static FinancialAccountType _stringToType(String type) {
    switch (type.toUpperCase()) {
      case 'BANK':
        return FinancialAccountType.bank;
      case 'MOBILE_MONEY':
      case 'MOBILEMONEY':
        return FinancialAccountType.mobileMoney;
      case 'CASH':
      default:
        return FinancialAccountType.cash;
    }
  }
}
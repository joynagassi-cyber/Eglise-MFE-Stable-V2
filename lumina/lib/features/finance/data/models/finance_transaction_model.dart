// lib/features/finance/data/models/finance_transaction_model.dart
import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/finance_transaction.dart';

part 'finance_transaction_model.g.dart';

@collection
class FinanceTransactionModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id; // UUID

  @Index()
  late DateTime date;

  @Index(caseSensitive: false)
  String? description;

  @Index()
  late String type; // 'income', 'expense', 'transfer'

  late double amount;

  @Index()
  late String category;

  @Index()
  late String accountId; // Pour filtrer par compte

  @Index()
  String? churchId;

  // Stockage complet JSON pour les détails (description, preuves, user, etc.)
  String? jsonData;

  bool isSynced = false;
  DateTime? lastSyncedAt;

  DateTime? createdAt;
  DateTime? updatedAt;

  int version = 1;
  String deviceId = 'unknown';
  String createdBy = 'unknown';
  String updatedBy = 'unknown';

  bool isDeleted = false;
  DateTime? deletedAt;
  String? deletedBy;

  /// Mapper vers le domaine
  FinanceTransaction toDomain() {
    return FinanceTransaction.fromJson(
      jsonData != null
          ? Map<String, dynamic>.from(jsonDecode(jsonData!))
          : {
              'id': id,
              'amount': amount,
              'date': date.toIso8601String(),
              'description': description ?? '',
              'type': type,
              'category': category,
              'accountId': accountId,
              'paymentMethod': 'CASH', // Default if missing
            },
    );
  }

  /// Mapper depuis le domaine (complet avec jsonData pour round-trip fiable)
  static FinanceTransactionModel fromDomain(FinanceTransaction transaction) {
    return FinanceTransactionModel()
      ..id = transaction.id
      ..churchId = transaction.groupId // Freezed domain uses groupId instead of churchId
      ..date = transaction.date
      ..amount = transaction.amount
      ..description = transaction.description
      ..type = transaction.type.name
      ..category = transaction.category ?? 'Autre'
      ..accountId = transaction.accountId ?? ''
      ..createdAt = transaction.createdAt ?? DateTime.now()
      ..updatedAt = transaction.updatedAt ?? DateTime.now()
      ..jsonData = jsonEncode(transaction.toJson())
      ..isSynced = true;
  }
}
// lib/features/finance/data/models/recurring_transaction_model.dart
import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/recurring_transaction.dart';

part 'recurring_transaction_model.g.dart';

@collection
class RecurringTransactionModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String accountId;

  late double amount;

  @Index()
  late String nextOccurrence; // ISO String for indexing if needed

  String? jsonData;

  bool isSynced = false;
  DateTime? lastSyncedAt;

  RecurringTransaction toDomain() {
    return RecurringTransaction.fromJson(
      jsonData != null
          ? Map<String, dynamic>.from(jsonDecode(jsonData!))
          : throw Exception(
              'jsonData is missing for RecurringTransactionModel $id'),
    );
  }

  static RecurringTransactionModel fromDomain(RecurringTransaction recurring) {
    return RecurringTransactionModel()
      ..id = recurring.id
      ..accountId = recurring.accountId
      ..amount = recurring.amount
      ..nextOccurrence = recurring.nextOccurrence.toIso8601String()
      ..jsonData = jsonEncode(recurring.toJson())
      ..isSynced = true;
  }
}
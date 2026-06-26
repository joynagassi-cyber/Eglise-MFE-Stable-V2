// lib/features/finance/domain/entities/recurring_transaction.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lumina/features/finance/domain/entities/enums/transaction_type.dart';

part 'recurring_transaction.freezed.dart';
part 'recurring_transaction.g.dart';

enum RecurringFrequency {
  @JsonValue('WEEKLY')
  weekly,
  @JsonValue('MONTHLY')
  monthly,
  @JsonValue('QUARTERLY')
  quarterly,
  @JsonValue('YEARLY')
  yearly,
}

@freezed
class RecurringTransaction with _$RecurringTransaction {
  const factory RecurringTransaction({
    required String id,
    required String churchId,
    required String accountId,
    required double amount,
    required TransactionType type,
    String? categoryId,
    String? categoryName,
    required String description,
    required RecurringFrequency frequency,
    @Default(1) int intervalValue,
    required DateTime startDate,
    required DateTime nextOccurrence,
    DateTime? endDate,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) = _RecurringTransaction;

  factory RecurringTransaction.fromJson(Map<String, dynamic> json) =>
      _$RecurringTransactionFromJson(json);
}
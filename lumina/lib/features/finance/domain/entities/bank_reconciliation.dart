// lib/features/finance/domain/entities/bank_reconciliation.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_reconciliation.freezed.dart';
part 'bank_reconciliation.g.dart';

enum ReconciliationStatus {
  draft('Brouillon'),
  inProgress('En cours'),
  completed('Terminée'),
  cancelled('Annulée');

  final String label;
  const ReconciliationStatus(this.label);
}

@freezed
class BankReconciliation with _$BankReconciliation {
  const BankReconciliation._();

  const factory BankReconciliation({
    required String id,
    required String bankAccountId,
    required String churchId,
    required DateTime startDate,
    required DateTime endDate,
    required double startBalance,
    required double endBalance,
    @Default(0.0) double calculatedBalance,
    @Default(ReconciliationStatus.draft) ReconciliationStatus status,
    @Default(0) int matchedCount,
    @Default(0) int unmatchedCount,
    @Default(0) int totalImported,
    String? csvFileName,
    String? notes,
    String? reconciledBy,
    DateTime? reconciledAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BankReconciliation;

  factory BankReconciliation.fromJson(Map<String, dynamic> json) =>
      _$BankReconciliationFromJson(json);

  /// Écart entre solde calculé et solde réel
  double get discrepancy => (endBalance - calculatedBalance).abs();

  /// Pourcentage de matching
  double get matchRate =>
      totalImported > 0 ? (matchedCount / totalImported) * 100 : 0;

  /// La réconciliation est-elle équilibrée ?
  bool get isBalanced => discrepancy < 0.01;
}
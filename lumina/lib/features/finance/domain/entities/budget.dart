// lib/features/finance/domain/entities/budget.dart
// Entité Budget pour la gestion budgétaire

import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums/budget_period.dart';

part 'budget.freezed.dart';
part 'budget.g.dart';

@freezed
class Budget with _$Budget {
  const Budget._();

  const factory Budget({
    required String id,
    required String churchId,
    required String categoryId, // Lié aux Rubriques
    required BudgetPeriod period,
    required int year,
    int? fiscalYear,
    int? month, // 1-12 pour monthly
    int? quarter, // 1-4 pour quarterly
    required double plannedAmount,
    @Default(0.0) double actualAmount,
    @Default('active') String status,
    @Default(false) bool isApproved,
    String? approvedBy,
    DateTime? approvedAt,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Budget;

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);

  // Factory pour créer un budget
  factory Budget.create({
    required String churchId,
    required String categoryId,
    required BudgetPeriod period,
    required int year,
    int? month,
    int? quarter,
    required double plannedAmount,
    String? notes,
  }) {
    return Budget(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      churchId: churchId,
      categoryId: categoryId,
      period: period,
      year: year,
      month: month,
      quarter: quarter,
      plannedAmount: plannedAmount,
      notes: notes,
      createdAt: DateTime.now(),
    );
  }

  // Computed Properties

  /// Écart entre réalisé et prévu (positif = dépassement, négatif = économie)
  double get variance => actualAmount - plannedAmount;

  /// Taux de réalisation en pourcentage
  double get completionRate =>
      plannedAmount > 0 ? (actualAmount / plannedAmount) * 100 : 0;

  /// Budget dépassé?
  bool get isOverBudget => actualAmount > plannedAmount;

  /// Proche de la limite (>= 80% et pas encore dépassé)
  bool get isNearLimit => completionRate >= 80 && !isOverBudget;

  /// Sous la limite (<80%)
  bool get isUnderLimit => completionRate < 80;

  /// Label de période formaté (ex: "2024-01", "2024-Q1", "2024")
  String get periodLabel {
    switch (period) {
      case BudgetPeriod.monthly:
        return '$year-${month?.toString().padLeft(2, '0') ?? '??'}';
      case BudgetPeriod.quarterly:
        return '$year-Q${quarter ?? '?'}';
      case BudgetPeriod.annual:
        return '$year';
    }
  }

  /// Label de période lisible (ex: "Janvier 2024", "T1 2024", "2024")
  String get periodReadable {
    switch (period) {
      case BudgetPeriod.monthly:
        final monthNames = [
          'Janvier',
          'Février',
          'Mars',
          'Avril',
          'Mai',
          'Juin',
          'Juillet',
          'Août',
          'Septembre',
          'Octobre',
          'Novembre',
          'Décembre',
        ];
        return '${monthNames[(month ?? 1) - 1]} $year';
      case BudgetPeriod.quarterly:
        return 'T${quarter ?? '?'} $year';
      case BudgetPeriod.annual:
        return '$year';
    }
  }

  /// Montant restant disponible
  double get remaining => plannedAmount - actualAmount;

  /// Pourcentage restant
  double get remainingRate =>
      plannedAmount > 0 ? (remaining / plannedAmount) * 100 : 0;
}
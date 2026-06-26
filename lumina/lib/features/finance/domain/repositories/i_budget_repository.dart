// lib/features/finance/domain/repositories/i_budget_repository.dart
// Interface abstraite pour le BudgetRepository

import '../entities/budget.dart';
import '../entities/enums/budget_period.dart';

abstract class IBudgetRepository {
  /// Récupérer tous les budgets
  Future<List<Budget>> getBudgets({
    String? churchId,
    int? year,
    BudgetPeriod? period,
  });

  /// Récupérer un budget par ID
  Future<Budget?> getBudgetById(String id);

  /// Sauvegarder un budget (create/update)
  /// [isAutoUpdate] indique si c'est une mise à jour automatique des montants réels
  Future<Budget> saveBudget(Budget budget, {bool isAutoUpdate = false});

  /// Supprimer un budget
  Future<void> deleteBudget(String id);

  /// Mettre à jour les montants réels (actualAmount) en fonction des transactions
  /// Cette méthode agrège les transactions de la période du budget
  Future<void> updateActualAmounts(String budgetId);

  /// Récupérer les budgets en dépassement
  Future<List<Budget>> getOverBudgets({String? churchId});

  /// Récupérer les budgets proches de la limite (>= 80%)
  Future<List<Budget>> getNearLimitBudgets({String? churchId});

  /// Approuver un budget
  Future<Budget> approveBudget(String budgetId, String approvedBy);
}
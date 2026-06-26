// lib/features/finance/presentation/providers/budget_providers.dart
/// Providers Riverpod pour la gestion des budgets
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/budget.dart';
import '../../domain/entities/enums/budget_period.dart';
import '../../../../core/logging/logging.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/services/pdf_export_service.dart';
import '../../../../core/services/storage_service.dart';
import 'package:lumina/core/providers/repository_providers_finance.dart';

part 'budget_providers.g.dart';

/// Provider pour la liste des budgets
@riverpod
Future<List<Budget>> budgetList(
  BudgetListRef ref, {
  int? year,
  BudgetPeriod? period,
}) async {
  final churchId = ref.watch(activeChurchIdProvider);
  final repository = ref.watch(budgetRepositoryProvider);

  final budgets = await repository.getBudgets(
    churchId: churchId,
    year: year,
    period: period,
  );

  EntityLoggers.budget.logList(
    count: budgets.length,
    metadata: {'year': year, 'period': period?.name},
  );

  return budgets;
}

/// Provider pour les budgets en dépassement
@riverpod
Future<List<Budget>> overBudgets(OverBudgetsRef ref) async {
  final churchId = ref.watch(activeChurchIdProvider);
  final repository = ref.watch(budgetRepositoryProvider);

  final budgets = await repository.getOverBudgets(churchId: churchId);

  logger.logAction(
    FinanceEvents.dashboardViewed,
    metadata: {'view': 'over_budgets', 'count': budgets.length},
  );

  return budgets;
}

/// Provider pour les budgets proches de la limite (>= 80%)
@riverpod
Future<List<Budget>> nearLimitBudgets(NearLimitBudgetsRef ref) async {
  final churchId = ref.watch(activeChurchIdProvider);
  final repository = ref.watch(budgetRepositoryProvider);

  return repository.getNearLimitBudgets(churchId: churchId);
}

@riverpod
class BudgetActions extends _$BudgetActions {
  @override
  FutureOr<void> build() async {}

  /// Sauvegarder un budget
  Future<void> saveBudget(Budget budget) async {
    final isNew = budget.id.isEmpty;
    state = const AsyncLoading();

    try {
      final repository = ref.read(budgetRepositoryProvider);
      await repository.saveBudget(budget);

      // Invalider les listes pour rafraîchir
      ref.invalidate(budgetListProvider);
      ref.invalidate(overBudgetsProvider);
      ref.invalidate(nearLimitBudgetsProvider);

      // Log success
      if (isNew) {
        EntityLoggers.budget.logCreate(
          budget.id,
          metadata: {
            'category': budget.categoryId,
            'period': budget.period.name,
            'planned_amount': budget.plannedAmount,
          },
        );
      } else {
        EntityLoggers.budget.logUpdate(
          budget.id,
          metadata: {
            'category': budget.categoryId,
            'planned_amount': budget.plannedAmount,
          },
        );
      }

      state = const AsyncData(null);
    } catch (e, st) {
      errorReporter.reportError(
        e,
        stackTrace: st,
        context: 'BudgetActions.saveBudget',
      );
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Supprimer un budget
  Future<void> deleteBudget(String id) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(budgetRepositoryProvider);
      await repository.deleteBudget(id);

      ref.invalidate(budgetListProvider);
      ref.invalidate(overBudgetsProvider);
      ref.invalidate(nearLimitBudgetsProvider);

      EntityLoggers.budget.logDelete(id);
      state = const AsyncData(null);
    } catch (e, st) {
      errorReporter.reportError(
        e,
        stackTrace: st,
        context: 'BudgetActions.deleteBudget',
      );
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Mettre à jour les montants réels de tous les budgets
  Future<void> updateAllActuals() async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(budgetRepositoryProvider);
      final budgets = await ref.read(budgetListProvider().future);

      logger.logAction(
        'finance.budget.sync_actuals.started',
        metadata: {'budget_count': budgets.length},
      );

      for (final budget in budgets) {
        await repository.updateActualAmounts(budget.id);
      }

      ref.invalidate(budgetListProvider);
      ref.invalidate(overBudgetsProvider);
      ref.invalidate(nearLimitBudgetsProvider);

      logger.logAction(
        'finance.budget.sync_actuals.completed',
        metadata: {'budget_count': budgets.length},
      );

      state = const AsyncData(null);
    } catch (e, st) {
      errorReporter.reportError(
        e,
        stackTrace: st,
        context: 'BudgetActions.updateAllActuals',
      );
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Approuver un budget
  Future<void> approveBudget(String budgetId, String approvedBy) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(budgetRepositoryProvider);
      await repository.approveBudget(budgetId, approvedBy);

      ref.invalidate(budgetListProvider);

      logger.logAction(
        'finance.budget.approved',
        targetType: 'budget',
        targetId: budgetId,
        metadata: {'approved_by': approvedBy},
      );

      state = const AsyncData(null);
    } catch (e, st) {
      errorReporter.reportError(
        e,
        stackTrace: st,
        context: 'BudgetActions.approveBudget',
      );
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Exporter un rapport budgétaire
  Future<void> exportBudgetReport({
    required int year,
    required BudgetPeriod period,
    required String churchName,
  }) async {
    state = const AsyncLoading();
    try {
      final budgets = await ref.read(
        budgetListProvider(year: year, period: period).future,
      );

      final pdfBytes = await PdfExportService.generateBudgetPdf(
        budgets: budgets,
        churchName: churchName,
        year: year,
        period: period.label,
      );

      final storageService = ref.read(storageServiceProvider);
      final fileName =
          'Budget_${churchName}_${year}_${period.name}_${DateTime.now().millisecondsSinceEpoch}.pdf';

      final activeChurchId = ref.read(activeChurchIdProvider);
      final authStateVal = ref.read(authProvider).valueOrNull;

      final file = await storageService.saveAndProcessReport(
        fileName: fileName,
        bytes: pdfBytes,
        uploadToCloud: true,
        entityType: 'budget_report',
        entityId: 'budget_${DateTime.now().millisecondsSinceEpoch}',
        churchId: activeChurchId,
        token: authStateVal?.accessToken,
      );

      // We open it directly for convenience in Budget Dashboard
      await storageService.openFile(file);

      state = const AsyncData(null);
    } catch (e, st) {
      errorReporter.reportError(
        e,
        stackTrace: st,
        context: 'BudgetActions.exportBudgetReport',
      );
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

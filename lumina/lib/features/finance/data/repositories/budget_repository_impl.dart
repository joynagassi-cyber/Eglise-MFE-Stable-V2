// lib/features/finance/data/repositories/budget_repository_impl.dart
// Implémentation du Budget Repository avec Supabase et Isar (offline-first)

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/budget.dart';
import '../../domain/entities/enums/budget_period.dart';
import '../../domain/repositories/i_budget_repository.dart';
import '../../domain/repositories/i_finance_repository.dart';
import '../models/budget_model.dart';
import 'package:lumina/core/data/local/isar_service.dart';
import '../../domain/entities/finance_transaction.dart';
import 'package:lumina/core/services/offline_sync_manager.dart';
import 'package:lumina/core/utils/supabase_extensions.dart';
import '../../../../core/utils/app_date_time.dart';

class BudgetRepositoryImpl implements IBudgetRepository {
  final SupabaseClient _client;
  final IsarService _isar;
  final IFinanceRepository _financeRepo;
  final Ref _ref;

  BudgetRepositoryImpl(this._client, this._isar, this._financeRepo, this._ref);

  @override
  Future<List<Budget>> getBudgets({
    String? churchId,
    int? year,
    BudgetPeriod? period,
  }) async {
    try {
      // 1. Essayer de charger depuis le cache local si disponible
      if (_isar.isReady) {
        final localModels = await _isar.getAllBudgets();

        if (localModels.isNotEmpty) {
          var budgets =
              localModels.map(_mapModelToDomain).whereType<Budget>().toList();

          // Filtrer par église
          if (churchId != null) {
            budgets = budgets.where((b) => b.churchId == churchId).toList();
          }

          // Filtrer par année
          if (year != null) {
            budgets = budgets.where((b) => b.year == year).toList();
          }

          // Filtrer par période
          if (period != null) {
            budgets = budgets.where((b) => b.period == period).toList();
          }

          return budgets;
        }
      }

      // Build Supabase query with church_id filter
      var query = _client
          .from('budgets').select().scoped(_ref, allowEmpty: true);
      if (year != null) {
        query = query.eq('year', year);
      }

      final records = await query.order('created_at', ascending: false);

      final budgets = records.map(_mapRecordToDomain).toList();

      // 3. Mettre à jour le cache local si disponible
      if (_isar.isReady) {
        await _saveBudgetsToLocal(budgets);
      }

      return budgets;
    } catch (e) {
      // En cas d'erreur réseau, fallback sur local si disponible
      if (_isar.isReady) {
        final localModels = await _isar.getAllBudgets();
        var budgets =
            localModels.map(_mapModelToDomain).whereType<Budget>().toList();

        if (churchId != null) {
          budgets = budgets.where((b) => b.churchId == churchId).toList();
        }
        if (year != null) {
          budgets = budgets.where((b) => b.year == year).toList();
        }
        if (period != null) {
          budgets = budgets.where((b) => b.period == period).toList();
        }

        return budgets;
      }
      return [];
    }
  }

  @override
  Future<Budget?> getBudgetById(String id) async {
    if (_isar.isReady) {
      final localModel = await _isar.getBudgetByBudgetId(id);
      if (localModel != null) {
        return localModel.toDomain();
      }
    }

    try {
      final records = await _client
          .from('budgets').select().scoped(_ref, allowEmpty: true)
          .eq('id', id).maybeSingle();
      if (records == null) return null;
      final budget = _mapRecordToDomain(records);

      if (_isar.isReady) {
        await _saveBudgetToLocal(budget);
      }
      return budget;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Budget> saveBudget(Budget budget, {bool isAutoUpdate = false}) async {
    // 1. Sauvegarde locale optimiste si disponible
    if (_isar.isReady) {
      final model = _mapDomainToModel(budget)..isSynced = false;
      await _isar.saveBudget(model);
    }

    // 2. Préparation du payload et exclusion des données calculées si auto-update local
    try {
      final body = budget.toJson();
      body.remove('id');
      body.remove('createdAt');
      body.remove('updatedAt');

      // PROTECTION LWW : On ne pousse pas actual_amount vers le serveur si c'est un calcul client
      // Le serveur (Trigger SQL) est la source de vérité pour les totaux.
      if (isAutoUpdate) {
        body.remove('actual_amount');
      }

      // Conversion enum
      body['period'] = budget.period.name;

      // 3. Queue pour synchronisation offline ou update direct
      if (_isar.isReady) {
        await _ref.read(offlineSyncManagerProvider).registerAction(
              entityType: 'budgets',
              action: budget.id.isNotEmpty && !budget.id.startsWith('temp_')
                  ? 'UPDATE'
                  : 'INSERT',
              payload: body,
              churchId: budget.churchId,
              recordId: budget.id,
            );
      } else {
        if (budget.id.isNotEmpty && !budget.id.startsWith('temp_')) {
          await _client.from('budgets').update(body).eq('id', budget.id);
        } else {
          await _client.from('budgets').insert(body);
        }
      }

      // Pour l'UX immédiate, on considère que c'est fait
      return budget;
    } catch (e) {
      // Si échec, le mode offline a déjà sauvegardé en Isar
      return budget;
    }
  }

  @override
  Future<void> deleteBudget(String id) async {
    if (_isar.isReady) {
      final model = await _isar.getBudgetByBudgetId(id);
      if (model != null) {
        await _isar.deleteBudget(model.isarId);

        await _ref.read(offlineSyncManagerProvider).registerAction(
              entityType: 'budgets',
              action: 'DELETE',
              payload: {'id': id},
              churchId: model.churchId,
              recordId: id,
            );
      }
    } else {
      try {
        await _client
            .from('budgets').delete().scoped(_ref, allowEmpty: true)
            .eq('id', id);
      } catch (e) {
        // Ignore network errors
      }
    }
  }

  @override
  Future<void> updateActualAmounts(String budgetId) async {
    final budget = await getBudgetById(budgetId);
    if (budget == null) return;

    // Récupérer toutes les transactions de la période du budget
    DateTime startDate;
    DateTime endDate;

    switch (budget.period) {
      case BudgetPeriod.monthly:
        startDate = DateTime(budget.year, budget.month ?? 1, 1);
        endDate = DateTime(budget.year, (budget.month ?? 1) + 1, 0);
        break;
      case BudgetPeriod.quarterly:
        final startMonth = ((budget.quarter ?? 1) - 1) * 3 + 1;
        startDate = DateTime(budget.year, startMonth, 1);
        endDate = DateTime(budget.year, startMonth + 3, 0);
        break;
      case BudgetPeriod.annual:
        startDate = DateTime(budget.year, 1, 1);
        endDate = DateTime(budget.year, 12, 31);
        break;
    }

    // Récupérer les transactions via FinanceRepository (depuis Isar de préférence)
    final transactionsResult = await _financeRepo.getTransactions();
    final allTransactions = transactionsResult.fold(
      (failure) => <FinanceTransaction>[],
      (txs) => txs,
    );

    final transactions = allTransactions
        .where(
          (t) =>
              t.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
              t.date.isBefore(endDate.add(const Duration(days: 1))),
        )
        .toList();

    // Filtrer par catégorie et calculer le total
    final categoryTransactions = transactions.where(
      (t) => t.category == budget.categoryId,
    );

    final totalAmount = categoryTransactions.fold<double>(
      0.0,
      (sum, t) => sum + (t.isIncome ? t.amount : -t.amount),
    );

    // Mettre à jour le budget LOCALEMENT
    final updated = budget.copyWith(
      actualAmount: totalAmount.abs(),
      updatedAt: AppDateTime.nowUtc(),
    );

    // On sauvegarde avec isAutoUpdate = true pour que saveBudget sache qu'il
    // ne doit pas écraser la valeur serveur si on re-synchronise plus tard.
    // En réalité, la sauvegarde se fait en Isar immédiatement pour l'UX.
    await saveBudget(updated, isAutoUpdate: true);
  }

  @override
  Future<List<Budget>> getOverBudgets({String? churchId}) async {
    final budgets = await getBudgets(churchId: churchId);
    return budgets.where((b) => b.isOverBudget).toList();
  }

  @override
  Future<List<Budget>> getNearLimitBudgets({String? churchId}) async {
    final budgets = await getBudgets(churchId: churchId);
    return budgets.where((b) => b.isNearLimit).toList();
  }

  @override
  Future<Budget> approveBudget(String budgetId, String approvedBy) async {
    final budget = await getBudgetById(budgetId);
    if (budget == null) {
      throw Exception('Budget not found');
    }

    final approved = budget.copyWith(
      isApproved: true,
      approvedBy: approvedBy,
      approvedAt: AppDateTime.nowUtc(),
    );

    return saveBudget(approved);
  }

  // --- Mappers ---

  Budget? _mapModelToDomain(BudgetModel model) {
    if (model.jsonData != null) {
      try {
        final json = jsonDecode(model.jsonData!);
        return Budget.fromJson(json);
      } catch (e) {
        // Fallback: construire depuis les champs du modèle
        return Budget(
          id: model.id,
          churchId: model.churchId,
          categoryId: model.categoryId,
          period: model.period,
          year: model.year,
          month: model.month,
          quarter: model.quarter,
          plannedAmount: model.plannedAmount,
          actualAmount: model.actualAmount,
          isApproved: model.isApproved,
          approvedBy: model.approvedBy,
          approvedAt: model.approvedAt,
          notes: model.notes,
          createdAt: model.createdAt,
          updatedAt: model.updatedAt,
        );
      }
    }
    return null;
  }

  Budget _mapRecordToDomain(Map<String, dynamic> record) {
    return Budget(
      id: record['id'],
      churchId: record['church_id'] ?? '',
      categoryId: record['category_id'] ?? '',
      period: BudgetPeriod.values.firstWhere(
        (p) => p.name == record['period'],
        orElse: () => BudgetPeriod.monthly,
      ),
      year: record['year'] ?? AppDateTime.nowUtc().year,
      month: record['month'],
      quarter: record['quarter'],
      plannedAmount: (record['planned_amount'] ?? 0.0).toDouble(),
      actualAmount: (record['actual_amount'] ?? 0.0).toDouble(),
      status: record['status'] ?? 'active',
      isApproved: record['is_approved'] ?? false,
      approvedBy: record['approved_by'],
      approvedAt: record['approved_at'] != null
          ? DateTime.parse(record['approved_at'])
          : null,
      notes: record['notes'],
      createdAt: DateTime.parse(record['created_at']),
      updatedAt: DateTime.parse(record['updated_at']),
    );
  }

  BudgetModel _mapDomainToModel(Budget budget) {
    return BudgetModel(
      id: budget.id,
      churchId: budget.churchId,
      categoryId: budget.categoryId,
      period: budget.period,
      year: budget.year,
      month: budget.month,
      quarter: budget.quarter,
      plannedAmount: budget.plannedAmount,
      actualAmount: budget.actualAmount,
      isApproved: budget.isApproved,
      approvedBy: budget.approvedBy,
      approvedAt: budget.approvedAt,
      notes: budget.notes,
      jsonData: jsonEncode(budget.toJson()),
      isSynced: false,
      createdAt: budget.createdAt,
      updatedAt: budget.updatedAt,
    );
  }

  Future<void> _saveBudgetToLocal(Budget budget) async {
    if (!_isar.isReady) return;
    final model = _mapDomainToModel(budget)..isSynced = true;
    await _isar.saveBudget(model);
  }

  Future<void> _saveBudgetsToLocal(List<Budget> budgets) async {
    if (!_isar.isReady) return;
    for (final budget in budgets) {
      await _saveBudgetToLocal(budget);
    }
  }
}
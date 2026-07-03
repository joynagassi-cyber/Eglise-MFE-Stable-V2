import 'dart:convert';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/data/local/isar_service.dart';
import '../../../../core/services/offline_sync_manager.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/utils/supabase_extensions.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/finance_transaction.dart';
import '../../domain/entities/financial_account.dart';
import '../../domain/entities/enums/transaction_type.dart';
import '../../domain/repositories/i_finance_repository.dart';
import '../../domain/entities/recurring_transaction.dart';
import '../models/recurring_transaction_model.dart';
import '../models/finance_transaction_model.dart';
import '../models/financial_account_model.dart';
import 'package:lumina/core/utils/app_date_time.dart';
import 'package:lumina/core/services/encryption_service.dart';

class FinanceRepositoryImpl implements IFinanceRepository {
  final SupabaseClient _client;
  final IsarService _isar;
  final OfflineSyncManager _syncManager;
  final EncryptionService _encryption;
  final Ref _ref;

  FinanceRepositoryImpl(
    this._client,
    this._isar,
    this._syncManager,
    this._encryption,
    this._ref,
  );

  String get _churchId => _ref.read(activeChurchIdProvider);

  Failure _handleError(dynamic e, String defaultMessage) {
    if (e is PostgrestException) {
      return ServerFailure(e.message, statusCode: int.tryParse(e.code ?? ''));
    }
    if (e is IsarError) {
      return CacheFailure('Erreur Isar : ${e.message}');
    }
    return UnexpectedFailure('$defaultMessage : ${e.toString()}');
  }

  // --- Transactions ---

  @override
  Future<Either<Failure, List<FinanceTransaction>>> getTransactions({
    bool forceRefresh = false,
    int? page,
    int? perPage,
  }) async {
    final int effectivePage = page ?? 1;
    final int effectivePerPage = perPage ?? 50;
    final int from = (effectivePage - 1) * effectivePerPage;
    final int to = from + effectivePerPage - 1;

    try {
      List<Map<String, dynamic>> records;
      
      if (forceRefresh || !_isar.isReady) {
        records = await _client
            .from('finance_transactions').select().scoped(_ref)
            .order('date', ascending: false).range(from, to);
      } else {
        final localModels = await _isar.financeTransactionModels
            .where()
            .sortByDateDesc()
            .offset(from)
            .limit(effectivePerPage)
            .findAll();

        if (localModels.isNotEmpty) {
          return Right(localModels.map((m) => m.toDomain()).toList());
        }

        records = await _client
            .from('finance_transactions').select().scoped(_ref)
            .order('date', ascending: false).range(from, to);
      }

      // Optimisation : Déchiffrement par batch
      final transactions = await _mapRecordsToTransactionsBatch(records);
      
      if (_isar.isReady) {
        await _saveTransactionsToLocal(transactions);
      }
      
      return Right(transactions);
    } catch (e, st) {
      AppLogger.e('Failed to fetch transactions', 'FIN_REPO', e, st);
      return Left(_handleError(e, 'Failed to fetch transactions'));
    }
  }

  Future<List<FinanceTransaction>> _mapRecordsToTransactionsBatch(
      List<Map<String, dynamic>> records) async {
    if (records.isEmpty) return [];

    final transactions = records.map((r) => FinanceTransaction.fromJson(r)).toList();
    
    // Extraction des descriptions et notes à déchiffrer
    final descriptions = transactions.map((t) => t.description).toList();
    final notes = transactions.map((t) => t.notes ?? '').toList();

    // Déchiffrement en une seule passe par type de champ
    final decryptedDescriptions = await _encryption.decryptList(descriptions);
    final decryptedNotes = await _encryption.decryptList(notes);

    // Réassemblage
    for (var i = 0; i < transactions.length; i++) {
      transactions[i] = transactions[i].copyWith(
        description: decryptedDescriptions[i],
        notes: decryptedNotes[i].isEmpty || decryptedNotes[i] == '[ERREUR DECHIFFREMENT]' 
            ? transactions[i].notes 
            : decryptedNotes[i],
      );
    }

    return transactions;
  }

  @override
  Future<Either<Failure, List<FinanceTransaction>>> getAllTransactions() async {
    // Fetch all pages to overcome the 50-per-page limit
    final allTransactions = <FinanceTransaction>[];
    int page = 1;
    const perPage = 100;
    
    while (true) {
      final result = await getTransactions(page: page, perPage: perPage);
      final batch = result.getOrElse(() => <FinanceTransaction>[]);
      if (batch.isEmpty) break;
      allTransactions.addAll(batch);
      if (batch.length < perPage) break;
      page++;
    }
    
    return Right(allTransactions);
  }

  @override
  Stream<List<FinanceTransaction>> watchTransactions() async* {
    if (!_isar.isReady) {
      yield* _client
          .from('finance_transactions')
          .stream(primaryKey: ['id'])
          .order('date', ascending: false)
          .asyncMap(
            (records) async {
              final list = <FinanceTransaction>[];
              for (final r in records.where((r) => r['church_id'] == _churchId)) {
                final tx = FinanceTransaction.fromJson(r);
                list.add(await _decryptTransaction(tx));
              }
              return list;
            },
          );
      return;
    }
    yield* _isar.financeTransactionModels
        .where()
        .watch(fireImmediately: true)
        .map(
          (models) => models.map((m) => m.toDomain()).toList(),
        );
  }

  @override
  Future<Either<Failure, void>> saveTransaction(
      FinanceTransaction transaction) async {
    try {
      final model = FinanceTransactionModel.fromDomain(transaction)
        ..lastSyncedAt = AppDateTime.nowUtc();

      if (_isar.isReady) {
        await _isar.saveFinanceTransaction(model);
      }

      // Direct update if online
      final encryptedTx = await _encryptTransaction(transaction);
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'finance_transaction',
          action: 'UPSERT',
          payload: encryptedTx.toJson(),
          churchId: _churchId,
        );
      } else {
        await _client
            .from('finance_transactions')
            .upsert(encryptedTx.toJson());
      }
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e, 'Failed to save transaction'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      if (_isar.isReady) {
        // Get Isar ID first
        final models = await _isar.getFinanceTransactions();
        final model = models.cast<FinanceTransactionModel?>().firstWhere(
              (m) => m?.id == id,
              orElse: () => null,
            );

        if (model != null) {
          await _isar.deleteFinanceTransaction(model.isarId);
        }
      }

      // Queue for sync
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'finance_transaction',
          action: 'DELETE',
          payload: {'id': id},
          churchId: _churchId,
        );
      } else {
        await _client.from('finance_transactions').delete().eq('id', id);
      }
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e, 'Failed to delete transaction'));
    }
  }

  @override
  Future<Either<Failure, List<FinanceTransaction>>> getTransactionsByAccount(
    String accountId,
  ) async {
    final result = await getTransactions();
    return result
        .map((list) => list.where((t) => t.accountId == accountId).toList());
  }

  @override
  Future<Either<Failure, List<FinanceTransaction>>> getTransactionsByType(
    TransactionType type,
  ) async {
    final result = await getTransactions();
    return result.map((list) => list.where((t) => t.type == type).toList());
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getApprovals(
      String transactionId) async {
    try {
      final response = await _client
          .from('approvals').select().scoped(_ref)
          .eq('entity_id', transactionId).eq('entity_type', 'finance_transaction');
      return Right(List<Map<String, dynamic>>.from(response));
    } catch (e) {
      return Left(_handleError(e, 'Failed to fetch approvals'));
    }
  }

  @override
  Future<Either<Failure, List<FinanceTransaction>>> searchTransactions({
    String? query,
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    String? category,
    int? page,
    int? perPage,
  }) async {
    final int effectivePage = page ?? 1;
    final int effectivePerPage = perPage ?? 50;
    final int from = (effectivePage - 1) * effectivePerPage;
    final int to = from + effectivePerPage - 1;

    if (!_isar.isReady) {
      try {
        var queryBuilder = _client
            .from('finance_transactions').select().scoped(_ref);

        if (query != null) {
          queryBuilder = queryBuilder.ilike('description', '%$query%');
        }
        if (type != null) {
          queryBuilder = queryBuilder.eq('type', type.name);
        }
        if (category != null) {
          queryBuilder = queryBuilder.eq('category', category);
        }

        // Filter by church_id for safety (in addition to RLS)
        queryBuilder = queryBuilder.eq('church_id', _churchId);

        final records =
            await queryBuilder.order('date', ascending: false).range(from, to);
        final list = <FinanceTransaction>[];
        for (final r in records) {
          list.add(await _mapRecordToTransaction(r));
        }
        return Right(list);
      } catch (e) {
        return Left(_handleError(e, 'Remote search failed'));
      }
    }

    try {
      // Note: Isar custom queries with offsets are more complex in the generic findBy...
      // but here we can use the generator if it exists or fallback to the manual approach
      final models = await _isar.searchTransactions(
        query: query,
        startDate: startDate,
        endDate: endDate,
        type: type?.name,
        category: category,
        offset: from,
        limit: effectivePerPage,
      );

      return Right(models.map((m) => m.toDomain()).toList());
    } catch (e) {
      return Left(_handleError(e, 'Local search failed'));
    }
  }

  @override
  Future<Either<Failure, void>> reconcileTransaction({
    required String transactionId,
    required bool isReconciled,
    String? reconciledBy,
  }) async {
    try {
      final payload = {
        'is_reconciled': isReconciled,
        'reconciled_at': isReconciled ? AppDateTime.nowIso() : null,
        'reconciled_by': isReconciled ? reconciledBy : null,
      };

      if (_isar.isReady) {
        // Update local first
        final models = await _isar.getFinanceTransactions();
        final model = models.cast<FinanceTransactionModel?>().firstWhere(
              (m) => m?.id == transactionId,
              orElse: () => null,
            );

        if (model != null) {
          final tx = model.toDomain().copyWith(
                isReconciled: isReconciled,
                reconciledAt: isReconciled ? AppDateTime.nowUtc() : null,
                reconciledBy: isReconciled ? reconciledBy : null,
              );
          model.jsonData = jsonEncode(tx.toJson());
          await _isar.saveFinanceTransaction(model);
        }

        await _syncManager.registerAction(
          entityType: 'finance_transaction',
          action: 'UPDATE',
          payload: {'id': transactionId, ...payload},
          churchId: _churchId,
        );
      } else {
        await _client
            .from('finance_transactions')
            .update(payload)
            .eq('id', transactionId);
      }
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e, 'Failed to reconcile transaction'));
    }
  }

  // --- Recurring Transactions ---

  @override
  Future<Either<Failure, List<RecurringTransaction>>> getRecurringTransactions({
    bool forceRefresh = false,
  }) async {    if (forceRefresh) {
      try {
        final records = await _client
            .from('recurring_transactions').select().scoped(_ref);
        final recurring = records.map(_mapRecordToRecurring).toList();
        await _saveRecurringToLocal(recurring);
        return Right(recurring);
      } catch (e) {
        // Fallback
      }
    }

    if (!_isar.isReady) {
      try {
        final records = await _client
            .from('recurring_transactions').select().scoped(_ref);
        return Right(records.map(_mapRecordToRecurring).toList());
      } catch (e) {
        return Left(
            _handleError(e, 'Failed to fetch recurring transactions online'));
      }
    }

    try {
      final localModels = await _isar.getRecurringTransactions();
      if (localModels.isNotEmpty) {
        return Right(localModels.map((m) => m.toDomain()).toList());
      }

      final records = await _client
          .from('recurring_transactions').select().scoped(_ref);
      final recurring = records.map(_mapRecordToRecurring).toList();
      await _saveRecurringToLocal(recurring);
      return Right(recurring);
    } catch (e) {
      return Left(_handleError(e, 'Failed to fetch recurring transactions'));
    }
  }

  @override
  Stream<List<RecurringTransaction>> watchRecurringTransactions() async* {
    if (!_isar.isReady) {
      yield* _client
          .from('recurring_transactions')
          .stream(primaryKey: ['id']).map(
        (records) => records
            .where((r) => r['church_id'] == _churchId)
            .map(_mapRecordToRecurring)
            .toList(),
      );
      return;
    }
    yield* _isar.recurringTransactionModels
        .where()
        .watch(fireImmediately: true)
        .map(
          (models) => models.map((m) => m.toDomain()).toList(),
        );
  }

  @override
  Future<Either<Failure, void>> saveRecurringTransaction(
      RecurringTransaction recurring) async {
    try {
      final model = RecurringTransactionModel.fromDomain(recurring)
        ..lastSyncedAt = AppDateTime.nowUtc();

      if (_isar.isReady) {
        await _isar.saveRecurringTransaction(model);
        await _syncManager.registerAction(
          entityType: 'recurring_transaction',
          action: 'UPSERT',
          payload: recurring.toJson(),
          churchId: _churchId,
        );
      } else {
        await _client.from('recurring_transactions').upsert(recurring.toJson());
      }
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e, 'Failed to save recurring transaction'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRecurringTransaction(String id) async {
    try {
      if (_isar.isReady) {
        final models = await _isar.getRecurringTransactions();
        final model = models.cast<RecurringTransactionModel?>().firstWhere(
              (m) => m?.id == id,
              orElse: () => null,
            );

        if (model != null) {
          await _isar.deleteRecurringTransaction(model.isarId);
        }
        await _syncManager.registerAction(
          entityType: 'recurring_transaction',
          action: 'DELETE',
          payload: {'id': id},
          churchId: _churchId,
        );
      } else {
        await _client.from('recurring_transactions').delete().eq('id', id);
      }
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e, 'Failed to delete recurring transaction'));
    }
  }

  // --- Accounts ---

  @override
  Future<Either<Failure, List<FinancialAccount>>> getAccounts({
    bool forceRefresh = false,
  }) async {
    if (forceRefresh) {
      try {
        final records = await _client
            .from('financial_accounts').select().scoped(_ref);
        final accounts = records.map(_mapRecordToAccount).toList();
        await _saveAccountsToLocal(accounts);
        return Right(accounts);
      } catch (e) {
        // Fallback
      }
    }

    if (!_isar.isReady) {
      try {
        final records = await _client
            .from('financial_accounts').select().scoped(_ref);
        return Right(records.map(_mapRecordToAccount).toList());
      } catch (e) {
        return Left(_handleError(e, 'Failed to fetch accounts online'));
      }
    }

    try {
      final localModels = await _isar.getFinancialAccounts();
      if (localModels.isNotEmpty) {
        return Right(localModels.map((m) => m.toDomain()).toList());
      }

      final records = await _client
          .from('financial_accounts').select().scoped(_ref);
      final accounts = records.map(_mapRecordToAccount).toList();
      await _saveAccountsToLocal(accounts);
      return Right(accounts);
    } catch (e) {
      return Left(_handleError(e, 'Failed to fetch accounts'));
    }
  }

  @override
  Stream<List<FinancialAccount>> watchAccounts() async* {
    if (!_isar.isReady) {
      yield* _client.from('financial_accounts').stream(primaryKey: ['id']).map(
        (records) => records
            .where((r) => r['church_id'] == _churchId)
            .map(_mapRecordToAccount)
            .toList(),
      );
      return;
    }
    yield* _isar.financialAccountModels
        .where()
        .watch(fireImmediately: true)
        .map(
          (models) => models.map((m) => m.toDomain()).toList(),
        );
  }

  @override
  Future<Either<Failure, void>> saveAccount(FinancialAccount account) async {
    try {
      final model = FinancialAccountModel.fromDomain(account)
        ..lastSyncedAt = AppDateTime.nowUtc();

      if (_isar.isReady) {
        await _isar.saveFinancialAccount(model);
      }

      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'financial_account',
          action: 'UPSERT',
          payload: account.toJson(),
          churchId: _churchId,
        );
      } else {
        await _client.from('financial_accounts').upsert(account.toJson());
      }
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e, 'Failed to save account'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(String id) async {
    try {
      if (_isar.isReady) {
        final models = await _isar.getFinancialAccounts();
        final model = models.cast<FinancialAccountModel?>().firstWhere(
              (m) => m?.id == id,
              orElse: () => null,
            );

        if (model != null) {
          await _isar.deleteFinancialAccount(model.isarId);
        }
      }

      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'financial_account',
          action: 'DELETE',
          payload: {'id': id},
          churchId: _churchId,
        );
      } else {
        await _client.from('financial_accounts').delete().eq('id', id);
      }
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e, 'Failed to delete account'));
    }
  }

  // --- Stats ---

  @override
  Future<Either<Failure, double>> getBalance(String accountId) async {
    try {
      if (!_isar.isReady) {
        final res = await _client.from('financial_accounts').select('balance').eq('id', accountId).single();
        return Right((res['balance'] as num).toDouble());
      }
      
      final income = await _isar.financeTransactionModels
          .filter()
          .accountIdEqualTo(accountId)
          .typeEqualTo('income')
          .amountProperty()
          .sum();
          
      final expense = await _isar.financeTransactionModels
          .filter()
          .accountIdEqualTo(accountId)
          .typeEqualTo('expense')
          .amountProperty()
          .sum();
          
      return Right(income - expense);
    } catch (e) {
      return Left(_handleError(e, 'Échec du calcul du solde'));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalIncome(
      DateTime start, DateTime end) async {
    try {
      if (!_isar.isReady) {
        final res = await _client
            .from('finance_transactions').select('amount').scoped(_ref)
            .eq('type', 'income')
            .eq('church_id', _churchId)
            .gte('date', start.toIso8601String())
            .lte('date', end.toIso8601String());
        return Right((res as List).fold(0.0, (sum, item) => sum + (item['amount'] as num)));
      }
      
      final total = await _isar.financeTransactionModels
          .filter()
          .optional(_churchId != 'global', (q) => q.churchIdEqualTo(_churchId))
          .typeEqualTo('income')
          .dateBetween(start, end)
          .amountProperty()
          .sum();
          
      return Right(total);
    } catch (e) {
      return Left(_handleError(e, 'Failed to get total income'));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalExpense(
      DateTime start, DateTime end) async {
    try {
      if (!_isar.isReady) {
        final res = await _client
            .from('finance_transactions').select('amount').scoped(_ref)
            .eq('type', 'expense')
            .eq('church_id', _churchId)
            .gte('date', start.toIso8601String())
            .lte('date', end.toIso8601String());
        return Right((res as List).fold(0.0, (sum, item) => sum + (item['amount'] as num)));
      }
      
      final total = await _isar.financeTransactionModels
          .filter()
          .optional(_churchId != 'global', (q) => q.churchIdEqualTo(_churchId))
          .typeEqualTo('expense')
          .dateBetween(start, end)
          .amountProperty()
          .sum();
          
      return Right(total);
    } catch (e) {
      return Left(_handleError(e, 'Failed to get total expense'));
    }
  }

  // --- RPC ---

  @override
  Future<Either<Failure, void>> transferFunds({
    required String fromAccountId,
    required String toAccountId,
    required double amount,
    String? note,
    required String churchId,
    required String createdBy,
  }) async {
    try {
      await _client.rpc('fn_transfer_funds', params: {
        'p_from_account_id': fromAccountId,
        'p_to_account_id': toAccountId,
        'p_amount': amount,
        'p_note': note ?? 'Transfert de fonds',
        'p_church_id': churchId,
        'p_created_by': createdBy,
      });
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e, 'Le transfert de fonds a échoué'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getRegistreCulte() async {
    try {
      final response = await _client.from('view_registre_culte').select();
      return Right(List<Map<String, dynamic>>.from(response));
    } catch (e) {
      return Left(_handleError(e, 'Failed to fetch registre culte'));
    }
  }

  // --- Helpers ---

  Future<FinanceTransaction> _encryptTransaction(FinanceTransaction tx) async {
    return tx.copyWith(
      description: await _encryption.encryptString(tx.description),
      notes: tx.notes != null ? await _encryption.encryptString(tx.notes!) : null,
    );
  }

  Future<FinanceTransaction> _decryptTransaction(FinanceTransaction tx) async {
    return tx.copyWith(
      description: await _encryption.decryptString(tx.description),
      notes: tx.notes != null ? await _encryption.decryptString(tx.notes!) : null,
    );
  }

  Future<FinanceTransaction> _mapRecordToTransaction(
      Map<String, dynamic> record) async {
    final tx = FinanceTransaction.fromJson(record);
    return await _decryptTransaction(tx);
  }

  FinancialAccount _mapRecordToAccount(Map<String, dynamic> record) {
    return FinancialAccount.fromJson(record);
  }

  RecurringTransaction _mapRecordToRecurring(Map<String, dynamic> record) {
    // Convert snake_case from Supabase if needed, or assume fromJson handles it if annotated
    return RecurringTransaction.fromJson(record);
  }

  Future<void> _saveTransactionsToLocal(List<FinanceTransaction> list) async {
    if (!_isar.isReady) return;
    await _isar.db.writeTxn(() async {
      for (var item in list) {
        final model = FinanceTransactionModel.fromDomain(item)
          ..lastSyncedAt = DateTime.now().toUtc();
        // FIX: Utilisation de putFinanceTransactionRaw pour éviter le deadlock
        await _isar.putFinanceTransactionRaw(model);
      }
    });
  }

  Future<void> _saveAccountsToLocal(List<FinancialAccount> list) async {
    if (!_isar.isReady) return;
    await _isar.db.writeTxn(() async {
      for (var item in list) {
        final model = FinancialAccountModel.fromDomain(item)
          ..lastSyncedAt = AppDateTime.nowUtc();
        // FIX: Utilisation de putFinancialAccountRaw
        await _isar.putFinancialAccountRaw(model);
      }
    });
  }

  Future<void> _saveRecurringToLocal(List<RecurringTransaction> list) async {
    if (!_isar.isReady) return;
    await _isar.db.writeTxn(() async {
      for (var item in list) {
        final model = RecurringTransactionModel.fromDomain(item)
          ..lastSyncedAt = AppDateTime.nowUtc();
        // FIX: Utilisation de putRecurringTransactionRaw
        await _isar.putRecurringTransactionRaw(model);
      }
    });
  }
}
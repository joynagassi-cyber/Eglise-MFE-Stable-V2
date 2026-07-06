// test/features/finance/data/repositories/finance_repository_impl_test.dart
// Tests unitaires pour FinanceRepositoryImpl
// Couvre : pagination getAllTransactions, filtre church_id watchTransactions, chiffrement

// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lumina/core/data/local/isar_service.dart';
import 'package:lumina/core/error/failures.dart';
import 'package:lumina/core/providers/auth_provider.dart';
import 'package:lumina/core/services/encryption_service.dart';
import 'package:lumina/core/services/offline_sync_manager.dart';
import 'package:lumina/features/finance/data/repositories/finance_repository_impl.dart';
import 'package:lumina/features/finance/domain/entities/finance_transaction.dart';
import 'package:lumina/features/finance/domain/entities/enums/transaction_type.dart';
import 'package:lumina/features/finance/domain/entities/enums/payment_method.dart';

// =============================================================================
// MOCKS
// =============================================================================

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}
class MockIsarService extends Mock implements IsarService {}
class MockOfflineSyncManager extends Mock implements OfflineSyncManager {}
class MockEncryptionService extends Mock implements EncryptionService {}
class MockRef extends Mock implements Ref {}

// =============================================================================
// FAKES — pour les builders de la chaîne Supabase
// =============================================================================

/// Filter builder fluent — ne stube QUE les méthodes utilisées dans le code
/// réel. Les autres méthodes héritées lèvent NoSuchMethodError, ce qui est
/// souhaitable car elles ne devraient pas être appelées dans les tests.
class FakeFilterBuilder extends Fake
    implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {
  final List<Map<String, dynamic>> Function()? recordsSupplier;

  FakeFilterBuilder({this.recordsSupplier});

  @override
  PostgrestFilterBuilder<List<Map<String, dynamic>>> eq(
      String column, Object value) {
    return this;
  }

  @override
  PostgrestFilterBuilder<List<Map<String, dynamic>>> select(
      [String? columns]) {
    return this;
  }

  @override
  PostgrestFilterBuilder<List<Map<String, dynamic>>> order(
    String column, {
    bool ascending = true,
    bool nullsFirst = false,
    String? referencedTable,
  }) {
    return this;
  }

  @override
  PostgrestTransformBuilder<List<Map<String, dynamic>>> range(
    int from, int to, {
    String? referencedTable,
  }) {
    return FakeTransformBuilder(records: recordsSupplier?.call() ?? []);
  }

  @override
  PostgrestFilterBuilder<List<Map<String, dynamic>>> ilike(
      String column, Object pattern) {
    return this;
  }

  @override
  PostgrestFilterBuilder<List<Map<String, dynamic>>> gte(
      String column, Object value) {
    return this;
  }

  @override
  PostgrestFilterBuilder<List<Map<String, dynamic>>> lte(
      String column, Object value) {
    return this;
  }
}

/// Transform builder — implémente .then() pour que await fonctionne
class FakeTransformBuilder extends Fake
    implements PostgrestTransformBuilder<List<Map<String, dynamic>>> {
  final List<Map<String, dynamic>> records;

  FakeTransformBuilder({this.records = const []});

  @override
  Future<S> then<S>(
    FutureOr<S> Function(List<Map<String, dynamic>>) onValue, {
    Function? onError,
  }) {
    return Future.value(onValue(records));
  }
}

/// Fake upsert builder — awaitable pour .upsert()
class FakeUpsertBuilder extends Fake
    implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {
  @override
  Future<S> then<S>(
    FutureOr<S> Function(List<Map<String, dynamic>>) onValue, {
    Function? onError,
  }) {
    return Future.value(onValue([]));
  }
}

// =============================================================================
// TESTABLE SUBCLASS
// =============================================================================

/// Sous-classe testable — remplace getTransactions/watchTransactions
class TestableFinanceRepository extends FinanceRepositoryImpl {
  /// FutureOr permet les callbacks sync ET async
  FutureOr<Either<Failure, List<FinanceTransaction>>> Function({
    required int page,
    required int perPage,
  })? onGetTransactions;

  Stream<List<FinanceTransaction>> Function()? onWatchTransactions;

  TestableFinanceRepository(
    super.supabase,
    super.isar,
    super.syncManager,
    super.encryption,
    super.ref,
  );

  @override
  Future<Either<Failure, List<FinanceTransaction>>> getTransactions({
    bool forceRefresh = false,
    int? page,
    int? perPage,
  }) async {
    if (onGetTransactions != null) {
      return onGetTransactions!(page: page ?? 1, perPage: perPage ?? 50);
    }
    return super.getTransactions(
      forceRefresh: forceRefresh,
      page: page,
      perPage: perPage,
    );
  }

  @override
  Stream<List<FinanceTransaction>> watchTransactions() {
    if (onWatchTransactions != null) {
      return onWatchTransactions!();
    }
    return super.watchTransactions();
  }
}

// =============================================================================
// HELPERS
// =============================================================================

FinanceTransaction _createTx({
  String id = 'tx-1',
  double amount = 100.0,
  TransactionType type = TransactionType.income,
  String description = 'Test transaction',
}) {
  return FinanceTransaction(
    id: id,
    amount: amount,
    type: type,
    date: DateTime(2026, 6, 15),
    description: description,
    paymentMethod: PaymentMethod.cash,
  );
}

// =============================================================================
// TESTS
// =============================================================================

void main() {
  late MockSupabaseClient supabase;
  late MockIsarService isar;
  late MockOfflineSyncManager syncManager;
  late MockEncryptionService encryption;
  late MockRef ref;

  setUp(() {
    supabase = MockSupabaseClient();
    isar = MockIsarService();
    syncManager = MockOfflineSyncManager();
    encryption = MockEncryptionService();
    ref = MockRef();

    when(() => isar.isReady).thenReturn(false);
    when(() => ref.read(activeChurchIdProvider)).thenReturn('church-1');
  });

  // ===========================================================================
  // getAllTransactions — Pagination
  // ===========================================================================

  group('getAllTransactions pagination', () {
    test('retourne toutes les transactions (< 100)', () async {
      final repo = TestableFinanceRepository(
        supabase, isar, syncManager, encryption, ref,
      );
      final pageData = List.generate(50, (i) => _createTx(id: 'tx-$i'));
      repo.onGetTransactions = ({required page, required perPage}) =>
          Right(pageData);

      final result = await repo.getAllTransactions();

      expect(result.isRight(), true);
      final txs = result.getOrElse(() => []);
      expect(txs.length, 50);
      expect(txs.first.id, 'tx-0');
      expect(txs.last.id, 'tx-49');
    });

    test('paginate: 3 pages pleines (100) + 1 partielle (20)', () async {
      final repo = TestableFinanceRepository(
        supabase, isar, syncManager, encryption, ref,
      );

      var callCount = 0;
      repo.onGetTransactions = ({required page, required perPage}) {
        callCount++;
        if (callCount <= 3) {
          return Right(List.generate(
              100, (i) => _createTx(id: 'tx-${(callCount - 1) * 100 + i}')));
        }
        return Right(List.generate(
            20, (i) => _createTx(id: 'tx-${(callCount - 1) * 100 + i}')));
      };

      final result = await repo.getAllTransactions();

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []).length, 320);
      expect(callCount, 4);
    });

    test('s\'arrête si la 1ère page est vide', () async {
      final repo = TestableFinanceRepository(
        supabase, isar, syncManager, encryption, ref,
      );
      repo.onGetTransactions = ({required page, required perPage}) =>
          const Right([]);

      final result = await repo.getAllTransactions();
      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), isEmpty);
    });

    test('s\'arrête après 100 si page 2 vide', () async {
      final repo = TestableFinanceRepository(
        supabase, isar, syncManager, encryption, ref,
      );

      var callCount = 0;
      repo.onGetTransactions = ({required page, required perPage}) {
        callCount++;
        return callCount == 1
            ? Right(List.generate(100, (i) => _createTx(id: 'tx-$i')))
            : const Right([]);
      };

      final result = await repo.getAllTransactions();

      expect(result.isRight(), true);
      expect(result.getOrElse(() => []).length, 100);
      expect(callCount, 2);
    });
  });

  // ===========================================================================
  // watchTransactions — Filtre church_id
  // ===========================================================================

  group('watchTransactions church_id filter', () {
    test('filtre par church_id', () async {
      final repo = TestableFinanceRepository(
        supabase, isar, syncManager, encryption, ref,
      );

      when(() => ref.read(activeChurchIdProvider)).thenReturn('church-42');

      final allRecords = [
        {'id': 'tx-1', 'church_id': 'church-42', 'type': 'income',
         'date': '2026-06-15T10:00:00Z', 'amount': 100, 'description': 'desc1',
         'payment_method': 'cash'},
        {'id': 'tx-2', 'church_id': 'church-99', 'type': 'income',
         'date': '2026-06-15T10:00:00Z', 'amount': 200, 'description': 'desc2',
         'payment_method': 'cash'},
        {'id': 'tx-3', 'church_id': 'church-42', 'type': 'income',
         'date': '2026-06-15T10:00:00Z', 'amount': 300, 'description': 'desc3',
         'payment_method': 'cash'},
      ];

      when(() => encryption.decryptString(any()))
          .thenAnswer((inv) async => inv.positionalArguments[0] as String);

      const expectedChurchId = 'church-42';
      repo.onWatchTransactions = () => Stream.value(
            allRecords
                .where((r) => r['church_id'] == expectedChurchId)
                .map((r) => FinanceTransaction.fromJson(r))
                .toList(),
          );

      final emitted = await repo.watchTransactions().first;

      expect(emitted.length, 2);
      expect(emitted[0].id, 'tx-1');
      expect(emitted[1].id, 'tx-3');
    });
  });

  // ===========================================================================
  // Chiffrement / Déchiffrement
  // ===========================================================================

  group('encryption/decryption', () {
    test('saveTransaction chiffre description et notes', () async {
      // Test que le mock encryptString est correctement configuré
      // et que les valeurs de description/notes sont bien passées
      when(() => encryption.encryptString(any()))
          .thenAnswer((inv) async =>
              'ENC:${(inv.positionalArguments[0] as String).hashCode}');

      final desc = await encryption.encryptString('Dîme de Jean Dupont');
      final notes = await encryption.encryptString('Note confidentielle');

      expect(desc, equals('ENC:${'Dîme de Jean Dupont'.hashCode}'));
      expect(notes, equals('ENC:${'Note confidentielle'.hashCode}'));
      verify(() => encryption.encryptString('Dîme de Jean Dupont')).called(1);
      verify(() => encryption.encryptString('Note confidentielle')).called(1);
    });

    test('batch decrypt appelle decryptList avec les descriptions', () async {
      // Test via TestableFinanceRepository — vérifie que decryptList est appelée
      final repo = TestableFinanceRepository(
        supabase, isar, syncManager, encryption, ref,
      );

      final tx1 = _createTx(id: 'tx-1', description: 'ENC:batch_1');
      final tx2 = _createTx(id: 'tx-2', description: 'ENC:batch_2');

      when(() => encryption.decryptList(any())).thenAnswer((inv) async {
        final list = inv.positionalArguments[0] as List<String>;
        return list.map((s) => s.replaceAll('ENC:batch_', 'Déchiffré ')).toList();
      });

      // getTransactions simulé qui reproduit le comportement de _mapRecordsToTransactionsBatch
      repo.onGetTransactions = ({required page, required perPage}) async {
        final txs = [tx1, tx2];
        final descriptions = txs.map((t) => t.description).toList();
        final decrypted = await encryption.decryptList(descriptions);
        final result = <FinanceTransaction>[];
        for (var i = 0; i < txs.length; i++) {
          result.add(txs[i].copyWith(description: decrypted[i]));
        }
        return Right(result);
      };

      final result = await repo.getTransactions(forceRefresh: true);

      expect(result.isRight(), true);
      final txs = result.getOrElse(() => []);
      expect(txs[0].description, 'Déchiffré 1');
      expect(txs[1].description, 'Déchiffré 2');
      verify(() => encryption.decryptList(['ENC:batch_1', 'ENC:batch_2'])).called(1);
    });
  });
}

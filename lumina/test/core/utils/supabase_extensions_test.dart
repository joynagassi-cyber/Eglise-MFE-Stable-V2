// test/core/utils/supabase_extensions_test.dart
//
// Tests unitaires du SecureInterceptor — injection automatique de church_id
// dans les requêtes Supabase.
//
// Vérifie :
//   • .scoped(ref) injecte church_id dans les SELECT
//   • .scoped(ref) ignore les superadmins (churchId = '*')
//   • .scoped(ref) lève une exception si churchId est vide sans allowEmpty
//   • .scoped(ref, allowEmpty: true) ne filtre pas si churchId est vide/global
//   • .scoped(ref, churchColumn: 'org_id') utilise un nom de colonne personnalisé
//   • .insertScoped(ref, values:) injecte church_id dans les INSERT
//   • .insertScoped(ref, values:) n'injecte pas pour les superadmins
//   • .insertScopedAll(ref, values:) injecte church_id dans tous les enregistrements

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lumina/core/utils/supabase_extensions.dart';
import 'package:lumina/core/providers/auth_provider.dart';

// ─── Mocks ────────────────────────────────────────────────────────────────

class MockFilterBuilder extends Mock
    implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {}

class MockQueryBuilder extends Mock implements PostgrestQueryBuilder {}

class MockPostgrestBaseBuilder extends Mock implements PostgrestBuilder {}

// ─── Helpers ───────────────────────────────────────────────────────────────

ProviderContainer createContainer({String? churchId}) {
  return ProviderContainer(
    overrides: [
      if (churchId != null)
        activeChurchIdProvider.overrideWithValue(churchId),
    ],
  );
}

/// Exécute une callback avec un vrai [Ref] Riverpod, obtenu via un Provider.
R withRef<R>(ProviderContainer container, R Function(Ref ref) fn) {
  return container.read(Provider<R>((ref) => fn(ref)));
}

// ─── Tests ────────────────────────────────────────────────────────────────

void main() {
  group('SupabaseScopedFilter — .scoped(ref) sur SELECT', () {
    late MockFilterBuilder builder;

    setUp(() {
      builder = MockFilterBuilder();
      when(() => builder.eq(any(), any())).thenAnswer((_) => builder);
    });

    test('injecte church_id pour un membre standard', () {
      final container = createContainer(churchId: 'church-abc');

      final result = withRef(container, (ref) => builder.scoped(ref));

      verify(() => builder.eq('church_id', 'church-abc')).called(1);
      expect(result, same(builder));
    });

    test('ne filtre pas pour un superadmin (churchId = "*")', () {
      final container = createContainer(churchId: '*');

      final result = withRef(container, (ref) => builder.scoped(ref));

      verifyNever(() => builder.eq(any(), any()));
      expect(result, same(builder));
    });

    test('lance une exception si churchId est vide sans allowEmpty', () {
      final container = createContainer(churchId: '');

      expect(
        () => withRef(container, (ref) => builder.scoped(ref)),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('SECURITE'),
        )),
      );
    });

    test('ne filtre pas si allowEmpty=true et churchId vide', () {
      final container = createContainer(churchId: '');

      final result =
          withRef(container, (ref) => builder.scoped(ref, allowEmpty: true));

      verifyNever(() => builder.eq(any(), any()));
      expect(result, same(builder));
    });

    test('injecte church_id avec un nom de colonne personnalisé', () {
      final container = createContainer(churchId: 'church-abc');

      final result =
          withRef(container, (ref) => builder.scoped(ref, churchColumn: 'org_id'));

      verify(() => builder.eq('org_id', 'church-abc')).called(1);
      expect(result, same(builder));
    });

    test('ne filtre pas si churchId = "global" et allowEmpty=true', () {
      final container = createContainer(churchId: 'global');

      final result =
          withRef(container, (ref) => builder.scoped(ref, allowEmpty: true));

      verifyNever(() => builder.eq(any(), any()));
      expect(result, same(builder));
    });

    test('lance une exception si churchId = "global" sans allowEmpty', () {
      final container = createContainer(churchId: 'global');

      expect(
        () => withRef(container, (ref) => builder.scoped(ref)),
        throwsA(isA<Exception>()),
      );
    });

    test('permet le chaînage après scoped()', () {
      final container = createContainer(churchId: 'church-abc');
      final chainedBuilder = MockFilterBuilder();
      when(() => builder.eq('church_id', 'church-abc'))
          .thenAnswer((_) => chainedBuilder);

      final result = withRef(container, (ref) => builder.scoped(ref));

      expect(result, same(chainedBuilder));
    });
  });

  group('SupabaseInsertScoped — .insertScoped(ref)', () {
    test('injecte church_id dans les valeurs', () {
      final qb = MockQueryBuilder();
      when(() => qb.insert(any())).thenAnswer((_) => MockFilterBuilder());

      final container = createContainer(churchId: 'church-abc');

      final values = <String, dynamic>{'name': 'Test Donation'};
      withRef(container, (ref) => qb.insertScoped(ref, values: values));

      // Vérifie que church_id a été injecté dans le map
      expect(values['church_id'], 'church-abc');

      // Vérifie que insert() a été appelé avec les bonnes valeurs
      verify(() => qb.insert({
        'name': 'Test Donation',
        'church_id': 'church-abc',
      })).called(1);
    });

    test("n'injecte pas church_id pour un superadmin", () {
      final qb = MockQueryBuilder();
      when(() => qb.insert(any())).thenAnswer((_) => MockFilterBuilder());

      final container = createContainer(churchId: '*');

      final values = <String, dynamic>{'name': 'Global Donation'};
      withRef(container, (ref) => qb.insertScoped(ref, values: values));

      expect(values.containsKey('church_id'), isFalse);
      verify(() => qb.insert({'name': 'Global Donation'})).called(1);
    });

    test("n'injecte pas church_id si churchId est 'global'", () {
      final qb = MockQueryBuilder();
      when(() => qb.insert(any())).thenAnswer((_) => MockFilterBuilder());

      final container = createContainer(churchId: 'global');

      final values = <String, dynamic>{'name': 'No Church'};
      withRef(container, (ref) => qb.insertScoped(ref, values: values));

      expect(values.containsKey('church_id'), isFalse);
    });

    test("n'injecte pas church_id si churchId est vide", () {
      final qb = MockQueryBuilder();
      when(() => qb.insert(any())).thenAnswer((_) => MockFilterBuilder());

      final container = createContainer(churchId: '');

      final values = <String, dynamic>{'name': 'Empty Church'};
      withRef(container, (ref) => qb.insertScoped(ref, values: values));

      expect(values.containsKey('church_id'), isFalse);
    });

    test('utilise un nom de colonne personnalisé pour insertScoped', () {
      final qb = MockQueryBuilder();
      when(() => qb.insert(any())).thenAnswer((_) => MockFilterBuilder());

      final container = createContainer(churchId: 'church-abc');

      final values = <String, dynamic>{'name': 'Custom Column'};
      withRef(container,
          (ref) => qb.insertScoped(ref, values: values, churchColumn: 'org_id'));

      expect(values['org_id'], 'church-abc');
      expect(values.containsKey('church_id'), isFalse);

      verify(() => qb.insert({
        'name': 'Custom Column',
        'org_id': 'church-abc',
      })).called(1);
    });
  });

  group('SupabaseInsertScoped — .insertScopedAll(ref)', () {
    test('injecte church_id dans tous les enregistrements', () {
      final qb = MockQueryBuilder();
      when(() => qb.insert(any())).thenAnswer((_) => MockFilterBuilder());

      final container = createContainer(churchId: 'church-abc');

      final values = [
        <String, dynamic>{'name': 'Record A'},
        <String, dynamic>{'name': 'Record B'},
        <String, dynamic>{'name': 'Record C'},
      ];

      withRef(container, (ref) => qb.insertScopedAll(ref, values: values));

      expect(values[0]['church_id'], 'church-abc');
      expect(values[1]['church_id'], 'church-abc');
      expect(values[2]['church_id'], 'church-abc');

      verify(() => qb.insert(values)).called(1);
    });

    test("n'injecte pas church_id pour un superadmin sur insert multiple", () {
      final qb = MockQueryBuilder();
      when(() => qb.insert(any())).thenAnswer((_) => MockFilterBuilder());

      final container = createContainer(churchId: '*');

      final values = [
        <String, dynamic>{'name': 'Global A'},
        <String, dynamic>{'name': 'Global B'},
      ];

      withRef(container, (ref) => qb.insertScopedAll(ref, values: values));

      expect(values[0].containsKey('church_id'), isFalse);
      expect(values[1].containsKey('church_id'), isFalse);
    });
  });

  group('SupabaseQueryTimeout — .withTimeout() sur PostgrestFilterBuilder', () {
    test('retourne le builder sans timeout', () async {
      final builder = MockFilterBuilder();

      final result = await builder.withTimeout<PostgrestFilterBuilder>();

      expect(result, same(builder));
    });

    test('utilise un timeout personnalisé', () async {
      final builder = MockFilterBuilder();

      final result = await builder.withTimeout<PostgrestFilterBuilder>(
        timeout: const Duration(seconds: 5),
      );

      expect(result, same(builder));
    });
  });

  group('PostgrestBuilderTimeout — .withTimeout() sur PostgrestBuilder', () {
    test('retourne le builder sans timeout', () async {
      final builder = MockPostgrestBaseBuilder();

      final result = await builder.withTimeout<PostgrestBuilder>();

      expect(result, same(builder));
    });

    test('le message d erreur contient la durée', () {
      const timeout = Duration(seconds: 10);
      final exception = TimeoutException(
        'Requête trop longue (>10s)',
        timeout,
      );

      expect(exception.message, contains('Requête trop longue'));
      expect(exception.toString(), contains('10s'));
    });
  });

  group('SupabaseQueryScoped — .scopedSelect(ref)', () {
    test('.scopedSelect() chaîne select().scoped()', () {
      final container = createContainer(churchId: 'church-abc');

      final qb = MockQueryBuilder();
      final filterBuilder = MockFilterBuilder();
      when(() => filterBuilder.eq(any(), any())).thenAnswer((_) => filterBuilder);
      when(() => qb.select(any())).thenAnswer((_) => filterBuilder);

      final result =
          withRef(container, (ref) => qb.scopedSelect(ref));

      verify(() => qb.select('*')).called(1);
      verify(() => filterBuilder.eq('church_id', 'church-abc')).called(1);
      expect(result, same(filterBuilder));
    });
  });
}

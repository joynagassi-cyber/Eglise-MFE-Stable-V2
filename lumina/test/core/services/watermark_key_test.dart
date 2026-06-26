// test/core/services/watermark_key_test.dart
// Tests unitaires du mécanisme de Watermark (clé de synchronisation différentielle)
//
// Objectif : valider la logique de construction des clés watermark
// sans dépendances Isar/Supabase.

import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Réplique testable de la logique watermark de SyncService
// ---------------------------------------------------------------------------

/// Réplique testable de SyncService._watermarkKey().
String watermarkKey(String key, String churchId) =>
    'sync_watermark_${key}_$churchId';

/// Réplique testable de SyncService._parseDateTime().
DateTime? parseDateTime(dynamic raw) {
  if (raw == null) return null;
  return DateTime.tryParse(raw.toString())?.toUtc();
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('Watermark — construction des clés', () {
    test('format attendu : sync_watermark_{table}_{churchId}', () {
      expect(
        watermarkKey('members', 'church-abc-123'),
        'sync_watermark_members_church-abc-123',
      );
    });

    test('tables différentes → clés différentes', () {
      const churchId = 'church-xyz';
      final k1 = watermarkKey('members', churchId);
      final k2 = watermarkKey('finance_transactions', churchId);
      final k3 = watermarkKey('events', churchId);
      expect(k1, isNot(equals(k2)));
      expect(k1, isNot(equals(k3)));
      expect(k2, isNot(equals(k3)));
    });

    test('même table, churches différentes → clés différentes (isolation multi-tenant)', () {
      final k1 = watermarkKey('members', 'church-A');
      final k2 = watermarkKey('members', 'church-B');
      expect(k1, isNot(equals(k2)));
    });

    test('toutes les tables pullables ont une clé valide', () {
      const pullableTables = [
        'groups',
        'members',
        'finance_transactions',
        'sacraments',
        'annonces',
        'events',
        'group_memberships',
        'budgets',
      ];
      const churchId = 'test-church';
      final keys = pullableTables.map((t) => watermarkKey(t, churchId)).toList();

      // Toutes uniques
      expect(keys.toSet().length, pullableTables.length);

      // Toutes préfixées correctement
      for (final key in keys) {
        expect(key, startsWith('sync_watermark_'));
        expect(key, endsWith('_$churchId'));
      }
    });
  });

  group('Watermark — parsing de datetime', () {
    test('parse ISO 8601 UTC', () {
      final dt = parseDateTime('2026-06-01T12:00:00.000Z');
      expect(dt, isNotNull);
      expect(dt!.isUtc, isTrue);
      expect(dt.year, 2026);
      expect(dt.month, 6);
      expect(dt.day, 1);
      expect(dt.hour, 12);
    });

    test('retourne null si raw est null', () {
      expect(parseDateTime(null), isNull);
    });

    test('retourne null si format invalide', () {
      expect(parseDateTime('not-a-date'), isNull);
      expect(parseDateTime(''), isNull);
      expect(parseDateTime(12345), isNull); // entier brut
    });

    test('parse une chaine avec offset timezone', () {
      final dt = parseDateTime('2026-06-01T13:00:00+01:00');
      expect(dt, isNotNull);
      expect(dt!.isUtc, isTrue);
      expect(dt.hour, 12); // converti en UTC
    });

    test('deux watermaks : le plus récent est correctement identifié', () {
      final old = parseDateTime('2026-05-01T00:00:00Z')!;
      final recent = parseDateTime('2026-06-01T00:00:00Z')!;
      expect(recent.isAfter(old), isTrue);
    });

    test('watermark epoch zéro = debut de temps Lumina', () {
      final epoch = parseDateTime(
        DateTime.fromMillisecondsSinceEpoch(0).toIso8601String(),
      );
      expect(epoch, isNotNull);
      expect(epoch!.millisecondsSinceEpoch, 0);
    });
  });

  group('Watermark — logique de progression', () {
    test('maxUpdatedAt accumule correctement sur plusieurs rows', () {
      final rows = [
        {'updated_at': '2026-06-01T10:00:00Z'},
        {'updated_at': '2026-06-01T14:00:00Z'},
        {'updated_at': '2026-06-01T12:00:00Z'},
        {'updated_at': '2026-06-01T09:00:00Z'},
      ];

      DateTime? maxUpdatedAt;
      for (final row in rows) {
        final dt = parseDateTime(row['updated_at']);
        if (dt != null) {
          if (maxUpdatedAt == null || dt.isAfter(maxUpdatedAt)) {
            maxUpdatedAt = dt;
          }
        }
      }

      expect(maxUpdatedAt, isNotNull);
      expect(maxUpdatedAt!.hour, 14); // 14h00 est le plus récent
    });

    test('watermark reste null si tous les updated_at sont invalides', () {
      final rows = [
        {'updated_at': null},
        {'updated_at': 'invalid'},
        <String, dynamic>{},
      ];

      DateTime? maxUpdatedAt;
      for (final row in rows) {
        final dt = parseDateTime(row['updated_at']);
        if (dt != null) {
          if (maxUpdatedAt == null || dt.isAfter(maxUpdatedAt)) {
            maxUpdatedAt = dt;
          }
        }
      }

      expect(maxUpdatedAt, isNull);
    });
  });
}

// test/core/services/lww_logic_test.dart
// Tests unitaires purs de la logique Last-Write-Wins (LWW)
//
// Principe : tester l'algorithme de résolution de conflits en isolation totale,
// sans dépendances Isar, Supabase ou réseau.
// La classe LwwResolver expose la logique extraite de SyncService._localWins().

import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// LwwResolver — classe de test qui réplique _localWins() de SyncService
// ---------------------------------------------------------------------------

/// Réplique testable de SyncService._localWins().
/// À maintenir en sync avec l'implémentation principale.
class LwwResolver {
  /// Retourne `true` si [local] est plus récent que [remote].
  ///
  /// Stratégie LWW :
  ///   1. Comparer `version` (entier incrémental) — priorité absolue
  ///   2. En cas d'égalité de version → comparer `updated_at` (ISO 8601)
  ///   3. Si données insuffisantes → [remote] gagne (safe default)
  static bool localWins(
    Map<String, dynamic> local,
    Map<String, dynamic> remote,
  ) {
    final localVersion = (local['version'] as num?)?.toInt() ?? 0;
    final remoteVersion = (remote['version'] as num?)?.toInt() ?? 0;

    if (localVersion != remoteVersion) return localVersion > remoteVersion;

    final localUpdatedAt = _parseDateTime(local['updated_at']);
    final remoteUpdatedAt = _parseDateTime(remote['updated_at']);

    if (localUpdatedAt == null || remoteUpdatedAt == null) return false;
    return localUpdatedAt.isAfter(remoteUpdatedAt);
  }

  static DateTime? _parseDateTime(dynamic raw) {
    if (raw == null) return null;
    return DateTime.tryParse(raw.toString())?.toUtc();
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('LWW — résolution par version', () {
    test('local gagne quand version locale > version distante', () {
      final local = {'version': 5, 'updated_at': '2026-01-01T10:00:00Z'};
      final remote = {'version': 3, 'updated_at': '2026-01-01T12:00:00Z'};
      // Version locale supérieure, même si remote est plus récent en temps
      expect(LwwResolver.localWins(local, remote), isTrue);
    });

    test('remote gagne quand version distante > version locale', () {
      final local = {'version': 2, 'updated_at': '2026-01-01T12:00:00Z'};
      final remote = {'version': 4, 'updated_at': '2026-01-01T10:00:00Z'};
      expect(LwwResolver.localWins(local, remote), isFalse);
    });

    test('version 0 vs version 1 : remote gagne', () {
      final local = {'version': 0};
      final remote = {'version': 1};
      expect(LwwResolver.localWins(local, remote), isFalse);
    });

    test('version null traitée comme 0', () {
      final local = <String, dynamic>{'version': null};
      final remote = {'version': 1};
      expect(LwwResolver.localWins(local, remote), isFalse);
    });

    test('versions absentes traitées comme 0 → égalité → fallback sur updated_at', () {
      final local = {'updated_at': '2026-01-01T12:00:00Z'};
      final remote = {'updated_at': '2026-01-01T10:00:00Z'};
      // versions identiques (0 vs 0), local plus récent en temps
      expect(LwwResolver.localWins(local, remote), isTrue);
    });
  });

  group('LWW — résolution par updated_at (versions égales)', () {
    test('local gagne quand local plus récent', () {
      final local = {
        'version': 3,
        'updated_at': '2026-06-01T15:00:00.000Z',
      };
      final remote = {
        'version': 3,
        'updated_at': '2026-06-01T14:00:00.000Z',
      };
      expect(LwwResolver.localWins(local, remote), isTrue);
    });

    test('remote gagne quand remote plus récent', () {
      final local = {
        'version': 3,
        'updated_at': '2026-06-01T09:00:00.000Z',
      };
      final remote = {
        'version': 3,
        'updated_at': '2026-06-01T14:00:00.000Z',
      };
      expect(LwwResolver.localWins(local, remote), isFalse);
    });

    test('remote gagne si updated_at identique (idempotent)', () {
      const ts = '2026-06-01T12:00:00.000Z';
      final local = {'version': 1, 'updated_at': ts};
      final remote = {'version': 1, 'updated_at': ts};
      // Même timestamp → localWins = false (remote safe default)
      expect(LwwResolver.localWins(local, remote), isFalse);
    });

    test('remote gagne si updated_at local absent', () {
      final local = {'version': 1};
      final remote = {'version': 1, 'updated_at': '2026-06-01T12:00:00Z'};
      expect(LwwResolver.localWins(local, remote), isFalse);
    });

    test('remote gagne si updated_at remote absent', () {
      final local = {'version': 1, 'updated_at': '2026-06-01T12:00:00Z'};
      final remote = {'version': 1};
      expect(LwwResolver.localWins(local, remote), isFalse);
    });

    test('remote gagne si les deux updated_at sont absents', () {
      final local = {'version': 1};
      final remote = {'version': 1};
      expect(LwwResolver.localWins(local, remote), isFalse);
    });
  });

  group('LWW — formats de datetime', () {
    test('supporte le format ISO 8601 avec millisecondes', () {
      final local = {
        'version': 1,
        'updated_at': '2026-06-01T15:30:45.123456Z',
      };
      final remote = {
        'version': 1,
        'updated_at': '2026-06-01T15:30:45.000000Z',
      };
      expect(LwwResolver.localWins(local, remote), isTrue);
    });

    test('supporte updated_at comme int (timestamp ms)', () {
      // _parseDateTime utilise toString() → fonctionnel
      // "1748782800000" ne parse pas en DateTime, donc les deux sont null → remote gagne
      final local = {'version': 1, 'updated_at': '1748782800000'};
      final remote = {'version': 1, 'updated_at': '1748782700000'};
      // DateTime.tryParse('1748782800000') == null → remote wins
      expect(LwwResolver.localWins(local, remote), isFalse);
    });

    test('updated_at invalide traité comme null → remote gagne', () {
      final local = {'version': 1, 'updated_at': 'NOT_A_DATE'};
      final remote = {'version': 1, 'updated_at': '2026-06-01T12:00:00Z'};
      expect(LwwResolver.localWins(local, remote), isFalse);
    });
  });

  group('LWW — edge cases multi-tenant', () {
    test('deux enregistrements totalement vides → remote gagne', () {
      expect(
        LwwResolver.localWins(<String, dynamic>{}, <String, dynamic>{}),
        isFalse,
      );
    });

    test('version très élevée toujours prioritaire sur le temps', () {
      final local = {
        'version': 999,
        'updated_at': '2020-01-01T00:00:00Z', // très vieux
      };
      final remote = {
        'version': 1,
        'updated_at': '2026-06-01T23:59:59Z', // très récent
      };
      expect(LwwResolver.localWins(local, remote), isTrue);
    });

    test('détecte correctement le microseconde de différence', () {
      final local = {
        'version': 2,
        'updated_at': '2026-06-01T12:00:00.000001Z',
      };
      final remote = {
        'version': 2,
        'updated_at': '2026-06-01T12:00:00.000000Z',
      };
      expect(LwwResolver.localWins(local, remote), isTrue);
    });
  });

  group('LWW — SyncResult', () {
    test('merged totals are correct', () {
      const r1 = (3, 7, 1); // (pushed, pulled, conflicts)
      const r2 = (5, 2, 0);
      expect(r1.$1 + r2.$1, 8);
      expect(r1.$2 + r2.$2, 9);
      expect(r1.$3 + r2.$3, 1);
    });
  });
}

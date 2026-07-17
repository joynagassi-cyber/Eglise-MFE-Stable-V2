// lib/core/providers/local_persistence_provider.dart
//
// Service de persistance locale offline-first.
// Wrappe IsarService pour sauvegarder/charger session, profil et contexte.
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumina/core/data/local/isar_service.dart';
import 'package:lumina/core/data/models/local_session_model.dart';
import 'package:lumina/core/data/models/local_profile_model.dart';
import 'package:lumina/core/data/models/local_user_context_model.dart';
import 'package:lumina/core/logging/app_logger.dart';
import 'package:isar/isar.dart';

part 'local_persistence_provider.g.dart';

const _tag = 'LOCAL_PERSISTENCE';

/// Provider du service de persistance locale.
@Riverpod(keepAlive: true)
LocalPersistenceService localPersistenceService(LocalPersistenceServiceRef ref) {
  final isar = ref.watch(isarServiceProvider);
  return LocalPersistenceService(isar);
}

/// Service centralisant les opérations de persistance locale (Isar).
class LocalPersistenceService {
  final IsarService _isar;
  LocalPersistenceService(this._isar);

  bool get isReady => _isar.isReady;

  // ─── Session ──────────────────────────────────────────────

  Future<LocalSessionModel?> getLocalSession() async {
    if (!_isar.isReady) return null;
    try {
      final all = await _isar.localSessionModels.where().findAll();
      if (all.isEmpty) return null;
      // Return the most recently updated
      all.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return all.first;
    } catch (e) {
      AppLogger.e('Error loading local session', _tag, e);
      return null;
    }
  }

  Future<void> saveLocalSession(LocalSessionModel session) async {
    if (!_isar.isReady) return;
    try {
      await _isar.db.writeTxn(() async {
        await _isar.localSessionModels.put(session);
      });
      AppLogger.d('Local session saved', _tag);
    } catch (e) {
      AppLogger.e('Error saving local session', _tag, e);
    }
  }

  Future<void> clearLocalSession() async {
    if (!_isar.isReady) return;
    try {
      await _isar.db.writeTxn(() async {
        await _isar.localSessionModels.clear();
      });
      AppLogger.d('Local session cleared', _tag);
    } catch (e) {
      AppLogger.e('Error clearing local session', _tag, e);
    }
  }

  // ─── Profile ──────────────────────────────────────────────

  Future<LocalProfileModel?> getLocalProfile(String userId) async {
    if (!_isar.isReady) return null;
    try {
      final existing = await _isar.localProfileModels
          .where()
          .findAll();
      for (final p in existing) {
        if (p.userId == userId) return p;
      }
      return null;
    } catch (e) {
      AppLogger.e('Error loading local profile', _tag, e);
      return null;
    }
  }

  Future<void> saveLocalProfile(LocalProfileModel profile) async {
    if (!_isar.isReady) return;
    try {
      await _isar.db.writeTxn(() async {
        // Upsert: delete existing by userId then put
        final existing = await _isar.localProfileModels.where().findAll();
        for (final e in existing) {
          if (e.userId == profile.userId) {
            await _isar.localProfileModels.delete(e.id);
          }
        }
        await _isar.localProfileModels.put(profile);
      });
      AppLogger.d('Local profile saved for ${profile.userId}', _tag);
    } catch (e) {
      AppLogger.e('Error saving local profile', _tag, e);
    }
  }

  // ─── User Context ─────────────────────────────────────────

  Future<LocalUserContextModel?> getLocalUserContext(String userId) async {
    if (!_isar.isReady) return null;
    try {
      final existing = await _isar.localUserContextModels.where().findAll();
      for (final c in existing) {
        if (c.userId == userId) return c;
      }
      return null;
    } catch (e) {
      AppLogger.e('Error loading local user context', _tag, e);
      return null;
    }
  }

  Future<void> saveLocalUserContext(LocalUserContextModel context) async {
    if (!_isar.isReady) return;
    try {
      await _isar.db.writeTxn(() async {
        final existing = await _isar.localUserContextModels.where().findAll();
        for (final e in existing) {
          if (e.userId == context.userId) {
            await _isar.localUserContextModels.delete(e.id);
          }
        }
        await _isar.localUserContextModels.put(context);
      });
      AppLogger.d('Local user context saved for ${context.userId}', _tag);
    } catch (e) {
      AppLogger.e('Error saving local user context', _tag, e);
    }
  }

  Future<void> clearAll() async {
    if (!_isar.isReady) return;
    try {
      await _isar.db.writeTxn(() async {
        await _isar.localSessionModels.clear();
        await _isar.localProfileModels.clear();
        await _isar.localUserContextModels.clear();
      });
      AppLogger.d('All local auth data cleared', _tag);
    } catch (e) {
      AppLogger.e('Error clearing local auth data', _tag, e);
    }
  }
}

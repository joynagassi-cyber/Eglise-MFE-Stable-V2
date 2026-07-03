import 'dart:async';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/local/isar_service.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/services/offline_sync_manager.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../domain/entities/jalon_spirituel.dart';
import '../models/jalon_spirituel_model.dart';
import '../../../../core/utils/app_date_time.dart';

import 'package:lumina/core/providers/supabase_provider.dart';
import 'package:lumina/core/providers/user_context_provider.dart';

/// ═══════════════════════════════════════════════════════════════════════════════
/// JALONS PROVIDER - Riverpod AsyncNotifier SRE
/// ═══════════════════════════════════════════════════════════════════════════════

/// Provider principal pour la liste des jalons
final jalonsProvider =
    AsyncNotifierProvider<JalonsNotifier, List<JalonSpirituel>>(
  () => JalonsNotifier(),
);

/// Provider pour les statistiques des jalons
final jalonsStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final repository = ref.watch(jalonsRepositoryProvider);
  final stats = await repository.getStats();
  return stats;
});

/// Provider pour un jalon spécifique par ID
final jalonByIdProvider = FutureProvider.family<JalonSpirituel?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(jalonsRepositoryProvider);
  return repository.getById(id);
});

/// Provider pour les jalons d'un membre spécifique (celui connecté)
final membreJalonsProvider = FutureProvider<List<MembreJalon>>((ref) async {
  final userContext = ref.watch(userContextNotifierProvider).value;
  final memberId = userContext?.user.memberId;

  if (memberId == null) return [];

  final repository = ref.watch(jalonsRepositoryProvider);
  return repository.getJalonsByMembre(memberId);
});

/// Provider pour les jalons d'un membre spécifique (celui passé en paramètre)
final memberAchievedJalonsProvider =
    FutureProvider.family<List<MembreJalon>, String>((ref, memberId) async {
  final repository = ref.watch(jalonsRepositoryProvider);
  return repository.getJalonsByMembre(memberId);
});

class JalonsNotifier extends AsyncNotifier<List<JalonSpirituel>> {
  @override
  FutureOr<List<JalonSpirituel>> build() async {
    return ref.read(jalonsRepositoryProvider).getAll();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(jalonsRepositoryProvider).getAll());
  }
}

/// Repository provider (singleton)
final jalonsRepositoryProvider = Provider<JalonsRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final isar = ref.watch(isarServiceProvider);
  final syncManager = ref.watch(offlineSyncManagerProvider);
  return JalonsRepository(supabase, isar, syncManager, ref);
});

class JalonsRepository {
  final SupabaseClient _supabase;
  final IsarService _isarService;
  final OfflineSyncManager _syncManager;
  final Ref _ref;

  JalonsRepository(this._supabase, this._isarService, this._syncManager, this._ref);

  String get _churchId => _ref.read(activeChurchIdProvider);

  Future<List<JalonSpirituel>> getAll() async {
    if (!_isarService.isReady) {
      final response = await _supabase
          .from('jalons_spirituels')
          .select()
          .eq('is_active', true)
          .order('order', ascending: true);
      return (response as List).map((json) => JalonSpirituel.fromJson(json)).toList();
    }

    // Sync from remote
    try {
      final response = await _supabase
          .from('jalons_spirituels')
          .select()
          .eq('is_active', true)
          .order('order', ascending: true);

      final jalons = (response as List).map((json) => JalonSpirituel.fromJson(json)).toList();
      
      await _isarService.db.writeTxn(() async {
        for (final j in jalons) {
          await _isarService.db.jalonSpirituelModels.put(JalonSpirituelModel.fromDomain(j));
        }
      });
    } catch (e) {
      AppLogger.w('Failed to sync jalons', 'JALONS_REPO');
    }

    final models = await _isarService.db.jalonSpirituelModels
        .filter()
        .isActiveEqualTo(true)
        .sortByOrder()
        .findAll();
    return models.map((m) => m.toDomain()).toList();
  }

  Future<JalonSpirituel?> getById(String id) async {
    if (_isarService.isReady) {
      final model = await _isarService.db.jalonSpirituelModels.filter().idEqualTo(id).findFirst();
      if (model != null) return model.toDomain();
    }
    
    try {
      final response = await _supabase.from('jalons_spirituels').select().eq('id', id).maybeSingle();
      if (response == null) return null;
      return JalonSpirituel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<void> attribuerJalon({
    required String membreId,
    required String jalonId,
    required DateTime dateRealisation,
    String? lieu,
    String? temoin,
    String? notes,
  }) async {
    final churchId = _churchId;
    final id = AppDateTime.tempId();
    
    final membreJalon = MembreJalon(
      id: id,
      membreId: membreId,
      jalonId: jalonId,
      dateRealisation: dateRealisation,
      lieu: lieu ?? '',
      temoin: temoin ?? '',
      notes: notes ?? '',
      createdAt: DateTime.now(),
    );

    if (_isarService.isReady) {
      await _isarService.db.writeTxn(() async {
        await _isarService.db.membreJalonModels.put(MembreJalonModel.fromDomain(membreJalon)..isSynced = false);
      });

      await _syncManager.registerAction(
        entityType: 'membres_jalons',
        action: 'INSERT',
        payload: membreJalon.toJson(),
        churchId: churchId,
        recordId: id,
      );
    } else {
      await _supabase.from('membres_jalons').insert(membreJalon.toJson());
    }
  }

  Future<List<MembreJalon>> getJalonsByMembre(String membreId) async {
    if (!_isarService.isReady) {
      final response = await _supabase
          .from('membres_jalons')
          .select('*, jalons_spirituels(*)')
          .eq('membre_id', membreId)
          .order('date_realisation', ascending: false);
      return (response as List).map((json) => MembreJalon.fromJson(json)).toList();
    }

    // Sync from remote
    try {
      final response = await _supabase
          .from('membres_jalons')
          .select()
          .eq('membre_id', membreId);
          
      final list = (response as List).map((json) => MembreJalon.fromJson(json)).toList();
      await _isarService.db.writeTxn(() async {
        for (final m in list) {
          await _isarService.db.membreJalonModels.put(MembreJalonModel.fromDomain(m));
        }
      });
    } catch (e) {
      AppLogger.w('Failed to sync membre jalons', 'JALONS_REPO');
    }

    final models = await _isarService.db.membreJalonModels
        .filter()
        .membreIdEqualTo(membreId)
        .sortByDateRealisationDesc()
        .findAll();
    return models.map((m) => m.toDomain()).toList();
  }

  Future<Map<String, int>> getStats() async {
    try {
      final response = await _supabase.from('stats_jalons').select();
      return Map<String, int>.fromEntries(
        (response as List).map((row) => MapEntry(row['id'] as String? ?? '', row['nombre_membres'] as int? ?? 0)),
      );
    } catch (e) {
      return {};
    }
  }
}

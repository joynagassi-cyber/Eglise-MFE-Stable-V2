import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumina/core/logging/app_logger.dart';
import 'package:lumina/features/bergers/domain/entities/visite_pastorale.dart';
import 'package:lumina/features/bergers/data/models/pastoral_visit_model.dart';
import '../../../../core/services/offline_sync_manager.dart';
import '../../../../core/data/local/isar_service.dart';
import '../../../../core/providers/auth_provider.dart';
import 'package:isar/isar.dart';
import '../../../../core/utils/app_date_time.dart';

/// ═══════════════════════════════════════════════════════════════════════════════
/// VISITES PROVIDER - Riverpod AsyncNotifier SRE
///
/// Architecture:
/// • AsyncValue pour états Loading/Error/Data
/// • Auto-refresh via StreamSubscription (Supabase Realtime)
/// • Timeout sur toutes les opérations réseau
/// • Gestion défensive des erreurs PostgrestException
/// • Fallback algorithmique si RPC indisponible
/// ═══════════════════════════════════════════════════════════════════════════════

/// Provider principal pour la liste des visites
final visitesProvider =
    AsyncNotifierProvider<VisitesNotifier, List<VisitePastorale>>(
  () => VisitesNotifier(),
);

/// Provider pour les membres à visiter (prioritaires)
final membresAVisiterProvider = FutureProvider<List<MembreAVisiter>>((
  ref,
) async {
  final repository = ref.watch(visitesRepositoryProvider);
  return repository.getMembresAVisiter();
});

/// Provider pour les statistiques des visites
final visitesStatsProvider = FutureProvider<VisitesStats>((ref) async {
  final repository = ref.watch(visitesRepositoryProvider);
  return repository.getStats();
});

/// Provider filtré par statut
final visitesByStatutProvider =
    FutureProvider.family<List<VisitePastorale>, StatutVisite>((
  ref,
  statut,
) async {
  final repository = ref.watch(visitesRepositoryProvider);
  return repository.getByStatut(statut);
});

/// Repository provider (singleton)
final visitesRepositoryProvider = Provider<VisitesRepository>((ref) {
  final isar = ref.watch(isarServiceProvider);
  final syncManager = ref.watch(offlineSyncManagerProvider);
  return VisitesRepository(ref, isar, syncManager);
});

/// ═══════════════════════════════════════════════════════════════════════════════
/// NOTIFIER - Gestion d'état avec Realtime
/// ═══════════════════════════════════════════════════════════════════════════════

class VisitesNotifier extends AsyncNotifier<List<VisitePastorale>> {
  StreamSubscription? _subscription;

  @override
  FutureOr<List<VisitePastorale>> build() async {
    // Cleanup previous
    ref.onDispose(_cleanup);
    unawaited(_subscription?.cancel());

    // Écoute Realtime pour auto-refresh
    _setupRealtimeSubscription();

    // Chargement initial
    return _fetchWithTimeout();
  }

  void _setupRealtimeSubscription() {
    try {
      final supabase = Supabase.instance.client;
      _subscription =
          supabase.from('visites_pastorales').stream(primaryKey: ['id']).listen(
        (data) => ref.invalidateSelf(),
        onError: (error) {
          _visitesDebugPrint('Realtime Visites error: $error');
        },
      );
    } catch (e) {
      _visitesDebugPrint('Failed to setup realtime: $e');
    }
  }

  Future<List<VisitePastorale>> _fetchWithTimeout() async {
    return await _withTimeout(
      operation: () async {
        final repository = ref.read(visitesRepositoryProvider);
        return await repository.getAll();
      },
      timeoutSeconds: 15,
      errorMessage: 'Timeout: Impossible de charger les visites',
    );
  }

  /// Rafraîchissement manuel
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchWithTimeout());
  }

  /// Création d'une visite
  Future<void> create({
    required String membreId,
    required DateTime dateVisite,
    required String motif,
    String? adresse,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(visitesRepositoryProvider);
      await repository.create(
        membreId: membreId,
        dateVisite: dateVisite,
        motif: motif,
        adresse: adresse,
        notes: notes,
      );
      return _fetchWithTimeout();
    });
  }

  /// Marque une visite comme effectuée
  Future<void> marquerEffectuee(String visiteId,
      {String? notes, required String churchId}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(visitesRepositoryProvider);
      await repository.marquerEffectuee(visiteId,
          notes: notes, churchId: churchId);
      return _fetchWithTimeout();
    });
  }

  /// Annule une visite
  Future<void> annuler(String visiteId, {required String churchId}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(visitesRepositoryProvider);
      await repository.annuler(visiteId, churchId: churchId);
      return _fetchWithTimeout();
    });
  }

  /// Supprime une visite
  Future<void> delete(String visiteId, {required String churchId}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(visitesRepositoryProvider);
      await repository.delete(visiteId, churchId: churchId);
      return _fetchWithTimeout();
    });
  }

  /// Cleanup when notifier is disposed (ref closes subscriptions)
  void _cleanup() {
    _subscription?.cancel();
  }
}

/// ═══════════════════════════════════════════════════════════════════════════════
/// REPOSITORY - Accès données avec défense en profondeur
/// ═══════════════════════════════════════════════════════════════════════════════

class VisitesRepository {
  final Ref _ref;
  final SupabaseClient _supabase;
  final IsarService _isar;
  final OfflineSyncManager _syncManager;

  VisitesRepository(this._ref, this._isar, this._syncManager)
      : _supabase = Supabase.instance.client;

  String get _churchId => _ref.read(activeChurchIdProvider);

  /// Récupère toutes les visites (90 derniers jours par défaut)
  Future<List<VisitePastorale>> getAll() async {
    final dateLimit = AppDateTime.nowUtc().subtract(const Duration(days: 90));

    // 1. Priorité locale si Isar est prêt
    if (_isar.isReady) {
      final localModels = await _isar.pastoralVisitModels
          .filter()
          .dateGreaterThan(dateLimit)
          .sortByDateDesc()
          .findAll();

      if (localModels.isNotEmpty) {
        return localModels.map((m) => m.toVisitePastorale()).toList();
      }
    }

    try {
      final response = await _supabase
          .from('visites_pastorales')
          .select('''
            *,
            membres:membre_id (nom, prenom),
            bergers:berger_id (email)
          ''')
          .gte('date_visite', dateLimit.toIso8601String())
          .order('date_visite', ascending: false);

      final visites = (response as List)
          .map((json) => VisitePastorale.fromJson(json))
          .toList();

      // 2. Mise à jour du cache local
      if (_isar.isReady) {
        unawaited(_isar.db.writeTxn(() async {
          for (final v in visites) {
            await _isar.db.pastoralVisitModels
                .put(PastoralVisitModel.fromVisitePastorale(v));
          }
        }));
      }

      return visites;
    } on PostgrestException catch (e) {
      // 3. Fallback cache local en cas d'erreur réseau
      if (_isar.isReady) {
        final localModels = await _isar.pastoralVisitModels
            .filter()
            .dateGreaterThan(dateLimit)
            .sortByDateDesc()
            .findAll();
        return localModels.map((m) => m.toVisitePastorale()).toList();
      }
      throw _handlePostgrestError(e, 'Erreur lors du chargement des visites');
    }
  }

  /// Récupère les visites filtrées par statut
  Future<List<VisitePastorale>> getByStatut(StatutVisite statut) async {
    try {
      final response = await _supabase.from('visites_pastorales').select('''
            *,
            membres:membre_id (nom, prenom),
            bergers:berger_id (email)
          ''').eq('statut', statut.name).order('date_visite', ascending: false);

      return (response as List)
          .map((json) => VisitePastorale.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw _handlePostgrestError(e, 'Erreur lors du filtrage');
    }
  }

  /// Crée une nouvelle visite
  Future<void> create({
    required String membreId,
    required DateTime dateVisite,
    required String motif,
    String? adresse,
    String? notes,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Utilisateur non authentifié');
    }

    final visite = VisitePastorale(
      id: AppDateTime.nowUtc()
          .millisecondsSinceEpoch
          .toString(), // ID temporaire
      churchId: _churchId,
      membreId: membreId,
      bergerId: userId,
      dateVisite: dateVisite,
      adresse: adresse ?? '',
      motif: motif,
      notes: notes ?? '',
      statut: StatutVisite.planifiee,
    );

    // 1. Sauvegarde locale immédiate
    if (_isar.isReady) {
      await _isar.db.writeTxn(() async {
        await _isar.db.pastoralVisitModels
            .put(PastoralVisitModel.fromVisitePastorale(visite));
      });
    }

    try {
      await _supabase.from('visites_pastorales').insert({
        'id': visite.id,
        'church_id': _churchId,
        'membre_id': membreId,
        'berger_id': userId,
        'date_visite': dateVisite.toIso8601String(),
        'adresse': adresse?.trim() ?? '',
        'motif': motif.trim(),
        'notes': notes?.trim() ?? '',
        'statut': 'planifiee',
      });
    } catch (_) {
      // 2. Mise en file d'attente si échec
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'visites_pastorales',
          action: 'INSERT',
          payload: {
            'id': visite.id,
            'church_id': _churchId,
            'membre_id': membreId,
            'berger_id': userId,
            'date_visite': dateVisite.toIso8601String(),
            'adresse': adresse,
            'motif': motif,
            'notes': notes,
            'statut': 'planifiee',
          },
          recordId: visite.id,
          churchId: _churchId,
        );
      }
    }
  }

  /// Marque une visite comme effectuée
  Future<void> marquerEffectuee(String visiteId,
      {String? notes, required String churchId}) async {
    // 1. Mise à jour locale
    if (_isar.isReady) {
      await _isar.db.writeTxn(() async {
        final existing = await _isar.db.pastoralVisitModels
            .filter()
            .idEqualTo(visiteId)
            .findFirst();
        if (existing != null) {
          existing.status = 'effectuee';
          if (notes != null) existing.notes = notes;
          existing.updatedAt = AppDateTime.nowUtc();
          await _isar.db.pastoralVisitModels.put(existing);
        }
      });
    }

    try {
      final updates = <String, dynamic>{
        'statut': 'effectuee',
        'updated_at': AppDateTime.nowIso(),
      };
      if (notes != null && notes.isNotEmpty) {
        updates['notes'] = notes.trim();
      }

      await _supabase
          .from('visites_pastorales')
          .update(updates)
          .eq('id', visiteId);
    } catch (_) {
      // 2. File d'attente
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'visites_pastorales',
          action: 'UPDATE',
          payload: {
            'id': visiteId,
            'statut': 'effectuee',
            if (notes != null) 'notes': notes,
            'updated_at': AppDateTime.nowIso(),
          },
          recordId: visiteId,
          churchId: churchId,
        );
      }
    }
  }

  /// Annule une visite
  Future<void> annuler(String visiteId, {required String churchId}) async {
    // 1. Mise à jour locale
    if (_isar.isReady) {
      await _isar.db.writeTxn(() async {
        final existing = await _isar.db.pastoralVisitModels
            .filter()
            .idEqualTo(visiteId)
            .findFirst();
        if (existing != null) {
          existing.status = 'annulee';
          existing.updatedAt = AppDateTime.nowUtc();
          await _isar.db.pastoralVisitModels.put(existing);
        }
      });
    }

    try {
      await _supabase.from('visites_pastorales').update({
        'statut': 'annulee',
        'updated_at': AppDateTime.nowIso(),
      }).eq('id', visiteId);
    } catch (_) {
      // 2. File d'attente
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'visites_pastorales',
          action: 'UPDATE',
          payload: {
            'id': visiteId,
            'statut': 'annulee',
            'updated_at': AppDateTime.nowIso(),
          },
          recordId: visiteId,
          churchId: churchId,
        );
      }
    }
  }

  /// Supprime une visite
  Future<void> delete(String visiteId, {required String churchId}) async {
    // 1. Suppression locale
    if (_isar.isReady) {
      await _isar.db.writeTxn(() async {
        await _isar.db.pastoralVisitModels
            .filter()
            .idEqualTo(visiteId)
            .deleteFirst();
      });
    }

    try {
      await _supabase.from('visites_pastorales').delete().eq('id', visiteId);
    } catch (_) {
      // 2. File d'attente
      if (_isar.isReady) {
        await _syncManager.registerAction(
          entityType: 'visites_pastorales',
          action: 'DELETE',
          payload: {'id': visiteId},
          recordId: visiteId,
          churchId: churchId,
        );
      }
    }
  }

  /// Récupère les membres à visiter (prioritaires)
  /// Essaie d'abord la RPC, fallback sur requête manuelle
  Future<List<MembreAVisiter>> getMembresAVisiter() async {
    try {
      // Essai avec la fonction RPC optimisée
      final dateLimite =
          AppDateTime.nowUtc().subtract(const Duration(days: 60));
      final response = await _supabase.rpc(
        'get_membres_a_visiter',
        params: {'p_date_limite': dateLimite.toIso8601String()},
      );

      if (response == null) return [];

      return (response as List)
          .map((json) => MembreAVisiter.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      // Si la RPC n'existe pas (42883), on fait un fallback
      if (e.code == '42883') {
        _visitesDebugPrint('RPC non disponible, fallback manuel');
        return _getMembresAVisiterFallback();
      }
      throw _handlePostgrestError(e, 'Erreur lors du chargement des priorités');
    }
  }

  /// Fallback algorithmique si RPC indisponible
  Future<List<MembreAVisiter>> _getMembresAVisiterFallback() async {
    try {
      final dateLimite =
          AppDateTime.nowUtc().subtract(const Duration(days: 60));

      // Récupère tous les membres actifs
      final membresResponse = await _supabase
          .from('membres')
          .select('id, nom, prenom, telephone, adresse')
          .eq('statut', 'actif');

      final List<MembreAVisiter> result = [];

      for (final membre in membresResponse as List) {
        // Vérifie la dernière visite pour ce membre
        final visiteResponse = await _supabase
            .from('visites_pastorales')
            .select('date_visite')
            .eq('membre_id', membre['id'])
            .eq('statut', 'effectuee')
            .order('date_visite', ascending: false)
            .limit(1)
            .maybeSingle();

        final derniereVisite = visiteResponse != null
            ? DateTime.tryParse(visiteResponse['date_visite'] ?? '')
            : null;

        if (derniereVisite == null || derniereVisite.isBefore(dateLimite)) {
          final jours = derniereVisite != null
              ? AppDateTime.nowUtc().difference(derniereVisite).inDays
              : 9999;

          PrioriteVisite priorite;
          if (jours > 120 || jours == 9999) {
            priorite = PrioriteVisite.haute;
          } else if (jours > 90) {
            priorite = PrioriteVisite.moyenne;
          } else {
            priorite = PrioriteVisite.basse;
          }

          result.add(
            MembreAVisiter(
              id: membre['id'] as String? ?? '',
              nom: '${membre['prenom'] ?? ''} ${membre['nom'] ?? ''}'.trim(),
              prenom: membre['prenom'] as String?,
              derniereVisite: derniereVisite,
              raison: jours == 9999
                  ? 'Jamais visité'
                  : 'Dernière visite il y a $jours jours',
              priorite: priorite,
              telephone: membre['telephone'] as String? ?? '',
              adresse: membre['adresse'] as String? ?? '',
              joursEcoules: jours == 9999 ? 9999 : jours,
            ),
          );
        }
      }

      // Trie par priorité (haute -> basse)
      result.sort((a, b) => b.priorite.index.compareTo(a.priorite.index));
      return result;
    } catch (e) {
      _visitesDebugPrint('Fallback error: $e');
      return [];
    }
  }

  /// Récupère les statistiques des visites
  Future<VisitesStats> getStats() async {
    try {
      final response = await _supabase.from('stats_visites').select();

      int planifiees = 0;
      int effectuees = 0;
      int annulees = 0;

      for (final row in response as List) {
        final statut = row['statut'] as String?;
        final total = row['total'] as int? ?? 0;

        switch (statut) {
          case 'planifiee':
            planifiees = total;
            break;
          case 'effectuee':
            effectuees = total;
            break;
          case 'annulee':
            annulees = total;
            break;
        }
      }

      return VisitesStats(
        planifiees: planifiees,
        effectuees: effectuees,
        annulees: annulees,
      );
    } catch (e) {
      return const VisitesStats();
    }
  }

  /// Gestion défensive des erreurs Postgrest
  Exception _handlePostgrestError(PostgrestException e, String context) {
    final code = e.code;
    final message = e.message;

    switch (code) {
      case 'PGRST116':
        return Exception('$context: Données non trouvées');
      case '23505':
        return Exception('$context: Conflit de données (doublon)');
      case '42501':
        return Exception(
          '$context: Permission refusée - Contactez un administrateur',
        );
      case 'PGRST301':
        return Exception('$context: Session expirée - Reconnectez-vous');
      case '22007':
        return Exception('$context: Format de date invalide');
      default:
        return Exception('$context: $message');
    }
  }
}

/// ═══════════════════════════════════════════════════════════════════════════════
/// UTILITAIRES
/// ═══════════════════════════════════════════════════════════════════════════════

Future<T> _withTimeout<T>({
  required Future<T> Function() operation,
  required int timeoutSeconds,
  required String errorMessage,
}) async {
  try {
    return await operation().timeout(
      Duration(seconds: timeoutSeconds),
      onTimeout: () => throw TimeoutException(errorMessage),
    );
  } on TimeoutException {
    rethrow;
  } catch (e) {
    throw Exception('$errorMessage: $e');
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => 'TimeoutException: $message';
}

void _visitesDebugPrint(String message) {
  AppLogger.d(message, 'VisitesProvider');
}
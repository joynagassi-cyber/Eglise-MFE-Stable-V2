import 'dart:async';
import 'package:lumina/core/providers/auth_provider.dart';
import 'package:lumina/features/churches/domain/entities/church.dart';
import 'package:lumina/features/churches/domain/repositories/church_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumina/core/mixins/auditable_mixin.dart';
import 'package:lumina/core/domain/entities/enums/audit_action.dart';

part 'church_providers.g.dart';

// ==================== Repository Provider ====================

/// Provider du repository d'églises
@riverpod
Future<ChurchRepository> churchRepository(ChurchRepositoryRef ref) async {
  return ref.watch(churchRepositoryProvider.future);
}

// ==================== Églises de l'Utilisateur ====================

/// Provider des églises accessibles par l'utilisateur connecté
@riverpod
Future<List<Church>> userChurches(UserChurchesRef ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];

  final repository = await ref.watch(churchRepositoryProvider.future);
  return repository.getUserChurches(userId);
}

/// Stream des églises de l'utilisateur (temps réel)
@riverpod
Stream<List<Church>> watchUserChurches(WatchUserChurchesRef ref) async* {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    yield [];
    return;
  }

  final repository = await ref.watch(churchRepositoryProvider.future);
  yield* repository.watchUserChurches(userId);
}

// ==================== Église Active ====================

/// Provider de l'église active actuelle
///
/// Récupère l'ID depuis la session active et retourne l'entité Church complète
@riverpod
Future<Church?> activeChurch(ActiveChurchRef ref) async {
  final churchId = ref.watch(activeChurchIdProvider);

  final repository = await ref.watch(churchRepositoryProvider.future);
  return repository.getChurchById(churchId);
}

/// Stream de l'église active (temps réel)
@riverpod
Stream<Church?> watchActiveChurch(WatchActiveChurchRef ref) async* {
  final churchId = ref.watch(activeChurchIdProvider);

  final repository = await ref.watch(churchRepositoryProvider.future);
  yield* repository.watchChurch(churchId);
}

// ==================== Changement d'Église Active ====================

/// Notifier pour changer d'église active
///
/// Utilise le provider Auth pour changer le contexte d'église
@riverpod
class ChurchSwitcher extends _$ChurchSwitcher {
  @override
  FutureOr<void> build() async {}

  /// Change l'église active dans la session
  Future<void> switchToChurch(String churchId) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      // Vérifier que l'église existe
      final repository = await ref.read(churchRepositoryProvider.future);
      final church = await repository.getChurchById(churchId);

      if (church == null) {
        throw Exception('Église introuvable');
      }

      // Vérifier que l'utilisateur a accès à cette église
      final userChurches = await ref.read(userChurchesProvider.future);
      if (!userChurches.any((c) => c.id == churchId)) {
        throw Exception('Accès non autorisé à cette église');
      }

      // Changer le contexte via Auth notifier
      await ref.read(authProvider.notifier).switchChurch(churchId);
    });
  }
}

// ==================== Actions Églises ====================

/// Provider des actions CRUD pour les églises
@riverpod
class ChurchActions extends _$ChurchActions with AuditableMixin {
  @override
  FutureOr<void> build() async {}

  /// Crée une nouvelle église
  Future<Church> createChurch({
    required String name,
    required ChurchType type,
    String? description,
    String? address,
    String? city,
    String? postalCode,
    String? phone,
    String? email,
    String? website,
    String? parentChurchId,
    String? federationId,
  }) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = await ref.read(churchRepositoryProvider.future);

      final church = Church(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        type: type,
        description: description,
        address: address,
        city: city,
        postalCode: postalCode,
        phone: phone,
        email: email,
        website: website,
        parentChurchId: parentChurchId,
        federationId: federationId,
        createdAt: DateTime.now(),
      );

      final created = await repository.createChurch(church);

      // Invalider les caches
      ref.invalidate(userChurchesProvider);
      ref.invalidate(allChurchesProvider);

      // Audit Log: Create Church
      unawaited(logAuditAction(
        ref,
        action: AuditAction.insert,
        entityType: 'churches',
        entityId: created.id,
        newData: created.toJson(),
      ));

      return created;
    }).then((asyncValue) => asyncValue.requireValue);
  }

  /// Met à jour une église existante
  Future<Church> updateChurch(Church church) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = await ref.read(churchRepositoryProvider.future);
      final updated = await repository.updateChurch(church);

      // Invalider les caches
      ref.invalidate(userChurchesProvider);
      ref.invalidate(activeChurchProvider);

      // Audit Log: Update Church
      unawaited(logAuditAction(
        ref,
        action: AuditAction.update,
        entityType: 'churches',
        entityId: updated.id,
        newData: updated.toJson(),
      ));

      return updated;
    }).then((asyncValue) => asyncValue.requireValue);
  }

  /// Supprime une église
  Future<void> deleteChurch(String churchId) async {
    state = const AsyncValue.loading();

    await AsyncValue.guard(() async {
      final repository = await ref.read(churchRepositoryProvider.future);
      await repository.deleteChurch(churchId);

      // Invalider les caches
      ref.invalidate(userChurchesProvider);
      ref.invalidate(allChurchesProvider);

      // Audit Log: Delete Church
      unawaited(logAuditAction(
        ref,
        action: AuditAction.delete,
        entityType: 'churches',
        entityId: churchId,
      ));
    });
  }
}

// ==================== Toutes les Églises ====================

/// Provider de toutes les églises (admin usage)
@riverpod
Future<List<Church>> allChurches(AllChurchesRef ref) async {
  final repository = await ref.watch(churchRepositoryProvider.future);
  return repository.getAllChurches();
}

/// Stream de toutes les églises
@riverpod
Stream<List<Church>> watchAllChurches(WatchAllChurchesRef ref) async* {
  final repository = await ref.watch(churchRepositoryProvider.future);
  yield* repository.watchAllChurches();
}

// ==================== Recherche & Filtres ====================

/// Provider de recherche d'églises
@riverpod
Future<List<Church>> searchChurches(SearchChurchesRef ref, String query) async {
  final repository = await ref.watch(churchRepositoryProvider.future);
  return repository.searchChurches(query);
}

/// Provider de filtrage par type
@riverpod
Future<List<Church>> churchesByType(
  ChurchesByTypeRef ref,
  ChurchType type,
) async {
  final repository = await ref.watch(churchRepositoryProvider.future);
  return repository.getChurchesByType(type);
}

/// Provider de filtrage par ville
@riverpod
Future<List<Church>> churchesByCity(ChurchesByCityRef ref, String city) async {
  final repository = await ref.watch(churchRepositoryProvider.future);
  return repository.getChurchesByCity(city);
}

// ==================== Statistiques ====================

/// Provider des statistiques d'une église
@riverpod
Future<Map<String, dynamic>> churchStats(
  ChurchStatsRef ref,
  String churchId,
) async {
  final repository = await ref.watch(churchRepositoryProvider.future);
  return repository.getChurchStats(churchId);
}

/// Provider du nombre total de membres (toutes églises)
@riverpod
Future<int> totalMemberCount(TotalMemberCountRef ref) async {
  final repository = await ref.watch(churchRepositoryProvider.future);
  return repository.getTotalMemberCount();
}
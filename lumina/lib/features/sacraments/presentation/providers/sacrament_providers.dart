import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import '../../domain/entities/sacrament.dart';
import '../../domain/entities/sacrament_type.dart';
import '../../../../core/mixins/auditable_mixin.dart';
import '../../../../core/domain/entities/enums/audit_action.dart';
import 'dart:async';

/// Provider pour la liste de tous les sacrements
final sacramentsProvider = FutureProvider<List<Sacrament>>((ref) async {
  final repository = ref.watch(sacramentRepositoryProvider);
  return await repository.getSacraments();
});

/// Provider pour un sacrement par ID
final sacramentByIdProvider = FutureProvider.family<Sacrament?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(sacramentRepositoryProvider);
  return await repository.getSacramentById(id);
});

/// Provider pour les sacrements d'un membre spécifique
final memberSacramentsProvider = FutureProvider.family<List<Sacrament>, String>(
  (ref, memberId) async {
    final repository = ref.watch(sacramentRepositoryProvider);
    return await repository.getMemberSacraments(memberId);
  },
);

/// Provider pour filtrer les sacrements par type
final sacramentsByTypeProvider =
    FutureProvider.family<List<Sacrament>, SacramentType>((ref, type) async {
  final repository = ref.watch(sacramentRepositoryProvider);
  return await repository.getSacraments(type: type);
});

/// Provider pour la recherche de sacrements
final sacramentSearchProvider = FutureProvider.family<List<Sacrament>, String>((
  ref,
  query,
) async {
  final repository = ref.watch(sacramentRepositoryProvider);
  return await repository.searchSacraments(query);
});

/// Provider pour vérifier si un membre a un type de sacrement
final hasSacramentProvider =
    FutureProvider.family<bool, ({String memberId, SacramentType type})>((
  ref,
  params,
) async {
  final repository = ref.watch(sacramentRepositoryProvider);
  return await repository.hasSacrament(params.memberId, params.type);
});

/// Notifier pour les actions CRUD sur les sacrements
class SacramentNotifier extends AsyncNotifier<List<Sacrament>> with AuditableMixin {
  @override
  Future<List<Sacrament>> build() async {
    final repository = ref.read(sacramentRepositoryProvider);
    return await repository.getSacraments();
  }

  Future<void> addSacrament(Sacrament sacrament) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(sacramentRepositoryProvider);
      await repository.createSacrament(sacrament);

      // Audit Log: Create Sacrament
      unawaited(logAuditAction(
        ref,
        action: AuditAction.insert,
        entityType: 'sacraments',
        entityId: sacrament.id,
        newData: sacrament.toJson(),
      ));

      return await repository.getSacraments();
    });
  }

  Future<void> updateSacrament(Sacrament sacrament) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(sacramentRepositoryProvider);
      await repository.updateSacrament(sacrament);

      // Audit Log: Update Sacrament
      unawaited(logAuditAction(
        ref,
        action: AuditAction.update,
        entityType: 'sacraments',
        entityId: sacrament.id,
        newData: sacrament.toJson(),
      ));

      return await repository.getSacraments();
    });
  }

  Future<void> deleteSacrament(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(sacramentRepositoryProvider);
      await repository.deleteSacrament(id);

      // Audit Log: Delete Sacrament
      unawaited(logAuditAction(
        ref,
        action: AuditAction.delete,
        entityType: 'sacraments',
        entityId: id,
      ));

      return await repository.getSacraments();
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(sacramentRepositoryProvider);
      return await repository.getSacraments();
    });
  }
}

final sacramentNotifierProvider =
    AsyncNotifierProvider<SacramentNotifier, List<Sacrament>>(
  SacramentNotifier.new,
);

// ============================================================
// FICHIER : lib/core/utils/optimistic_update_mixin.dart
// DESCRIPTION : Mixin réutilisable pour les AsyncNotifier qui gère
//               le pattern optimistic update avec rollback automatique.
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/logging/app_logger.dart';

/// Mixin pour les [AsyncNotifier] qui ajoute le pattern optimistic update.
///
/// L'état est immédiatement mis à jour avec la valeur optimiste,
/// puis l'action asynchrone est exécutée. En cas d'erreur, l'état
/// est restauré à la valeur précédente (rollback).
///
/// Usage dans un AsyncNotifier :
/// ```dart
/// class MyNotifier extends _$MyNotifier with OptimisticUpdateMixin<List<Item>> {
///   @override
///   Future<List<Item>> build() async => fetchItems();
///
///   Future<void> addItem(Item item) async {
///     await optimisticUpdate(
///       optimisticValue: [...state.requireValue, item],
///       action: () => repository.addItem(item),
///       onError: (e) => showErrorSnackbar('Failed to add item'),
///     );
///   }
/// }
/// ```
mixin OptimisticUpdateMixin<T> on AutoDisposeAsyncNotifier<T> {
  /// Exécute une action avec optimistic update et rollback automatique.
  ///
  /// - [optimisticValue] : l'état à afficher immédiatement
  /// - [action] : l'action asynchrone à exécuter (DB call, API call)
  /// - [onError] : callback optionnel appelé en cas d'erreur
  /// - [onSuccess] : callback optionnel appelé après succès
  Future<void> optimisticUpdate({
    required T optimisticValue,
    required Future<void> Function() action,
    void Function(Object error)? onError,
    void Function()? onSuccess,
  }) async {
    // Sauvegarder l'état actuel pour le rollback
    final previousState = state;

    // Appliquer l'état optimiste immédiatement
    state = AsyncData(optimisticValue);

    try {
      // Exécuter l'action réelle
      await action();

      // Succès : l'état optimiste est confirmé
      onSuccess?.call();
      AppLogger.d('Optimistic update confirmed', 'OPTIMISTIC');
    } catch (error, stackTrace) {
      // Échec : rollback à l'état précédent
      state = previousState;

      AppLogger.w(
        'Optimistic update rolled back: $error',
        'OPTIMISTIC',
      );

      // Notifier l'erreur au UI
      onError?.call(error);

      // Aussi setter l'état en erreur pour les listeners
      state = AsyncError(error, stackTrace);

      // Re-build pour retrouver l'état serveur cohérent
      ref.invalidateSelf();
    }
  }
}

/// Version pour les [StateNotifier<AsyncValue<T>>]
/// (providers non-codegen).
mixin OptimisticStateNotifierMixin<T> on StateNotifier<AsyncValue<T>> {
  /// Exécute une action avec optimistic update et rollback automatique.
  Future<void> optimisticAction({
    required T optimisticValue,
    required Future<void> Function() action,
    void Function(Object error)? onError,
    void Function()? onSuccess,
  }) async {
    final previousState = state;

    // Appliquer immédiatement
    state = AsyncData(optimisticValue);

    try {
      await action();
      onSuccess?.call();
    } catch (error, stackTrace) {
      // Rollback
      state = previousState;
      onError?.call(error);
      state = AsyncError(error, stackTrace);
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import '../../../../core/providers/auth_provider.dart'; // activeChurchIdProvider réel
import '../../domain/entities/transaction_category.dart';
import '../../domain/entities/enums/category_type.dart';

// Providers classiques pour éviter les problèmes de génération de code sans build_runner
// activeChurchIdProvider est importé depuis core/providers/auth_provider.dart

final categoryListProvider =
    FutureProvider.family<List<TransactionCategory>, String>((
  ref,
  churchId,
) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getAllCategories(churchId: churchId);
});

final incomeCategoriesProvider =
    FutureProvider.family<List<TransactionCategory>, String>((
  ref,
  churchId,
) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getCategoriesByType(
    churchId: churchId,
    type: CategoryType.income,
  );
});

final expenseCategoriesProvider =
    FutureProvider.family<List<TransactionCategory>, String>((
  ref,
  churchId,
) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getCategoriesByType(
    churchId: churchId,
    type: CategoryType.expense,
  );
});

/// Provider pour les catégories racines par type
final rootCategoriesProvider =
    FutureProvider.family<List<TransactionCategory>, CategoryType?>((
  ref,
  type,
) async {
  final repository = ref.watch(categoryRepositoryProvider);
  final churchId = ref.read(activeChurchIdProvider);
  return repository.getRootCategories(churchId: churchId, type: type);
});

final childCategoriesProvider =
    FutureProvider.family<List<TransactionCategory>, String>((
  ref,
  parentId,
) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getChildCategories(parentId);
});

final categoryByIdProvider =
    FutureProvider.family<TransactionCategory?, String>((ref, id) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getCategoryById(id);
});

final categoriesStreamProvider =
    StreamProvider.family<List<TransactionCategory>, String>((
  ref,
  churchId,
) async* {
  final repository = ref.watch(categoryRepositoryProvider);
  yield* repository.watchCategories(churchId: churchId);
});

final categoryControllerProvider =
    StateNotifierProvider<CategoryController, AsyncValue<void>>((ref) {
  return CategoryController(ref);
});

class CategoryController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  CategoryController(this.ref) : super(const AsyncValue.data(null));

  Future<void> create(TransactionCategory category) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(categoryRepositoryProvider).createCategory(category);
      ref.invalidate(categoryListProvider);
    });
  }

  // Alias pour la compatibilité avec les écrans
  Future<void> createCategory(TransactionCategory category) => create(category);

  Future<void> update(TransactionCategory category) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(categoryRepositoryProvider).updateCategory(category);
      ref.invalidate(categoryListProvider);
    });
  }

  // Alias pour la compatibilité avec les écrans
  Future<void> updateCategory(TransactionCategory category) => update(category);

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(categoryRepositoryProvider).deleteCategory(id);
      ref.invalidate(categoryListProvider);
    });
  }

  // Alias pour la compatibilité avec les écrans
  Future<void> deleteCategory(String id) => delete(id);

  /// Synchronise les catégories avec le serveur
  Future<void> syncCategories() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // Force refresh des données
      ref.invalidate(categoryListProvider);
    });
  }

  /// Seed les catégories par défaut
  Future<void> seedDefaultCategories(String churchId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(categoryRepositoryProvider);
      // Créer les catégories par défaut pour les revenus
      final defaultIncomeCategories = [
        TransactionCategory(
          id: '',
          name: 'Dîmes',
          type: CategoryType.income,
          churchId: churchId,
          iconName: 'payments',
          color: '#4CAF50',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        TransactionCategory(
          id: '',
          name: 'Offrandes',
          type: CategoryType.income,
          churchId: churchId,
          iconName: 'volunteer_activism',
          color: '#8BC34A',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final defaultExpenseCategories = [
        TransactionCategory(
          id: '',
          name: 'Salaires',
          type: CategoryType.expense,
          churchId: churchId,
          iconName: 'money',
          color: '#F44336',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      for (final cat in [
        ...defaultIncomeCategories,
        ...defaultExpenseCategories,
      ]) {
        await repository.createCategory(cat);
      }
      ref.invalidate(categoryListProvider);
    });
  }
}

final categoryActionsProvider = Provider<CategoryController>((ref) {
  return ref.read(categoryControllerProvider.notifier);
});

import '../entities/transaction_category.dart';
import '../entities/enums/category_type.dart';

/// Repository abstrait pour la gestion des catégories de transactions
///
/// Définit le contrat pour la persistance et la récupération des catégories
/// Implémentation: Supabase (remote) + Isar (local/offline)
abstract class CategoryRepository {
  /// Récupère toutes les catégories pour une église donnée
  ///
  /// [churchId] - ID de l'église
  /// [includeInactive] - Inclure les catégories désactivées (défaut: false)
  Future<List<TransactionCategory>> getAllCategories({
    required String churchId,
    bool includeInactive = false,
  });

  /// Récupère les catégories par type
  ///
  /// [churchId] - ID de l'église
  /// [type] - Type de catégorie (income/expense)
  Future<List<TransactionCategory>> getCategoriesByType({
    required String churchId,
    required CategoryType type,
  });

  /// Récupère les catégories racines (sans parent)
  ///
  /// [churchId] - ID de l'église
  /// [type] - Optionnel: filtrer par type
  Future<List<TransactionCategory>> getRootCategories({
    required String churchId,
    CategoryType? type,
  });

  /// Récupère les sous-catégories d'une catégorie parente
  ///
  /// [parentId] - ID de la catégorie parente
  Future<List<TransactionCategory>> getChildCategories(String parentId);

  /// Récupère une catégorie par son ID
  ///
  /// [id] - ID de la catégorie
  /// Retourne null si la catégorie n'existe pas
  Future<TransactionCategory?> getCategoryById(String id);

  /// Crée une nouvelle catégorie
  ///
  /// [category] - La catégorie à créer
  /// Retourne la catégorie créée avec son ID généré
  Future<TransactionCategory> createCategory(TransactionCategory category);

  /// Met à jour une catégorie existante
  ///
  /// [category] - La catégorie avec les modifications
  /// Retourne la catégorie mise à jour
  Future<TransactionCategory> updateCategory(TransactionCategory category);

  /// Supprime une catégorie (soft delete)
  ///
  /// [id] - ID de la catégorie à supprimer
  /// La catégorie est marquée comme inactive au lieu d'être supprimée
  Future<void> deleteCategory(String id);

  /// Supprime définitivement une catégorie (hard delete)
  ///
  /// [id] - ID de la catégorie à supprimer
  ///  Attention: Cette opération est irréversible
  Future<void> permanentlyDeleteCategory(String id);

  /// Réorganise l'ordre des catégories
  ///
  /// [categoryIds] - Liste des IDs dans le nouvel ordre
  Future<void> reorderCategories(List<String> categoryIds);

  /// Synchronise les catégories entre local et remote
  ///
  /// [churchId] - ID de l'église à synchroniser
  Future<void> syncCategories(String churchId);

  /// Initialise les catégories par défaut pour une nouvelle église
  ///
  /// [churchId] - ID de l'église
  /// Crée les catégories prédéfinies (Dîmes, Offrandes, Salaires, etc.)
  Future<void> seedDefaultCategories(String churchId);

  /// Compte le nombre de transactions utilisant une catégorie
  ///
  /// [categoryId] - ID de la catégorie
  /// Utile pour empêcher la suppression de catégories en usage
  Future<int> countTransactionsUsingCategory(String categoryId);

  /// Stream des catégories pour une église (temps réel)
  ///
  /// [churchId] - ID de l'église
  Stream<List<TransactionCategory>> watchCategories({required String churchId});
}
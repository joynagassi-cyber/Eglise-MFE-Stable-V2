// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums/category_type.dart';

part 'transaction_category.freezed.dart';
part 'transaction_category.g.dart';

/// Entité représentant une catégorie de transaction financière
///
/// Supporte une hiérarchie parent/enfant pour organiser les catégories
/// Exemple: "Revenus" (parent) > "Dîmes" (enfant) > "Dîmes Mensuelles" (petit-enfant)
@freezed
class TransactionCategory with _$TransactionCategory {
  const TransactionCategory._();

  const factory TransactionCategory({
    /// Identifiant unique de la catégorie
    required String id,

    /// ID de l'église propriétaire (multi-église support)
    required String churchId,

    /// Nom de la catégorie (ex: "Dîmes", "Salaires Pasteurs")
    required String name,

    /// Type de catégorie (revenu ou dépense)
    required CategoryType type,

    /// ID de la catégorie parente (null si catégorie racine)
    String? parentId,

    /// Nom de l'icône Material (ex: "payments", "church", "volunteer_activism")
    @Default('category') String iconName,

    /// Couleur en format hex (ex: "#4CAF50" pour vert)
    @Default('#9E9E9E') String color,

    /// Indique si cette catégorie peut avoir un budget associé
    @Default(true) bool isBudgetable,

    /// Ordre d'affichage (pour tri personnalisé)
    @Default(0) int sortOrder,

    /// Indique si la catégorie est active (soft delete)
    @Default(true) bool isActive,

    /// Date de création
    DateTime? createdAt,

    /// Date de dernière modification
    DateTime? updatedAt,
  }) = _TransactionCategory;

  factory TransactionCategory.fromJson(Map<String, dynamic> json) =>
      _$TransactionCategoryFromJson(json);

  /// Indique si cette catégorie est une catégorie racine (pas de parent)
  bool get isRoot => parentId == null;

  /// Retourne une copie avec les timestamps mis à jour
  TransactionCategory withTimestamps({bool isNew = false}) {
    final now = DateTime.now();
    return copyWith(createdAt: isNew ? now : createdAt ?? now, updatedAt: now);
  }

  /// Crée une catégorie par défaut pour les revenus
  factory TransactionCategory.defaultIncome({
    required String churchId,
    required String name,
    String? parentId,
    String iconName = 'payments',
    String color = '#4CAF50',
  }) {
    return TransactionCategory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      churchId: churchId,
      name: name,
      type: CategoryType.income,
      parentId: parentId,
      iconName: iconName,
      color: color,
      isBudgetable: true,
      sortOrder: 0,
      isActive: true,
      createdAt: DateTime.now(),
    );
  }

  /// Crée une catégorie par défaut pour les dépenses
  factory TransactionCategory.defaultExpense({
    required String churchId,
    required String name,
    String? parentId,
    String iconName = 'shopping_cart',
    String color = '#F44336',
  }) {
    return TransactionCategory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      churchId: churchId,
      name: name,
      type: CategoryType.expense,
      parentId: parentId,
      iconName: iconName,
      color: color,
      isBudgetable: true,
      sortOrder: 0,
      isActive: true,
      createdAt: DateTime.now(),
    );
  }
}
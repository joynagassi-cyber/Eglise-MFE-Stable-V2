// lib/features/rubriques/data/models/category_model.dart
// Modèle Isar (Persistence locale) pour les catégories de transactions
// Pattern basé sur MemberModel avec stockage JSON pour flexibilité sync

import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/transaction_category.dart';
import '../../domain/entities/enums/category_type.dart';

part 'category_model.g.dart';

@collection
class CategoryModel {
  Id isarId = Isar.autoIncrement;

  @Index()
  late String id; // UUID principal

  @Index()
  late String churchId; // Pour filtrage multi-église

  late String name;

  @Enumerated(EnumType.name)
  late CategoryType type; // income ou expense

  @Index()
  String? parentId; // Pour hiérarchie

  String iconName = 'category';
  String color = '#9E9E9E';

  bool isBudgetable = true;
  int sortOrder = 0;
  bool isActive = true;

  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? lastSyncedAt;

  bool isDeleted = false;
  bool isSynced = true; // Si false, doit être envoyé au backend

  // Stockage JSON complet pour synchronisation complète
  String? jsonData;

  /// Convertir Domain → Data (Isar)
  static CategoryModel fromDomain(TransactionCategory category) {
    return CategoryModel()
      ..id = category.id
      ..churchId = category.churchId
      ..name = category.name
      ..type = category.type
      ..parentId = category.parentId
      ..iconName = category.iconName
      ..color = category.color
      ..isBudgetable = category.isBudgetable
      ..sortOrder = category.sortOrder
      ..isActive = category.isActive
      ..createdAt = category.createdAt
      ..updatedAt = category.updatedAt ?? DateTime.now()
      ..jsonData = jsonEncode(category.toJson());
  }

  /// Convertir Data (Isar) → Domain
  TransactionCategory toDomain() {
    // Si jsonData existe, on l'utilise pour hydrater complètement
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        final json = jsonDecode(jsonData!) as Map<String, dynamic>;
        return TransactionCategory.fromJson(json);
      } catch (e) {
        // Fallback si le JSON est corrompu
      }
    }

    // Fallback: construction manuelle
    return TransactionCategory(
      id: id,
      churchId: churchId,
      name: name,
      type: type,
      parentId: parentId,
      iconName: iconName,
      color: color,
      isBudgetable: isBudgetable,
      sortOrder: sortOrder,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
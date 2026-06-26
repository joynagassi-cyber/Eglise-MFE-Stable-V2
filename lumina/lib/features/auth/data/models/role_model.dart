import 'dart:convert';
import 'package:isar/isar.dart';
import '../../../../core/auth/domain/entities/church_role.dart';
import '../../../../core/auth/domain/entities/enums/permission.dart';
import '../../../../core/auth/domain/entities/enums/role_level.dart';

part 'role_model.g.dart';

/// Modèle Isar pour la persistence des rôles
///
/// Stocke les rôles localement pour l'accès offline.
/// Utilise `jsonData` pour stocker l'entité complète et garantir
/// la synchronisation parfaite avec Supabase.
@collection
class RoleModel {
  RoleModel();

  /// ID auto-incrémenté pour Isar
  Id isarId = Isar.autoIncrement;

  /// Identifiant unique (UUID)
  @Index()
  late String id;

  /// Identifiant de l'église
  @Index()
  late String churchId;

  /// Niveau du rôle (enum stocké comme string)
  @Enumerated(EnumType.name)
  late RoleLevel level;

  /// Nom du rôle
  late String name;

  /// Description du rôle
  String? description;

  /// Liste des permissions (stockées comme enum names)
  late List<String> permissions;

  /// Indique si le rôle est actif
  late bool isActive;

  /// Indique si c'est un rôle système
  late bool isSystemRole;

  /// Date de création
  late DateTime createdAt;

  /// Route initiale de redirection
  late String initialRoute;

  /// Date de dernière modification
  DateTime? updatedAt;

  // ============================================
  // SYNC FLAGS
  // ============================================

  /// Indique si ce rôle a été synchronisé avec le serveur
  @Index()
  late bool isSynced;

  /// Date de dernière synchronisation
  DateTime? lastSyncedAt;

  /// Indique si ce rôle est en attente de suppression sur le serveur
  late bool pendingDeletion;

  // ============================================
  // DONNÉES JSON COMPLÈTES
  // ============================================

  /// Stocke l'entité complète en JSON pour garantir
  /// la synchronisation parfaite avec le serveur
  String? jsonData;

  // ============================================
  // CONVERSION DOMAIN <-> MODEL
  // ============================================

  /// Crée un modèle Isar à partir d'une entité domain
  factory RoleModel.fromDomain(ChurchRole role) {
    return RoleModel()
      ..id = role.id
      ..churchId = role.churchId
      ..level = role.level
      ..name = role.name
      ..description = role.description
      ..permissions =
          role.permissions.map((p) => p.toString().split('.').last).toList()
      ..isActive = role.isActive
      ..isSystemRole = role.isSystemRole
      ..createdAt = role.createdAt
      ..initialRoute = role.initialRoute
      ..updatedAt = role.updatedAt
      ..isSynced = true
      ..pendingDeletion = false
      ..jsonData = jsonEncode(role.toJson());
  }

  /// Convertit le modèle Isar en entité domain
  ChurchRole toDomain() {
    // Convertir les permissions de string à enum
    final permissionSet = permissions
        .map((permName) {
          try {
            return Permission.values.firstWhere(
              (p) => p.toString().split('.').last == permName,
            );
          } catch (e) {
            return null; // Ignorer les permissions inconnues
          }
        })
        .whereType<Permission>()
        .toSet();

    return ChurchRole(
      id: id,
      churchId: churchId,
      level: level,
      name: name,
      description: description,
      permissions: permissionSet,
      isActive: isActive,
      isSystemRole: isSystemRole,
      createdAt: createdAt,
      initialRoute: initialRoute,
      updatedAt: updatedAt,
    );
  }

  /// Crée un modèle depuis les données Supabase
  factory RoleModel.fromSupabase(Map<String, dynamic> data) {
    // Convertir permissions
    final permissionsList = (data['permissions'] as List<dynamic>?)
            ?.map((p) => p.toString())
            .toList() ??
        [];

    return RoleModel()
      ..id = data['id'] ?? ''
      ..churchId = data['church_id'] ?? data['churchId'] ?? ''
      ..level = RoleLevel.values.firstWhere(
        (l) => l.toString().split('.').last == (data['level'] ?? 'membre'),
        orElse: () => RoleLevel.membre,
      )
      ..name = data['name'] ?? ''
      ..description = data['description']
      ..permissions = permissionsList
      ..isActive = data['is_active'] ?? data['isActive'] ?? true
      ..isSystemRole = data['is_system_role'] ?? data['isSystemRole'] ?? false
      ..createdAt =
          DateTime.tryParse(data['created_at'] ?? '') ?? DateTime.now()
      ..initialRoute = data['initial_route'] ?? data['initialRoute'] ?? '/dashboard'
      ..updatedAt = data['updated_at'] != null
          ? DateTime.tryParse(data['updated_at'])
          : null
      ..isSynced = true
      ..lastSyncedAt = DateTime.now()
      ..pendingDeletion = false
      ..jsonData = jsonEncode(data);
  }

  /// Convertit en format Supabase
  Map<String, dynamic> toSupabase() {
    return {
      'church_id': churchId,
      'level': level.toString().split('.').last,
      'name': name,
      'description': description,
      'permissions': permissions,
      'is_active': isActive,
      'is_system_role': isSystemRole,
      'initial_route': initialRoute,
    };
  }
}
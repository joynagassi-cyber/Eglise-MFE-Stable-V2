// lib/core/auth/domain/entities/module.dart
// Entité Module - Définition des modules de l'application

import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums/role_level.dart';

part 'module.freezed.dart';
part 'module.g.dart';

/// Entité Module - Représente un module fonctionnel de l'application
@freezed
class Module with _$Module {
  const factory Module({
    /// ID unique du module
    required String id,

    /// Nom lisible du module
    required String name,

    /// Code unique du module (ex: 'members', 'finance')
    @Default('') String code,

    /// Description du module
    required String description,

    /// Icône du module (code Flutter Icons)
    required String icon,

    /// Catégorie du module (pour regroupement)
    required ModuleCategory category,

    /// Ordre d'affichage
    required int order,

    /// Niveau de confidentialité
    required ModuleVisibility visibility,

    /// Permissions requises par défaut pour accéder à ce module
    @Default([]) List<String> requiredPermissions,

    /// Indique si ce module est public pour toute l'équipe
    @Default(false) bool isPublicTeam,

    /// Routes associées à ce module
    @Default([]) List<String> routes,

    /// Date de création
    required DateTime createdAt,

    /// Dernière modification
    DateTime? updatedAt,

    /// Indique si le module est actif
    @Default(true) bool isActive,
  }) = _Module;

  factory Module.fromJson(Map<String, dynamic> json) => _$ModuleFromJson(json);

  /// Modules par défaut de Lumina
  static List<Module> get defaultModules => [
        // Modules publics équipe (Règle 3)
        Module(
          id: 'eglise',
          name: 'Église',
          description: 'Annuaire et gestion des membres',
          icon: 'church',
          category: ModuleCategory.community,
          order: 1,
          visibility: ModuleVisibility.team,
          isPublicTeam: true,
          requiredPermissions: ['membersView'],
          routes: ['/communaute', '/membres'],
          createdAt: DateTime.now(),
        ),
        Module(
          id: 'evenements',
          name: 'Événements',
          description: 'Calendrier et événements',
          icon: 'event',
          category: ModuleCategory.organization,
          order: 2,
          visibility: ModuleVisibility.team,
          isPublicTeam: true,
          requiredPermissions: ['eventsView'],
          routes: ['/evenements', '/calendrier'],
          createdAt: DateTime.now(),
        ),

        // Modules privés (Règle 2)
        Module(
          id: 'finance',
          name: 'Finance',
          description: 'Transactions et trésorerie',
          icon: 'account_balance_wallet',
          category: ModuleCategory.administration,
          order: 3,
          visibility: ModuleVisibility.private,
          isPublicTeam: false,
          requiredPermissions: ['financeView'],
          routes: ['/finance', '/transactions'],
          createdAt: DateTime.now(),
        ),
        Module(
          id: 'budget',
          name: 'Budget',
          description: 'Planification financière',
          icon: 'savings',
          category: ModuleCategory.administration,
          order: 4,
          visibility: ModuleVisibility.private,
          isPublicTeam: false,
          requiredPermissions: ['budgetView'],
          routes: ['/budget'],
          createdAt: DateTime.now(),
        ),
        Module(
          id: 'statistiques',
          name: 'Statistiques',
          description: 'Analytics et rapports',
          icon: 'analytics',
          category: ModuleCategory.administration,
          order: 5,
          visibility: ModuleVisibility.private,
          isPublicTeam: false,
          requiredPermissions: ['dashboardView'],
          routes: ['/statistiques', '/rapports'],
          createdAt: DateTime.now(),
        ),

        // Modules Super Admin uniquement (Règle 1)
        Module(
          id: 'dashboard',
          name: 'Dashboard Complet',
          description: 'Vue d\'ensemble de tous les modules',
          icon: 'dashboard',
          category: ModuleCategory.administration,
          order: 0,
          visibility: ModuleVisibility.superAdmin,
          isPublicTeam: false,
          requiredPermissions: ['dashboardView'],
          routes: ['/dashboard'],
          createdAt: DateTime.now(),
        ),
        Module(
          id: 'administration',
          name: 'Administration',
          description: 'Gestion des accès et paramètres',
          icon: 'admin_panel_settings',
          category: ModuleCategory.administration,
          order: 10,
          visibility: ModuleVisibility.superAdmin,
          isPublicTeam: false,
          requiredPermissions: ['adminManagePermissions'],
          routes: ['/admin'],
          createdAt: DateTime.now(),
        ),
      ];
}

/// Catégorie de module pour regroupement
enum ModuleCategory {
  @JsonValue('community')
  community('Communauté'),

  @JsonValue('organization')
  organization('Organisation'),

  @JsonValue('administration')
  administration('Administration'),

  @JsonValue('spiritual')
  spiritual('Vie Spirituelle');

  final String label;
  const ModuleCategory(this.label);
}

/// Visibilité du module (qui peut y accéder)
enum ModuleVisibility {
  @JsonValue('public')
  public('Public'),

  @JsonValue('team')
  team('Équipe'),

  @JsonValue('private')
  private('Privé'),

  @JsonValue('super_admin')
  superAdmin('Super Admin');

  final String label;
  const ModuleVisibility(this.label);

  /// Vérifier si un rôle peut accéder à ce niveau de visibilité
  bool canAccess(RoleLevel roleLevel) {
    switch (this) {
      case ModuleVisibility.public:
        return true; // Tout le monde peut accéder
      case ModuleVisibility.team:
        return roleLevel.priority <= RoleLevel.groupLeader.priority;
      case ModuleVisibility.private:
        return roleLevel.priority <= RoleLevel.finance.priority ||
            roleLevel.priority <= RoleLevel.adminTotal.priority;
      case ModuleVisibility.superAdmin:
        return roleLevel == RoleLevel.superadmin ||
            roleLevel == RoleLevel.adminTotal;
    }
  }
}

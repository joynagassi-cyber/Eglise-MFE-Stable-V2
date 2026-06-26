import 'package:lumina/core/theme/lumina_tokens.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/legacy_compatibility_providers.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/auth/domain/entities/enums/permission.dart';

part 'dashboard_modules_provider.g.dart';

enum ModulePriority { critical, frequent, secondary }

class ModuleData {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final String route;
  final int notificationCount;
  final bool isVisible;
  final ModulePriority priority;

  const ModuleData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.route,
    this.notificationCount = 0,
    this.isVisible = true,
    required this.priority,
  });
}

@riverpod
class DashboardModules extends _$DashboardModules {
  @override
  List<ModuleData> build() {
    final hasFinance = ref.watch(
      hasResourcePermissionProvider(
        const PermissionArgs('finance_transaction', 'read'),
      ),
    );
    final hasMembers = ref.watch(
      hasResourcePermissionProvider(const PermissionArgs('member', 'read')),
    );
    final hasAdmin = ref.watch(
      hasResourcePermissionProvider(
        const PermissionArgs('rbac_manager', 'write'),
      ),
    );

    final allModules = [
      // NIVEAU CRITIQUE
      ModuleData(
        id: 'finance',
        title: 'Finance',
        subtitle: 'Dîmes & Offrandes',
        icon: Icons.account_balance_wallet,
        gradient: const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
        ),
        route: AppRoutes.finance,
        isVisible: hasFinance,
        priority: ModulePriority.critical,
      ),
      ModuleData(
        id: 'membres',
        title: 'Membres',
        subtitle: 'Brebis du Seigneur',
        icon: Icons.people,
        gradient: const LinearGradient(
          colors: [LuminaBrand.red, LuminaBrand.orange],
        ),
        route: AppRoutes.brebis,
        isVisible: hasMembers,
        priority: ModulePriority.critical,
      ),
      ModuleData(
        id: 'events',
        title: 'Événements',
        subtitle: 'Agenda & Planning',
        icon: Icons.event,
        gradient: const LinearGradient(
          colors: [LuminaBrand.amber, LuminaBrand.orange],
        ),
        route: AppRoutes.vieSpirituelleEvents,
        isVisible: hasMembers,
        priority: ModulePriority.critical,
      ),
      const ModuleData(
        id: 'messages',
        title: 'Messages',
        subtitle: 'Communication',
        icon: Icons.message,
        gradient: LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
        ),
        route: AppRoutes.communicationMessaging,
        isVisible: true,
        priority: ModulePriority.critical,
      ),

      // NIVEAU FRÉQUENT
      ModuleData(
        id: 'groupes',
        title: 'Groupes',
        subtitle: 'Groupes & Cellules',
        icon: Icons.groups,
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
        ),
        route: AppRoutes.groups,
        isVisible: hasMembers,
        priority: ModulePriority.frequent,
      ),
      ModuleData(
        id: 'vie-spirituelle',
        title: 'Vie Spirituelle',
        subtitle: 'Croissance & Jalons',
        icon: Icons.auto_awesome,
        gradient: const LinearGradient(
          colors: [LuminaBrand.red, LuminaBrand.orange],
        ),
        route: AppRoutes.vieSpirituelle,
        isVisible: hasMembers,
        priority: ModulePriority.frequent,
      ),
      ModuleData(
        id: 'celebrations',
        title: 'Célébrations',
        subtitle: 'Cultes & Services',
        icon: Icons.celebration,
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
        ),
        route: AppRoutes.vieSpirituelleCelebrations,
        isVisible: hasMembers,
        priority: ModulePriority.frequent,
      ),
      ModuleData(
        id: 'bergers',
        title: 'Bergers',
        subtitle: 'Équipe Pastorale',
        icon: Icons.shield,
        gradient: const LinearGradient(
          colors: [Color(0xFF64748B), Color(0xFF475569)],
        ),
        route: AppRoutes.bergers,
        isVisible: hasMembers || hasAdmin,
        priority: ModulePriority.frequent,
      ),

      // NIVEAU SECONDAIRE
      const ModuleData(
        id: 'social',
        title: 'Social',
        subtitle: 'Fil d\'actualité',
        icon: Icons.feed,
        gradient: LinearGradient(
          colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
        ),
        route: AppRoutes.communicationSocial,
        isVisible: true,
        priority: ModulePriority.secondary,
      ),
      ModuleData(
        id: 'ministere',
        title: 'MFE-JC',
        subtitle: 'Administration',
        icon: Icons.admin_panel_settings,
        gradient: const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
        ),
        route: AppRoutes.ministere,
        isVisible: hasAdmin,
        priority: ModulePriority.secondary,
      ),
      ModuleData(
        id: 'sacraments',
        title: 'Sacrements',
        subtitle: 'Baptêmes & Mariages',
        icon: Icons.church,
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
        ),
        route: AppRoutes.sacraments,
        isVisible: hasMembers,
        priority: ModulePriority.secondary,
      ),
      ModuleData(
        id: 'audit',
        title: 'Audit',
        subtitle: 'Journaux & Sécurité',
        icon: Icons.history_edu,
        gradient: const LinearGradient(
          colors: [Color(0xFF475569), Color(0xFF1E293B)],
        ),
        route: AppRoutes.audit,
        isVisible: ref.watch(hasResourcePermissionProvider(
                const PermissionArgs('audit', 'read'))) ||
            hasAdmin,
        priority: ModulePriority.secondary,
      ),
      ModuleData(
        id: 'approvals',
        title: 'Approbations',
        subtitle: 'Validation Flux',
        icon: Icons.fact_check,
        gradient: const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFFF59E0B)],
        ),
        route: AppRoutes.approvals,
        isVisible: ref.watch(hasResourcePermissionProvider(
                const PermissionArgs('finance', 'approve'))) ||
            hasAdmin,
        priority: ModulePriority.secondary,
      ),
      ModuleData(
        id: 'donors',
        title: 'Donateurs',
        subtitle: 'Générosité & Suivi',
        icon: Icons.volunteer_activism,
        gradient: const LinearGradient(
          colors: [LuminaBrand.red, LuminaBrand.orange],
        ),
        route: AppRoutes.donors,
        isVisible: hasFinance || hasAdmin,
        priority: ModulePriority.secondary,
      ),
      ModuleData(
        id: 'bilan',
        title: 'Bilan',
        subtitle: 'Rapports Comptables',
        icon: Icons.account_balance,
        gradient: const LinearGradient(
          colors: [Color(0xFF64748B), Color(0xFF334155)],
        ),
        route: AppRoutes.bilan,
        isVisible: hasFinance || hasAdmin,
        priority: ModulePriority.secondary,
      ),
      ModuleData(
        id: 'churches',
        title: 'Sites',
        subtitle: 'Gestion Multi-campus',
        icon: Icons.location_city,
        gradient: const LinearGradient(
          colors: [Color(0xFF475569), Color(0xFF334155)],
        ),
        route: AppRoutes.churches,
        isVisible: hasAdmin,
        priority: ModulePriority.secondary,
      ),
    ];

    return allModules.where((module) => module.isVisible).toList();
  }

  void refresh() {
    ref.invalidateSelf();
  }
}
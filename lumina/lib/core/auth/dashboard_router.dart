import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/app_routes.dart';
import 'role_resolver.dart';

class DashboardRouter {
  /// Redirige vers le dashboard approprié selon le rôle et le groupe
  static void navigateToCorrectDashboard(
    BuildContext context, {
    required String? groupId,
    required String roleCode,
    bool isSuperAdmin = false,
  }) {
    if (isSuperAdmin) {
      // SuperAdmin reste sur le dashboard global par défaut,
      // mais peut switcher vers n'importe quel groupe via l'UI.
      context.go(AppRoutes.dashboard);
      return;
    }

    if (RoleResolver.isGroupRole(roleCode)) {
      if (groupId != null && groupId.isNotEmpty) {
        context.go(AppRoutes.groupDashboardPath(groupId));
      } else {
        context.go(AppRoutes.dashboard);
      }
    } else {
      // Rôle église ou inconnu -> Dashboard global
      context.go(AppRoutes.dashboard);
    }
  }

  /// Retourne la route de base pour un module spécifique au groupe
  static String getModuleRoute(String groupId, String module) {
    switch (module) {
      case 'finance':
        return AppRoutes.groupFinancePath(groupId);
      case 'events':
        return AppRoutes.groupEventsPath(groupId);
      case 'members':
        return AppRoutes.groupMembersPath(groupId);
      case 'documents':
        return AppRoutes.groupDocumentsPath(groupId);
      default:
        return AppRoutes.groupDashboardPath(groupId);
    }
  }
}

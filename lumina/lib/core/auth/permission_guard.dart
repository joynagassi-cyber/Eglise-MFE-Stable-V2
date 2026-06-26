import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../logging/app_logger.dart';
import '../providers/user_context_provider.dart';

class PermissionGuard {
  /// Vérifie si l'utilisateur a accès au groupId spécifié dans la route
  static String? guardGroupAccess(
      BuildContext context, GoRouterState state, WidgetRef ref) {
    final userContext = ref.read(userContextNotifierProvider).valueOrNull;
    if (userContext == null) return '/login';

    // SuperAdmin bypass
    if (userContext.role.isSuper) {
      final routeGroupCode = state.pathParameters['groupCode'];
      if (routeGroupCode != null) {
        AppLogger.w(
          'SuperAdmin cross-group access: user=${userContext.user.id}, '
          'userGroup=${userContext.group?.code}, targetGroup=$routeGroupCode, '
          'route=${state.uri.path}',
          'PERMISSION_GUARD',
        );
      }
      return null;
    }

    final routeGroupCode = state.pathParameters['groupCode'];

    // Check if user is in the correct group if group-specific
    if (routeGroupCode != null && userContext.group?.code != routeGroupCode) {
      // Tentative de navigation croisée détectée
      return '/access-denied';
    }

    return null;
  }
}

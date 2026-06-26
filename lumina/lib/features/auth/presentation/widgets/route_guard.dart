import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/router/app_routes.dart';

import '../../../../core/auth/domain/entities/enums/permission.dart';
import '../../../../core/auth/domain/entities/auth_state.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/legacy_compatibility_providers.dart';
import 'package:lumina/core/widgets/widgets.dart';
/// Widget de garde de route avec vérification des permissions
///
/// Utilisé pour protéger les routes nécessitant une authentification
/// et/ou des permissions spécifiques.
///
/// Exemple d'utilisation dans GoRouter:
/// ```dart
/// GoRoute(
///   path: '/members',
///   builder: (context, state) => const RouteGuard(
///     requiredPermissions: {Permission.membersView},
///     child: MembersListScreen(),
///   ),
/// )
/// ```
class RouteGuard extends ConsumerWidget {
  /// Enfant à afficher si l'accès est autorisé
  final Widget child;

  /// Permissions requises (toutes doivent être présentes si requireAllPermissions est true)
  final Set<Permission>? requiredPermissions;

  /// Rôles requis (l'utilisateur doit avoir AU MOINS UN de ces rôles)
  final List<RoleLevel>? requiredRoles;

  /// Mode de vérification des permissions
  /// - true: Toutes les permissions doivent être présentes (AND)
  /// - false: Au moins une permission doit être présente (OR)
  final bool requireAllPermissions;

  /// Message personnalisé pour l'accès refusé
  final String? deniedMessage;

  /// Redirection personnalisée en cas d'accès refusé
  final String? redirectTo;

  const RouteGuard({
    super.key,
    required this.child,
    this.requiredPermissions,
    this.requiredRoles,
    this.requireAllPermissions = true,
    this.deniedMessage,
    this.redirectTo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authProvider);

    return authAsync.when(
      data: (user) {
        if (user is AuthUnauthenticated) {
          return _buildUnauthorized(context, 'Veuillez vous connecter');
        }

        UserContext? userContext;
        if (user is AuthAuthenticated) {
          userContext = user.context;
        } else if (user is AuthOnboardingRequired) {
          userContext = user.context;
        }

        if (requiredRoles != null && requiredRoles!.isNotEmpty) {
          final userRole = userContext?.role.level;
          if (userRole == null || !requiredRoles!.contains(userRole)) {
            return _buildForbidden(
              context,
              deniedMessage ??
                  'Vous n\'avez pas le rôle nécessaire pour accéder à cette page',
            );
          }
        }

        if (requiredPermissions != null && requiredPermissions!.isNotEmpty) {
          final isFullAdmin = ref.watch(isFullAdminProvider);
          final skipPermissionCheck = user.isSuperAdmin || isFullAdmin;
          if (!skipPermissionCheck) {
            final hasAccess = requireAllPermissions
                ? ref.watch(hasAllPermissionsProvider(requiredPermissions!))
                : ref.watch(hasAnyPermissionProvider(requiredPermissions!));
            if (!hasAccess) {
              return _buildForbidden(
                context,
                deniedMessage ?? 'Vous n\'avez pas les permissions nécessaires',
              );
            }
          }
        }

        return child;
      },
      loading: () =>
          const Scaffold(body: Center(child: LoadingState())),
      error: (error, stack) {
        final colorScheme = Theme.of(context).colorScheme;
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: LuminaIcon.mega, color: colorScheme.error),
                const SizedBox(height: 16),
                const Text('Impossible de vérifier l\'autorisation'),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context.go(AppRoutes.splash),
                  child: const Text('Retour à l\'accueil'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Construit l'écran d'accès non autorisé (401)
  Widget _buildUnauthorized(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;

    // Rediriger immédiatement vers login si spécifié
    if (redirectTo != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(redirectTo!);
      });
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: LuminaIcon.giga, color: colorScheme.error),
              const SizedBox(height: 24),
              Text(
                'Accès non autorisé',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => context.go(AppRoutes.login),
                icon: const Icon(Icons.login),
                label: const Text('Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit l'écran d'accès interdit (403)
  Widget _buildForbidden(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accès refusé'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.splash),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.block, size: LuminaIcon.giga, color: colorScheme.error),
              const SizedBox(height: 24),
              Text(
                'Accès interdit',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              if (requiredPermissions != null &&
                  requiredPermissions!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Permissions requises:',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...requiredPermissions!.map(
                  (p) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: LuminaIcon.sm,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(p.label),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              OutlinedButton.icon(
                onPressed: () => context.go(AppRoutes.splash),
                icon: const Icon(Icons.home),
                label: const Text('Retour à l\'accueil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper pour créer une route protégée avec GoRouter
///
/// Exemple:
/// ```dart
/// guardedRoute(
///   path: '/finance',
///   permissions: {Permission.financeView},
///   builder: (context, state) => const FinanceScreen(),
/// )
/// ```
GoRoute guardedRoute({
  required String path,
  required Widget Function(BuildContext, GoRouterState) builder,
  Set<Permission>? permissions,
  bool requireAllPermissions = true,
  String? deniedMessage,
  String? redirectTo,
  List<RouteBase>? routes,
}) {
  return GoRoute(
    path: path,
    builder: (context, state) {
      return RouteGuard(
        requiredPermissions: permissions,
        requireAllPermissions: requireAllPermissions,
        deniedMessage: deniedMessage,
        redirectTo: redirectTo,
        child: builder(context, state),
      );
    },
    routes: routes ?? [],
  );
}
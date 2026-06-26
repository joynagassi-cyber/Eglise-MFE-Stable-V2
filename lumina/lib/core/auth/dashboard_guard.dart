import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import 'domain/entities/auth_state.dart';

class DashboardGuard {
  /// Redirige si l'utilisateur n'a pas accès au dashboard spécifique
  static String? checkAccess(
      BuildContext context, GoRouterState state, Ref ref) {
    // FIX: Utilisation de watch pour la réactivité, mais GoRouter guards sont sync.
    // On utilise read pour le guard, mais on s'appuie sur le refreshListenable du routeur
    // pour déclencher la re-vérification.
    final authState = ref.read(authProvider).valueOrNull;

    UserContext? userContext;
    if (authState is AuthAuthenticated) {
      userContext = authState.context;
    } else if (authState is AuthOnboardingRequired) {
      // Bloquer l'accès au dashboard si l'onboarding est requis
      return '/onboarding';
    }

    if (userContext == null) return '/login';

    final type = state.pathParameters['type'];

    // 1. Accès Global (Super Admin)
    if (userContext.role.isSuper) return null;

    // 2. Vérification du Rôle pour le type de dashboard
    if (type != null) {
      // a. Exception: Le dashboard 'generic' est accessible à tous les membres connectés
      if (type == 'generic') {
        return null; // Accès autorisé pour tout utilisateur authentifié
      }

      // b. Vérification via le Groupe Assigné (Source de vérité: DB)
      // On compare le code du groupe de l'utilisateur avec le type demandé dans l'URL
      final userGroupCode = userContext.group?.code;

      if (userGroupCode == null) {
        // L'utilisateur n'a pas de groupe assigné, il ne peut pas accéder aux dashboards spécifiques
        return '/access-denied';
      }

      if (userGroupCode != type) {
        // L'utilisateur tente d'accéder au dashboard d'un autre groupe
        return '/access-denied';
      }
    }

    return null;
  }
}

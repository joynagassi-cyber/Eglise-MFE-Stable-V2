import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import 'domain/entities/auth_state.dart';

class DashboardGuard {
  /// Redirige si l'utilisateur n'a pas accès au dashboard spécifique.
  ///
  /// LOGIQUE DÉTERMINISTE :
  /// 1. Super-admin / admin total → accès immédiat (pas de groupe requis).
  /// 2. Dashboard 'generic' → accessible à tout utilisateur authentifié.
  /// 3. Si l'utilisateur n'a PAS de groupe assigné (group == null) → rediriger
  ///    vers GroupSelectionScreen pour qu'il choisisse un groupe.
  ///    AVANT ce fix : renvoyait vers /access-denied, ce qui bloquait
  ///    indéfiniment tout utilisateur dont active_group_id est NULL en DB
  ///    (cas typique : membre qui vient de choisir son rôle).
  /// 4. Si le groupe ne correspond pas au type demandé → /access-denied.
  static String? checkAccess(
      BuildContext context, GoRouterState state, Ref ref) {
    final authState = ref.read(authProvider).valueOrNull;

    UserContext? userContext;
    if (authState is AuthAuthenticated) {
      userContext = authState.context;
    } else if (authState is AuthOnboardingRequired) {
      return '/onboarding';
    }

    if (userContext == null) return '/login';

    final type = state.pathParameters['type'];

    // 1. Accès Global (Super Admin)
    if (userContext.role.isSuper) return null;

    // 2. Dashboard 'generic' accessible à tous les membres connectés
    if (type == 'generic') return null;

    // 3. Aucun groupe assigné → rediriger vers la liste de groupes
    //    pour que l'utilisateur puisse rejoindre un groupe existant.
    //    IMPORTANT : use only existing routes to keep the redirect valid
    //    until a dedicated GroupSelectionScreen is created.
    if (userContext.group == null || userContext.group!.code.isEmpty) {
      return '/groups';
    }

    // 4. Vérification via le Groupe Assigné (Source de vérité: DB)
    if (userContext.group!.code != type) {
      return '/access-denied';
    }

    return null;
  }
}

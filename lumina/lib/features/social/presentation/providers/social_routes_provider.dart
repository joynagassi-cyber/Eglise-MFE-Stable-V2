// lib/features/social/presentation/providers/social_routes_provider.dart
// Routes supplémentaires pour les fonctionnalités sociales IA
// NOTE: La route /communication/social/detail est déjà définie
// dans communication_routes_provider.dart (sous-route de /communication/social)

import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/navigator_keys.dart';
import '../screens/create_post_screen.dart';
import '../../../auth/presentation/widgets/route_guard.dart';

part 'social_routes_provider.g.dart';

@riverpod
List<RouteBase> socialRoutes(SocialRoutesRef ref) {
  return [
    // Route pour créer un post (écran fullscreen, modale)
    // Utilise rootNavigatorKey pour s'ouvrir par-dessus la navigation shell
    GoRoute(
      path: AppRoutes.communicationSocialCreate,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        fullscreenDialog: true,
        child: const RouteGuard(child: CreatePostScreen()),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
      ),
    ),
  ];
}

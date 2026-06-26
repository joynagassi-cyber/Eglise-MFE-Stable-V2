// lib/features/communication/presentation/providers/communication_routes_provider.dart

import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_animations.dart';
import '../screens/communication_home_screen.dart';
import '../../../annonces/presentation/screens/annonces_screen.dart';
import '../../../annonces/presentation/screens/annonce_detail_screen.dart';
import '../../../messaging/presentation/screens/inbox_screen.dart';
import '../../../messaging/presentation/screens/chat_screen.dart';
import '../../../social/presentation/screens/social_feed_screen.dart';
import '../../../social/presentation/screens/post_detail_screen.dart';
import '../../../social/domain/entities/social_post.dart';
import '../../../tasks/presentation/screens/tasks_screen.dart';
import '../../../tasks/presentation/screens/task_form_screen.dart';
import '../../../auth/presentation/widgets/route_guard.dart';

import '../../../../core/router/navigator_keys.dart';

part 'communication_routes_provider.g.dart';

@riverpod
List<RouteBase> communicationRoutes(CommunicationRoutesRef ref) {

  return [
    GoRoute(
      path: AppRoutes.communication,
      builder: (context, state) => const RouteGuard(
        child: CommunicationHomeScreen(),
      ),
      routes: [
        GoRoute(
          path: 'annonces',
          builder: (context, state) => const RouteGuard(
            child: AnnoncesScreen(),
          ),
          routes: [
            GoRoute(
              path: ':id',
              pageBuilder: (context, state) => AppAnimations.slideRightPage(
                key: state.pageKey,
                child: RouteGuard(
                  child: AnnonceDetailScreen(
                    annonceId: state.pathParameters['id'] ?? '',
                  ),
                ),
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'messaging',
          pageBuilder: (context, state) => AppAnimations.slideRightPage(
            key: state.pageKey,
            child: const RouteGuard(child: InboxScreen()),
          ),
          routes: [
            GoRoute(
              path: ':id',
              pageBuilder: (context, state) => AppAnimations.slideRightPage(
                key: state.pageKey,
                child: RouteGuard(
                  child: ChatScreen(
                    conversationId: state.pathParameters['id'] ?? '',
                  ),
                ),
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'social',
          pageBuilder: (context, state) => AppAnimations.scalePage(
            key: state.pageKey,
            child: const RouteGuard(child: SocialFeedScreen()),
          ),
          routes: [
            GoRoute(
              path: 'detail',
              pageBuilder: (context, state) => AppAnimations.scalePage(
                key: state.pageKey,
                child: RouteGuard(
                  child: PostDetailScreen(post: state.extra as SocialPost),
                ),
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'tasks',
          pageBuilder: (context, state) => AppAnimations.slideRightPage(
            key: state.pageKey,
            child: const RouteGuard(child: TasksScreen()),
          ),
          routes: [
            GoRoute(
              path: 'new',
              parentNavigatorKey: rootNavigatorKey,
              pageBuilder: (context, state) => AppAnimations.slideBottomPage(
                key: state.pageKey,
                child: const RouteGuard(child: TaskFormScreen()),
              ),
            ),
            GoRoute(
              path: 'edit/:id',
              parentNavigatorKey: rootNavigatorKey,
              pageBuilder: (context, state) => AppAnimations.slideBottomPage(
                key: state.pageKey,
                child: RouteGuard(
                  child: TaskFormScreen(taskId: state.pathParameters['id']),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  ];
}

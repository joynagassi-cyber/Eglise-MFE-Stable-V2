// lib/features/groups/presentation/providers/group_routes_provider.dart

import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/router/transition_factory.dart';
import '../screens/group_list_screen.dart';
import '../screens/group_form_screen.dart';
import '../screens/group_detail_screen.dart';
import '../../chorale/presentation/screens/chorale_dashboard_screen.dart';
import '../../hommes/presentation/screens/hommes_dashboard_screen.dart';
import '../../femmes/presentation/screens/femmes_dashboard_screen.dart';
import '../../enfants/presentation/screens/enfants_dashboard_screen.dart';
import '../../intercession/presentation/screens/intercession_dashboard_screen.dart';
import '../../../auth/presentation/widgets/route_guard.dart';
import '../../../../core/auth/domain/entities/enums/permission.dart';

import '../../../../core/router/navigator_keys.dart';

part 'group_routes_provider.g.dart';

@riverpod
List<RouteBase> groupRoutes(GroupRoutesRef ref) {

  return [
    GoRoute(
      path: '/groups',
      builder: (context, state) => const RouteGuard(
        requiredPermissions: {Permission.membersView},
        child: GroupListScreen(),
      ),
      routes: [
        GoRoute(
          path: 'nouveau',
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) => TransitionFactory.buildPage(
            context: context,
            state: state,
            type: PageType.form,
            child: const RouteGuard(
              requiredPermissions: {Permission.membersCreate},
              child: GroupFormScreen(),
            ),
          ),
        ),
        GoRoute(
          path: ':id',
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) => TransitionFactory.buildPage(
            context: context,
            state: state,
            type: PageType.detail,
            child: RouteGuard(
              requiredPermissions: const {Permission.membersView},
              child: GroupDetailScreen(groupId: state.pathParameters['id'] ?? ''),
            ),
          ),
          routes: [
            GoRoute(
              path: 'modifier',
              pageBuilder: (context, state) => TransitionFactory.buildPage(
                context: context,
                state: state,
                type: PageType.form,
                child: RouteGuard(
                  requiredPermissions: const {Permission.membersEdit},
                  child: GroupFormScreen(groupId: state.pathParameters['id']),
                ),
              ),
            ),
            GoRoute(
              path: 'chorale',
              pageBuilder: (context, state) => TransitionFactory.buildPage(
                context: context,
                state: state,
                type: PageType.detail,
                child: RouteGuard(
                  requiredPermissions: const {Permission.membersView},
                  child: ChoraleDashboardScreen(groupId: state.pathParameters['id'] ?? ''),
                ),
              ),
            ),
            GoRoute(
              path: 'hommes',
              pageBuilder: (context, state) => TransitionFactory.buildPage(
                context: context,
                state: state,
                type: PageType.detail,
                child: RouteGuard(
                  requiredPermissions: const {Permission.membersView},
                  child: HommesDashboardScreen(groupId: state.pathParameters['id'] ?? ''),
                ),
              ),
            ),
            GoRoute(
              path: 'femmes',
              pageBuilder: (context, state) => TransitionFactory.buildPage(
                context: context,
                state: state,
                type: PageType.detail,
                child: RouteGuard(
                  requiredPermissions: const {Permission.membersView},
                  child: FemmesDashboardScreen(groupId: state.pathParameters['id'] ?? ''),
                ),
              ),
            ),
            GoRoute(
              path: 'enfants',
              pageBuilder: (context, state) => TransitionFactory.buildPage(
                context: context,
                state: state,
                type: PageType.detail,
                child: const RouteGuard(
                  requiredPermissions: {Permission.membersView},
                  child: EnfantsDashboardScreen(),
                ),
              ),
            ),
            GoRoute(
              path: 'intercession',
              pageBuilder: (context, state) => TransitionFactory.buildPage(
                context: context,
                state: state,
                type: PageType.detail,
                child: RouteGuard(
                  requiredPermissions: const {Permission.membersView},
                  child: IntercessionDashboardScreen(groupId: state.pathParameters['id'] ?? ''),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  ];
}

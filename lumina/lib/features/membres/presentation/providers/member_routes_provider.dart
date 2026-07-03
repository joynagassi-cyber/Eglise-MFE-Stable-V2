// lib/features/membres/presentation/providers/member_routes_provider.dart

import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/transition_factory.dart';
import '../screens/member_list_screen.dart';
import '../screens/member_detail_screen.dart';
import '../screens/member_form_screen.dart';
import '../screens/member_stats_screen.dart';
import '../screens/member_qr_screen.dart';
import '../screens/qr_scanner_screen.dart';
import '../../../auth/presentation/widgets/route_guard.dart';
import '../../../../core/auth/domain/entities/enums/permission.dart';

import '../../../../core/router/navigator_keys.dart';

part 'member_routes_provider.g.dart';

@riverpod
List<RouteBase> memberRoutes(MemberRoutesRef ref) {

  return [
    GoRoute(
      path: AppRoutes.brebis,
      builder: (context, state) => const RouteGuard(
        requiredPermissions: {Permission.membersView},
        child: MemberListScreen(),
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
              child: MemberFormScreen(),
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
              child: MemberDetailScreen(memberId: state.pathParameters['id'] ?? ''),
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
                  child: MemberFormScreen(memberId: state.pathParameters['id']),
                ),
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'stats',
          pageBuilder: (context, state) => TransitionFactory.buildPage(
            context: context,
            state: state,
            type: PageType.modal,
            child: const RouteGuard(
              requiredPermissions: {Permission.membersView},
              child: MemberStatsScreen(),
            ),
          ),
        ),
        GoRoute(
          path: 'qr',
          pageBuilder: (context, state) => TransitionFactory.buildPage(
            context: context,
            state: state,
            type: PageType.form,
            child: const MemberQrScreen(),
          ),
        ),
        GoRoute(
          path: 'scanner',
          pageBuilder: (context, state) => TransitionFactory.buildPage(
            context: context,
            state: state,
            type: PageType.detail,
            child: const RouteGuard(
              requiredPermissions: {Permission.membersView},
              child: QRScannerScreen(),
            ),
          ),
        ),
      ],
    ),
  ];
}

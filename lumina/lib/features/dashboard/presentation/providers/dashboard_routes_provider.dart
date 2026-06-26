// lib/features/dashboard/presentation/providers/dashboard_routes_provider.dart

import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_animations.dart';
import '../screens/home_switcher.dart';
import '../../generic/screens/generic_group_dashboard_screen.dart';
import '../../../finance/presentation/screens/finance_dashboard_screen.dart';
import '../../../events/presentation/screens/events_screen.dart';
import '../../../membres/presentation/screens/member_list_screen.dart';
import '../../../churches/presentation/screens/church_list_screen.dart';
import '../screens/equipe_screen.dart';
import '../screens/communaute_screen.dart';
import '../../../auth/presentation/widgets/route_guard.dart';
import '../../../../core/auth/domain/entities/enums/permission.dart';
import '../../../../core/auth/dashboard_guard.dart';
import '../../../groups/presentation/screens/attendance_screen.dart';
import '../../../groups/presentation/screens/member_transfer_screen.dart';
import '../../../donors/presentation/member_donations_screen.dart';
import '../../../bible/presentation/widgets/bible_view.dart';
import '../../../bible/presentation/screens/bible_reader_screen.dart';
import '../../../bible/presentation/screens/bible_share_studio.dart';
import '../../../bible/presentation/screens/bible_offline_screen.dart';
import '../../../bible/presentation/screens/bible_plans_screen.dart';
import '../../../bible/presentation/screens/bible_plan_detail_screen.dart';
import '../../../bible/presentation/screens/bible_search_screen.dart';
import '../../../bible/presentation/screens/bible_library_screen.dart';
import '../../../sacraments/presentation/screens/sacraments_screen.dart';
import '../../../bergers/presentation/screens/team_list_screen.dart';
import '../../../bergers/presentation/screens/shepherd_detail_screen.dart';
import '../../../bergers/presentation/screens/shepherd_form_screen.dart';
import '../../../bergers/domain/entities/shepherd.dart';

part 'dashboard_routes_provider.g.dart';

@riverpod
List<RouteBase> dashboardRoutes(DashboardRoutesRef ref) {
  return [
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (context, state) => const RouteGuard(child: HomeSwitcher()),
    ),
    GoRoute(
      path: AppRoutes.memberDonations,
      builder: (context, state) => const RouteGuard(child: MemberDonationsScreen()),
    ),
    GoRoute(
      path: '/dashboard/:type',
      redirect: (context, state) => DashboardGuard.checkAccess(context, state, ref),
      builder: (context, state) {
        final type = state.pathParameters['type'] ?? 'generic';
        return GenericGroupDashboardScreen(dashboardType: type);
      },
      routes: [
        GoRoute(
          path: 'bible',
          pageBuilder: (context, state) => AppAnimations.scalePage(
            key: state.pageKey,
            child: const RouteGuard(child: BibleView()),
          ),
        ),
        GoRoute(
          path: 'finance',
          pageBuilder: (context, state) => AppAnimations.scalePage(
            key: state.pageKey,
            child: const RouteGuard(
              requiredPermissions: {Permission.financeView},
              child: FinanceDashboardScreen(),
            ),
          ),
        ),
        GoRoute(
          path: 'events',
          pageBuilder: (context, state) => AppAnimations.scalePage(
            key: state.pageKey,
            child: const RouteGuard(
              requiredPermissions: {Permission.eventsView},
              child: EventsScreen(),
            ),
          ),
        ),
        GoRoute(
          path: 'members',
          pageBuilder: (context, state) => AppAnimations.scalePage(
            key: state.pageKey,
            child: const RouteGuard(
              requiredPermissions: {Permission.membersView},
              child: MemberListScreen(),
            ),
          ),
        ),
        GoRoute(
          path: 'documents',
          builder: (context, state) => RouteGuard(
            requiredPermissions: const {Permission.documentsRead},
            child: Scaffold(
              appBar: AppBar(title: const Text('Gestionnaire de Documents')),
              body: const Center(child: Text('Gestionnaire de Documents')),
            ),
          ),
        ),
        GoRoute(
          path: 'attendance',
          builder: (context, state) => AttendanceScreen(
            groupId: state.pathParameters['type'] == 'group'
                ? (state.uri.pathSegments.length > 2 ? state.uri.pathSegments[2] : '')
                : '',
            date: DateTime.now(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/dashboard/group/:groupId',
      builder: (context, state) {
        final groupId = state.pathParameters['groupId'] ?? '';
        return RouteGuard(child: GenericGroupDashboardScreen(dashboardType: groupId));
      },
      routes: [
        GoRoute(
          path: 'attendance',
          pageBuilder: (context, state) => AppAnimations.slideBottomPage(
            key: state.pageKey,
            child: AttendanceScreen(
              groupId: state.pathParameters['groupId'] ?? '',
              date: DateTime.now(),
            ),
          ),
        ),
        GoRoute(
          path: 'transfer',
          pageBuilder: (context, state) => AppAnimations.slideBottomPage(
            key: state.pageKey,
            child: MemberTransferScreen(groupId: state.pathParameters['groupId'] ?? ''),
          ),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.churches,
      builder: (context, state) => const RouteGuard(child: ChurchListScreen()),
    ),
    GoRoute(
      path: AppRoutes.equipe,
      builder: (context, state) => const RouteGuard(
        requiredPermissions: {Permission.membersView},
        child: EquipeScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.communaute,
      builder: (context, state) => const RouteGuard(
        requiredPermissions: {Permission.membersView},
        child: CommunauteScreen(),
      ),
    ),
    // ─── Sacrements ───
    // Seul l'écran principal est câblé. La vue alternative SacramentListScreen
    // (/sacraments/list) n'est jamais atteinte par l'UI et ses boutons internes
    // pointent vers des routes sans écran (/sacraments/nouveau, /sacraments/:id) :
    // à réparer avant de l'exposer.
    GoRoute(
      path: AppRoutes.sacraments,
      pageBuilder: (context, state) => AppAnimations.scalePage(
        key: state.pageKey,
        child: const RouteGuard(
          requiredPermissions: {Permission.membersView},
          child: SacramentsScreen(),
        ),
      ),
    ),
    // ─── Bergers / Équipe pastorale ───
    GoRoute(
      path: AppRoutes.bergers,
      pageBuilder: (context, state) => AppAnimations.scalePage(
        key: state.pageKey,
        child: const RouteGuard(
          requiredPermissions: {
            Permission.membersView,
            Permission.adminManageRoles,
          },
          requireAllPermissions: false,
          child: TeamListScreen(),
        ),
      ),
      routes: [
        GoRoute(
          path: ':id',
          pageBuilder: (context, state) => AppAnimations.slideRightPage(
            key: state.pageKey,
            child: RouteGuard(
              requiredPermissions: const {Permission.membersView},
              child: ShepherdDetailScreen(
                shepherdId: state.pathParameters['id'] ?? '',
              ),
            ),
          ),
          routes: [
            GoRoute(
              path: 'modifier',
              pageBuilder: (context, state) => AppAnimations.slideBottomPage(
                key: state.pageKey,
                child: RouteGuard(
                  requiredPermissions: const {Permission.adminManageRoles},
                  child: ShepherdFormScreen(
                    shepherd: state.extra as Shepherd?,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.bible,
      builder: (context, state) => const RouteGuard(child: BibleView()),
    ),
    GoRoute(
      path: AppRoutes.bibleReader,
      builder: (context, state) {
        final book = state.pathParameters['book'] ?? 'GEN';
        final chapter = int.tryParse(state.pathParameters['chapter'] ?? '1') ?? 1;
        return RouteGuard(child: BibleReaderScreen(book: book, chapter: chapter));
      },
    ),
    GoRoute(
      path: 'bible-share',
      name: AppRoutes.bibleShareStudio,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        if (extra == null) {
          return const RouteGuard(
            child: Scaffold(body: Center(child: Text('Données de partage non disponibles.'))),
          );
        }
        return RouteGuard(
          child: BibleShareStudio(
            book: extra['book'] as String? ?? '',
            verses: (extra['verses'] as List<int>?) ?? const [],
            content: extra['content'] as String? ?? '',
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.bibleOffline,
      builder: (context, state) => const RouteGuard(child: BibleOfflineScreen()),
    ),
    GoRoute(
      path: AppRoutes.biblePlans,
      builder: (context, state) => const RouteGuard(child: BiblePlansScreen()),
    ),
    GoRoute(
      path: AppRoutes.biblePlanDetail,
      builder: (context, state) {
        final planId = state.pathParameters['planId'] ?? '';
        return RouteGuard(child: BiblePlanDetailScreen(planId: planId));
      },
    ),
    GoRoute(
      path: AppRoutes.bibleSearch,
      builder: (context, state) => const RouteGuard(child: BibleSearchScreen()),
    ),
    GoRoute(
      path: AppRoutes.bibleBookmarks,
      builder: (context, state) => const RouteGuard(child: BibleLibraryScreen()),
    ),
  ];
}
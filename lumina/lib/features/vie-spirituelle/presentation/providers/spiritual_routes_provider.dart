// lib/features/vie-spirituelle/presentation/providers/spiritual_routes_provider.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/transition_factory.dart';
import '../screens/vie_spirituelle_home_screen.dart';
import '../../../events/presentation/screens/events_screen.dart';
import '../../../events/presentation/screens/event_form_screen.dart';
import '../../../events/presentation/screens/event_detail_screen.dart';
import '../../../celebrations/presentation/screens/celebrations_screen.dart';
import '../screens/etapes_spirituelles_screen.dart';
import '../../../mfejc/presentation/screens/ministere_home_screen.dart';
import '../../../rubriques/presentation/screens/category_list_screen.dart';
import '../../../rubriques/presentation/screens/category_form_screen.dart';
import '../../../rubriques/domain/entities/enums/category_type.dart';
import '../../../rubriques/domain/entities/transaction_category.dart';
import '../../../events/presentation/screens/calendar_screen.dart';
import '../../../churches/presentation/screens/church_list_screen.dart';
import '../../../auth/presentation/widgets/route_guard.dart';
import 'package:lumina/core/auth/domain/entities/enums/permission.dart';
import '../../../celebrations/presentation/screens/global_attendance_screen.dart';
import '../../../celebrations/domain/entities/church_service.dart';
import '../../../bible/presentation/screens/bible_plans_screen.dart';
import '../../../bible/presentation/screens/bible_plan_detail_screen.dart';

part 'spiritual_routes_provider.g.dart';

@riverpod
List<RouteBase> spiritualRoutes(SpiritualRoutesRef ref) {
  return [
    GoRoute(
      path: AppRoutes.vieSpirituelle,
      builder: (context, state) => const RouteGuard(
        requiredPermissions: {Permission.membersView},
        child: VieSpirituelleHomeScreen(),
      ),
      routes: [
        GoRoute(
          path: 'events',
          pageBuilder: (context, state) => TransitionFactory.buildPage(
            context: context,
            state: state,
            type: PageType.main,
            child: const RouteGuard(
              requiredPermissions: {Permission.membersView},
              child: EventsScreen(),
            ),
          ),
          routes: [
            GoRoute(
              path: 'new',
              pageBuilder: (context, state) => TransitionFactory.buildPage(
                context: context,
                state: state,
                type: PageType.form,
                child: const RouteGuard(
                  requiredPermissions: {Permission.membersCreate},
                  child: EventFormScreen(),
                ),
              ),
            ),
            GoRoute(
              path: ':id',
              pageBuilder: (context, state) => TransitionFactory.buildPage(
                context: context,
                state: state,
                type: PageType.detail,
                child: RouteGuard(
                  requiredPermissions: const {Permission.membersView},
                  child: EventDetailScreen(eventId: state.pathParameters['id'] ?? ''),
                ),
              ),
              routes: [
                GoRoute(
                  path: 'edit',
                  pageBuilder: (context, state) => TransitionFactory.buildPage(
                    context: context,
                    state: state,
                    type: PageType.form,
                    child: RouteGuard(
                      requiredPermissions: const {Permission.membersEdit},
                      child: EventFormScreen(eventId: state.pathParameters['id']),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: 'celebrations',
          builder: (context, state) => const RouteGuard(
            requiredPermissions: {Permission.membersView},
            child: CelebrationsScreen(),
          ),
          routes: [
            GoRoute(
              path: ':id/attendance',
              builder: (context, state) {
                final serviceId = state.pathParameters['id'] ?? '';
                final service = state.extra as ChurchService?;
                return RouteGuard(
                  requiredPermissions: const {Permission.membersEdit},
                  child: GlobalAttendanceScreen(serviceId: serviceId, service: service),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'jalons',
          pageBuilder: (context, state) => TransitionFactory.buildPage(
            context: context,
            state: state,
            type: PageType.detail,
            child: const RouteGuard(
              requiredPermissions: {Permission.membersView},
              child: EtapesSpirituellesScreen(),
            ),
          ),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.ministere,
      builder: (context, state) => const RouteGuard(
        requiredPermissions: {Permission.adminManageRoles},
        child: MinistereHomeScreen(),
      ),
      routes: [
        GoRoute(
          path: 'rubriques',
          builder: (context, state) => const RouteGuard(
            requiredPermissions: {Permission.adminManageRoles},
            child: CategoryListScreen(),
          ),
          routes: [
            GoRoute(
              path: 'new',
              pageBuilder: (context, state) => TransitionFactory.buildPage(
                context: context,
                state: state,
                type: PageType.form,
                child: RouteGuard(
                  requiredPermissions: const {Permission.adminManageRoles},
                  child: CategoryFormScreen(
                    type: state.extra as CategoryType? ?? CategoryType.income,
                  ),
                ),
              ),
            ),
            GoRoute(
              path: 'edit',
              pageBuilder: (context, state) => TransitionFactory.buildPage(
                context: context,
                state: state,
                type: PageType.detail,
                child: RouteGuard(
                  requiredPermissions: const {Permission.adminManageRoles},
                  child: Builder(
                    builder: (context) {
                      final category = state.extra as TransactionCategory?;
                      return CategoryFormScreen(
                        category: category,
                        type: category?.type ?? CategoryType.income,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'churches',
          builder: (context, state) => const RouteGuard(
            requiredPermissions: {Permission.adminManageRoles},
            child: ChurchListScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/calendrier',
      builder: (context, state) => const RouteGuard(
        requiredPermissions: {Permission.membersView},
        child: CalendarScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.biblePlans,
      builder: (context, state) => const RouteGuard(
        requiredPermissions: {Permission.membersView},
        child: BiblePlansScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.biblePlanDetail,
      builder: (context, state) => RouteGuard(
        requiredPermissions: const {Permission.membersView},
        child: BiblePlanDetailScreen(planId: state.pathParameters['planId'] ?? ''),
      ),
    ),
  ];
}
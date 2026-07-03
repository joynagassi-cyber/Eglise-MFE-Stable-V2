// lib/features/bible/presentation/providers/bible_routes_provider.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/transition_factory.dart';
import '../widgets/bible_view.dart';
import '../screens/bible_reader_screen.dart';
import '../screens/bible_share_studio.dart';
import '../screens/bible_offline_screen.dart';
import '../screens/bible_plans_screen.dart';
import '../screens/bible_plan_detail_screen.dart';
import '../screens/bible_search_screen.dart';
import '../screens/bible_library_screen.dart';
import '../../../auth/presentation/widgets/route_guard.dart';

part 'bible_routes_provider.g.dart';

@riverpod
List<RouteBase> bibleRoutes(BibleRoutesRef ref) {
  return [
    GoRoute(
      path: AppRoutes.bible,
      pageBuilder: (context, state) => TransitionFactory.buildPage(
        context: context,
        state: state,
        type: PageType.main,
        child: const RouteGuard(child: BibleView()),
      ),
    ),
    GoRoute(
      path: AppRoutes.bibleReader,
      pageBuilder: (context, state) => TransitionFactory.buildPage(
        context: context,
        state: state,
        type: PageType.detail,
        child: RouteGuard(
          child: BibleReaderScreen(
            book: state.pathParameters['book'] ?? 'GEN',
            chapter: int.tryParse(state.pathParameters['chapter'] ?? '1') ?? 1,
          ),
        ),
      ),
    ),
    GoRoute(
      path: 'bible-share',
      name: AppRoutes.bibleShareStudio,
      pageBuilder: (context, state) => TransitionFactory.buildPage(
        context: context,
        state: state,
        type: PageType.form,
        child: RouteGuard(
          child: _buildShareStudio(state),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.bibleOffline,
      pageBuilder: (context, state) => TransitionFactory.buildPage(
        context: context,
        state: state,
        type: PageType.detail,
        child: const RouteGuard(child: BibleOfflineScreen()),
      ),
    ),
    GoRoute(
      path: AppRoutes.biblePlans,
      pageBuilder: (context, state) => TransitionFactory.buildPage(
        context: context,
        state: state,
        type: PageType.detail,
        child: const RouteGuard(child: BiblePlansScreen()),
      ),
    ),
    GoRoute(
      path: AppRoutes.biblePlanDetail,
      pageBuilder: (context, state) => TransitionFactory.buildPage(
        context: context,
        state: state,
        type: PageType.detail,
        child: RouteGuard(
          child: BiblePlanDetailScreen(
            planId: state.pathParameters['planId'] ?? '',
          ),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.bibleSearch,
      pageBuilder: (context, state) => TransitionFactory.buildPage(
        context: context,
        state: state,
        type: PageType.form,
        child: const RouteGuard(child: BibleSearchScreen()),
      ),
    ),
    GoRoute(
      path: AppRoutes.bibleBookmarks,
      pageBuilder: (context, state) => TransitionFactory.buildPage(
        context: context,
        state: state,
        type: PageType.detail,
        child: const RouteGuard(child: BibleLibraryScreen()),
      ),
    ),
  ];
}

Widget _buildShareStudio(GoRouterState state) {
  final extra = state.extra as Map<String, dynamic>?;
  if (extra == null) {
    return const Scaffold(body: Center(child: Text('Données de partage non disponibles.')));
  }
  return BibleShareStudio(
    book: extra['book'] as String? ?? '',
    verses: (extra['verses'] as List<int>?) ?? const [],
    content: extra['content'] as String? ?? '',
  );
}
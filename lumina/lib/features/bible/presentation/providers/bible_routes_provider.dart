// lib/features/bible/presentation/providers/bible_routes_provider.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/router/app_routes.dart';
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
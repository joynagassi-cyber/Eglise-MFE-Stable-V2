// lib/features/tutorial/presentation/providers/tutorial_routes_provider.dart

import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/router/app_routes.dart';
import '../screens/tutorial_page.dart';

part 'tutorial_routes_provider.g.dart';

@riverpod
List<RouteBase> tutorialRoutes(TutorialRoutesRef ref) {
  return [
    GoRoute(
      path: AppRoutes.tutorial,
      builder: (context, state) => const TutorialPage(),
    ),
  ];
}
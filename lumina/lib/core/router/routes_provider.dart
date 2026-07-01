// lib/core/router/routes_provider.dart
//
// Provider agrégateur qui collecte toutes les routes des features.

import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/providers/auth_routes_provider.dart';
import '../../features/dashboard/presentation/providers/dashboard_routes_provider.dart';
import '../../features/finance/presentation/providers/finance_routes_provider.dart';
import '../../features/membres/presentation/providers/member_routes_provider.dart';
import '../../features/admin/presentation/providers/admin_routes_provider.dart';
import '../../features/communication/presentation/providers/communication_routes_provider.dart';
import '../../features/vie-spirituelle/presentation/providers/spiritual_routes_provider.dart';
import '../../features/groups/presentation/providers/group_routes_provider.dart';
import '../../features/donors/presentation/providers/donor_routes_provider.dart';
import '../../features/settings/presentation/providers/settings_routes_provider.dart';
import '../../features/bible/presentation/providers/bible_routes_provider.dart';
import '../../features/social/presentation/providers/social_routes_provider.dart';
import '../../features/tutorial/presentation/providers/tutorial_routes_provider.dart';

part 'routes_provider.g.dart';

@riverpod
List<RouteBase> allFeatureRoutes(AllFeatureRoutesRef ref) {
  final routes = <RouteBase>[];

  // Auth & Onboarding
  routes.addAll(ref.watch(authRoutesProvider));

  // Feature routes
  routes.addAll(ref.watch(dashboardRoutesProvider));
  routes.addAll(ref.watch(bibleRoutesProvider));
  routes.addAll(ref.watch(spiritualRoutesProvider));
  routes.addAll(ref.watch(communicationRoutesProvider));
  routes.addAll(ref.watch(financeRoutesProvider));
  routes.addAll(ref.watch(memberRoutesProvider));
  routes.addAll(ref.watch(groupRoutesProvider));
  routes.addAll(ref.watch(donorRoutesProvider));
  routes.addAll(ref.watch(adminRoutesProvider));
  routes.addAll(ref.watch(socialRoutesProvider));
  routes.addAll(ref.watch(settingsRoutesProvider));
  routes.addAll(ref.watch(tutorialRoutesProvider));

  return routes;
}
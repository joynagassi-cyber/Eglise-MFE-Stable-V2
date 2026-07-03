// lib/features/donors/presentation/providers/donor_routes_provider.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/transition_factory.dart';
import '../donor_dashboard_screen.dart';
import '../donor_list_screen.dart';
import '../donor_form_screen.dart';
import '../donor_detail_screen.dart';
import '../donation_form_screen.dart';
import '../../../auth/presentation/widgets/route_guard.dart';
import '../../../../core/auth/domain/entities/enums/permission.dart';

import '../../../../core/router/navigator_keys.dart';

part 'donor_routes_provider.g.dart';

@riverpod
List<RouteBase> donorRoutes(DonorRoutesRef ref) {

  return [
    GoRoute(
      path: AppRoutes.donors,
      pageBuilder: (context, state) => TransitionFactory.buildPage(
        context: context,
        state: state,
        type: PageType.main,
        child: const RouteGuard(
          requiredPermissions: {Permission.financeView},
          child: DonorDashboardScreen(),
        ),
      ),
      routes: [
        GoRoute(
          path: 'list',
          pageBuilder: (context, state) => TransitionFactory.buildPage(
            context: context,
            state: state,
            type: PageType.detail,
            child: const RouteGuard(
              requiredPermissions: {Permission.financeView},
              child: DonorListScreen(),
            ),
          ),
        ),
        GoRoute(
          path: 'new',
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) => TransitionFactory.buildPage(
            context: context,
            state: state,
            type: PageType.form,
            child: const RouteGuard(
              requiredPermissions: {Permission.financeCreate},
              child: DonorFormScreen(),
            ),
          ),
        ),
        GoRoute(
          path: 'edit/:id',
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) => TransitionFactory.buildPage(
            context: context,
            state: state,
            type: PageType.form,
            child: RouteGuard(
              requiredPermissions: const {Permission.financeEdit},
              child: DonorFormScreen(donorId: state.pathParameters['id']),
            ),
          ),
        ),
        GoRoute(
          path: 'detail/:id',
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) => TransitionFactory.buildPage(
            context: context,
            state: state,
            type: PageType.detail,
            child: RouteGuard(
              requiredPermissions: const {Permission.financeView},
              child: DonorDetailScreen(donorId: state.pathParameters['id'] ?? ''),
            ),
          ),
        ),
        GoRoute(
          path: 'record-donation',
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) => TransitionFactory.buildPage(
            context: context,
            state: state,
            type: PageType.form,
            child: Builder(builder: (context) {
              final donorId = state.uri.queryParameters['donorId'];
              return RouteGuard(
                requiredPermissions: const {Permission.financeCreate},
                child: DonationFormScreen(donorId: donorId),
              );
            }),
          ),
        ),
      ],
    ),
  ];
}
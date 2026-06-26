// lib/features/finance/presentation/providers/finance_routes_provider.dart

import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:io';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/transition_factory.dart';
import '../screens/finance_dashboard_screen.dart';
import '../screens/transaction_history_screen.dart';
import '../screens/bank_account_list_screen.dart';
import '../screens/reconciliation_screen.dart';
import '../screens/transaction_details_screen.dart';
import '../../../invoice_capture/presentation/invoice_capture_screen.dart';
import '../../domain/entities/finance_transaction.dart';
import '../../../../core/services/ocr_service.dart';
import '../../../auth/presentation/widgets/route_guard.dart';
import '../../../../core/auth/domain/entities/enums/permission.dart';

import '../../../../core/router/navigator_keys.dart';

part 'finance_routes_provider.g.dart';

@riverpod
List<RouteBase> financeRoutes(FinanceRoutesRef ref) {

  return [
    GoRoute(
      path: AppRoutes.finance,
      pageBuilder: (context, state) => TransitionFactory.buildPage(
        context: context, state: state, type: PageType.main,
        child: const RouteGuard(
          requiredPermissions: {Permission.financeView},
          child: FinanceDashboardScreen(),
        ),
      ),
      routes: [
        GoRoute(
          path: 'history',
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) => TransitionFactory.buildPage(
            context: context, state: state, type: PageType.detail,
            child: const RouteGuard(
              requiredPermissions: {Permission.financeView},
              child: TransactionHistoryScreen(),
            ),
          ),
        ),
        GoRoute(
          path: 'transactions/detail',
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) {
            final transaction = state.extra as FinanceTransaction;
            return TransitionFactory.buildPage(
              context: context, state: state, type: PageType.detail,
              child: RouteGuard(
                requiredPermissions: const {Permission.financeView},
                child: TransactionDetailsScreen(transaction: transaction),
              ),
            );
          },
        ),
        GoRoute(
          path: 'transactions/capture',
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) {
            final onImageSelected = state.extra as void Function(File, InvoiceData?)?;
            return TransitionFactory.buildPage(
              context: context, state: state, type: PageType.form,
              child: RouteGuard(
                requiredPermissions: const {Permission.financeCreate},
                child: InvoiceCaptureScreen(
                  onImageSelected: onImageSelected ?? (file, data) {},
                ),
              ),
            );
          },
        ),
        GoRoute(
          path: 'accounts',
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) => TransitionFactory.buildPage(
            context: context, state: state, type: PageType.detail,
            child: const RouteGuard(
              requiredPermissions: {Permission.financeView},
              child: BankAccountListScreen(),
            ),
          ),
        ),
        GoRoute(
          path: 'reconciliation',
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) => TransitionFactory.buildPage(
            context: context, state: state, type: PageType.form,
            child: const RouteGuard(
              requiredPermissions: {Permission.financeView},
              child: ReconciliationScreen(),
            ),
          ),
        ),
      ],
    ),
  ];
}

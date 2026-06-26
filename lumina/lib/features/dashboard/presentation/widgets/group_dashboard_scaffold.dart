import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/l10n/app_localizations.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/theme/app_breakpoints.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../widgets/kpi_card.dart';
// import '../widgets/quick_action_button.dart';
// Supprimé car inutilisé
import 'premium_dashboard_scaffold.dart';

/// A reusable Premium Scaffold for all Group Dashboards.
/// Wraps PremiumDashboardScaffold with Group-specific logic (KPIs, etc.)
class GroupDashboardScaffold extends ConsumerWidget {
  final String title;
  final String subtitle;
  final AsyncValue<Map<String, dynamic>> dashboardData;
  final VoidCallback onRefresh;
  final List<Widget> quickActions;
  final Widget?
      extraContent; // For events, finances, members lists specific to the group
  final String? bannerImage; // Optional header image

  const GroupDashboardScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.dashboardData,
    required this.onRefresh,
    required this.quickActions,
    this.extraContent,
    this.bannerImage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PremiumDashboardScaffold(
      title: title,
      subtitle: subtitle,
      onRefresh: onRefresh,
      asyncData: switch (dashboardData) {
        AsyncData() => const AsyncSnapshot.withData(ConnectionState.done, null),
        AsyncError(:final error) => AsyncSnapshot.withError(
            ConnectionState.done,
            error,
          ),
        _ => const AsyncSnapshot.nothing(),
      },
      slivers: dashboardData.maybeWhen(
        data: (data) => [
          // KPIs Grid
          _buildKPIsSliver(context, data),

          SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

          // Quick Actions Header
          SliverToBoxAdapter(
            child: SectionHeader(
              title: AppLocalizations.of(context)!.quickActions,
              icon: Icons.bolt,
              iconColor: context.colors.warningText,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

          // Quick Actions Grid
          _buildQuickActionsSliver(context),

          SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

          // Extra Content
          if (extraContent != null) SliverToBoxAdapter(child: extraContent!),
        ],
        orElse: () => [],
      ),
    );
  }

  Widget _buildKPIsSliver(BuildContext context, Map<String, dynamic> data) {
    // Extract stats safely
    final stats = data['stats'] as Map<String, dynamic>? ?? {};
    final balance = (stats['balance'] as num?)?.toDouble() ?? 0.0;
    final income = (stats['income'] as num?)?.toDouble() ?? 0.0;
    final expense = (stats['expense'] as num?)?.toDouble() ?? 0.0;
    final membersCount = (data['members'] as List?)?.length ?? 0;

    return SliverGrid.count(
      crossAxisCount: AppBreakpoints.isMobile(context) ? 2 : 4,
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.4,
      children: [
        KPICard(
          label: AppLocalizations.of(context)!.balance,
          value: '${balance.toStringAsFixed(0)} F',
          icon: Icons.account_balance_wallet,
          color: context.colors.brandPrimary,
        ),
        KPICard(
          label: AppLocalizations.of(context)!.members,
          value: membersCount.toString(),
          icon: Icons.people,
          color: context.colors.brandSecondary,
        ),
        KPICard(
          label: AppLocalizations.of(context)!.incomeMonth,
          value: '${income.toStringAsFixed(0)} F',
          icon: Icons.arrow_downward,
          color: context.colors.successText,
        ),
        KPICard(
          label: AppLocalizations.of(context)!.expenseMonth,
          value: '${expense.toStringAsFixed(0)} F',
          icon: Icons.arrow_upward,
          color: context.colors.errorText,
        ),
      ],
    );
  }

  Widget _buildQuickActionsSliver(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: 3,
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.0, // Square buttons for modern look
      children: quickActions,
    );
  }
}

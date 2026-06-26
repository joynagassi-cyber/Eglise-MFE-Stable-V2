import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/skeletons/fire_skeleton_system.dart';
import '../../../../core/animations/staggered_animations.dart';
import '../../../../core/utils/haptic_helper.dart';
import '../providers/analytics_provider.dart';

class AnalyticsDashboardScreen extends ConsumerWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(dashboardAnalyticsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          label: 'Analytics',
          header: true,
          child: Text('Analytics', style: theme.textTheme.titleLarge),
        ),
        actions: [
          Semantics(
            label: 'Actualiser',
            button: true,
            child: Tooltip(
              message: 'Actualiser',
              child: IconButton(
                icon: const Icon(Icons.refresh, size: AppSpacing.iconMd),
                onPressed: () async {
                  await HapticHelper.light();
                  ref.invalidate(dashboardAnalyticsProvider);
                },
              ),
            ),
          ),
        ],
      ),
      body: analytics.when(
        data: (data) => _buildContent(context, data),
        loading: () => const FireSkeletonDashboard(),
        error: (e, _) => Center(
          child: Text(
            'Impossible de charger les analyses',
            style: theme.textTheme.bodyMedium?.copyWith(color: context.colors.errorText),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Map<String, dynamic> data) {
    final members = data['members'] as Map<String, dynamic>;
    final finance = data['finance'] as Map<String, dynamic>;
    final events = data['events'] as Map<String, dynamic>;
    final currencyFormat = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: 'FCFA',
      decimalDigits: 0,
    );

    final memberCards = [
      StatCard(
        title: 'Total Membres',
        value: members['total'].toString(),
        icon: Icons.people,
        color: context.colors.brandPrimary,
        isPrimary: true, // Hero Metric
      ),
      StatCard(
        title: 'Nouveaux (mois)',
        value: members['newMonth'].toString(),
        icon: Icons.person_add,
        color: context.colors.brandSecondary,
        change: '+${members['growthRate']}%',
      ),
      StatCard(
        title: 'Âge moyen',
        value: '${members['avgAge']} ans',
        icon: Icons.cake,
        color: context.colors.warningText,
      ),
      StatCard(
        title: 'Rétention',
        value: '${members['retention'].toStringAsFixed(1)}%',
        icon: Icons.trending_up,
        color: context.colors.infoText,
      ),
    ];

    final financeCards = [
      StatCard(
        title: 'Revenus',
        value: currencyFormat.format(finance['income']),
        icon: Icons.arrow_downward,
        color: context.colors.successText,
        change: '+${finance['growth']}%',
      ),
      StatCard(
        title: 'Dépenses',
        value: currencyFormat.format(finance['expense']),
        icon: Icons.arrow_upward,
        color: context.colors.errorText,
      ),
      StatCard(
        title: 'Solde Total',
        value: currencyFormat.format(finance['balance']),
        icon: Icons.account_balance,
        color: context.colors.brandPrimary,
        isPrimary: true, // Hero Metric
      ),
      StatCard(
        title: 'Épargne',
        value: '${finance['savingsRate']}%',
        icon: Icons.savings,
        color: context.colors.warningText,
      ),
    ];

    final eventCards = [
      StatCard(
        title: 'Total Événements',
        value: events['total'].toString(),
        icon: Icons.event,
        color: context.colors.brandSecondary,
      ),
      StatCard(
        title: 'À venir',
        value: events['upcoming'].toString(),
        icon: Icons.event_available,
        color: context.colors.brandPrimary,
        isPrimary: true, // Hero Metric
      ),
      StatCard(
        title: 'Participation moy.',
        value: events['avgAttendance'].toString(),
        icon: Icons.people,
        color: context.colors.successText,
      ),
      StatCard(
        title: 'Taux réalisation',
        value: '${events['completionRate']}%',
        icon: Icons.check_circle,
        color: context.colors.infoText,
      ),
    ];

    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        children: [
          StaggeredListItem(
            index: 0,
            child: SectionHeader(
              title: 'Membres',
              icon: Icons.people,
              iconColor: context.colors.brandPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.4,
            ),
            itemCount: memberCards.length,
            itemBuilder: (context, index) => StaggeredListItem(
              index: index + 1,
              child: memberCards[index],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          StaggeredListItem(
            index: 5,
            child: SectionHeader(
              title: 'Finances',
              icon: Icons.account_balance_wallet,
              iconColor: context.colors.successText,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.4,
            ),
            itemCount: financeCards.length,
            itemBuilder: (context, index) => StaggeredListItem(
              index: index + 6,
              child: financeCards[index],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          StaggeredListItem(
            index: 10,
            child: SectionHeader(
              title: 'Événements',
              icon: Icons.event,
              iconColor: context.colors.brandSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.4,
            ),
            itemCount: eventCards.length,
            itemBuilder: (context, index) => StaggeredListItem(
              index: index + 11,
              child: eventCards[index],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../core/theme/app_breakpoints.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'providers/donor_providers.dart';
import 'widgets/monthly_donations_chart.dart';
import '../../dashboard/presentation/widgets/main_drawer.dart';
import '../data/models/donor_models.dart';

class DonorDashboardScreen extends ConsumerWidget {
  const DonorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(donorStatsProvider);

    return Scaffold(
      drawer: const MainDrawer(),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  EdgeInsets.all(AppBreakpoints.horizontalPadding(context)),
              child: statsAsync.when(
                data: (stats) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsGrid(context, stats),
                    const SizedBox(height: AppSpacing.xl),
                    SectionHeader(
                      title: context.l10n.donors_evolution,
                      subtitle: context.l10n.donors_last_6_months,
                      icon: Icons.analytics_outlined,
                      iconColor: context.colors.brandPrimary,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const GlassCard(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: SizedBox(
                        height: 220,
                        child: MonthlyDonationsChart(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SectionHeader(
                      title: context.l10n.donors_active_campaigns,
                      icon: Icons.campaign_outlined,
                      iconColor: context.colors.brandSecondary,
                      trailingLabel: context.l10n.donors_all_campaigns,
                      onTrailingTap: () => context.push(AppRoutes.donorsList),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 140,
                      child: ref.watch(donationCampaignsProvider).when(
                            data: (campaigns) => campaigns.isEmpty
                                ? const Center(
                                    child: EmptyState(
                                      icon: Icons.campaign_outlined,
                                      title: 'Aucune campagne active',
                                      subtitle:
                                          'Les campagnes de dons s\'afficheront ici.',
                                    ),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: campaigns.length,
                                    itemBuilder: (context, index) =>
                                        _buildCampaignCard(
                                            context, campaigns[index]),
                                  ),
                            loading: () => const ShimmerCardList(
                              itemCount: 2,
                              itemHeight: 140,
                              spacing: AppSpacing.md,
                            ),
                            error: (e, _) => const Center(child: Text('Impossible de charger les statistiques')),
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SectionHeader(
                      title: context.l10n.donors_quick_actions,
                      icon: Icons.bolt_rounded,
                      iconColor: context.colors.warningText,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: GradientButton(
                            text: context.l10n.donors_action_list,
                            icon: Icons.people_outline,
                            onPressed: () => context.push(AppRoutes.donorsList),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: GradientButton(
                            text: context.l10n.donors_action_record,
                            icon: Icons.add_card_rounded,
                            onPressed: () =>
                                context.push(AppRoutes.donorsRecordDonation),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                loading: () => const ShimmerCardList(
                  itemCount: 4,
                  itemHeight: 100,
                ),
                error: (e, _) => EmptyState(
                  icon: Icons.error_outline,
                  title: 'Erreur de chargement',
                  subtitle: e.toString(),
                ),
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.donorsNew),
        icon: const Icon(Icons.person_add_rounded),
        label: Text(context.l10n.donors_new_donor),
        backgroundColor: context.colors.brandPrimary,
        foregroundColor: context.colors.textOnBrand,
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: context.colors.brandPrimary,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          context.l10n.donors_title,
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: context.colors.textOnBrand,
          ),
        ),
        centerTitle: true,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(gradient: LinearGradient(
                  colors: [context.colors.brandPrimary, context.colors.brandSecondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                Icons.volunteer_activism_rounded,
                size: 150,
                color: context.colors.textOnBrand.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () => context.push(AppRoutes.donorsList),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context, Map<String, dynamic> stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.4,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _StatCard(
          label: context.l10n.donors_action_list.toUpperCase(),
          value: stats['total_donors'].toString(),
          icon: Icons.people_rounded,
          color: context.colors.infoText,
        ),
        _StatCard(
          label: context.l10n.donors_stat_total,
          value: '${(stats['total_donated'] as num?)?.toStringAsFixed(0) ?? 0}',
          suffix: 'FCFA',
          icon: Icons.monetization_on_rounded,
          color: context.colors.successText,
        ),
        _StatCard(
          label: context.l10n.donors_stat_avg,
          value: '${(stats['avg_donation'] as num?)?.toStringAsFixed(0) ?? 0}',
          suffix: 'FCFA',
          icon: Icons.trending_up_rounded,
          color: context.colors.warningText,
        ),
        _StatCard(
          label: context.l10n.donors_stat_retention,
          value: '${stats['retention_rate']}',
          suffix: '%',
          icon: Icons.repeat_rounded,
          color: context.colors.brandPrimary,
        ),
      ],
    );
  }

  Widget _buildCampaignCard(BuildContext context, DonationCampaign campaign) {
    final progress = campaign.goalAmount > 0
        ? (campaign.currentAmount / campaign.goalAmount).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: AppSpacing.md),
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        borderColor: context.colors.brandPrimary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              campaign.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${campaign.currentAmount.toInt()} / ${campaign.goalAmount.toInt()}',
                  style: TextStyle(
                      fontSize: 10, color: context.colors.textTertiary),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: context.colors.brandPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Semantics(
              label:
                  '${context.l10n.donors_active_campaigns}: ${campaign.title}, ${(progress * 100).toInt()}%',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: AppProgressBar(
                  value: progress,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? suffix;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    this.suffix,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      label: '$label: $value ${suffix ?? ""}',
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        borderColor: color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                if (suffix != null) ...[
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      suffix!,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? context.colors.textTertiary
                            : context.colors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color:
                    isDark ? context.colors.textTertiary : context.colors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

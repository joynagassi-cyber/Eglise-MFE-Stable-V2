import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// import '../../../../core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';

import 'package:lumina/features/bible/core/models/bible_models.dart';
import 'package:lumina/features/bible/data/services/bible_plan_service.dart';
import 'package:lumina/features/bible/data/services/bible_reward_service.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class BiblePlansScreen extends ConsumerWidget {
  const BiblePlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availablePlans = ref.watch(biblePlanServiceProvider);
    final activePlansAsync = ref.watch(activeBiblePlansProvider);
    final rewardsAsync = ref.watch(bibleRewardServiceProvider);

    return Scaffold(
      backgroundColor: context.colors.bgPrimary,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  _buildSectionTitle(context, 'MES PLANS EN COURS'),
                  const SizedBox(height: AppSpacing.md),
                  activePlansAsync.when(
                    data: (active) => active.isEmpty
                        ? _buildEmptyActivePlans(context)
                        : Column(
                            children: active.map((p) {
                              final plan = availablePlans.firstWhere(
                                (ap) => ap.planId == p.planId,
                                orElse: () => availablePlans.first,
                              );
                              final progress = p.completedDays.length / plan.durationInDays;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                                child: _buildPlanCard(
                                  context,
                                  title: plan.title,
                                  description: plan.description,
                                  progress: progress,
                                  duration: '${plan.durationInDays} JOURS',
                                  color: context.colors.accent,
                                  onTap: () => context.push(AppRoutes.biblePlanDetail
                                      .replaceAll(':planId', plan.planId)),
                                ),
                              );
                            }).toList(),
                          ),
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                      child: FireSkeletonHeroCard(),
                    ),
                    error: (e, _) => Text('Erreur: $e'),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _buildSectionTitle(context, 'DÉCOUVRIR LES PLANS'),
                  const SizedBox(height: AppSpacing.md),
                  ...availablePlans.map((plan) {
                    // Skip if already active
                    final isActive = activePlansAsync.valueOrNull?.any((p) => p.planId == plan.planId) ?? false;
                    if (isActive) return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                      child: _buildDiscoveryCard(
                        context,
                        plan: plan,
                        onTap: () => context.push(AppRoutes.biblePlanDetail
                            .replaceAll(':planId', plan.planId)),
                      ),
                    );
                  }),
                  const SizedBox(height: AppSpacing.xl),
                  _buildSectionTitle(context, 'MES RÉCOMPENSES'),
                  const SizedBox(height: AppSpacing.md),
                  _buildRewardsSection(context, rewardsAsync),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: context.colors.bgPrimary,
      surfaceTintColor: context.colors.bgPrimary,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Bible - Plans',
          style: AppTypography.h3.copyWith(color: context.colors.textPrimary),
        ),
        background: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.colors.accent.withOpacity(0.2),
                    context.colors.bgPrimary,
                  ],
                ),
              ),
            ),
            // Decorative circle
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.accent.withOpacity(0.1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: AppTypography.editorialSection.copyWith(
        color: context.colors.accent,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildEmptyActivePlans(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      borderRadius: 24,
      child: Center(
        child: Column(
          children: [
            Icon(Icons.menu_book, size: 40, color: context.colors.textTertiary),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Aucun plan actif',
              style: AppTypography.bodySmallStyle.copyWith(color: context.colors.textSecondary),
            ),
            Text(
              'Commencez un parcours aujourd\'hui.',
              style: AppTypography.caption.copyWith(color: context.colors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String description,
    required double progress,
    required String duration,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      onTap: onTap,
      borderRadius: 24,
      showShine: true,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  duration,
                  style: AppTypography.editorialSection.copyWith(color: color, fontSize: 9),
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: AppTypography.bodySmallStyle.copyWith(color: context.colors.textTertiary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: AppTypography.h3.copyWith(color: context.colors.textPrimary)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            description,
            style: AppTypography.bodySmallStyle.copyWith(color: context.colors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppProgressBar(
            value: progress,
            backgroundColor: context.colors.borderSubtle,
            color: color,
            height: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoveryCard(
    BuildContext context, {
    required BibleReadingPlanModel plan,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      onTap: onTap,
      borderRadius: 16,
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        title: Text(plan.title, style: AppTypography.h4),
        subtitle: Text(
          plan.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodySmallStyle.copyWith(color: context.colors.textSecondary),
        ),
        trailing: Icon(Icons.chevron_right, color: context.colors.textTertiary),
      ),
    );
  }

  Widget _buildRewardsSection(BuildContext context, AsyncValue<List<BibleRewardModel>> rewardsAsync) {
    return rewardsAsync.when(
      data: (rewards) => rewards.isEmpty
          ? _buildEmptyRewards(context)
          : SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: rewards.length,
                itemBuilder: (context, index) {
                  final reward = rewards[index];
                  return Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: AppSpacing.md),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [context.colors.accent, context.colors.accent.withOpacity(0.6)],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        reward.rewardType == 'badge' ? Icons.emoji_events : Icons.description,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
      loading: () => Center(
        child: FireSkeletonAtom.circle(context: context, diameter: 60),
      ),
      error: (e, _) => Text('Erreur: $e'),
    );
  }

  Widget _buildEmptyRewards(BuildContext context) {
    return Text(
      'Complétez votre premier plan pour débloquer des cadeaux.',
      style: AppTypography.bodySmallStyle.copyWith(color: context.colors.textTertiary),
    );
  }
}

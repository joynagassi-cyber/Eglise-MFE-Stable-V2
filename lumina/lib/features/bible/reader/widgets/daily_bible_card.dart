import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
import 'package:lumina/features/bible/data/services/bible_service.dart';
import 'package:lumina/features/bible/data/services/bible_plan_service.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class DailyBibleCard extends ConsumerWidget {
  const DailyBibleCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activePlansAsync = ref.watch(activeBiblePlansProvider);
    final bibleService = ref.read(bibleServiceProvider.notifier);
    final verseOfTheDay = bibleService.getVerseOfTheDay();

    return activePlansAsync.when(
      data: (plans) {
        if (plans.isNotEmpty) {
          final activePlan = plans.first;
          final availablePlans = getAvailablePlans();
          final planDetails = availablePlans.firstWhere(
            (p) => p.planId == activePlan.planId,
            orElse: () => availablePlans.first,
          );

          final currentDayNumber = activePlan.completedDays.isNotEmpty
              ? activePlan.completedDays.last + 1
              : 1;

          final effectiveDayNumber = currentDayNumber > planDetails.days.length
              ? planDetails.days.length
              : currentDayNumber;

          final todayPlan = planDetails.days.firstWhere(
            (d) => d.dayNumber == effectiveDayNumber,
            orElse: () => planDetails.days.first,
          );

          return GlassCard(
            onTap: () {
              context.push(AppRoutes.biblePlanDetail
                  .replaceFirst(':planId', activePlan.planId));
            },
            borderRadius: 24,
            showShine: true,
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.menu_book_rounded,
                            color: context.colors.accent, size: 20),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'PLAN DE LECTURE',
                          style: AppTypography.editorialSection.copyWith(
                              color: context.colors.accent, fontSize: 10),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: context.colors.accent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Continuer',
                        style: TextStyle(
                            color: context.colors.accent,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  planDetails.title,
                  style: AppTypography.h3
                      .copyWith(color: context.colors.textOnBrand, fontSize: 18),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Jour $effectiveDayNumber : ${todayPlan.references?.join(", ") ?? "Aucune référence"}',
                  style: AppTypography.bodySmallStyle
                      .copyWith(color: context.colors.textOnBrand.withOpacity(0.7)),
                ),
                const SizedBox(height: AppSpacing.md),
                AppProgressBar(
                  value: activePlan.completedDays.length /
                      planDetails.durationInDays,
                  backgroundColor: context.colors.textOnBrand.withOpacity(0.1),
                  color: context.colors.accent,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${activePlan.completedDays.length} / ${planDetails.durationInDays} jours complétés',
                  style: AppTypography.labelSmall
                      .copyWith(color: context.colors.textOnBrand.withOpacity(0.6), fontSize: 10),
                ),
              ],
            ),
          );
        }

        // Fallback to Verse of the Day if no active plans
        return _buildVerseOfTheDayCard(context, verseOfTheDay);
      },
      loading: () => const FireSkeletonHeroCard(),
      error: (_, __) => _buildVerseOfTheDayCard(context, verseOfTheDay),
    );
  }

  Widget _buildVerseOfTheDayCard(
      BuildContext context, Map<String, String> verseOfTheDay) {
    return GlassCard(
      onTap: () {
        context.push(AppRoutes.biblePlans);
      },
      borderRadius: 24,
      showShine: true,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_stories_rounded,
                      color: context.colors.accent, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'VERSET DU JOUR',
                    style: AppTypography.editorialSection
                        .copyWith(color: context.colors.accent, fontSize: 10),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: context.colors.accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Plans',
                  style: TextStyle(
                      color: context.colors.accent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            "${verseOfTheDay['text']}",
            style: AppTypography.h3.copyWith(
              color: context.colors.textOnBrand,
              fontSize: 16,
              height: 1.4,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                verseOfTheDay['ref'] ?? '',
                style: AppTypography.bodySmallStyle.copyWith(
                    color: context.colors.textOnBrand.withOpacity(0.6), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// import '../../../../core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/router/app_routes.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/features/bible/core/models/bible_models.dart';
import 'package:lumina/features/bible/data/services/bible_plan_service.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class BiblePlanDetailScreen extends ConsumerWidget {
  final String planId;
  const BiblePlanDetailScreen({super.key, required this.planId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availablePlans = ref.watch(biblePlanServiceProvider);
    
    if (availablePlans.isEmpty) {
      return Scaffold(body: Center(child: FireSkeletonHeroCard()));
    }

    final plan = availablePlans.firstWhere(
      (p) => p.planId == planId,
      orElse: () => availablePlans.first,
    );

    final activePlansAsync = ref.watch(activeBiblePlansProvider);
    
    return activePlansAsync.when(
      loading: () => Scaffold(body: Center(child: FireSkeletonHeroCard())),
      error: (err, _) => Scaffold(body: Center(child: Text('Erreur: $err'))),
      data: (activePlans) {
        final progress = activePlans.firstWhere(
          (p) => p.planId == planId,
          orElse: () => BiblePlanProgressModel(),
        );
        final isActive = progress.planId == planId;

        return Scaffold(
          backgroundColor: context.colors.bgPrimary,
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, plan, isActive, ref),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final day = plan.days[index];
                      final isCompleted = progress.completedDays.contains(day.dayNumber);
                      final isToday = isActive &&
                          !isCompleted &&
                          (index == 0 || progress.completedDays.contains(plan.days[index - 1].dayNumber));

                      return _buildDayTile(
                        context,
                        ref: ref,
                        planId: planId,
                        day: day,
                        isCompleted: isCompleted,
                        isToday: isToday,
                        isActive: isActive,
                      );
                    },
                    childCount: plan.days.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context, BibleReadingPlanModel plan, bool isActive, WidgetRef ref) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: context.colors.bgPrimary,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 48, bottom: 16),
        title: Text(
          plan.title,
          style: AppTypography.h3.copyWith(color: context.colors.textPrimary),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    context.colors.accent.withOpacity(0.3),
                    context.colors.bgPrimary,
                  ],
                ),
              ),
            ),
            Center(
              child: Icon(
                Icons.menu_book,
                size: 100,
                color: context.colors.accent.withOpacity(0.05),
              ),
            ),
            if (!isActive)
              Positioned(
                bottom: 60,
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                child: AppButton(
                  label: 'DÉMARRER LE PLAN',
                  onPressed: () => ref.read(biblePlanServiceProvider.notifier).startPlan(planId),
                  color: context.colors.brandPrimary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayTile(
    BuildContext context, {
    required WidgetRef ref,
    required String planId,
    required PlanDayModel day,
    required bool isCompleted,
    required bool isToday,
    required bool isActive,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: isToday
            ? context.colors.accent.withOpacity(0.05)
            : context.colors.textPrimary.withOpacity(0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isToday
              ? context.colors.accent.withOpacity(0.3)
              : context.colors.borderSubtle,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        leading: GestureDetector(
          onTap: isActive && day.dayNumber != null
              ? () => ref.read(biblePlanServiceProvider.notifier).markDayAsCompleted(planId, day.dayNumber!)
              : null,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? context.colors.accent
                  : context.colors.textPrimary.withOpacity(0.05),
              border: !isCompleted ? Border.all(color: context.colors.borderSubtle) : null,
            ),
            child: Center(
              child: isCompleted
                  ? Icon(Icons.check, color: Colors.white, size: 20)
                  : Text('${day.dayNumber}',
                      style: AppTypography.bodySmallStyle.copyWith(
                        color: isToday ? context.colors.accent : context.colors.textTertiary,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      )),
            ),
          ),
        ),
        title: Text(
          day.title ?? '',
          style: AppTypography.h4.copyWith(
            color: isCompleted ? context.colors.textTertiary : context.colors.textPrimary,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          day.references?.join(', ') ?? '',
          style: AppTypography.bodySmallStyle.copyWith(
            color: context.colors.textTertiary,
            fontSize: 12,
          ),
        ),
        trailing: isToday
            ? IconButton(
                onPressed: () {
                  final refs = day.references;
                  if (refs != null && refs.isNotEmpty) {
                    final refParts = refs.first.split(' ');
                    context.push(AppRoutes.bibleReader
                        .replaceAll(':book', refParts[0])
                        .replaceAll(':chapter', refParts[1]));
                  }
                },
                icon: Icon(Icons.play_circle, color: context.colors.accent),
                tooltip: 'Lire le passage du jour',
              )
            : null,
      ),
    );
  }
}

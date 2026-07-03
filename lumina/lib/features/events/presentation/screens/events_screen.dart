// import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/extensions/context_extension.dart';
// import 'package:lumina/core/widgets/shimmer_loading.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/theme/app_typography.dart';
// import 'package:lumina/core/widgets/empty_state.dart';
// import 'package:lumina/core/widgets/animated_entrance.dart';
// import 'package:lumina/core/widgets/touch_target.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../providers/event_providers.dart';
import '../widgets/event_card.dart';
// import 'package:lumina/core/widgets/app_error_widget.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textSecondary = context.colors.textSecondary;

    final eventsAsync = ref.watch(filteredEventsProvider);
    final currentFilter = ref.watch(eventFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: AnimatedEntrance.fromLeft(
          delay: const Duration(milliseconds: 100),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs + 2),
                decoration: BoxDecoration(
                  gradient: context.colors.brandPrimaryGradient,
                  borderRadius: AppSpacing.borderRadiusSm,
                ),
                child: Icon(Icons.event_rounded,
                  color: context.colors.textOnBrand,
                  size: AppSpacing.iconSm,
                ),
              ),
              SizedBox(width: AppSpacing.sm + 2),
              Text(
                'Événements',
                style: AppTypography.h3.copyWith(fontFamily: 'Outfit'),
              ),
            ],
          ),
        ),
        actions: [
          AnimatedEntrance.fromRight(
            delay: const Duration(milliseconds: 200),
            child: Tooltip(
              message: 'Voir le calendrier',
              child: IconButton(
                icon: Icon(
                  Icons.calendar_month_rounded,
                  color: textSecondary,
                  size: AppSpacing.iconMd,
                ),
                onPressed: () async {
                  await HapticHelper.light();
                  if (context.mounted) unawaited(context.push(AppRoutes.calendrier));
                },
              ).withTouchTarget(),
            ),
          ),
          AnimatedEntrance.fromRight(
            delay: const Duration(milliseconds: 300),
            child: Tooltip(
              message: 'Filtrer les événements',
              child: IconButton(
                icon: Icon(
                  Icons.filter_list_rounded,
                  color: currentFilter == EventFilter.all
                      ? textSecondary
                      : context.colors.brandPrimaryFire,
                  size: AppSpacing.iconMd,
                ),
                onPressed: () => _showFilterSheet(context, ref),
              ).withTouchTarget(),
            ),
          ),
        ],
      ),
      body: eventsAsync.when(
        data: (events) {
          if (events.isEmpty) {
            return AnimatedEntrance.fromBottom(
              delay: const Duration(milliseconds: 400),
              child: EmptyState(
                icon: Icons.event_available_rounded,
                title: currentFilter == EventFilter.all
                    ? 'Aucun événement prévu'
                    : 'Aucun résultat pour ce filtre',
                subtitle: currentFilter == EventFilter.all
                    ? 'Créez votre premier événement pour\nrassembler votre communauté'
                    : 'Essayez un autre filtre pour trouver\ndes événements',
                actionLabel: currentFilter == EventFilter.all
                    ? 'CRÉER UN ÉVÉNEMENT'
                    : 'TOUT AFFICHER',
                onAction: () async {
                  await HapticHelper.light();
                  if (currentFilter == EventFilter.all) {
                    if (context.mounted) {
                      unawaited(context.push(AppRoutes.eventNew));
                    }
                  } else {
                    ref.read(eventFilterProvider.notifier).state =
                        EventFilter.all;
                  }
                },
              ),
            );
          }

          return ListView.builder(
            padding: AppSpacing.screenPadding,
            itemCount: events.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: AnimatedEntrance.fromBottom(
                  delay: Duration(milliseconds: 400 + (index * 100)),
                  child: EventCard(event: events[index]),
                ),
              );
            },
          );
        },
        loading: () => const LoadingState(skeleton: FireSkeletonMemberList()),
        error: (err, stack) => Center(
          child: AppErrorWidget(
            message: 'Désolé, une erreur est survenue',
            technicalDetails: err.toString(),
            showTechnicalDetails: true,
            onRetry: () => ref.refresh(filteredEventsProvider),
          ),
        ),
      ),
      floatingActionButton: AnimatedEntrance.fromBottom(
        delay: const Duration(milliseconds: 500),
        child: Semantics(
          label: 'Créer un nouvel événement',
          button: true,
          child: Container(
            decoration: BoxDecoration(
              gradient: context.colors.brandPrimaryGradientFire,
              borderRadius: AppSpacing.borderRadiusLg,
              boxShadow: context.colors.brandGlow,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  await HapticHelper.light();
                  if (context.mounted) {
                    unawaited(context.push(AppRoutes.eventNew));
                  }
                },
                borderRadius: AppSpacing.borderRadiusLg,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Icon(
                    Icons.add_rounded,
                    color: context.colors.textOnBrand,
                    size: AppSpacing.iconLg,
                  ),
                ),
              ).withTouchTarget(),
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    HapticHelper.light();
    final currentFilter = ref.read(eventFilterProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppSpacing.lg)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filtrer par date',
                style: AppTypography.h3.copyWith(fontFamily: 'Outfit'),
              ),
              SizedBox(height: AppSpacing.lg),
              _FilterOption(
                label: 'Tous les événements',
                value: EventFilter.all,
                currentValue: currentFilter,
                icon: Icons.all_inclusive_rounded,
                onSelected: (val) {
                  ref.read(eventFilterProvider.notifier).state = val;
                  Navigator.pop(context);
                },
              ),
              _FilterOption(
                label: 'Événements à venir',
                value: EventFilter.upcoming,
                currentValue: currentFilter,
                icon: Icons.event_available_rounded,
                onSelected: (val) {
                  ref.read(eventFilterProvider.notifier).state = val;
                  Navigator.pop(context);
                },
              ),
              _FilterOption(
                label: 'Événements passés',
                value: EventFilter.past,
                currentValue: currentFilter,
                icon: Icons.history_rounded,
                onSelected: (val) {
                  ref.read(eventFilterProvider.notifier).state = val;
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: AppSpacing.xl),
            ],
          ),
        );
      },
    );
  }
}

class _FilterOption extends StatelessWidget {
  final String label;
  final EventFilter value;
  final EventFilter currentValue;
  final IconData icon;
  final Function(EventFilter) onSelected;

  const _FilterOption({
    required this.label,
    required this.value,
    required this.currentValue,
    required this.icon,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == currentValue;
    final color = isSelected ? context.colors.brandPrimaryFire : null;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: TextStyle(
          color: color ?? context.colors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: context.colors.brandPrimaryFire)
          : null,
      onTap: () async {
        await HapticHelper.light();
        onSelected(value);
      },
    ).withTouchTarget();
  }
}
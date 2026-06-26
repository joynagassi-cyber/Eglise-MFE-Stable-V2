import 'package:lumina/core/extensions/context_extension.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/features/events/presentation/providers/event_providers.dart';
import 'package:lumina/features/events/domain/entities/event.dart';
import 'package:lumina/core/widgets/horizontal_week_calendar.dart';
import 'package:lumina/core/widgets/widgets.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final eventsAsync = ref.watch(eventsProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: context.colors.bgPage,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Agenda Pastoral',
          style: AppTypography.h3.copyWith(fontFamily: 'Outfit'),
        ),
        actions: [
          Semantics(
            label: 'Retour à aujourd\'hui',
            button: true,
            child: IconButton(
              icon: Icon(Icons.calendar_today_rounded,
                color: context.colors.brandPrimaryFire,
                size: AppSpacing.iconMd,
              ),
              onPressed: () async {
                await HapticHelper.medium();
                ref.read(selectedDateProvider.notifier).state = DateTime.now();
              },
            ).withTouchTarget(),
          ),
        ],
      ),
      body: Column(
        children: [
          // New Horizontal Selection
          HorizontalWeekCalendar(
            selectedDate: selectedDate,
            onDateSelected: (date) {
              ref.read(selectedDateProvider.notifier).state = date;
            },
          ),

          SizedBox(height: AppSpacing.md),

          Expanded(
            child: eventsAsync.when(
              data: (events) =>
                  _buildEventList(context, ref, selectedDate, isDark, theme),
              loading: () => const LoadingState(),
              error: (e, _) => EmptyState(
                icon: Icons.error_outline,
                title: 'Erreur',
                subtitle: e.toString(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: context.colors.brandPrimaryGradientFire,
        borderRadius: BorderRadius.circular(20),
        boxShadow: context.colors.brandGlow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await HapticHelper.light();
            if (context.mounted) unawaited(context.push(AppRoutes.eventNew));
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Icon(
              Icons.add_rounded,
              color: context.colors.textOnBrand,
              size: 28,
            ),
          ),
        ).withTouchTarget(),
      ),
    );
  }

  Widget _buildEventList(
    BuildContext context,
    WidgetRef ref,
    DateTime selectedDate,
    bool isDark,
    ThemeData theme,
  ) {
    final eventsAsync = ref.watch(eventsProvider);

    return eventsAsync.when(
      data: (allEvents) {
        final dayEvents = allEvents
            .where(
              (e) =>
                  e.date.year == selectedDate.year &&
                  e.date.month == selectedDate.month &&
                  e.date.day == selectedDate.day,
            )
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));

        if (dayEvents.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.event_available_rounded,
                  size: 64,
                  color: context.colors.textPrimary.withValues(alpha: 0.05),
                ),
                SizedBox(height: 16),
                Text(
                  'Journée libre',
                  style: AppTypography.titleMedium.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: dayEvents.length,
          itemBuilder: (context, index) {
            final event = dayEvents[index];
            return _buildEventTimelineItem(context, event, isDark, theme);
          },
        );
      },
      loading: () => Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: ShimmerCardList(
          itemCount: 4,
          itemHeight: 100,
        ),
      ),
      error: (e, _) => Center(child: Text('Impossible de charger le calendrier')),
    );
  }

  Widget _buildEventTimelineItem(
    BuildContext context,
    Event event,
    bool isDark,
    ThemeData theme,
  ) {
    final timeStr = DateFormat('HH:mm').format(event.date);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Indicator
          SizedBox(
            width: 60,
            child: Column(
              children: [
                Text(
                  timeStr,
                  style: AppTypography.labelMedium.copyWith(
                    color: context.colors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: context.colors.borderSubtle,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Event Card
          Expanded(
            child: GlassCard(
              onTap: () async {
                await HapticHelper.light();
                if (context.mounted) {
                  unawaited(context.push(AppRoutes.eventDetailsWithId(event.id)));
                }
              },
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: context.colors.brandPrimaryFire.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          event.type.icon,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          event.title,
                          style: AppTypography.titleSmall.copyWith(
                            color: context.colors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (event.location != null) ...[
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 14,
                          color: context.colors.textTertiary,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location!,
                            style: AppTypography.bodySmall.copyWith(
                              color: context.colors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

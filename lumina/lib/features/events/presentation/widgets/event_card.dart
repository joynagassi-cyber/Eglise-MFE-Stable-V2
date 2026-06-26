import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/widgets/glass_card.dart';
import 'package:lumina/features/events/domain/entities/event.dart'
    show Event;
import 'package:lumina/features/events/domain/entities/event_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat;

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final eventType = event.type;
    final now = DateTime.now();
    final isCancelled = event.status == 'ANNULE';
    final isFuture = event.date.isAfter(now);
    final daysUntil = event.date.difference(DateTime(now.year, now.month, now.day)).inDays;

    return GlassCard(
      onTap: () => HapticFeedback.lightImpact(),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Opacity(
        opacity: isCancelled ? 0.6 : 1.0,
        child: Row(
          children: [
            // Icon badge avec Hero
            Hero(
              tag: 'event_${event.id}',
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.smd),
                decoration: BoxDecoration(
                  color: isCancelled
                      ? context.colors.errorText.withValues(alpha: 0.1)
                      : eventType == EventType.mass
                          ? context.colors.brandPrimaryFire.withValues(alpha: 0.12)
                          : theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                  borderRadius: AppSpacing.borderRadiusMd,
                ),
                child: Text(
                  isCancelled ? '🚫' : eventType.icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration: isCancelled
                                ? TextDecoration.lineThrough
                                : null,
                            color: isCancelled
                                ? context.colors.textSecondary
                                : null,
                          ),
                        ),
                      ),
                      // Cancellation badge
                      if (isCancelled)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xxs,
                          ),
                          decoration: BoxDecoration(
                            color: context.colors.errorText.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'ANNULÉ',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: context.colors.errorText,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      // Countdown badge
                      else if (isFuture && daysUntil <= 7)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xxs,
                          ),
                          decoration: BoxDecoration(
                            color: daysUntil == 0
                                ? context.colors.successText.withValues(alpha: 0.15)
                                : context.colors.warningText.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            daysUntil == 0
                                ? "Aujourd'hui"
                                : daysUntil == 1
                                    ? 'Demain'
                                    : 'J-$daysUntil',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: daysUntil == 0
                                  ? context.colors.successText
                                  : context.colors.brandPrimaryFire,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (event.description != null &&
                      event.description!.isNotEmpty) ...[
                    SizedBox(height: AppSpacing.xxs),
                    Text(
                      event.description!,
                      style: AppTypography.bodySmall.copyWith(
                        color: context.colors.textSecondary,
                        decoration: isCancelled
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: AppSpacing.iconXs,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      SizedBox(width: AppSpacing.xxs),
                      Text(
                        DateFormat('dd MMM yyyy').format(event.date),
                        style: AppTypography.bodySmall.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (event.location != null) ...[
                        SizedBox(width: AppSpacing.sm),
                        Icon(
                          Icons.location_on_outlined,
                          size: AppSpacing.iconXs,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        SizedBox(width: AppSpacing.xxs),
                        Expanded(
                          child: Text(
                            event.location!,
                            style: AppTypography.bodySmall.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}

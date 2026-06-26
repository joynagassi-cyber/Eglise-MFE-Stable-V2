// import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/domain/entities/enums/audit_action.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../../../core/animations/staggered_animations.dart';
import '../../../../core/utils/haptic_helper.dart';
import '../../../../core/utils/traceability_formatter.dart';
import '../../domain/services/audit_service.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class AuditTimeline extends ConsumerWidget {
  const AuditTimeline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(auditLogsProvider);
    final theme = Theme.of(context);

    return logsAsync.when(
      data: (logs) {
        if (logs.isEmpty) {
          return GlassCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 48,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'Aucune activité enregistrée',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index];
            final isLast = index == logs.length - 1;
            final actionColor = _colorForAction(context, log.action);
            final actionIcon = _iconForAction(log.action);

            return StaggeredListItem(
              index: index,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline connector gauche
                    SizedBox(
                      width: 40,
                      child: Column(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: actionColor.withOpacity(0.12),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: actionColor.withOpacity(0.4),
                                width: 2,
                              ),
                              boxShadow: actionColor == context.colors.brandPrimary
                                  ? context.colors.brandGlow
                                  : (log.action == AuditAction.seal
                                      ? [
                                          BoxShadow(
                                            color:
                                                Colors.amber.withOpacity(0.3),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          )
                                        ]
                                      : null),
                            ),
                            child: Icon(
                              actionIcon,
                              color: actionColor,
                              size: 16,
                            ),
                          ),
                          if (!isLast)
                            Expanded(
                              child: Container(
                                width: 2,
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      actionColor.withOpacity(0.4),
                                      actionColor.withOpacity(0.02),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    // Contenu principal
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: isLast ? 0 : AppSpacing.md,
                        ),
                        child: GlassCard(
                          padding: const EdgeInsets.all(AppSpacing.smd),
                          elevated: log.action == AuditAction.seal,
                          onTap: () async {
                            await HapticHelper.selection();
                            // TODO: Navigation vers le détail
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // Badge action
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.sm,
                                      vertical: AppSpacing.xxs,
                                    ),
                                    decoration: BoxDecoration(
                                      color: actionColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      log.action.label.toUpperCase(),
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        color: actionColor,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    _formatTimestamp(log.occurredAt),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.4),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppSpacing.sm),
                              Text(
                                '${log.action.label} : ${log.entityType}',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Outfit',
                                ),
                              ),
                              SizedBox(height: AppSpacing.xxs),
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_outline_rounded,
                                    size: 12,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.5),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Par ${TraceabilityFormatter.formatActor(name: log.actorName, role: log.roleUsed)}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const GlassCard(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: LoadingState(),
          ),
        ),
      ),
      error: (err, _) => GlassCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        borderColor: context.colors.errorText.withOpacity(0.3),
        child: Row(children: [
            Icon(Icons.error_outline_rounded, color: context.colors.errorText),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'Impossible de charger l\'historique',
                style: TextStyle(color: context.colors.errorText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _colorForAction(BuildContext context, AuditAction action) {
    switch (action) {
      case AuditAction.insert:
        return context.colors.successText;
      case AuditAction.update:
        return context.colors.brandPrimary;
      case AuditAction.delete:
        return context.colors.errorText;
      case AuditAction.login:
        return Colors.teal;
      case AuditAction.logout:
        return Colors.blueGrey;
      case AuditAction.upload:
        return Colors.indigo;
      case AuditAction.seal:
        return Colors.amber.shade700;
      case AuditAction.export_:
        return Colors.deepPurple;
      case AuditAction.backup:
        return Colors.cyan;
      case AuditAction.register:
        return Colors.purple;
    }
  }

  IconData _iconForAction(AuditAction action) {
    switch (action) {
      case AuditAction.insert:
        return Icons.add_circle_outline_rounded;
      case AuditAction.update:
        return Icons.edit_rounded;
      case AuditAction.delete:
        return Icons.delete_outline_rounded;
      case AuditAction.login:
        return Icons.login_rounded;
      case AuditAction.logout:
        return Icons.logout_rounded;
      case AuditAction.upload:
        return Icons.cloud_upload_rounded;
      case AuditAction.seal:
        return Icons.verified_rounded;
      case AuditAction.export_:
        return Icons.download_rounded;
      case AuditAction.backup:
        return Icons.backup_rounded;
      case AuditAction.register:
        return Icons.how_to_reg_rounded;
    }
  }

  String _formatTimestamp(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return 'il y a ${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return 'il y a ${diff.inHours}h';
    } else {
      return DateFormat('dd/MM HH:mm').format(date);
    }
  }
}
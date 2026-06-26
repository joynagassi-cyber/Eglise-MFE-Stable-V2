import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../domain/services/audit_service.dart';
import '../../domain/models/audit_anomaly.dart';

class AuditAnomalyList extends ConsumerWidget {
  const AuditAnomalyList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anomalies = ref.watch(auditAnomaliesProvider);

    if (anomalies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Anomalies Détectées',
          icon: Icons.warning_amber_rounded,
          iconColor: context.colors.errorText,
        ),
        SizedBox(height: AppSpacing.md),
        ...anomalies.asMap().entries.map(
          (entry) {
            final index = entry.key;
            final anomaly = entry.value;
            final isCritical = anomaly.severity == AnomalySeverity.critical;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: AnimatedEntrance(
                delay: Duration(milliseconds: index * 100),
                child: GlassCard(
                  borderColor: isCritical ? context.colors.errorText : context.colors.warningText,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              (isCritical ? context.colors.errorText : context.colors.warningText)
                                  .withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isCritical
                              ? Icons.gpp_bad_rounded
                              : Icons.report_problem_rounded,
                          color:
                              isCritical ? context.colors.errorText : context.colors.warningText,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              anomaly.description,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Détecté à ${_formatTime(anomaly.detectedAt)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white54
                                    : context.colors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded,
                          size: 20, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

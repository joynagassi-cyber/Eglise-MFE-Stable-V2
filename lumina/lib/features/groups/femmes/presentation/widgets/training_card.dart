import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/training.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/core/widgets/widgets.dart';
class TrainingCard extends StatelessWidget {
  final Training training;
  final Color color;

  const TrainingCard({
    super.key,
    required this.training,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = training.capacity != null && training.capacity! > 0
        ? (training.enrolledCount / training.capacity!).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      training.title,
                      style: AppTypography.labelLarge
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Formateur: ${training.trainer ?? "N/A"}',
                      style: AppTypography.tiny,
                    ),
                  ],
                ),
              ),
              Text(
                '${training.enrolledCount}/${training.capacity ?? "?"}',
                style: AppTypography.labelMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AppProgressBar(
              value: progress,
              color: progress >= 1.0 ? context.colors.successText : context.colors.brandPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                training.nextSession != null
                    ? 'Prochaine: ${DateFormat('dd MMM').format(training.nextSession!)}'
                    : 'Date à définir',
                style: AppTypography.tiny.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              TextButton(
                onPressed: () async {
                  await HapticHelper.medium();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Inscription : Bientôt disponible')),
                    );
                  }
                },
                child: Text(
                  'S\'inscrire',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

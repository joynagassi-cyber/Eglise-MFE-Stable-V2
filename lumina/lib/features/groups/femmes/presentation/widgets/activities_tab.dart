import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/theme/app_spacing.dart';
class ActivitiesTab extends StatelessWidget {
  final String groupId;
  final Color accentColor;

  const ActivitiesTab({
    super.key,
    required this.groupId,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final activities = [
      {
        'type': 'Entraide',
        'title': 'Réunion Solidarité',
        'date': '28 Mars, 15:00',
        'participants': 12,
        'icon': Icons.handshake_rounded
      },
      {
        'type': 'Formation',
        'title': 'Atelier Leadership',
        'date': '02 Avril, 18:00',
        'participants': 8,
        'icon': Icons.school_rounded
      },
      {
        'type': 'Prière',
        'title': 'Intercession Matinale',
        'date': 'Chaque Lundi, 05:00',
        'participants': 25,
        'icon': Icons.auto_awesome_rounded
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final act = activities[index];
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: context.colors.bgCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: accentColor.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  act['icon'] as IconData,
                  color: accentColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      act['type'] as String,
                      style: AppTypography.tiny.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      act['title'] as String,
                      style: AppTypography.labelLarge
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      act['date'] as String,
                      style: AppTypography.tiny.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: context.colors.bgPage,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.people_rounded,
                      size: 14,
                      color: context.colors.textSecondary,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${act['participants']}',
                      style: AppTypography.tiny
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.05);
      },
    );
  }
}

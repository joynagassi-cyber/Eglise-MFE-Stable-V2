// lib/features/dashboard/presentation/screens/stat_detail_screen.dart
// Écran de détail pour les statistiques avec Hero animation

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/theme/app_text.dart';
import 'package:lumina/core/widgets/animated_entrance.dart';
import 'package:lumina/core/utils/haptic_helper.dart';

class StatDetailScreen extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final List<StatDetailItem> details;

  const StatDetailScreen({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.details = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Semantics(
          label: 'Retour',
          button: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await HapticHelper.light();
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        title: Hero(
          tag: 'stat-title-$title',
          child: Material(
            type: MaterialType.transparency,
            child: Text(title, style: AppText.titleLarge(context)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Card
            AnimatedEntrance.fromBottom(
              delay: const Duration(milliseconds: 100),
              child: Hero(
                tag: 'stat-card-$title',
                child: Semantics(
                  label:
                      '$title: $value${subtitle != null ? ", $subtitle" : ""}',
                  child: Container(
                    width: double.infinity,
                    padding: AppSpacing.cardPadding,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color.withValues(alpha: 0.8), color],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: AppSpacing.borderRadiusCard,
                      boxShadow: AppSpacing.shadowLg,
                    ),
                    child: Column(
                      children: [
                        Hero(
                          tag: 'stat-icon-$title',
                          child: Icon(
                            icon,
                            size: AppSpacing.iconHero,
                            color: context.colors.textInverse,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Hero(
                          tag: 'stat-value-$title',
                          child: Material(
                            type: MaterialType.transparency,
                            child: Text(
                              value,
                              style: AppText.displaySmall(context).copyWith(
                                color: context.colors.textInverse,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            subtitle!,
                            style: AppText.bodyMedium(context).copyWith(
                              color: context.colors.textInverse.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Details Section
            if (details.isNotEmpty) ...[
              AnimatedEntrance.fromBottom(
                delay: const Duration(milliseconds: 200),
                child: Text('Détails', style: AppText.headlineSmall(context)),
              ),
              const SizedBox(height: AppSpacing.md),
              ...details.asMap().entries.map((entry) {
                final index = entry.key;
                final detail = entry.value;
                return AnimatedEntrance.fromBottom(
                  delay: Duration(milliseconds: 300 + (index * 50)),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Semantics(
                      label: '${detail.label}: ${detail.value}',
                      child: Container(
                        padding: AppSpacing.cardPadding,
                        decoration: BoxDecoration(
                          color: context.colors.bgCard,
                          borderRadius: BorderRadius.circular(LuminaRadius.md),
                          border: Border.all(
                            color: context.colors.borderSubtle,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              detail.icon,
                              color: color,
                              size: AppSpacing.iconMd,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    detail.label,
                                    style: AppText.titleMedium(context),
                                  ),
                                  Text(
                                    detail.value,
                                    style: AppText.bodyMedium(context).copyWith(
                                      color: context.colors.textSecondary.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

class StatDetailItem {
  final String label;
  final String value;
  final IconData icon;

  const StatDetailItem({
    required this.label,
    required this.value,
    required this.icon,
  });
}

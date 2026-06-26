// lib/features/dashboard/presentation/widgets/section_shortcuts.dart
// Widget pour les raccourcis vers les sections principales

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/glass_card.dart';
import 'package:lumina/core/utils/haptic_helper.dart';


/// Données d'un raccourci de section
class SectionShortcut {
  final String title;
  final String description;
  final IconData icon;
  final String route;
  final Color color;
  final int badgeCount;

  const SectionShortcut({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    required this.color,
    this.badgeCount = 0,
  });
}

/// Widget pour afficher un raccourci vers une section
class SectionShortcutCard extends StatelessWidget {
  final SectionShortcut shortcut;
  final VoidCallback? onTap;

  const SectionShortcutCard({super.key, required this.shortcut, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = context.colors.textPrimary;
    final textSecondary = context.colors.textSecondary;

    return Semantics(
      label: '${shortcut.title}, ${shortcut.description}',
      button: true,
      enabled: true,
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        onTap: () async {
          await HapticHelper.light();
          onTap?.call();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon avec badge
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: shortcut.color.withValues(alpha: 0.1),
                    borderRadius: AppSpacing.borderRadiusSm,
                  ),
                  child: Icon(
                    shortcut.icon,
                    color: shortcut.color,
                    size: AppSpacing.iconLg,
                  ),
                ),
                if (shortcut.badgeCount > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.xxs),
                      decoration: BoxDecoration(
                        color: context.colors.errorText,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Text(
                        shortcut.badgeCount > 99
                            ? '99+'
                            : shortcut.badgeCount.toString(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Titre
            Text(
              shortcut.title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xxs),
            // Description
            Text(
              shortcut.description,
              style: theme.textTheme.bodySmall?.copyWith(color: textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget pour afficher une grille de raccourcis vers les sections
class SectionShortcutsGrid extends StatelessWidget {
  final List<SectionShortcut> shortcuts;
  final bool showTitle;

  const SectionShortcutsGrid({
    super.key,
    required this.shortcuts,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = context.colors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(
              context.l10n.quickNavigation,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.2,
          ),
          itemCount: shortcuts.length,
          itemBuilder: (context, index) {
            final shortcut = shortcuts[index];
            return SectionShortcutCard(
              shortcut: shortcut,
              onTap: () => context.go(shortcut.route),
            );
          },
        ),
      ],
    );
  }
}

/// Liste des raccourcis de section (localisée via context)
List<SectionShortcut> getLocalizedSectionShortcuts(BuildContext context) {
  final l10n = context.l10n;
  return [
    SectionShortcut(
      title: l10n.community,
      description: l10n.communityDescription,
      icon: Icons.people_outline,
      route: '/communaute',
      color: context.colors.brandPrimary,
    ),
    SectionShortcut(
      title: l10n.spiritualLife,
      description: l10n.spiritualLifeDescription,
      icon: Icons.psychology_outlined,
      route: '/vie-spirituelle',
      color: context.colors.brandPrimary,
    ),
    SectionShortcut(
      title: l10n.team,
      description: l10n.teamDescription,
      icon: Icons.shield_outlined,
      route: '/equipe',
      color: context.colors.brandSecondary,
    ),
    SectionShortcut(
      title: l10n.ministry,
      description: l10n.ministryDescription,
      icon: Icons.work_outlined,
      route: '/ministere',
      color: context.colors.successText,
    ),
    SectionShortcut(
      title: l10n.communication,
      description: l10n.communicationDescription,
      icon: Icons.messenger_outlined,
      route: '/communication',
      color: context.colors.brandPrimaryLight,
    ),
    SectionShortcut(
      title: l10n.calendar,
      description: l10n.calendarDescription,
      icon: Icons.calendar_today_outlined,
      route: '/vie-spirituelle/events',
      color: context.colors.brandPrimary,
    ),
  ];
}

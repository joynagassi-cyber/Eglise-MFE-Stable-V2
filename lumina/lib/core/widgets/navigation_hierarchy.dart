import 'package:lumina/core/extensions/context_extension.dart';
// lib/core/widgets/navigation_hierarchy.dart
// Widget de navigation hiérarchique et breadcrumbs

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';

/// Informations de navigation pour une section
class SectionInfo {
  final String title;
  final IconData icon;
  final String routePath;
  final Color? color;
  final List<SectionInfo> subSections;

  const SectionInfo({
    required this.title,
    required this.icon,
    required this.routePath,
    this.color,
    this.subSections = const [],
  });
}

/// Classe utilitaire pour la navigation hiérarchique
class NavigationHierarchy {
  static final sections = {
    '/communaute': const SectionInfo(
      title: 'Communauté',
      icon: Icons.people,
      routePath: '/communaute',
      subSections: [
        SectionInfo(
          title: 'Membres',
          icon: Icons.person,
          routePath: '/communaute',
        ),
        SectionInfo(
          title: 'Groupes',
          icon: Icons.group,
          routePath: '/communaute/groupes',
        ),
        SectionInfo(
          title: 'Visiteurs',
          icon: Icons.waving_hand,
          routePath: '/communaute/visiteurs',
        ),
        SectionInfo(
          title: 'Statistiques',
          icon: Icons.bar_chart,
          routePath: '/communaute/stats',
        ),
      ],
    ),
    '/vie-spirituelle': const SectionInfo(
      title: 'Vie Spirituelle',
      icon: Icons.psychology,
      routePath: '/vie-spirituelle',
      subSections: [
        SectionInfo(
          title: 'Agenda Pastoral',
          icon: Icons.calendar_today,
          routePath: '/vie-spirituelle',
        ),
        SectionInfo(
          title: 'Sacrements',
          icon: Icons.church,
          routePath: '/vie-spirituelle/sacrements',
        ),
        SectionInfo(
          title: 'Célébrations',
          icon: Icons.celebration,
          routePath: '/vie-spirituelle/celebrations',
        ),
        SectionInfo(
          title: 'Jalons Spirituels',
          icon: Icons.flag,
          routePath: '/vie-spirituelle/jalons',
        ),
      ],
    ),
    '/equipe': const SectionInfo(
      title: 'Équipe',
      icon: Icons.shield,
      routePath: '/equipe',
      subSections: [
        SectionInfo(
          title: 'Bergers',
          icon: Icons.people,
          routePath: '/equipe',
        ),
        SectionInfo(
          title: 'Équipes de Service',
          icon: Icons.groups,
          routePath: '/equipe/equipes',
        ),
        SectionInfo(
          title: 'Visites Pastorales',
          icon: Icons.location_on,
          routePath: '/equipe/visites',
        ),
      ],
    ),
    '/ministere': const SectionInfo(
      title: 'MFE-JC',
      icon: Icons.work,
      routePath: '/ministere',
      subSections: [
        SectionInfo(
          title: 'Finance Globale',
          icon: Icons.account_balance_wallet,
          routePath: '/ministere/finance',
        ),
        SectionInfo(
          title: 'Sites MFE-JC',
          icon: Icons.location_city,
          routePath: '/ministere/churches',
        ),
        SectionInfo(
          title: 'Rubriques',
          icon: Icons.category,
          routePath: '/ministere/rubriques',
        ),
      ],
    ),
    '/communication': const SectionInfo(
      title: 'Communication',
      icon: Icons.messenger,
      routePath: '/communication',
      subSections: [
        SectionInfo(
          title: 'Annonces',
          icon: Icons.campaign,
          routePath: '/communication/annonces',
        ),
        SectionInfo(
          title: 'Réseau Social',
          icon: Icons.rss_feed,
          routePath: '/communication/social',
        ),
        SectionInfo(
          title: 'Messagerie',
          icon: Icons.chat,
          routePath: '/communication/messaging',
        ),
      ],
    ),
  };

  /// Obtient les informations de section basées sur l'URL actuelle
  static SectionInfo? getSectionInfo(String location) {
    for (final path in sections.keys) {
      if (location.startsWith(path)) {
        return sections[path];
      }
    }

    // Recherche dans les sous-sections
    for (final section in sections.values) {
      for (final subSection in section.subSections) {
        if (location.startsWith(subSection.routePath)) {
          return section;
        }
      }
    }

    return null;
  }

  /// Obtient la sous-section actuelle basée sur l'URL
  static SectionInfo? getCurrentSubSection(String location) {
    for (final section in sections.values) {
      for (final subSection in section.subSections) {
        if (location.startsWith(subSection.routePath)) {
          return subSection;
        }
      }
    }

    // Si c'est la route principale, retourne null
    for (final section in sections.values) {
      if (location == section.routePath) {
        return null;
      }
    }

    return null;
  }

  /// Construit un breadcrumb (fil d'Ariane) pour l'URL actuelle
  static List<Widget> buildBreadcrumbs(
      BuildContext context, String currentLocation,
      {bool compact = false}) {
    final currentSection = getSectionInfo(currentLocation);
    final currentSubSection = getCurrentSubSection(currentLocation);

    if (currentSection == null) return [];

    final textColor = context.colors.textSecondary;
    final accentColor = context.colors.brandPrimary;

    if (compact) {
      return [
        Text(
          currentSection.title,
          style: GoogleFonts.openSans(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (currentSubSection != null) ...[
          Icon(Icons.chevron_right,
              size: 16, color: textColor.withValues(alpha: 0.5)),
          Text(
            currentSubSection.title,
            style: GoogleFonts.openSans(
              color: accentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ];
    }

    return [
      GestureDetector(
        onTap: () => context.go(currentSection.routePath),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(currentSection.icon, size: 16, color: accentColor),
            const SizedBox(width: 4),
            Text(
              currentSection.title,
              style: GoogleFonts.openSans(
                color: accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ).withTouchTarget(),
      if (currentSubSection != null) ...[
        Icon(Icons.chevron_right,
            size: 16, color: textColor.withValues(alpha: 0.5)),
        GestureDetector(
          onTap: () => context.go(currentSubSection.routePath),
          child: Text(
            currentSubSection.title,
            style: GoogleFonts.openSans(
              color: accentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ).withTouchTarget(),
      ],
    ];
  }
}

/// Widget affichant un menu "Voir tout" pour les sous-sections
class SectionQuickMenu extends StatelessWidget {
  final String currentRoute;
  final bool showHeader;

  const SectionQuickMenu({
    super.key,
    required this.currentRoute,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    final section = NavigationHierarchy.getSectionInfo(currentRoute);
    if (section == null || section.subSections.isEmpty) {
      return const SizedBox();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = context.colors.textPrimary;
    final cardColor = context.colors.bgCard;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Text(
              'Navigation Rapide',
              style: GoogleFonts.poppins(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: context.colors.borderSubtle.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            children: section.subSections.map((subSection) {
              final isActive = currentRoute.startsWith(subSection.routePath);

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.go(subSection.routePath),
                  borderRadius: BorderRadius.circular(32),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: subSection == section.subSections.last
                          ? null
                          : Border(
                              bottom: BorderSide(
                                color: context.colors.borderSubtle
                                    .withValues(alpha: 0.3),
                                width: 0.5,
                              ),
                            ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isActive
                                ? context.colors.brandPrimary.withValues(alpha: 0.1)
                                : (isDark
                                    ? context.colors.stateHoverBg
                                    : context.colors.bgSecondary),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            subSection.icon,
                            size: 18,
                            color: isActive
                                ? context.colors.brandPrimary
                                : context.colors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            subSection.title,
                            style: GoogleFonts.openSans(
                              color: isActive ? context.colors.brandPrimary : textColor,
                              fontWeight:
                                  isActive ? FontWeight.w700 : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (isActive)
                          Icon(Icons.arrow_forward_ios_rounded,
                            size: 12,
                            color: context.colors.brandPrimary,
                          )
                        else
                          Icon(Icons.chevron_right_rounded,
                            size: 14,
                            color: context.colors.textTertiary,
                          ),
                      ],
                    ),
                  ),
                ).withTouchTarget(),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

/// Widget de breadcrumb pour l'app bar
class BreadcrumbAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentLocation;
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;

  const BreadcrumbAppBar({
    super.key,
    required this.currentLocation,
    this.title,
    this.leading,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.colors.bgPage;

    return AppBar(
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,
      leading: leading,
      title: title != null 
        ? Text(title!, style: context.textTheme.titleMedium)
        : Row(
            children: NavigationHierarchy.buildBreadcrumbs(
              context,
              currentLocation,
              compact: true,
            ),
          ),
      actions: actions,
    );
  }
}

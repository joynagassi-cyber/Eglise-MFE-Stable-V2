// lib/core/widgets/status_badge.dart
// Widget de badge de statut réutilisable

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';

/// Badge de statut avec couleur et icône optionnelle
class StatusBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final String? icon;
  final double? fontSize;
  final EdgeInsets? padding;
  final bool outlined;
  final StatusBadgeType? type;

  const StatusBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.fontSize,
    this.padding,
    this.outlined = false,
    this.type,
  });

  /// Badge Actif
  factory StatusBadge.active({String? label}) {
    return StatusBadge(
      label: label ?? 'Actif',
      icon: '✓',
      type: StatusBadgeType.active,
    );
  }

  /// Badge Inactif
  factory StatusBadge.inactive({String? label}) {
    return StatusBadge(
      label: label ?? 'Inactif',
      type: StatusBadgeType.inactive,
    );
  }

  /// Badge Baptisé
  factory StatusBadge.baptized({String? label}) {
    return StatusBadge(
      label: label ?? 'Baptisé',
      icon: '✝️',
      type: StatusBadgeType.baptized,
    );
  }

  /// Badge Leader
  factory StatusBadge.leader({String? label}) {
    return StatusBadge(
      label: label ?? 'Leader',
      type: StatusBadgeType.leader,
    );
  }

  /// Badge personnalisé avec couleur
  factory StatusBadge.custom({
    required String label,
    required int colorValue,
    String? icon,
  }) {
    return StatusBadge(
      label: label,
      icon: icon,
      backgroundColor: Color(colorValue),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color? bgColor = backgroundColor;
    Color? txtColor = textColor;

    if (type != null) {
      switch (type!) {
        case StatusBadgeType.active:
          bgColor = context.colors.badgeSuccessBackground;
          txtColor = context.colors.badgeSuccessText;
          break;
        case StatusBadgeType.inactive:
          bgColor = context.colors.badgeWarningBackground;
          txtColor = context.colors.badgeWarningText;
          break;
        case StatusBadgeType.baptized:
          bgColor = context.colors.bgElevated;
          txtColor = context.colors.brandPrimary;
          break;
        case StatusBadgeType.leader:
          bgColor = context.colors.brandPrimary.withValues(alpha: 0.1);
          txtColor = context.colors.brandPrimary;
          break;
        case StatusBadgeType.custom:
          break;
      }
    }

    bgColor ??= context.colors.bgElevated;
    txtColor ??= context.colors.textPrimary;

    if (outlined) {
      return Container(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: bgColor, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Text(icon!, style: TextStyle(fontSize: fontSize ?? 10)),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: bgColor,
                fontSize: fontSize ?? 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Text(icon!, style: TextStyle(fontSize: fontSize ?? 10)),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: txtColor,
              fontSize: fontSize ?? 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

enum StatusBadgeType { active, inactive, baptized, leader, custom }

/// Row de plusieurs badges
class StatusBadgeRow extends StatelessWidget {
  final List<StatusBadge> badges;
  final double spacing;
  final MainAxisAlignment alignment;

  const StatusBadgeRow({
    super.key,
    required this.badges,
    this.spacing = 6,
    this.alignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: spacing / 2,
      alignment: WrapAlignment.start,
      children: badges,
    );
  }
}

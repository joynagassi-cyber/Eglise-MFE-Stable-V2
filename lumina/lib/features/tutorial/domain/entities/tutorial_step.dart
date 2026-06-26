import 'package:flutter/material.dart';

/// Représente une étape individuelle du tutoriel interactif.
class TutorialStep {
  final String id;
  final String title;
  final String description;
  final String actionLabel;
  final String targetRoute;
  final Map<String, String>? targetRouteParams;
  final IconData icon;

  const TutorialStep({
    required this.id,
    required this.title,
    required this.description,
    this.actionLabel = 'Essayer maintenant →',
    required this.targetRoute,
    this.targetRouteParams,
    required this.icon,
  });
}

/// Configuration complète du tutoriel pour un rôle donné.
class TutorialConfig {
  final String roleCode;
  final String roleDisplayName;
  final String roleDescription;
  final IconData roleIcon;
  final List<TutorialStep> steps;

  const TutorialConfig({
    required this.roleCode,
    required this.roleDisplayName,
    required this.roleDescription,
    required this.roleIcon,
    required this.steps,
  });
}
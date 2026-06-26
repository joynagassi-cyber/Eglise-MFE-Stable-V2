import 'package:flutter/material.dart';

/// Shadow definitions (Clean 2026 Edition)
/// Focused on performance and clarity, removing heavy glows.
class EmberAurumShadows {
  static List<BoxShadow> get fireGlow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get goldGlow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get deepShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 12.0,
          offset: const Offset(0, 5),
        ),
      ];

  static List<BoxShadow> get standardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];
}

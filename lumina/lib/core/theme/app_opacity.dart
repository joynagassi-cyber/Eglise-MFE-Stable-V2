// lib/core/theme/app_opacity.dart
// Constantes d'opacité standardisées pour le Design System

/// Valeurs d'opacité réutilisables pour maintenir la cohérence visuelle
class AppOpacity {
  AppOpacity._();

  // ==========================================
  // OPACITY VALUES
  // ==========================================

  /// 0.05 - Très subtil (hover states légers)
  static const double verySubtle = 0.05;

  /// 0.1 - Subtil (backgrounds de badges, chips)
  static const double subtle = 0.1;

  /// 0.2 - Léger (containers glassmorphic, overlays)
  static const double light = 0.2;

  /// 0.3 - Moyen (dividers, borders glassmorphic)
  static const double medium = 0.3;

  /// 0.5 - Fort (overlays modals, shadows)
  static const double strong = 0.5;

  /// 0.7 - Très fort (overlays bloquants)
  static const double veryStrong = 0.7;

  /// 0.9 - Presque opaque (cards glassmorphic en mode sombre)
  static const double almostOpaque = 0.9;

  /// 0.95 - Presque totalement opaque (cards en mode clair)
  static const double nearlyOpaque = 0.95;
}

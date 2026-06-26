// lib/core/theme/app_durations.dart

class AppDurations {
  AppDurations._();

  // Durées standardisées
  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration long = Duration(milliseconds: 600);
  static const Duration extraLong = Duration(milliseconds: 1000);

  // Transitions de page
  static const Duration pageTransition = Duration(milliseconds: 300);

  // Animations spécifiques
  static const Duration shimmer =
      Duration(milliseconds: 1800); // Pour FireShimmer
  static const Duration floatingNavRotation =
      Duration(milliseconds: 400); // Pour NavBar
  static const Duration floatingNavWave =
      Duration(milliseconds: 550); // Pour NavBar
  static const Duration staggeredDelay =
      Duration(milliseconds: 50); // Délai entre items
}

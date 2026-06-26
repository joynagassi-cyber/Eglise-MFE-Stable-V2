// lib/core/constants/app_assets.dart

class AppAssets {
  AppAssets._();

  static const String _premiumPath = 'assets/images/premium';

  // Auth
  static const String authBackground = '$_premiumPath/auth_background.png';
  static const String authLogo = '$_premiumPath/splash_artwork.png';

  // Badges
  static const String badgeGold = '$_premiumPath/badge_gold.png';
  static const String badgeSilver = '$_premiumPath/badge_silver.png';
  static const String badgeBronze = '$_premiumPath/badge_bronze.png';

  // Feedback (Optionnel mais impactant)
  static const String success = '$_premiumPath/feedback_success.png';
  static const String error = '$_premiumPath/feedback_error.png';
  static const String warning = '$_premiumPath/feedback_warning.png';
}

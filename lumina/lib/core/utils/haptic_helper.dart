// lib/core/utils/haptic_helper.dart
// Utilitaire pour feedback haptique standardisé

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Helper pour feedback haptique (vibrations tactiles)
class HapticHelper {
  HapticHelper._();

  /// Impact léger - Pour hover, focus, petites interactions
  static Future<void> light() async {
    await HapticFeedback.lightImpact();
  }

  /// Impact moyen - Pour sélections, toggles, switches
  static Future<void> medium() async {
    await HapticFeedback.mediumImpact();
  }

  /// Impact fort - Pour actions importantes, confirmations
  static Future<void> heavy() async {
    await HapticFeedback.heavyImpact();
  }

  /// Sélection - Pour navigation, changements de tabs
  static Future<void> selection() async {
    await HapticFeedback.selectionClick();
  }

  /// Succès - Pour validations réussies
  static Future<void> success() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.lightImpact();
  }

  /// Erreur - Pour actions échouées, erreurs
  static Future<void> error() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }

  /// Warning - Pour avertissements
  static Future<void> warning() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
  }

  /// Vibration - Pour notifications, alertes
  static Future<void> vibrate() async {
    await HapticFeedback.vibrate();
  }
}

/// Extension pour faciliter l'usage sur les widgets
extension HapticWidget on Widget {
  /// Wrapper avec feedback haptique au tap
  Widget withHaptic({
    HapticFeedbackType type = HapticFeedbackType.light,
  }) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            _triggerHaptic(type);
          },
          child: this,
        );
      },
    );
  }

  void _triggerHaptic(HapticFeedbackType type) {
    switch (type) {
      case HapticFeedbackType.light:
        HapticHelper.light();
        break;
      case HapticFeedbackType.medium:
        HapticHelper.medium();
        break;
      case HapticFeedbackType.heavy:
        HapticHelper.heavy();
        break;
      case HapticFeedbackType.selection:
        HapticHelper.selection();
        break;
      case HapticFeedbackType.success:
        HapticHelper.success();
        break;
      case HapticFeedbackType.error:
        HapticHelper.error();
        break;
      case HapticFeedbackType.warning:
        HapticHelper.warning();
        break;
    }
  }
}

/// Types de feedback haptique
enum HapticFeedbackType {
  light,
  medium,
  heavy,
  selection,
  success,
  error,
  warning,
}

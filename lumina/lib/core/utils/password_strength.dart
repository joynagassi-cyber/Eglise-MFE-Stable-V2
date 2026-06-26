// lib/core/utils/password_strength.dart

import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:flutter/material.dart';

enum PasswordStrength {
  weak,
  fair,
  strong,
  veryStrong;

  String get label {
    switch (this) {
      case PasswordStrength.weak:
        return 'Faible';
      case PasswordStrength.fair:
        return 'Moyen';
      case PasswordStrength.strong:
        return 'Fort';
      case PasswordStrength.veryStrong:
        return 'Très fort';
    }
  }

  Color color(LuminaColorsExtension colors) {
    switch (this) {
      case PasswordStrength.weak:
        return colors.errorText;
      case PasswordStrength.fair:
        return colors.warningText;
      case PasswordStrength.strong:
        return colors.successText;
      case PasswordStrength.veryStrong:
        return colors.successText;
    }
  }
}

class PasswordStrengthEvaluator {
  PasswordStrengthEvaluator._();

  static PasswordStrength evaluate(String password) {
    if (password.isEmpty) return PasswordStrength.weak;

    int score = 0;

    // Critères
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    // Vérification de séquences simples (ex: 123, abc)
    final bool hasSequence = _checkSequence(password);
    if (!hasSequence && password.length >= 8) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.fair;
    if (score == 5) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }

  static bool _checkSequence(String password) {
    // Logique simplifiée pour détecter les séquences évidentes
    final lower = password.toLowerCase();
    const sequences = ['123', 'abc', 'azerty', 'qwerty', 'password'];
    for (final seq in sequences) {
      if (lower.contains(seq)) return true;
    }
    return false;
  }
}

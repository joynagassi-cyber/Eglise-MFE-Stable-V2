// lib/core/utils/adaptive_code_formatter.dart
//
// Formateur de saisie adaptatif pour les codes secrets.
//
// Comportement :
//   - Force les majuscules en temps réel (même si l'utilisateur tape en minuscules).
//   - Insère automatiquement les tirets au bon endroit.
//   - Mode Patterns : S'adapte aux codes connus (ex: "ADMIN-XXXX-2026").
//   - Mode Universel (Défaut) : Formate en blocs de 4 (ex: "XXXX-XXXX-XXXX-...").
//   - Supporte jusqu'à 7 blocs (28 caractères + 6 tirets).

import 'package:flutter/services.dart';
import '../constants/security_constants.dart';

class AdaptiveCodeFormatter extends TextInputFormatter {
  final List<_CodePattern>? _patterns;
  final int maxBlocks;
  final int blockSize;

  AdaptiveCodeFormatter({
    List<String>? expectedPatterns,
    this.maxBlocks = 12, // Augmenté pour supporter les très longs codes
    this.blockSize = 4,
  }) : _patterns = (expectedPatterns ?? SecurityConstants.roleSecurityCodes).isNotEmpty
            ? (expectedPatterns ?? SecurityConstants.roleSecurityCodes)
                .map(_CodePattern.fromRawCode)
                .where((p) => p.stripped.isNotEmpty)
                .toList()
            : null;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 1. Normalisation : Tout en Majuscules
    final String text = newValue.text.toUpperCase();
    
    // Pour les patterns, on retire tout sauf Alphanumérique
    final String stripped = text.replaceAll(RegExp(r'[^A-Z0-9]'), '');

    if (stripped.isEmpty) return TextEditingValue.empty;

    final bool isDeleting = newValue.text.length < oldValue.text.length;

    // 2. Choix de la stratégie de formatage
    String formattedText;

    // Tentative de Match avec les patterns spécifiques
    final List<_CodePattern>? matches = _patterns
        ?.where((p) => p.stripped.startsWith(stripped))
        .toList();

    if (matches != null && matches.isNotEmpty) {
      formattedText = _applyPatternFormatting(stripped, matches, isDeleting);
    } else {
      // Stratégie Universelle : insertion intelligente de tirets
      // Tous les codes suivent la structure : MOTS-HEX4-2026
      // On insère un tiret avant le bloc hex (4 chars) et avant l'année 2026
      formattedText = _applyUniversalFormatting(stripped);
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  /// Formatage universel : insère les tirets selon la structure MOTS-HEX4-2026
  ///
  /// Tous les codes de l'application suivent ce schéma :
  ///   - Un ou plusieurs mots (lettres uniquement)
  ///   - Un bloc hexadécimal de 4 caractères (chiffres + lettres A-F)
  ///   - L'année "2026"
  ///
  /// Exemples :
  ///   PASTEUR00812026     → PASTEUR-0081-2026
  ///   SUPERADMIN5FA12026  → SUPERADMIN-5FA1-2026
  ///   CHEFCHORALE9B552026 → CHEFCHORALE-9B55-2026
  String _applyUniversalFormatting(String stripped) {
    // Si le code se termine par 2026, on peut structurer les tirets
    if (stripped.length > 8 && stripped.endsWith('2026')) {
      const year = '2026';
      final hexEnd = stripped.length - 4; // position avant 2026
      final hexStart = hexEnd - 4; // début du bloc hex (4 chars)
      final prefix = hexStart > 0 ? stripped.substring(0, hexStart) : '';
      final hex = stripped.substring(hexStart, hexEnd);

      final buffer = StringBuffer();
      if (prefix.isNotEmpty) buffer.write(prefix);
      buffer.write('-');
      buffer.write(hex);
      buffer.write('-');
      buffer.write(year);
      return buffer.toString();
    }

    // Fallback : transitions lettre→chiffre (au moins un tiret)
    final buffer = StringBuffer();
    for (int i = 0; i < stripped.length; i++) {
      if (i > 0) {
        final prevIsLetter = RegExp(r'[A-Z]').hasMatch(stripped[i - 1]);
        final currIsDigit = RegExp(r'[0-9]').hasMatch(stripped[i]);
        if (prevIsLetter && currIsDigit) {
          buffer.write('-');
        }
      }
      buffer.write(stripped[i]);
    }
    return buffer.toString();
  }

  /// Applique le formatage basé sur des patterns connus
  String _applyPatternFormatting(
    String stripped,
    List<_CodePattern> matches,
    bool isDeleting,
  ) {
    final buffer = StringBuffer();

    for (int i = 0; i < stripped.length; i++) {
      // Insérer un tiret AVANT ce caractère si TOUS les patterns compatibles prévoient un tiret
      final allAgree = matches.every((p) => p.dashPositions.contains(i));
      if (allAgree && i != 0) buffer.write('-');
      buffer.write(stripped[i]);
    }

    // Ajouter un tiret FINAL (trailing dash) pour guider l'utilisateur
    if (!isDeleting) {
      final nextPos = stripped.length;
      final extending = matches.where((p) => p.stripped.length > nextPos).toList();
      if (extending.isNotEmpty &&
          extending.every((p) => p.dashPositions.contains(nextPos))) {
        buffer.write('-');
      }
    }

    return buffer.toString();
  }
}

class _CodePattern {
  final String stripped;
  final List<int> dashPositions;

  const _CodePattern({
    required this.stripped,
    required this.dashPositions,
  });

  static _CodePattern fromRawCode(String rawCode) {
    final upper = rawCode.trim().toUpperCase();
    final positions = <int>[];
    int strippedIndex = 0;

    for (int i = 0; i < upper.length; i++) {
      if (upper[i] == '-') {
        positions.add(strippedIndex);
      } else {
        strippedIndex++;
      }
    }

    return _CodePattern(
      stripped: upper.replaceAll('-', ''),
      dashPositions: positions,
    );
  }
}

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
      // Stratégie Universelle : Majuscules uniquement, pas de tirets forcés
      // On garde le texte original (majuscule) tel quel pour laisser l'utilisateur libre
      formattedText = text;
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
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

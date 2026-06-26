// lib/core/providers/data_visibility_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider pour gérer la visibilité des données sensibles (masquage)
final dataVisibilityProvider = StateProvider<bool>((ref) => false);

/// Extension pour formater les montants avec masquage optionnel
extension MaskableAmount on double {
  String toMaskedCurrency({required bool isVisible, String currency = 'FCFA'}) {
    if (!isVisible) return '•••••• $currency';

    // Formatage simple pour l'exemple, peut être enrichi avec NumberFormat
    if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M $currency';
    }
    if (this >= 1000) return '${(this / 1000).toStringAsFixed(0)}K $currency';
    return '${toStringAsFixed(0)} $currency';
  }
}

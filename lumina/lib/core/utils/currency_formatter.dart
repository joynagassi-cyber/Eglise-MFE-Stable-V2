// lib/core/utils/currency_formatter.dart
// AMÉLIORATION: Centralisation du formatage financier pour une cohérence globale.

import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final Map<String, NumberFormat> _formatters = {};

  /// Formate un montant avec le symbole de devise approprié.
  /// Exemple: format(1250000, 'XOF') -> "1 250 000 XOF"
  static String format(num amount, String currency) {
    if (!_formatters.containsKey(currency)) {
      _formatters[currency] = NumberFormat.currency(
        locale: 'fr_FR',
        symbol: currency,
        decimalDigits: 0,
      );
    }
    return _formatters[currency]!.format(amount);
  }

  /// Formate un montant en utilisant la devise de l'église actuelle (si disponible).
  static String formatWithChurch(num amount, {String? churchCurrency}) {
    return format(amount, churchCurrency ?? 'XOF');
  }
}

// lib/features/finance/domain/services/currency_service.dart

/// Service de conversion de devises pour le MVP.
/// Utilise des taux statiques (BEAC) — pas d'API externe.
class CurrencyService {
  CurrencyService._();

  /// Taux de change statiques (base: 1 EUR)
  static const Map<String, double> _rates = {
    'XAF': 655.957, // Franc CFA BEAC (taux fixe)
    'XOF': 655.957, // Franc CFA BCEAO (taux fixe)
    'EUR': 1.0,
    'USD': 1.08, // Approximatif
    'GBP': 0.86,
    'CHF': 0.95,
  };

  /// Devises supportées
  static List<String> get supportedCurrencies => _rates.keys.toList();

  /// Convertir un montant d'une devise à une autre
  static double convert(double amount, String from, String to) {
    if (from == to) return amount;

    final fromRate = _rates[from];
    final toRate = _rates[to];

    if (fromRate == null || toRate == null) return amount;

    // Convertir en EUR (base), puis vers la devise cible
    final amountInEur = amount / fromRate;
    return amountInEur * toRate;
  }

  /// Obtenir le taux de change entre deux devises
  static double getRate(String from, String to) {
    if (from == to) return 1.0;

    final fromRate = _rates[from];
    final toRate = _rates[to];

    if (fromRate == null || toRate == null) return 1.0;

    return toRate / fromRate;
  }

  /// Formater un montant avec symbole de devise
  static String format(double amount, String currency) {
    final symbol = _currencySymbols[currency] ?? currency;
    if (currency == 'XAF' || currency == 'XOF') {
      return '${amount.toStringAsFixed(0)} $symbol';
    }
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  static const Map<String, String> _currencySymbols = {
    'XAF': 'FCFA',
    'XOF': 'FCFA',
    'EUR': '€',
    'USD': '\$',
    'GBP': '£',
    'CHF': 'CHF',
  };
}
/// Number formatter service for Excel-like formatting
///
/// Supports:
/// - XOF Béninois (FCFA) as default currency
/// - Space thousands separator
/// - Banker's rounding (half-even)
/// - Compact notation (10k, 1.2M)
/// - Parentheses for negative values
library;

import 'package:intl/intl.dart';

class NumberFormatterService {
  NumberFormatterService({
    this.locale = 'fr_BJ',
    this.currencyCode = 'XOF',
    this.currencySymbol = 'FCFA',
    this.decimalPrecision = 0,
    this.thousandSeparator = ' ',
    this.decimalSeparator = ',',
    this.useParenthesesForNegative = true,
  });

  final String locale;
  final String currencyCode;
  final String currencySymbol;
  final int decimalPrecision;
  final String thousandSeparator;
  final String decimalSeparator;
  final bool useParenthesesForNegative;

  /// Format as currency (XX XXX FCFA)
  String formatCurrency(num amount, {bool showSymbol = true}) {
    final isNegative = amount < 0;
    final absValue = amount.abs().toDouble();

    final rounded = bankersRound(absValue);
    final formatted = _formatWithThousands(rounded);
    final result = showSymbol ? '$formatted $currencySymbol' : formatted;

    if (isNegative) {
      return useParenthesesForNegative ? '($result)' : '-$result';
    }
    return result;
  }

  /// Format as compact (1.2M, 10k)
  String formatCompact(num amount) {
    final absValue = amount.abs().toDouble();
    final isNegative = amount < 0;

    String result;
    if (absValue >= 1000000) {
      result = '${(absValue / 1000000).toStringAsFixed(1)}M';
    } else if (absValue >= 1000) {
      result = '${(absValue / 1000).toStringAsFixed(0)}k';
    } else {
      result = absValue.toStringAsFixed(0);
    }

    return isNegative ? '-$result' : result;
  }

  /// Format as percentage
  String formatPercentage(double value, {int decimals = 1}) {
    final formatted = value.toStringAsFixed(decimals);
    return '$formatted%';
  }

  /// Format with sign (+/-)
  String formatWithSign(num amount) {
    final formatted = formatCurrency(amount, showSymbol: false);
    if (amount > 0) return '+$formatted';
    return formatted;
  }

  /// Format integer with thousands separator
  String _formatWithThousands(int value) {
    final formatter = NumberFormat('#,##0', locale);
    return formatter.format(value).replaceAll(',', thousandSeparator);
  }

  /// Banker's rounding (half-even)
  static int bankersRound(double value) {
    final floor = value.floor();
    final diff = value - floor;
    if (diff < 0.5) return floor;
    if (diff > 0.5) return floor + 1;
    return floor.isEven ? floor : floor + 1;
  }
}
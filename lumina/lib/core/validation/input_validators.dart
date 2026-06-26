import 'package:flutter/services.dart';

/// Validation centralisée pour tous les inputs
class InputValidators {
  // Email
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email requis';
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(value) ? null : 'Email invalide';
  }

  // Téléphone
  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'Téléphone requis';
    final cleaned = value.replaceAll(RegExp(r'[^\d+]'), '');
    return cleaned.length >= 10 ? null : 'Téléphone invalide';
  }

  // Montant
  static String? amount(String? value) {
    if (value == null || value.isEmpty) return 'Montant requis';
    final amount = double.tryParse(value);
    if (amount == null) return 'Montant invalide';
    return amount > 0 ? null : 'Montant doit être positif';
  }

  // Texte requis
  static String? required(String? value, [String field = 'Champ']) {
    return value?.trim().isEmpty ?? true ? '$field requis' : null;
  }

  // Longueur min
  static String? minLength(String? value, int min) {
    if (value == null || value.isEmpty) return 'Champ requis';
    return value.length >= min ? null : 'Minimum $min caractères';
  }

  // Date
  static String? date(DateTime? value) {
    return value == null ? 'Date requise' : null;
  }
}

/// Input formatters
class InputFormatters {
  static final phone =
      FilteringTextInputFormatter.allow(RegExp(r'[\d+\s\-\(\)]'));
  static final amount =
      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'));
  static final alphanumeric =
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]'));
}

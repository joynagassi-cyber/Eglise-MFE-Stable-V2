// lib/features/finance/domain/entities/enums/payment_method.dart
import 'package:flutter/material.dart';

enum PaymentMethod {
  cash, // Espèces
  mobileMoney, // Orange Money, MTN, Wave
  bankTransfer, // Virement bancaire
  check, // Chèque
  other; // Autre

  String get label {
    switch (this) {
      case PaymentMethod.cash:
        return 'Espèces';
      case PaymentMethod.mobileMoney:
        return 'Mobile Money';
      case PaymentMethod.bankTransfer:
        return 'Virement';
      case PaymentMethod.check:
        return 'Chèque';
      case PaymentMethod.other:
        return 'Autre';
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentMethod.cash:
        return Icons.money;
      case PaymentMethod.mobileMoney:
        return Icons.smartphone;
      case PaymentMethod.bankTransfer:
        return Icons.account_balance;
      case PaymentMethod.check:
        return Icons.wysiwyg;
      case PaymentMethod.other:
        return Icons.category;
    }
  }
}
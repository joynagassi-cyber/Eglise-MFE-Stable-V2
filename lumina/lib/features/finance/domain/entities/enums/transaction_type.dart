// lib/features/finance/domain/entities/enums/transaction_type.dart

enum TransactionType {
  income, // Revenu (Dîmes, Offrandes, Dons)
  expense, // Dépense (Factures, Salaires, Aide)
  transfer; // Transfert interne

  String get label {
    switch (this) {
      case TransactionType.income:
        return 'Entrée';
      case TransactionType.expense:
        return 'Sortie';
      case TransactionType.transfer:
        return 'Transfert';
    }
  }

}
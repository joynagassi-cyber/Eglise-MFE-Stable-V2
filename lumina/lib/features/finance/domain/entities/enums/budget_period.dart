// lib/features/finance/domain/entities/enums/budget_period.dart
// Énumération des périodes de budget

enum BudgetPeriod {
  monthly,
  quarterly,
  annual;

  String get label {
    switch (this) {
      case BudgetPeriod.monthly:
        return 'Mensuel';
      case BudgetPeriod.quarterly:
        return 'Trimestriel';
      case BudgetPeriod.annual:
        return 'Annuel';
    }
  }

  String get shortLabel {
    switch (this) {
      case BudgetPeriod.monthly:
        return 'M';
      case BudgetPeriod.quarterly:
        return 'T';
      case BudgetPeriod.annual:
        return 'A';
    }
  }
}
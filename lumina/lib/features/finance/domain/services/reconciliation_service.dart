import 'package:lumina/features/finance/domain/entities/enums/transaction_type.dart'
    show TransactionType;
import 'package:lumina/features/finance/domain/entities/finance_transaction.dart'
    show FinanceTransaction;

import 'package:csv/csv.dart';
import 'package:logger/logger.dart';

class ImportedTransaction {
  final DateTime date;
  final String description;
  final double amount;
  final TransactionType type;
  bool isMatched;
  FinanceTransaction? matchedTransaction;

  ImportedTransaction({
    required this.date,
    required this.description,
    required this.amount,
    required this.type,
    this.isMatched = false,
    this.matchedTransaction,
  });
}

class ReconciliationService {
  final _logger = Logger();

  List<ImportedTransaction> parseCsv(String csvContent) {
    // Simple CSV parser assuming columns: Date, Description, Montant (negative for expense)
    // Custom parsers can be added for different bank formats
    final List<List<dynamic>> rows = const CsvToListConverter().convert(
      csvContent,
    );
    final List<ImportedTransaction> transactions = [];

    // Skip header row if exists (usually row 0)
    // Assuming simplistic format for MVP: Date(YYYY-MM-DD), Description, Amount
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.length < 3) continue;

      try {
        final dateStr = row[0].toString();
        final desc = row[1].toString();
        final amountVal = double.tryParse(row[2].toString()) ?? 0.0;

        final type =
            amountVal >= 0 ? TransactionType.income : TransactionType.expense;
        final amount = amountVal.abs();
        final date = DateTime.tryParse(dateStr) ?? DateTime.now();

        transactions.add(
          ImportedTransaction(
            date: date,
            description: desc,
            amount: amount,
            type: type,
          ),
        );
      } catch (e) {
        // Skip invalid rows
        _logger.e('Error parsing row $i: $e');
      }
    }
    return transactions;
  }

  void matchTransactions(
    List<ImportedTransaction> imported,
    List<FinanceTransaction> existing,
  ) {
    // Simple matching algorithm
    // Match exactly on Amount and Type, and Date within +/- 3 days
    for (var imp in imported) {
      if (imp.isMatched) continue;

      try {
        final match = existing.firstWhere((ex) {
          final daysDiff = ex.date.difference(imp.date).inDays.abs();
          final amountMatch = (ex.amount - imp.amount).abs() < 0.01;
          final typeMatch = ex.type == imp.type;

          // TODO: Add check if 'ex' is already matched to another imported transaction?
          // For MVP, we don't track 'isMatched' on existing transactions here without local state.
          // In a real app, 'existing' list should be mutable wrappers or we track IDs.

          return amountMatch && typeMatch && daysDiff <= 3;
        });

        imp.isMatched = true;
        imp.matchedTransaction = match;
      } catch (e) {
        // No match found
        imp.isMatched = false;
      }
    }
  }
}
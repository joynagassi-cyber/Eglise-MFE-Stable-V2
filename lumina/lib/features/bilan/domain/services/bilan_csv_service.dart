import 'dart:convert';
import 'dart:typed_data';
import '../entities/bilan_entities.dart';

class BilanCsvService {
  /// Generate a CSV of transactions
  Uint8List generateTransactionsCsv(List<BilanTransaction> transactions) {
    final headers = [
      'Date',
      'Libellé',
      'Type',
      'Catégorie',
      'Groupe',
      'Montant',
    ];
    final buffer = StringBuffer();

    // Write headers
    buffer.writeln(headers.join(';'));

    for (final tx in transactions) {
      final row = [
        tx.date.toIso8601String().substring(0, 10),
        tx.label,
        tx.type,
        tx.category,
        tx.groupName ?? '',
        tx.amount.toString(),
      ];
      buffer.writeln(row.join(';'));
    }

    final encoded = utf8.encode(buffer.toString());
    final bom = [0xEF, 0xBB, 0xBF];
    return Uint8List.fromList([...bom, ...encoded]);
  }

  /// Generate a CSV of group summaries
  Uint8List generateSummariesCsv(List<BilanGroupSummary> summaries) {
    final headers = [
      'Groupe',
      'Entrées',
      'Sorties',
      'Net',
      'Transactions',
      '% Total',
    ];
    final buffer = StringBuffer();

    // Write headers
    buffer.writeln(headers.join(';'));

    for (final s in summaries) {
      final row = [
        s.groupName,
        s.income.toString(),
        s.expense.toString(),
        s.net.toString(),
        s.txCount.toString(),
        s.percentOfTotal?.toStringAsFixed(2) ?? '0.00',
      ];
      buffer.writeln(row.join(';'));
    }

    final encoded = utf8.encode(buffer.toString());
    final bom = [0xEF, 0xBB, 0xBF];
    return Uint8List.fromList([...bom, ...encoded]);
  }
}
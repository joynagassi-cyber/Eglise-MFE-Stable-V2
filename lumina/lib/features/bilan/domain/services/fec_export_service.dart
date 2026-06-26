import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import '../entities/bilan_entities.dart';

class FecExportService {
  /// Generate FEC file content in OHADA-compliant CSV format (Tab-separated)
  Uint8List generateFecCsv(List<FecLine> lines) {
    final dateFormat = DateFormat('yyyyMMdd');
    final headers = [
      'JournalCode',
      'JournalLib',
      'EcritureNum',
      'EcritureDate',
      'CompteNum',
      'CompteLib',
      'CompauxNum',
      'CompauxLib',
      'PieceRef',
      'PieceDate',
      'EcritureLib',
      'Debit',
      'Credit',
      'ValidDate',
      'Montantdevise',
      'Idevise',
    ];

    final buffer = StringBuffer();

    // Write headers (Tab separated is preferred for FEC)
    buffer.writeln(headers.join('\t'));

    // Write data rows
    for (final line in lines) {
      final row = [
        line.journalCode,
        line.journalLib,
        line.ecritureNum,
        dateFormat.format(line.ecritureDate),
        line.compteNum,
        line.compteLib,
        line.compauxNum,
        line.compauxLib,
        line.pieceRef,
        dateFormat.format(line.pieceDate),
        line.ecritureLib,
        line.debit.toStringAsFixed(2).replaceAll('.', ','),
        line.credit.toStringAsFixed(2).replaceAll('.', ','),
        dateFormat.format(line.valideDate),
        line.montantDevise.toStringAsFixed(2).replaceAll('.', ','),
        line.iDevise,
      ];
      buffer.writeln(row.join('\t'));
    }

    // Convert to bytes with UTF-8 BOM (for Excel compatibility)
    final encoded = utf8.encode(buffer.toString());
    final bom = [0xEF, 0xBB, 0xBF];
    return Uint8List.fromList([...bom, ...encoded]);
  }
}
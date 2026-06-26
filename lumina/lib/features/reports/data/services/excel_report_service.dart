// lib/features/reports/data/services/excel_report_service.dart

import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import '../../../finance/domain/entities/finance_transaction.dart';
import '../../../finance/domain/entities/enums/transaction_type.dart';

class ExcelReportService {
  Future<Uint8List> generateFinancialReport({
    required DateTime startDate,
    required DateTime endDate,
    required List<FinanceTransaction> transactions,
    List<Map<String, dynamic>>? registreCulte,
    required String churchName,
  }) async {
    final excel = Excel.createExcel();

    _addSummarySheet(excel, transactions, churchName, startDate, endDate);
    _addTransactionsSheet(excel, transactions);
    _addCategoryAnalysisSheet(excel, transactions);
    if (registreCulte != null && registreCulte.isNotEmpty) {
      _addRegistreCulteSheet(excel, registreCulte);
    }

    excel.delete('Sheet1');

    final bytes = excel.encode();
    return Uint8List.fromList(bytes!);
  }

  void _addSummarySheet(
    Excel excel,
    List<FinanceTransaction> transactions,
    String churchName,
    DateTime start,
    DateTime end,
  ) {
    final sheet = excel['Résumé'];

    final totalIncome = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (s, t) => s + t.amount);
    final totalExpense = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (s, t) => s + t.amount);
    final balance = totalIncome - totalExpense;

    _addHeader(sheet, 'A1', churchName, isTitle: true);
    _addHeader(sheet, 'A2', 'Rapport Financier');
    _addHeader(
      sheet,
      'A3',
      'Période: ${DateFormat('dd/MM/yyyy').format(start)} - ${DateFormat('dd/MM/yyyy').format(end)}',
    );

    _addLabelValue(sheet, 5, 'Total Revenus', totalIncome, isAmount: true);
    _addLabelValue(sheet, 6, 'Total Dépenses', totalExpense, isAmount: true);
    _addLabelValue(sheet, 7, 'Solde', balance, isAmount: true);
    _addLabelValue(
      sheet,
      9,
      'Nombre de transactions',
      transactions.length.toDouble(),
    );

    sheet.setColumnWidth(0, 30);
    sheet.setColumnWidth(1, 20);
  }

  void _addHeader(
    Sheet sheet,
    String cell,
    String value, {
    bool isTitle = false,
  }) {
    final c = sheet.cell(CellIndex.indexByString(cell));
    c.value = TextCellValue(value);
    c.cellStyle = CellStyle(
      bold: true,
      fontSize: isTitle ? 16 : 12,
      fontColorHex: ExcelColor.fromInt(0xFF4B2C82),
    );
  }

  void _addLabelValue(
    Sheet sheet,
    int row,
    String label,
    double value, {
    bool isAmount = false,
  }) {
    sheet.cell(CellIndex.indexByString('A$row')).value = TextCellValue(label);
    final valCell = sheet.cell(CellIndex.indexByString('B$row'));
    valCell.value = DoubleCellValue(value);
    if (isAmount) {
      valCell.cellStyle = CellStyle(
        fontColorHex: ExcelColor.fromInt(value >= 0 ? 0xFF2E7D32 : 0xFFC62828),
      );
    }
  }

  void _addTransactionsSheet(
    Excel excel,
    List<FinanceTransaction> transactions,
  ) {
    final sheet = excel['Transactions'];

    final headers = [
      'Date',
      'Catégorie',
      'Description',
      'Compte',
      'Paiement',
      'Type',
      'Montant',
    ];
    for (var i = 0; i < headers.length; i++) {
      final cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
      );
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.fromInt(0xFF4B2C82),
        fontColorHex: ExcelColor.fromInt(0xFFFFFFFF),
      );
    }

    for (var i = 0; i < transactions.length; i++) {
      final tx = transactions[i];
      final r = i + 1;

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: r))
          .value = TextCellValue(
        DateFormat('dd/MM/yyyy').format(tx.date),
      );
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: r))
          .value = TextCellValue(
        tx.category ?? '-',
      );
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: r))
          .value = TextCellValue(
        tx.description,
      );
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: r))
          .value = TextCellValue(
        tx.accountId ?? '-',
      );
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: r))
          .value = TextCellValue(
        tx.paymentMethod.label,
      );
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: r))
          .value = TextCellValue(
        tx.type == TransactionType.income ? 'Revenu' : 'Dépense',
      );
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: r))
          .value = DoubleCellValue(
        tx.amount,
      );
    }

    sheet.setColumnWidth(0, 15);
    sheet.setColumnWidth(1, 20);
    sheet.setColumnWidth(2, 40);
    sheet.setColumnWidth(3, 15);
    sheet.setColumnWidth(4, 15);
    sheet.setColumnWidth(5, 10);
    sheet.setColumnWidth(6, 15);
  }

  void _addCategoryAnalysisSheet(
    Excel excel,
    List<FinanceTransaction> transactions,
  ) {
    final sheet = excel['Analyse par Catégorie'];

    final categoryMap = <String, double>{};
    for (final tx in transactions) {
      final category = tx.category ?? 'Non catégorisé';
      categoryMap[category] = (categoryMap[category] ?? 0) + tx.amount;
    }

    sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue(
      'Catégorie',
    );
    sheet.cell(CellIndex.indexByString('B1')).value = TextCellValue(
      'Montant Total',
    );
    sheet.cell(CellIndex.indexByString('C1')).value = TextCellValue(
      'Pourcentage',
    );

    final total = categoryMap.values.fold(0.0, (s, v) => s + v);
    var row = 2;

    for (final entry in categoryMap.entries) {
      final percent = total == 0 ? 0.0 : (entry.value / total * 100);
      sheet.cell(CellIndex.indexByString('A$row')).value = TextCellValue(
        entry.key,
      );
      sheet.cell(CellIndex.indexByString('B$row')).value = DoubleCellValue(
        entry.value,
      );
      sheet.cell(CellIndex.indexByString('C$row')).value = TextCellValue(
        '${percent.toStringAsFixed(1)}%',
      );
      row++;
    }
  }

  void _addRegistreCulteSheet(Excel excel, List<Map<String, dynamic>> data) {
    final sheet = excel['Registre de Culte'];
    final headers = [
      'Date',
      'Type Service',
      'Offrandes',
      'Dîmes',
      'Terrain',
      'Chorale',
      'Total'
    ];

    for (var i = 0; i < headers.length; i++) {
      final cell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.fromInt(0xFF2E7D32),
        fontColorHex: ExcelColor.fromInt(0xFFFFFFFF),
      );
    }

    for (var i = 0; i < data.length; i++) {
      final row = data[i];
      final r = i + 1;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: r))
          .value = TextCellValue(row['date']?.toString() ?? '-');
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: r))
          .value = TextCellValue(row['type_service']?.toString() ?? '-');
      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: r))
              .value =
          DoubleCellValue(
              double.tryParse(row['offrandes']?.toString() ?? '0') ?? 0);
      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: r))
              .value =
          DoubleCellValue(
              double.tryParse(row['dimes']?.toString() ?? '0') ?? 0);
      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: r))
              .value =
          DoubleCellValue(
              double.tryParse(row['terrain']?.toString() ?? '0') ?? 0);
      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: r))
              .value =
          DoubleCellValue(
              double.tryParse(row['chorale']?.toString() ?? '0') ?? 0);
      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: r))
              .value =
          DoubleCellValue(
              double.tryParse(row['total_jour']?.toString() ?? '0') ?? 0);
    }

    sheet.setColumnWidth(0, 15);
    sheet.setColumnWidth(1, 25);
    for (var j = 2; j < 7; j++) {
      sheet.setColumnWidth(j, 15);
    }
  }
}
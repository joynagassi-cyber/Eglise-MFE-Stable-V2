import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:fl_chart/fl_chart.dart';
import '../../../finance/domain/entities/finance_transaction.dart';
import '../../../finance/domain/entities/enums/transaction_type.dart';
import 'chart_generator_service.dart';

/// Top-level function for Isolate execution.
/// Receives a map with pre-generated chart bytes and transaction JSON data,
/// then builds the PDF document entirely off the UI thread.
Future<Uint8List> _buildPdfInIsolate(Map<String, dynamic> params) async {
  final service = EnhancedPdfService();
  return service._buildPdfDocument(
    startDate: DateTime.parse(params['startDate'] as String),
    endDate: DateTime.parse(params['endDate'] as String),
    transactions: (params['transactions'] as List)
        .map((e) => FinanceTransaction.fromJson(e as Map<String, dynamic>))
        .toList(),
    registreCulte:
        (params['registreCulte'] as List?)?.cast<Map<String, dynamic>>(),
    churchName: params['churchName'] as String,
    reportType: params['reportType'] as String,
    chartBytes: (params['chartBytes'] as List?)?.cast<Uint8List>(),
    logoBytes: params['logoBytes'] as Uint8List?,
  );
}

class EnhancedPdfService {
  static final _currencyFormat = NumberFormat.currency(
    locale: 'fr_FR',
    symbol: 'FCFA',
    decimalDigits: 0,
  );

  Future<Uint8List> generateEnhancedReport({
    required DateTime startDate,
    required DateTime endDate,
    required List<FinanceTransaction> transactions,
    List<Map<String, dynamic>>? registreCulte,
    required String churchName,
    required String reportType,
    bool showCharts = true,
    Uint8List? logoBytes,
  }) async {
    // Trier par date pour la cohérence
    final sortedTransactions = List<FinanceTransaction>.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));

    // Générer les charts sur le thread principal (nécessite Flutter rendering)
    List<Uint8List>? charts;
    if (showCharts) {
      final chartService = ChartGeneratorService();
      final categoryData = _groupByCategory(sortedTransactions);
      final dailyData = _groupByDay(sortedTransactions);
      charts = await Future.wait([
        chartService.generatePieChart(
          data: categoryData.map(
            (k, v) => MapEntry(k, v.fold(0.0, (s, t) => s + t.amount)),
          ),
        ),
        _generateLineChartData(dailyData, chartService),
        _generateBarChartData(sortedTransactions, chartService),
      ]);
    }

    // Offload la construction PDF lourde vers un Isolate
    return compute(_buildPdfInIsolate, {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'transactions': sortedTransactions.map((t) => t.toJson()).toList(),
      'registreCulte': registreCulte,
      'churchName': churchName,
      'reportType': reportType,
      'chartBytes': charts,
      'logoBytes': logoBytes,
    });
  }

  /// Construction du document PDF (peut tourner dans un Isolate)
  Future<Uint8List> _buildPdfDocument({
    required DateTime startDate,
    required DateTime endDate,
    required List<FinanceTransaction> transactions,
    List<Map<String, dynamic>>? registreCulte,
    required String churchName,
    required String reportType,
    List<Uint8List>? chartBytes,
    Uint8List? logoBytes,
  }) async {
    final categoryData = _groupByCategory(transactions);

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildPageHeader(context, churchName),
        footer: (context) => _buildPageFooter(context),
        build: (context) => [
          _buildEnhancedHeader(
              churchName, startDate, endDate, reportType, logoBytes),
          pw.SizedBox(height: 20),
          _buildKPICards(transactions),
          if (chartBytes != null) ...[
            pw.SizedBox(height: 20),
            _buildChartSection('Répartition par Catégorie', chartBytes[0]),
            pw.SizedBox(height: 20),
            _buildChartSection('Évolution Quotidienne', chartBytes[1]),
            pw.SizedBox(height: 20),
            _buildChartSection('Top 5 Dépenses', chartBytes[2]),
          ],
          if (registreCulte != null && registreCulte.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            _buildRegistreCulteSection(registreCulte),
          ],
          pw.SizedBox(height: 20),
          _buildCategoryTable(categoryData),
          pw.SizedBox(height: 20),
          _buildTransactionsTable(transactions),
        ],
      ),
    );

    return pdf.save();
  }

  Future<Uint8List> _generateLineChartData(
    Map<DateTime, List<FinanceTransaction>> dailyData,
    ChartGeneratorService chartService,
  ) async {
    final spots = dailyData.entries.toList().asMap().entries.map((e) {
      final balance = e.value.value.fold(
        0.0,
        (s, t) => s + (t.type == TransactionType.income ? t.amount : -t.amount),
      );
      return FlSpot(e.key.toDouble(), balance);
    }).toList();
    return await chartService.generateLineChart(spots: spots);
  }

  Future<Uint8List> _generateBarChartData(
    List<FinanceTransaction> transactions,
    ChartGeneratorService chartService,
  ) async {
    final topExpenses =
        (transactions.where((t) => t.type == TransactionType.expense).toList()
              ..sort((a, b) => b.amount.compareTo(a.amount)))
            .take(5);
    final data = Map.fromEntries(
      topExpenses.map(
        (t) => MapEntry(
          t.description.substring(
            0,
            t.description.length > 10 ? 10 : t.description.length,
          ),
          t.amount,
        ),
      ),
    );
    return await chartService.generateBarChart(data: data);
  }

  pw.Widget _buildPageHeader(pw.Context context, String churchName) {
    if (context.pageNumber == 1) return pw.SizedBox.shrink();
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Text(
        '$churchName - Rapport Financier',
        style: const pw.TextStyle(color: PdfColors.grey, fontSize: 10),
      ),
    );
  }

  pw.Widget _buildPageFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Text(
        'Page ${context.pageNumber} sur ${context.pagesCount}',
        style: const pw.TextStyle(color: PdfColors.grey, fontSize: 10),
      ),
    );
  }

  pw.Widget _buildEnhancedHeader(
    String churchName,
    DateTime start,
    DateTime end,
    String type,
    Uint8List? logoBytes,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        gradient: const pw.LinearGradient(
          colors: [PdfColors.blue900, PdfColors.blue700],
        ),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                churchName.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'RAPPORT FINANCIER ${type.toUpperCase()}',
                style: const pw.TextStyle(fontSize: 14, color: PdfColors.white),
              ),
              pw.Text(
                '${DateFormat('dd/MM/yyyy').format(start)} - ${DateFormat('dd/MM/yyyy').format(end)}',
                style: const pw.TextStyle(fontSize: 11, color: PdfColors.white),
              ),
            ],
          ),
          if (logoBytes != null)
            pw.Container(
              width: 60,
              height: 60,
              decoration: const pw.BoxDecoration(
                color: PdfColors.white,
                shape: pw.BoxShape.circle,
              ),
              padding: const pw.EdgeInsets.all(5),
              child: pw.Image(pw.MemoryImage(logoBytes)),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildRegistreCulteSection(List<Map<String, dynamic>> data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'REGISTRE DE CULTE (RÉSUMÉ DES COLLECTES)',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.TableHelper.fromTextArray(
          headers: ['Date', 'Type Service', 'Offrandes', 'Dîmes', 'Total'],
          data: data.take(31).map((row) {
            return [
              row['date'] ?? '-',
              row['type_service'] ?? '-',
              _currencyFormat
                  .format(double.tryParse(row['offrandes'].toString()) ?? 0),
              _currencyFormat
                  .format(double.tryParse(row['dimes'].toString()) ?? 0),
              _currencyFormat
                  .format(double.tryParse(row['total_jour'].toString()) ?? 0),
            ];
          }).toList(),
          headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white,
            fontSize: 10,
          ),
          cellStyle: const pw.TextStyle(fontSize: 9),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerRight,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.centerRight,
          },
        ),
      ],
    );
  }

  pw.Widget _buildKPICards(List<FinanceTransaction> transactions) {
    final stats = _calculateStats(transactions);

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _buildKPICard('Revenus', _currencyFormat.format(stats['income'])),
        _buildKPICard('Dépenses', _currencyFormat.format(stats['expense'])),
        _buildKPICard('Solde', _currencyFormat.format(stats['balance'])),
        _buildKPICard(
          'Épargne',
          '${(stats['savingsRate'] ?? 0.0).toStringAsFixed(1)}%',
        ),
      ],
    );
  }

  Map<String, double> _calculateStats(List<FinanceTransaction> transactions) {
    double income = 0, expense = 0;
    for (final t in transactions) {
      if (t.type == TransactionType.income) {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }
    final balance = income - expense;
    final savingsRate = income == 0 ? 0.0 : ((income - expense) / income * 100);
    return {
      'income': income,
      'expense': expense,
      'balance': balance,
      'savingsRate': savingsRate,
    };
  }

  pw.Widget _buildKPICard(String label, String value) {
    return pw.Expanded(
      child: pw.Container(
        margin: const pw.EdgeInsets.symmetric(horizontal: 4),
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          color: PdfColors.grey100,
          borderRadius: pw.BorderRadius.circular(8),
          border: pw.Border.all(color: PdfColors.grey300, width: 1),
        ),
        child: pw.Column(
          children: [
            pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 4),
            pw.Text(
              value,
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget _buildChartSection(String title, Uint8List chartBytes) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Container(
          height: 200,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Center(
            child: pw.Image(
              pw.MemoryImage(chartBytes),
              width: 400,
              height: 180,
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildCategoryTable(
    Map<String, List<FinanceTransaction>> categoryData,
  ) {
    final total =
        categoryData.values.expand((v) => v).fold(0.0, (s, t) => s + t.amount);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'ANALYSE PAR CATÉGORIE',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.TableHelper.fromTextArray(
          headers: ['Catégorie', 'Transactions', 'Montant', '%'],
          data: categoryData.entries.map((e) {
            final amount = e.value.fold(0.0, (s, t) => s + t.amount);
            final percent = total == 0 ? 0.0 : (amount / total * 100);
            return [
              e.key,
              e.value.length.toString(),
              _currencyFormat.format(amount),
              '${percent.toStringAsFixed(1)}%',
            ];
          }).toList(),
          headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white,
          ),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.center,
            2: pw.Alignment.centerRight,
            3: pw.Alignment.center,
          },
        ),
      ],
    );
  }

  pw.Widget _buildTransactionsTable(List<FinanceTransaction> transactions) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'DÉTAIL EXHAUSTIF DES TRANSACTIONS',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.TableHelper.fromTextArray(
          headers: [
            'Date',
            'Catégorie',
            'Description',
            'Compte',
            'Paiement',
            'Montant',
          ],
          data: transactions
              .map(
                (t) => [
                  DateFormat('dd/MM/yyyy').format(t.date),
                  t.category ?? '-',
                  t.description,
                  t.accountId ?? '-',
                  t.paymentMethod.label,
                  _currencyFormat.format(t.amount),
                ],
              )
              .toList(),
          headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white,
            fontSize: 10,
          ),
          cellStyle: const pw.TextStyle(fontSize: 9),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
          cellHeight: 20,
          columnWidths: {
            0: const pw.FixedColumnWidth(60),
            1: const pw.FixedColumnWidth(80),
            2: const pw.FlexColumnWidth(),
            3: const pw.FixedColumnWidth(60),
            4: const pw.FixedColumnWidth(60),
            5: const pw.FixedColumnWidth(70),
          },
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.center,
            4: pw.Alignment.center,
            5: pw.Alignment.centerRight,
          },
          oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
          headerAlignment: pw.Alignment.center,
        ),
      ],
    );
  }

  Map<String, List<FinanceTransaction>> _groupByCategory(
    List<FinanceTransaction> transactions,
  ) {
    final map = <String, List<FinanceTransaction>>{};
    for (final tx in transactions) {
      final category = tx.category ?? 'Non catégorisé';
      map.putIfAbsent(category, () => []).add(tx);
    }
    return map;
  }

  Map<DateTime, List<FinanceTransaction>> _groupByDay(
    List<FinanceTransaction> transactions,
  ) {
    final map = <DateTime, List<FinanceTransaction>>{};
    for (final tx in transactions) {
      final day = DateTime(tx.date.year, tx.date.month, tx.date.day);
      map.putIfAbsent(day, () => []).add(tx);
    }
    return map;
  }
}
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../../../../events/domain/entities/event.dart';
import '../chart_generator_service.dart';

class EventReportService {
  final currencyFormat = NumberFormat.currency(
    locale: 'fr_FR',
    symbol: 'FCFA',
    decimalDigits: 0,
  );

  Future<File> generateEventReport({
    required List<Event> events,
    required String churchName,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final pdf = pw.Document();
    final chartService = ChartGeneratorService();

    final typeData = _groupByType(events);
    final pieChartBytes = await chartService.generatePieChart(
      data: typeData.map((k, v) => MapEntry(k, v.length.toDouble())),
    );

    final barChartBytes = await chartService.generateBarChart(
      data: Map.fromEntries(
        events.where((e) => e.actualParticipants != null).take(10).map(
              (e) => MapEntry(
                e.title.substring(0, e.title.length > 10 ? 10 : e.title.length),
                e.actualParticipants!.toDouble(),
              ),
            ),
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildHeader(churchName, startDate, endDate),
          pw.SizedBox(height: 20),
          _buildKPICards(events),
          pw.SizedBox(height: 20),
          _buildChartSection('Répartition par Type', pieChartBytes),
          pw.SizedBox(height: 20),
          _buildChartSection('Top 10 Participation', barChartBytes),
          pw.SizedBox(height: 20),
          _buildEventsTable(events),
        ],
      ),
    );

    return _saveDocument(
      pdf,
      'rapport_evenements_${DateFormat('yyyy_MM_dd').format(startDate)}.pdf',
    );
  }

  pw.Widget _buildHeader(String churchName, DateTime start, DateTime end) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        gradient: const pw.LinearGradient(
          colors: [PdfColors.purple800, PdfColors.purple600],
        ),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
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
            'RAPPORT ÉVÉNEMENTS',
            style: const pw.TextStyle(fontSize: 16, color: PdfColors.white),
          ),
          pw.Text(
            '${DateFormat('dd/MM/yyyy').format(start)} - ${DateFormat('dd/MM/yyyy').format(end)}',
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.white),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildKPICards(List<Event> events) {
    final totalEvents = events.length;
    final totalParticipants = events
        .where((e) => e.actualParticipants != null)
        .fold(0, (s, e) => s + e.actualParticipants!);
    final avgParticipants = totalEvents > 0
        ? (totalParticipants /
                events.where((e) => e.actualParticipants != null).length)
            .round()
        : 0;
    final totalBudget = events
        .where((e) => e.actualBudget != null)
        .fold(0.0, (s, e) => s + e.actualBudget!);

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _buildKPICard(
          'Événements',
          totalEvents.toString(),
          PdfColors.purple700,
        ),
        _buildKPICard(
          'Participants',
          totalParticipants.toString(),
          PdfColors.blue700,
        ),
        _buildKPICard(
          'Moyenne',
          avgParticipants.toString(),
          PdfColors.green700,
        ),
        _buildKPICard(
          'Budget',
          currencyFormat.format(totalBudget),
          PdfColors.orange700,
        ),
      ],
    );
  }

  pw.Widget _buildKPICard(String label, String value, PdfColor color) {
    return pw.Expanded(
      child: pw.Container(
        margin: const pw.EdgeInsets.symmetric(horizontal: 4),
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          color: color.shade(0.1),
          borderRadius: pw.BorderRadius.circular(8),
          border: pw.Border.all(color: color, width: 2),
        ),
        child: pw.Column(
          children: [
            pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 4),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: color,
              ),
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

  pw.Widget _buildEventsTable(List<Event> events) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'DÉTAIL DES ÉVÉNEMENTS',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.TableHelper.fromTextArray(
          headers: ['Date', 'Titre', 'Type', 'Participants', 'Budget'],
          data: events
              .take(20)
              .map(
                (e) => [
                  DateFormat('dd/MM/yyyy').format(e.date),
                  e.title.length > 30
                      ? '${e.title.substring(0, 30)}...'
                      : e.title,
                  e.type.name,
                  e.actualParticipants?.toString() ?? '-',
                  e.actualBudget != null
                      ? currencyFormat.format(e.actualBudget)
                      : '-',
                ],
              )
              .toList(),
          headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white,
          ),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.purple800),
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.center,
            3: pw.Alignment.center,
            4: pw.Alignment.centerRight,
          },
          oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
        ),
      ],
    );
  }

  Map<String, List<Event>> _groupByType(List<Event> events) {
    final map = <String, List<Event>>{};
    for (final event in events) {
      map.putIfAbsent(event.type.name, () => []).add(event);
    }
    return map;
  }

  Future<File> _saveDocument(pw.Document pdf, String fileName) async {
    if (kIsWeb) {
      throw UnsupportedError(
          'Local file system saving is not supported on Web. Use browser downloads.');
    }
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../features/bilan/domain/entities/bilan_entities.dart';

import '../../features/finance/domain/entities/budget.dart';
import '../../features/audit/domain/models/audit_anomaly.dart';

class PdfExportOptions {
  final String title;
  final bool showKpis;
  final bool showBreakdown;
  final bool showFooter;
  final String? customColor;
  final bool showLogo;

  const PdfExportOptions({
    this.title = 'Rapport de Bilan Financier',
    this.showKpis = true,
    this.showBreakdown = true,
    this.showFooter = true,
    this.customColor,
    this.showLogo = true,
  });
}

class PdfExportService {
  static Future<Uint8List> generateBilanPdf({
    required ConsolidatedBilan summary,
    required List<BilanGroupSummary> categoryBreakdown,
    required ChurchBranding branding,
    required DateTimeRange period,
    PdfExportOptions options = const PdfExportOptions(),
  }) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.interRegular();
    final fontBold = await PdfGoogleFonts.interBold();

    final colorHex = options.customColor ?? branding.color;
    final primaryColor = colorHex.startsWith('#')
        ? PdfColor.fromInt(
            int.parse(colorHex.substring(1), radix: 16) | 0xFF000000)
        : PdfColors.deepPurple;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          _buildHeader(branding, period, fontBold,
              title: options.title,
              primaryColor: primaryColor,
              showLogo: options.showLogo),
          pw.SizedBox(height: 20),
          if (options.showKpis) ...[
            _buildKpiSection(summary, font, fontBold,
                primaryColor: primaryColor),
            pw.SizedBox(height: 30),
          ],
          if (options.showBreakdown) ...[
            _buildBreakdownTable(categoryBreakdown, font, fontBold),
            pw.SizedBox(height: 40),
          ],
          if (options.showFooter) _buildFooter(font),
        ],
      ),
    );

    return pdf.save();
  }

  static Future<Uint8List> generateAuditPdf({
    required List<AuditAnomaly> anomalies,
    required String churchName,
    required DateTimeRange period,
  }) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.interRegular();
    final fontBold = await PdfGoogleFonts.interBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          _buildHeader(
            ChurchBranding(name: churchName),
            period,
            fontBold,
            title: 'Rapport d\'Audit & Sécurité',
            primaryColor: PdfColors.red,
            showLogo: false,
          ),
          pw.SizedBox(height: 20),
          _buildAnomalyTable(anomalies, font, fontBold),
          pw.SizedBox(height: 40),
          _buildFooter(font),
        ],
      ),
    );

    return pdf.save();
  }

  static Future<Uint8List> generateBudgetPdf({
    required List<Budget> budgets,
    required String churchName,
    required int year,
    required String period,
  }) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.interRegular();
    final fontBold = await PdfGoogleFonts.interBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          _buildHeader(
            ChurchBranding(name: churchName),
            DateTimeRange(start: DateTime(year), end: DateTime(year)),
            fontBold,
            title: 'Rapport Budgétaire $year ($period)',
            primaryColor: PdfColors.deepPurple,
            showLogo: false,
          ),
          pw.SizedBox(height: 20),
          _buildBudgetTable(budgets, font, fontBold),
          pw.SizedBox(height: 40),
          _buildFooter(font),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildBudgetTable(
      List<Budget> budgets, pw.Font font, pw.Font fontBold) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey100),
          children: [
            pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child:
                    pw.Text('Catégorie', style: pw.TextStyle(font: fontBold))),
            pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text('Prévu', style: pw.TextStyle(font: fontBold))),
            pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text('Réel', style: pw.TextStyle(font: fontBold))),
            pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text('Écart', style: pw.TextStyle(font: fontBold))),
          ],
        ),
        ...budgets.map((b) => pw.TableRow(
              children: [
                pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(b.categoryId)),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(b.plannedAmount.toStringAsFixed(0))),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(b.actualAmount.toStringAsFixed(0))),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(b.variance.toStringAsFixed(0),
                        style: pw.TextStyle(
                            color: b.isOverBudget
                                ? PdfColors.red
                                : PdfColors.green))),
              ],
            )),
      ],
    );
  }

  static pw.Widget _buildHeader(
      ChurchBranding branding, DateTimeRange period, pw.Font fontBold,
      {String title = 'Rapport de Bilan Financier',
      required PdfColor primaryColor,
      bool showLogo = true}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(branding.name,
                    style: pw.TextStyle(
                        font: fontBold,
                        fontSize: branding.fontSize.toDouble(),
                        color: primaryColor)),
                pw.Text(title,
                    style: pw.TextStyle(font: fontBold, fontSize: 18)),
              ],
            ),
            if (showLogo && branding.logoUrl != null)
              pw.Container(
                width: 60,
                height: 60,
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: branding.logoUrl!,
                  width: 60,
                  height: 60,
                ), // Placeholder logic if network image is complex in static context, but preferably use pw.Image with net
              ),
          ],
        ),
        pw.Text(
            'Période: ${period.start.day}/${period.start.month}/${period.start.year} - ${period.end.day}/${period.end.month}/${period.end.year}'),
        pw.Divider(thickness: 2, color: primaryColor),
      ],
    );
  }

  static pw.Widget _buildAnomalyTable(
      List<AuditAnomaly> anomalies, pw.Font font, pw.Font fontBold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Anomalies Détectées',
            style: pw.TextStyle(
                font: fontBold, fontSize: 16, color: PdfColors.red)),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: [
                pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child:
                        pw.Text('Date', style: pw.TextStyle(font: fontBold))),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text('Sévérité',
                        style: pw.TextStyle(font: fontBold))),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text('Description',
                        style: pw.TextStyle(font: fontBold))),
              ],
            ),
            ...anomalies.map((item) => pw.TableRow(
                  children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(
                            item.detectedAt.toString().split('.').first)),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(item.severity.name.toUpperCase(),
                            style: pw.TextStyle(
                                color: item.severity == AnomalySeverity.critical
                                    ? PdfColors.red
                                    : PdfColors.orange))),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(item.description)),
                  ],
                )),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildKpiSection(
      ConsolidatedBilan summary, pw.Font font, pw.Font fontBold,
      {required PdfColor primaryColor}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Résumé des Flux',
            style: pw.TextStyle(font: fontBold, fontSize: 16)),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            _buildKpiItem('Total Revenus', summary.totalIncome, PdfColors.green,
                font, fontBold),
            _buildKpiItem('Total Dépenses', summary.totalExpense, PdfColors.red,
                font, fontBold),
            _buildKpiItem(
                'Solde Net', summary.netBalance, primaryColor, font, fontBold),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildKpiItem(String label, num amount, PdfColor color,
      pw.Font font, pw.Font fontBold) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Column(
        children: [
          pw.Text(label, style: pw.TextStyle(font: font, fontSize: 12)),
          pw.Text('${amount.toStringAsFixed(0)} XOF',
              style: pw.TextStyle(font: fontBold, fontSize: 14, color: color)),
        ],
      ),
    );
  }

  static pw.Widget _buildBreakdownTable(
      List<BilanGroupSummary> breakdown, pw.Font font, pw.Font fontBold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Détails par Catégorie',
            style: pw.TextStyle(font: fontBold, fontSize: 16)),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: [
                pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text('Catégorie',
                        style: pw.TextStyle(font: fontBold))),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text('Revenus',
                        style: pw.TextStyle(font: fontBold))),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text('Dépenses',
                        style: pw.TextStyle(font: fontBold))),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text('Transactions',
                        style: pw.TextStyle(font: fontBold))),
              ],
            ),
            ...breakdown.map((item) => pw.TableRow(
                  children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(item.groupName)),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(item.income.toStringAsFixed(0))),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(item.expense.toStringAsFixed(0))),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(item.txCount.toString())),
                  ],
                )),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildFooter(pw.Font font) {
    return pw.Column(
      children: [
        pw.Divider(),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Généré par Eglise Management System',
                style: pw.TextStyle(
                    font: font, fontSize: 10, color: PdfColors.grey)),
            pw.Text('Date: ${DateTime.now()}',
                style: pw.TextStyle(
                    font: font, fontSize: 10, color: PdfColors.grey)),
          ],
        ),
      ],
    );
  }
}

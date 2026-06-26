// lib/features/membres/presentation/providers/member_export_provider.dart
// Provider pour export/import de membres (CSV, Excel)

import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../domain/entities/member.dart';

part 'member_export_provider.g.dart';

/// Provider pour les actions d'export/import
@riverpod
class MemberExportActions extends _$MemberExportActions {
  @override
  FutureOr<void> build() async {}

  /// Export des membres vers CSV
  Future<File> exportToCsv({
    required List<Member> members,
    String? churchName,
  }) async {
    // Headers CSV
    final List<List<dynamic>> rows = [
      [
        'ID',
        'Nom',
        'Prénom',
        'Genre',
        'Date Naissance',
        'Email',
        'Téléphone',
        'Ville',
        'Adresse',
        'Statut',
        'Baptisé',
        'Leader',
        'Date Création',
      ],
    ];

    // Ajouter les données de chaque membre
    for (final member in members) {
      rows.add([
        member.id,
        member.lastName,
        member.firstName,
        member.gender.label,
        member.birthDate != null
            ? DateFormat('dd/MM/yyyy').format(member.birthDate!)
            : '',
        member.email ?? '',
        member.phone ?? '',
        member.city ?? '',
        member.addressLine1 ?? '',
        member.status.label,
        member.isBaptized ? 'Oui' : 'Non',
        member.isLeader ? 'Oui' : 'Non',
        member.createdAt != null
            ? DateFormat('dd/MM/yyyy HH:mm').format(member.createdAt!)
            : '',
      ]);
    }

    // Convertir en CSV
    final csvData = const ListToCsvConverter().convert(rows);

    // Sauvegarder dans fichier temporaire
    if (kIsWeb) {
      throw UnsupportedError(
          'Local file system access is not supported on Web. Use browser downloads.');
    }
    final directory = await getTemporaryDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = churchName != null
        ? 'membres_${churchName}_$timestamp.csv'
        : 'membres_export_$timestamp.csv';
    final file = File('${directory.path}/$fileName');

    await file.writeAsString(csvData, encoding: utf8);

    return file;
  }

  /// Export des membres vers Excel avec styles
  Future<File> exportToExcel({
    required List<Member> members,
    String? churchName,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel['Membres'];

    // Supprimer la feuille par défaut si elle existe
    if (excel.sheets.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    // Headers avec style
    final headers = [
      'ID',
      'Nom',
      'Prénom',
      'Genre',
      'Date Naissance',
      'Âge',
      'Email',
      'Téléphone',
      'Ville',
      'Adresse',
      'Statut',
      'Baptisé',
      'Leader',
      'Date Création',
    ];

    // Ajouter headers
    for (var i = 0; i < headers.length; i++) {
      final cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
      );
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.blue,
        fontColorHex: ExcelColor.white,
      );
    }

    // Ajouter les données
    for (var rowIndex = 0; rowIndex < members.length; rowIndex++) {
      final member = members[rowIndex];
      final row = rowIndex + 1; // +1 car row 0 = headers

      // ID
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
          .value = TextCellValue(
        member.id,
      );

      // Nom
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
          .value = TextCellValue(
        member.lastName,
      );

      // Prénom
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
          .value = TextCellValue(
        member.firstName,
      );

      // Genre
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
          .value = TextCellValue(
        member.gender.label,
      );

      // Date Naissance
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
          .value = TextCellValue(
        member.birthDate != null
            ? DateFormat('dd/MM/yyyy').format(member.birthDate!)
            : '',
      );

      // Âge
      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
              .value =
          member.birthDate != null
              ? IntCellValue(_calculateAge(member.birthDate!))
              : TextCellValue('');

      // Email
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row))
          .value = TextCellValue(
        member.email ?? '',
      );

      // Téléphone
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row))
          .value = TextCellValue(
        member.phone ?? '',
      );

      // Ville
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: row))
          .value = TextCellValue(
        member.city ?? '',
      );

      // Adresse
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: row))
          .value = TextCellValue(
        member.addressLine1 ?? '',
      );

      // Statut
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: row))
          .value = TextCellValue(
        member.status.label,
      );

      // Baptisé
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: row))
          .value = TextCellValue(
        member.isBaptized ? 'Oui' : 'Non',
      );

      // Leader
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: row))
          .value = TextCellValue(
        member.isLeader ? 'Oui' : 'Non',
      );

      // Date Création
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: row))
          .value = TextCellValue(
        member.createdAt != null
            ? DateFormat('dd/MM/yyyy HH:mm').format(member.createdAt!)
            : '',
      );
    }

    // Auto-size columns (approximatif)
    // for (var i = 0; i < headers.length; i++) {
    //   sheet.setColWidth(i, 15.0);
    // }

    // Largeurs spécifiques
    // sheet.setColWidth(0, 25.0); // ID
    // sheet.setColWidth(6, 25.0); // Email
    // sheet.setColWidth(9, 30.0); // Adresse

    // Sauvegarder fichier
    if (kIsWeb) {
      throw UnsupportedError(
          'Local file system access is not supported on Web. Use browser downloads.');
    }
    final directory = await getTemporaryDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = churchName != null
        ? 'membres_${churchName}_$timestamp.xlsx'
        : 'membres_export_$timestamp.xlsx';
    final file = File('${directory.path}/$fileName');

    final bytes = excel.encode();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }

    return file;
  }

  /// Export des membres vers PDF avec mise en page professionnelle
  Future<File> exportToPdf({
    required List<Member> members,
    String? churchName,
  }) async {
    final pdf = pw.Document();

    // Grouper par statut pour stats
    final actifs = members.where((m) => m.status.name == 'active').length;
    final baptises = members.where((m) => m.isBaptized).length;
    final leaders = members.where((m) => m.isLeader).length;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // En-tête
          pw.Header(
            level: 0,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Lumina',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blue900,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          churchName ?? 'Liste des Membres',
                          style: const pw.TextStyle(
                            fontSize: 14,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                        pw.Text(
                          'Heure: ${DateFormat('HH:mm').format(DateTime.now())}',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Divider(thickness: 2, color: PdfColors.blue900),
              ],
            ),
          ),

          pw.SizedBox(height: 20),

          // Statistiques résumées
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue50,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                _buildKpiPdf('Total', '${members.length}'),
                _buildKpiPdf('Actifs', '$actifs'),
                _buildKpiPdf('Baptisés', '$baptises'),
                _buildKpiPdf('Leaders', '$leaders'),
              ],
            ),
          ),

          pw.SizedBox(height: 20),

          // Tableau des membres
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(2), // Nom
              1: const pw.FlexColumnWidth(2), // Prénom
              2: const pw.FlexColumnWidth(1), // Genre
              3: const pw.FlexColumnWidth(1.5), // Téléphone
              4: const pw.FlexColumnWidth(1.5), // Statut
            },
            children: [
              // Header
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.blue900),
                children: [
                  _buildTableHeader('Nom'),
                  _buildTableHeader('Prénom'),
                  _buildTableHeader('Genre'),
                  _buildTableHeader('Téléphone'),
                  _buildTableHeader('Statut'),
                ],
              ),
              // Données
              ...members.asMap().entries.map((entry) {
                final index = entry.key;
                final member = entry.value;
                final isOdd = index % 2 == 1;

                return pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: isOdd ? PdfColors.grey100 : PdfColors.white,
                  ),
                  children: [
                    _buildTableCell(member.lastName),
                    _buildTableCell(member.firstName),
                    _buildTableCell(member.gender.label),
                    _buildTableCell(member.phone ?? '-'),
                    _buildTableCell(member.status.label),
                  ],
                );
              }),
            ],
          ),
        ],
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 8),
          child: pw.Text(
            'Page ${context.pageNumber} / ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ),
      ),
    );

    // Sauvegarder fichier
    if (kIsWeb) {
      throw UnsupportedError(
          'Local file system access is not supported on Web. Use browser downloads.');
    }
    final directory = await getTemporaryDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = churchName != null
        ? 'membres_${churchName}_$timestamp.pdf'
        : 'membres_export_$timestamp.pdf';
    final file = File('${directory.path}/$fileName');

    await file.writeAsBytes(await pdf.save());

    return file;
  }

  /// Helper pour KPI dans PDF
  pw.Widget _buildKpiPdf(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
      ],
    );
  }

  /// Helper pour headers de tableau dans PDF
  pw.Widget _buildTableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
      ),
    );
  }

  /// Helper pour cellules de tableau dans PDF
  pw.Widget _buildTableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
    );
  }

  /// Partager le fichier exporté
  Future<void> shareExport(File file) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Export Membres - Lumina',
      text:
          'Liste des membres exportée le ${DateFormat('dd/MM/yyyy à HH:mm').format(DateTime.now())}',
    );
  }

  /// Calculer l'âge à partir de la date de naissance
  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    var age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}

/// Provider pour obtenir le nom de l'église active (pour les noms de fichiers)
@riverpod
Future<String?> activeChurchName(ActiveChurchNameRef ref) async {
  // TODO: Récupérer depuis le church provider quand disponible
  return null;
}
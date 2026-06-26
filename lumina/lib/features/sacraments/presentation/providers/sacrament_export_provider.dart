import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import '../../domain/entities/sacrament.dart';

final sacramentExportActionsProvider = Provider(
  (ref) => SacramentExportActions(),
);

class SacramentExportActions {
  Future<void> generateCertificate(
    Sacrament sacrament, {
    String? churchName,
  }) async {
    final pdf = pw.Document();

    // Design ideas: Elegant border, Church logo (placeholder), Title, Body text, Signatures
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.landscape,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(40),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.amber, width: 5),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  churchName?.toUpperCase() ?? '',
                  style: pw.TextStyle(
                    fontSize: 30,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.amber,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'CERTIFICAT DE ${sacrament.type.label.toUpperCase()}',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 40),
                pw.Text(
                  'Ceci certifie que',
                  style: const pw.TextStyle(fontSize: 18),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  '${sacrament.memberFirstName} ${sacrament.memberLastName}',
                  style: pw.TextStyle(
                    fontSize: 26,
                    fontWeight: pw.FontWeight.bold,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'a reçu le sacrement de ${sacrament.type.label.toLowerCase()}',
                  style: const pw.TextStyle(fontSize: 18),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'le ${DateFormat('dd MMMM yyyy', 'fr_FR').format(sacrament.date)}',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                if (sacrament.location != null) ...[
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'à ${sacrament.location}',
                    style: const pw.TextStyle(fontSize: 16),
                  ),
                ],
                pw.Spacer(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Column(
                      children: [
                        pw.Container(
                          width: 150,
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(bottom: pw.BorderSide()),
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'Le Célébrant',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                        if (sacrament.celebrant != null)
                          pw.Text(
                            sacrament.celebrant!,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Container(
                          width: 150,
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(bottom: pw.BorderSide()),
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'Le Secrétariat',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    if (kIsWeb) {
      throw UnsupportedError(
          'PDF generation to local file is not supported on Web. Use a web-compatible PDF service.');
    }

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/certificat_${sacrament.id}.pdf");
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Certificat de ${sacrament.type.label}',
    );
  }
}
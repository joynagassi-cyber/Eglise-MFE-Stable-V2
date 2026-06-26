// lib/features/reports/data/services/infographic_service.dart

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../../../finance/domain/entities/finance_transaction.dart';
import '../../../finance/domain/entities/enums/transaction_type.dart';

class InfographicService {
  final currencyFormat = NumberFormat.currency(
    locale: 'fr_FR',
    symbol: 'FCFA',
    decimalDigits: 0,
  );

  Future<File> generateFinancialInfographic({
    required List<FinanceTransaction> transactions,
    required String churchName,
    required DateTime period,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(1080, 1920);

    _drawBackground(canvas, size);
    _drawHeader(canvas, size, churchName, period);
    _drawKPIs(canvas, size, transactions);
    _drawMainChart(canvas, size, transactions);
    _drawFooter(canvas, size);

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return _saveImage(
      bytes!.buffer.asUint8List(),
      'infographie_${DateFormat('yyyy_MM_dd').format(period)}.png',
    );
  }

  void _drawBackground(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(0, size.height),
        [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)],
      );
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  void _drawHeader(
    Canvas canvas,
    Size size,
    String churchName,
    DateTime period,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: churchName.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout(maxWidth: size.width - 80);
    textPainter.paint(canvas, const Offset(40, 60));

    final subtitlePainter = TextPainter(
      text: TextSpan(
        text:
            'Rapport Financier - ${DateFormat('MMMM yyyy', 'fr_FR').format(period)}',
        style: const TextStyle(color: Colors.white70, fontSize: 28),
      ),
      textDirection: ui.TextDirection.ltr,
    );
    subtitlePainter.layout(maxWidth: size.width - 80);
    subtitlePainter.paint(canvas, const Offset(40, 130));
  }

  void _drawKPIs(
    Canvas canvas,
    Size size,
    List<FinanceTransaction> transactions,
  ) {
    final income = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (s, t) => s + t.amount);
    final expense = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (s, t) => s + t.amount);
    final balance = income - expense;

    final kpis = [
      {
        'label': 'REVENUS',
        'value': currencyFormat.format(income),
        'color': const Color(0xFF10B981),
      },
      {
        'label': 'DÉPENSES',
        'value': currencyFormat.format(expense),
        'color': const Color(0xFFEF4444),
      },
      {
        'label': 'SOLDE',
        'value': currencyFormat.format(balance),
        'color':
            balance >= 0 ? const Color(0xFF3B82F6) : const Color(0xFFEF4444),
      },
    ];

    double yOffset = 240;
    for (final kpi in kpis) {
      _drawKPICard(canvas, Offset(40, yOffset), size.width - 80, kpi);
      yOffset += 180;
    }
  }

  void _drawKPICard(
    Canvas canvas,
    Offset position,
    double width,
    Map<String, dynamic> kpi,
  ) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(position.dx, position.dy, width, 140),
      const Radius.circular(20),
    );

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rect, paint);

    final labelPainter = TextPainter(
      text: TextSpan(
        text: kpi['label'],
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    );
    labelPainter.layout();
    labelPainter.paint(canvas, Offset(position.dx + 30, position.dy + 30));

    final valuePainter = TextPainter(
      text: TextSpan(
        text: kpi['value'],
        style: TextStyle(
          color: kpi['color'],
          fontSize: 42,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    );
    valuePainter.layout();
    valuePainter.paint(canvas, Offset(position.dx + 30, position.dy + 70));
  }

  void _drawMainChart(
    Canvas canvas,
    Size size,
    List<FinanceTransaction> transactions,
  ) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(40, 800, size.width - 80, 400),
      const Radius.circular(20),
    );

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rect, paint);

    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Graphique Évolution',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size.width - textPainter.width) / 2, 980),
    );
  }

  void _drawFooter(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text:
            'Généré le ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
        style: const TextStyle(color: Colors.white60, fontSize: 20),
      ),
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size.width - textPainter.width) / 2, size.height - 80),
    );
  }

  Future<File> _saveImage(Uint8List bytes, String fileName) async {
    if (kIsWeb) {
      throw UnsupportedError(
          'Local file system saving is not supported on Web. Use browser downloads.');
    }
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }
}
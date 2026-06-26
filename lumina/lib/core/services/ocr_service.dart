import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OcrService {
  static String get _ocrUrl =>
      dotenv.env['OCR_WORKER_URL'] ??
      'https://lumina-ocr-worker.joynagassi.workers.dev';
  Future<InvoiceData?> extractInvoiceData(File imageFile) async {
    try {
      final token = Supabase.instance.client.auth.currentSession?.accessToken;
      if (token == null) return null;

      final request = http.MultipartRequest('POST', Uri.parse(_ocrUrl));
      request.files
          .add(await http.MultipartFile.fromPath('file', imageFile.path));
      request.headers['Authorization'] = 'Bearer $token';

      final response = await request.send();
      if (response.statusCode != 200) return null;

      final responseBody = await response.stream.bytesToString();
      final json = jsonDecode(responseBody);

      if (json['success'] == true && json['data'] != null) {
        return InvoiceData.fromJson(json['data']);
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}

class InvoiceData {
  final String vendor;
  final DateTime? date;
  final double amount;
  final String currency;
  final List<InvoiceItem> items;
  final double tax;
  final double total;

  InvoiceData({
    required this.vendor,
    this.date,
    required this.amount,
    required this.currency,
    required this.items,
    required this.tax,
    required this.total,
  });

  factory InvoiceData.fromJson(Map<String, dynamic> json) {
    return InvoiceData(
      vendor: json['vendor'] ?? '',
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'CDF',
      items: (json['items'] as List?)
              ?.map((item) => InvoiceItem.fromJson(item))
              .toList() ??
          [],
      tax: (json['tax'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
    );
  }
}

class InvoiceItem {
  final String description;
  final int quantity;
  final double price;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.price,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      description: json['description'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}

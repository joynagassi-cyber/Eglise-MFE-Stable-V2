import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReportStorageService {
  final SupabaseClient _client = Supabase.instance.client;
  final String _workerUrl =
      dotenv.env['STORAGE_WORKER_URL'] ?? 'https://lumina-storage-worker.joynagassi.workers.dev';

  Future<String> uploadReport({
    required File file,
    required String churchId,
    required String type,
    required String title,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final userId = _client.auth.currentUser!.id;
    final token = _client.auth.currentSession!.accessToken;
    final reportId = '${DateTime.now().millisecondsSinceEpoch}_$type';

    // Upload vers R2 via Worker
    final request =
        http.MultipartRequest('POST', Uri.parse('$_workerUrl/upload'));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['entity_type'] = 'report';
    request.fields['entity_id'] = reportId;
    request.fields['church_id'] = churchId;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    if (response.statusCode != 201) {
      throw Exception('Upload failed');
    }

    // Sauvegarder métadonnées
    await _client.from('reports').insert({
      'church_id': churchId,
      'user_id': userId,
      'type': type,
      'title': title,
      'file_path': reportId,
      'file_size': await file.length(),
      'mime_type': 'application/pdf',
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
    });

    return reportId;
  }

  Future<String> getDownloadUrl(String filePath) async {
    return '$_workerUrl/download/$filePath';
  }

  Future<List<Map<String, dynamic>>> getReports({
    required String churchId,
    String? type,
  }) async {
    var query = _client.from('reports').select().eq('church_id', churchId);
    if (type != null) {
      query = query.eq('type', type);
    }
    final result = await query.order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(result as List);
  }

  Future<void> deleteReport(String id, String filePath) async {
    await _client.from('reports').delete().eq('id', id);
    // R2 cleanup via Worker si nécessaire
  }
}

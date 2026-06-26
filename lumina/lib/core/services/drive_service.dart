import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../logging/app_logger.dart';

class DriveUploadResult {
  final String fileId;
  final String url;

  DriveUploadResult({required this.fileId, required this.url});
}

class DriveService {
  final SupabaseClient _supabase;
  
  static String get _workerUrl =>
      dotenv.env['STORAGE_WORKER_URL'] ??
      'https://lumina-storage-worker.joynagassi.workers.dev/upload';

  DriveService(this._supabase);

  /// Uploads a file to Cloudflare R2 via Worker
  Future<DriveUploadResult> uploadFile({
    required String entityType,
    required String entityId,
    required String churchId,
    required Uint8List fileBytes,
    required String filename,
    required String mimeType,
    required String authToken,
    bool encrypt = false,
  }) async {
    try {
      final token = _supabase.auth.currentSession?.accessToken;
      if (token == null) {
         throw Exception('Utilisateur non authentifié');
      }

      final request = http.MultipartRequest('POST', Uri.parse(_workerUrl));
      
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: filename,
      ));
      
      request.fields['entity_type'] = entityType;
      request.fields['entity_id'] = entityId;
      request.fields['church_id'] = churchId;
      
      request.headers['Authorization'] = 'Bearer $token';

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Echec de upload R2: $responseBody');
      }
      
      final json = jsonDecode(responseBody);

      return DriveUploadResult(
        fileId: json['r2_key'],
        url: json['file_url'],
      );
    } catch (e) {
      AppLogger.e('Error uploading file to R2 Worker', 'DRIVE_SERVICE', e);
      rethrow;
    }
  }

  /// Mark an invoice as sealed (using a DB flag since Supabase Storage is immutable by default if not upserted)
  Future<void> sealInvoice({
    required String fileId,
    required String authToken,
  }) async {
    // In Supabase, we would probably call an RPC or update a table 'storage_objects_metadata'
    // For now, let's assume success if the file exists
    AppLogger.i('Sealing invoice: $fileId', 'DRIVE_SERVICE');
  }

  /// Upload specifically for member photos
  Future<String> uploadMemberPhoto(String memberId, Uint8List bytes) async {
    final result = await uploadFile(
      entityType: 'member_photo',
      entityId: memberId,
      churchId: 'global', // Or specific churchId if available
      fileBytes: bytes,
      filename: 'photo.jpg',
      mimeType: 'image/jpeg',
      authToken: '', // Not used by Supabase client internally here
    );
    return result.url;
  }

  // Buckets deprecates, no longer used
}

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logging/app_logger.dart';

class PhotoService {
  final String _workerUrl;

  PhotoService({String? workerUrl})
      : _workerUrl = workerUrl ??
            'https://lumina-storage-worker.joynagassi.workers.dev';

  Future<PhotoUploadResult> uploadMemberPhoto({
    required String memberId,
    required String churchId,
    required File photoFile,
    required String token,
  }) async {
    try {
      final request =
          http.MultipartRequest('POST', Uri.parse('$_workerUrl/upload'));

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['entity_type'] = 'member_photo';
      request.fields['entity_id'] = memberId;
      request.fields['church_id'] = churchId;

      request.files
          .add(await http.MultipartFile.fromPath('file', photoFile.path));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        final data = jsonDecode(responseBody);
        AppLogger.i('Photo uploadée R2', 'PHOTO_SERVICE');

        return PhotoUploadResult(
          success: true,
          fileId: data['r2_key'],
          fileUrl: data['file_url'],
          uploadedAt: DateTime.now(),
          checksum: '',
        );
      }

      throw PhotoUploadException('Upload échoué: ${response.statusCode}',
          statusCode: response.statusCode);
    } on SocketException {
      throw PhotoUploadException('Worker inaccessible', statusCode: 503);
    } catch (e) {
      AppLogger.e('Erreur upload R2', 'PHOTO_SERVICE', e);
      rethrow;
    }
  }

  Future<String?> getMemberPhotoUrl(String memberId) async {
    return '$_workerUrl/download/$memberId';
  }
}

class PhotoUploadResult {
  final bool success;
  final String fileId;
  final String fileUrl;
  final DateTime uploadedAt;
  final String checksum;

  PhotoUploadResult({
    required this.success,
    required this.fileId,
    required this.fileUrl,
    required this.uploadedAt,
    required this.checksum,
  });
}

class PhotoUploadException implements Exception {
  final String message;
  final int statusCode;

  PhotoUploadException(this.message, {required this.statusCode});

  @override
  String toString() => 'PhotoUploadException: $message (HTTP $statusCode)';
}

final photoServiceProvider = Provider<PhotoService>((ref) => PhotoService());

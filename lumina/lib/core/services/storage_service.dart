import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../logging/app_logger.dart';

class StorageService {
  final String _workerUrl;
  static const String _folderName = 'Gestion Totale';

  StorageService({String? workerUrl})
      : _workerUrl = workerUrl ??
            'https://lumina-storage-worker.joynagassi.workers.dev';

  /// Saves a file locally in the "Gestion Totale" folder and optionally uploads to cloud.
  Future<File> saveAndProcessReport({
    required String fileName,
    required List<int> bytes,
    bool uploadToCloud = false,
    String? entityType,
    String? entityId,
    String? churchId,
    String? token,
  }) async {
    try {
      // 1. Get/Create local directory
      final directory = await _getAppDirectory();
      final file = File('${directory.path}/$fileName');

      // 2. Save locally
      await file.writeAsBytes(bytes);
      AppLogger.i(
          'Fichier sauvegardé localement: ${file.path}', 'STORAGE_SERVICE');

      // 3. Cloud backup if requested
      if (uploadToCloud &&
          token != null &&
          entityType != null &&
          entityId != null &&
          churchId != null) {
        await _uploadToCloud(
          file: file,
          entityType: entityType,
          entityId: entityId,
          churchId: churchId,
          token: token,
        );
      }

      return file;
    } catch (e) {
      AppLogger.e('Erreur lors du traitement du rapport', 'STORAGE_SERVICE', e);
      rethrow;
    }
  }

  /// Opens the file with the default system application.
  Future<void> openFile(File file) async {
    final result = await OpenFile.open(file.path);
    if (result.type != ResultType.done) {
      AppLogger.e(
          'Erreur ouverture fichier: ${result.message}', 'STORAGE_SERVICE');
      throw Exception('Impossible d\'ouvrir le fichier: ${result.message}');
    }
  }

  /// Shares the file using the system share dialog.
  Future<void> shareFile(File file, {String? subject}) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: subject ?? 'Rapport Exporté',
    );
  }

  Future<Directory> _getAppDirectory() async {
    if (kIsWeb) {
      throw UnsupportedError(
          'Local file system access is not supported on Web. Use browser downloads.');
    }

    Directory? baseDir;

    if (Platform.isAndroid) {
      // On Android, we try to get a more accessible directory
      baseDir = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      baseDir = await getApplicationDocumentsDirectory();
    } else {
      baseDir = await getDownloadsDirectory();
    }

    baseDir ??= await getApplicationDocumentsDirectory();

    final appDir = Directory('${baseDir.path}/$_folderName');
    if (!await appDir.exists()) {
      await appDir.create(recursive: true);
    }
    return appDir;
  }

  Future<void> _uploadToCloud({
    required File file,
    required String entityType,
    required String entityId,
    required String churchId,
    required String token,
  }) async {
    try {
      AppLogger.i('Début backup cloud R2...', 'STORAGE_SERVICE');
      final request =
          http.MultipartRequest('POST', Uri.parse('$_workerUrl/upload'));

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['entity_type'] = entityType;
      request.fields['entity_id'] = entityId;
      request.fields['church_id'] = churchId;
      request.fields['file_name'] = file.path.split('/').last;

      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();
      if (response.statusCode == 201) {
        AppLogger.i('Backup cloud réussi', 'STORAGE_SERVICE');
      } else {
        final body = await response.stream.bytesToString();
        AppLogger.e('Backup cloud échoué (${response.statusCode}): $body',
            'STORAGE_SERVICE');
      }
    } catch (e) {
      AppLogger.e('Erreur backup cloud', 'STORAGE_SERVICE', e);
      // We don't rethrow here to not block local save if cloud fails
    }
  }
}

final storageServiceProvider =
    Provider<StorageService>((ref) => StorageService());

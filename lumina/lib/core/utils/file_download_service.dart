import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class FileDownloadService {
  static const _timeout = Duration(seconds: 30);
  static final _deviceInfo = DeviceInfoPlugin();

  static Future<File> saveToDownloads(File file, String fileName) async {
    return await _withTimeout(() async {
      if (!await file.exists()) throw Exception('Fichier source introuvable');

      final directory = await _getTargetDirectory();
      final newPath = '${directory.path}/$fileName';

      if (await File(newPath).exists()) {
        await File(newPath).delete();
      }

      return await file.copy(newPath);
    });
  }

  static Future<Directory> _getTargetDirectory() async {
    if (kIsWeb) {
      throw UnsupportedError(
          'Local file system access is not supported on Web.');
    }

    if (Platform.isAndroid) {
      if (await _requestStoragePermission()) {
        final dir = Directory('/storage/emulated/0/Download');
        if (await dir.exists()) return dir;
        return await getExternalStorageDirectory() ??
            await getApplicationDocumentsDirectory();
      }
      return await getApplicationDocumentsDirectory();
    }

    if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    }

    return await getDownloadsDirectory() ??
        await getApplicationDocumentsDirectory();
  }

  static Future<bool> _requestStoragePermission() async {
    if (kIsWeb || !Platform.isAndroid) return true;

    final androidInfo = await _deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt >= 33) return true;

    final status = await Permission.storage.status;
    if (status.isGranted) return true;

    return (await Permission.storage.request()).isGranted;
  }

  static Future<void> openFile(File file) async {
    if (!await file.exists()) throw Exception('Fichier introuvable');

    final result = await OpenFile.open(file.path);
    if (result.type != ResultType.done) {
      throw Exception(result.message);
    }
  }

  static Future<T> _withTimeout<T>(Future<T> Function() operation) async {
    try {
      return await operation().timeout(_timeout);
    } on TimeoutException {
      throw Exception('Opération expirée après ${_timeout.inSeconds}s');
    }
  }

  static Future<void> downloadAndOpen({
    required File file,
    required String fileName,
    required BuildContext context,
  }) async {
    try {
      final savedFile = await saveToDownloads(file, fileName);
      await openFile(savedFile);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Fichier téléchargé: $fileName'),
              duration: const Duration(seconds: 2)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Impossible de télécharger le fichier'),
              duration: Duration(seconds: 3)),
        );
      }
      rethrow;
    }
  }

  static Future<void> downloadAndShare({
    required File file,
    required String fileName,
    required BuildContext context,
  }) async {
    try {
      final savedFile = await saveToDownloads(file, fileName);
      await Share.shareXFiles([XFile(savedFile.path, name: fileName)]);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Impossible de télécharger le fichier'),
              duration: Duration(seconds: 3)),
        );
      }
      rethrow;
    }
  }

  static Future<String> getDownloadPath() async {
    final directory = await _getTargetDirectory();
    return directory.path;
  }
}

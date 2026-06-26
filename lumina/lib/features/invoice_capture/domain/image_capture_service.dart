import 'dart:io';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:crypto/crypto.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;

import '../data/models/proof_image.dart';
import '../data/proof_image_repository.dart';

class ImageCaptureService {
  final ProofImageRepository _repository;
  final String _workerUrl =
      dotenv.env['STORAGE_WORKER_URL'] ?? 'https://lumina-storage-worker.joynagassi.workers.dev';
  final ImagePicker _picker = ImagePicker();

  ImageCaptureService(this._repository);

  /// Capture une image depuis la caméra ou la galerie
  Future<File?> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return null;
    return File(pickedFile.path);
  }

  /// Compresse l'image pour optimiser le stockage
  Future<File?> compressImage(File file) async {
    final filePath = file.absolute.path;
    final lastDotIndex = filePath.lastIndexOf('.');
    final splitted = lastDotIndex != -1 ? filePath.substring(0, lastDotIndex) : filePath;
    final extension = lastDotIndex != -1 ? filePath.substring(lastDotIndex) : '.jpg';
    final outPath = "${splitted}_out$extension";

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 80,
    );

    if (result != null) return File(result.path);
    return null;
  }

  /// Calcule le hash SHA-256 du fichier
  Future<String> computeFileHash(File file) async {
    final bytes = await file.readAsBytes();
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Upload l'image et sauvegarde les métadonnées
  Future<ProofImage> uploadAndSave({
    required File file,
    required String transactionId,
    required String userId,
    required String churchId,
    required String authToken,
  }) async {
    final hash = await computeFileHash(file);

    // Upload vers R2 via Worker
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$_workerUrl/upload'),
    );
    request.headers['Authorization'] = 'Bearer $authToken';
    request.fields['entity_type'] = 'justificatif';
    request.fields['entity_id'] = transactionId;
    request.fields['church_id'] = churchId;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    if (response.statusCode != 201) {
      throw Exception('Upload failed');
    }

    final responseBody = await response.stream.bytesToString();
    final data = jsonDecode(responseBody);

    // Create Metadata
    final proofImage = ProofImage(
      id: '', // DB generated
      transactionId: transactionId,
      originalUrl: data['file_url'],
      sha256Client: hash,
      fileSizeBytes: await file.length(),
      mimeType: 'image/jpeg',
      uploadedBy: userId,
      uploadedAt: DateTime.now(),
    );

    return await _repository.saveProofImage(proofImage);
  }
}
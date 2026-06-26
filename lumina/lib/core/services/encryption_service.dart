// lib/core/services/encryption_service.dart
import 'dart:convert' as convert;
import 'package:flutter/foundation.dart' as foundation;
import 'package:encrypt/encrypt.dart' as encrypt_lib;
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static const _storage = FlutterSecureStorage();
  static const _keyStorageKey = 'imagir_encryption_master_key';

  Future<encrypt_lib.Key>? _cachedKey;
  Future<encrypt_lib.Key> getMasterKey() async {
    if (_cachedKey != null) return _cachedKey!;
    
    final String? keyString = await _storage.read(key: _keyStorageKey);

    if (keyString == null) {
      final key = encrypt_lib.Key.fromSecureRandom(32);
      await _storage.write(
          key: _keyStorageKey, value: convert.base64.encode(key.bytes));
      _cachedKey = Future.value(key);
      return key;
    }

    final key = encrypt_lib.Key(convert.base64.decode(keyString));
    _cachedKey = Future.value(key);
    return key;
  }

  Future<List<String>> decryptList(List<String> encryptedList) async {
    final key = await getMasterKey();
    return await foundation.compute(_decryptBatchJob, _DecryptParams(encryptedList, key));
  }

  static List<String> _decryptBatchJob(_DecryptParams params) {
    final encrypter = encrypt_lib.Encrypter(encrypt_lib.AES(params.key, mode: encrypt_lib.AESMode.gcm));
    
    return params.list.map((data) {
      if (!data.startsWith('ENC:')) return data;
      try {
        final parts = data.split(':');
        if (parts.length != 3) return data;
        final iv = encrypt_lib.IV.fromBase64(parts[1]);
        final encrypted = encrypt_lib.Encrypted.fromBase64(parts[2]);
        return encrypter.decrypt(encrypted, iv: iv);
      } catch (e) {
        return '[ERREUR DECHIFFREMENT]';
      }
    }).toList();
  }

  Future<String> encryptString(String log) async {
    final key = await getMasterKey();
    final iv = encrypt_lib.IV.fromSecureRandom(16);
    final encrypter = encrypt_lib.Encrypter(encrypt_lib.AES(key, mode: encrypt_lib.AESMode.gcm));

    final encrypted = encrypter.encrypt(log, iv: iv);
    return 'ENC:${iv.base64}:${encrypted.base64}';
  }

  Future<String> decryptString(String encryptedData) async {
    if (!encryptedData.startsWith('ENC:')) return encryptedData;

    try {
      final parts = encryptedData.split(':');
      if (parts.length != 3) return encryptedData;

      final iv = encrypt_lib.IV.fromBase64(parts[1]);
      final encrypted = encrypt_lib.Encrypted.fromBase64(parts[2]);

      final key = await getMasterKey();
      final encrypter = encrypt_lib.Encrypter(encrypt_lib.AES(key, mode: encrypt_lib.AESMode.gcm));

      return encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      return '[ERREUR DECHIFFREMENT]';
    }
  }

  Future<EncryptedFile> encryptFile(foundation.Uint8List fileBytes) async {
    final key = await getMasterKey();
    final iv = encrypt_lib.IV.fromSecureRandom(16);

    final encrypter = encrypt_lib.Encrypter(encrypt_lib.AES(key, mode: encrypt_lib.AESMode.gcm));
    final encrypted = encrypter.encryptBytes(fileBytes, iv: iv);

    final checksum = sha256.convert(fileBytes).toString();

    return EncryptedFile(
        encryptedBytes: encrypted.bytes,
        iv: iv.base64,
        checksum: checksum,
        originalSize: fileBytes.length,
        encryptedSize: encrypted.bytes.length);
  }

  Future<foundation.Uint8List> decryptFile(
      foundation.Uint8List encryptedBytes, String ivBase64) async {
    final key = await getMasterKey();
    final iv = encrypt_lib.IV.fromBase64(ivBase64);

    final encrypter = encrypt_lib.Encrypter(encrypt_lib.AES(key, mode: encrypt_lib.AESMode.gcm));
    final encrypted = encrypt_lib.Encrypted(encryptedBytes);

    return foundation.Uint8List.fromList(encrypter.decryptBytes(encrypted, iv: iv));
  }

  String calculateChecksum(foundation.Uint8List bytes) {
    return sha256.convert(bytes).toString();
  }

  bool verifyChecksum(foundation.Uint8List bytes, String expectedChecksum) {
    return calculateChecksum(bytes) == expectedChecksum;
  }
}

class _DecryptParams {
  final List<String> list;
  final encrypt_lib.Key key;
  _DecryptParams(this.list, this.key);
}

class EncryptedFile {
  final foundation.Uint8List encryptedBytes;
  final String iv;
  final String checksum;
  final int originalSize;
  final int encryptedSize;

  EncryptedFile({
    required this.encryptedBytes,
    required this.iv,
    required this.checksum,
    required this.originalSize,
    required this.encryptedSize,
  });

  Map<String, dynamic> toJson() => {
        'encrypted_base64': convert.base64.encode(encryptedBytes),
        'iv': iv,
        'checksum_sha256': checksum,
        'original_size': originalSize,
        'encrypted_size': encryptedSize,
      };
}

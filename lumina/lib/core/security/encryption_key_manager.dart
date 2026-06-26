import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionKeyManager {
  static const _storage = FlutterSecureStorage();
  static const _keyName = 'isar_encryption_key';

  static Future<Uint8List> getOrCreateKey() async {
    final String? storedKey = await _storage.read(key: _keyName);

    if (storedKey != null) {
      return base64Decode(storedKey);
    }

    final key = _generateKey();
    await _storage.write(key: _keyName, value: base64Encode(key));
    return key;
  }

  static Uint8List _generateKey() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    return Uint8List.fromList(values);
  }
}

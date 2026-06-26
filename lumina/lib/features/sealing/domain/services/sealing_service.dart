import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';

class SealingService {
  /// Calcule le hash SHA-256 d'une payload JSON
  String computeHash(Map<String, dynamic> payload) {
    // 1. Canonicalisation simple: tri des clés
    final sortedKeys = payload.keys.toList()..sort();
    final sortedMap = {for (var key in sortedKeys) key: payload[key]};

    // 2. Encodage JSON
    final jsonString = jsonEncode(sortedMap);

    // 3. Hashing
    final bytes = utf8.encode(jsonString);
    final digest = sha256.convert(bytes);

    return digest.toString();
  }

  /// Signe une payload avec un sel interne (Lumina 2026)
  String signPayload(Map<String, dynamic> payload) {
    final Map<String, dynamic> dataToSign = Map.from(payload);
    dataToSign['app'] = 'Lumina';
    dataToSign['church'] = 'MFE-JC';
    dataToSign['sealed_at'] = DateTime.now().toIso8601String();
    
    return computeHash(dataToSign);
  }

  /// Vérifie l'intégrité d'une signature ECDSA P-256
  Future<bool> verifySignature(
    String payloadHash,
    String signatureHex,
    String publicKeyHex,
  ) async {
    try {
      if (signatureHex.isEmpty || publicKeyHex.isEmpty) return false;

      final algorithm = Ecdsa.p256(Sha256());

      // Conversion des hex en bytes
      final signatureBytes = _hexToBytes(signatureHex);
      final publicKeyBytes = _hexToBytes(publicKeyHex);
      final messageBytes = utf8.encode(payloadHash);

      // Création de l'objet Signature
      // Pour une clé publique ECDSA P-256 de 65 bytes (format non compressé 0x04 + X + Y)
      // On extrait X (32 bytes) et Y (32 bytes)
      List<int> x;
      List<int> y;

      if (publicKeyBytes.length == 65 && publicKeyBytes[0] == 0x04) {
        x = publicKeyBytes.sublist(1, 33);
        y = publicKeyBytes.sublist(33, 65);
      } else {
        // Fallback or handle different formats if necessary
        return false;
      }

      final publicKey = EcPublicKey(
        x: x,
        y: y,
        type: KeyPairType.p256,
      );

      final signature = Signature(
        signatureBytes,
        publicKey: publicKey,
      );

      // Vérification
      return await algorithm.verify(
        messageBytes,
        signature: signature,
      );
    } catch (e) {
      // En cas d'erreur de format ou autre, on considère la signature invalide
      return false;
    }
  }

  List<int> _hexToBytes(String hex) {
    final bytes = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return bytes;
  }
}
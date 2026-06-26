// lib/core/services/signature_service.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service de scellement cryptographique IMAGIR
/// Utilise SHA-256 pour le hachage et délègue la signature ECDSA P-256
/// à la Edge Function `seal-proof` pour sécuriser la clé privée.
class SignatureService {
  final SupabaseClient _supabase;

  SignatureService(this._supabase);

  /// Calcule le hash SHA-256 d'un contenu (bytes)
  String computeHash(Uint8List content) {
    final digest = sha256.convert(content);
    return digest.toString();
  }

  /// Calcule le hash SHA-256 d'une chaîne de caractères
  String computeStringHash(String content) {
    final bytes = utf8.encode(content);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Scelle une preuve photographique via la Edge Function
  /// Retourne la signature ECDSA P-256 ou null en cas d'erreur
  Future<SealResult?> sealProof({
    required String transactionId,
    required String storagePath,
    required Uint8List imageBytes,
  }) async {
    final hash = computeHash(imageBytes);

    try {
      final response = await _supabase.functions.invoke(
        'seal-proof',
        body: {
          'transactionId': transactionId,
          'storagePath': storagePath,
          'hash': hash,
        },
      );

      if (response.status == 200 && response.data != null) {
        return SealResult(
          hash: hash,
          signature: response.data['signature'] as String,
          keyId: response.data['keyId'] as String,
          sealedAt: DateTime.parse(response.data['sealedAt'] as String),
        );
      }
      return null;
    } catch (e) {
      // Log error but don't throw - sealing is optional for draft transactions
      return null;
    }
  }

  /// Vérifie si un hash correspond au contenu
  bool verifyHash(Uint8List content, String expectedHash) {
    final actualHash = computeHash(content);
    return actualHash == expectedHash;
  }

  /// Construit un payload canonique pour la signature d'une transaction
  String buildTransactionPayload(Map<String, dynamic> transaction) {
    // Trier les clés pour garantir la reproductibilité
    final sortedKeys = transaction.keys.toList()..sort();
    final canonicalMap = {
      for (final key in sortedKeys) key: transaction[key],
    };
    return jsonEncode(canonicalMap);
  }
}

/// Résultat d'un scellement cryptographique
class SealResult {
  final String hash;
  final String signature;
  final String keyId;
  final DateTime sealedAt;

  SealResult({
    required this.hash,
    required this.signature,
    required this.keyId,
    required this.sealedAt,
  });
}

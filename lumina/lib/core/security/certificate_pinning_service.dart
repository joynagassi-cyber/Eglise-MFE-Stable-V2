import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';

/// Certificate pinning service for Supabase connections
/// Fingerprint obtained: 2025-02-15
class CertificatePinningService {
  static const _supabaseFingerprints = [
    // Supabase production certificate SHA-256 (vvcdmqpbwfyhkzalwdli.supabase.co)
    '2FFED0127BAB9D424169231F0696BF8E3CAB2F00057D6DEE4AC018C3829261B4',
    // Backup/intermediate certificates (add if needed)
  ];

  static HttpClient createPinnedClient() {
    final client = HttpClient();

    client.badCertificateCallback = (cert, host, port) {
      if (kDebugMode) return true;

      final certBytes = cert.der;
      final certSha256 = sha256.convert(certBytes).bytes;
      final fingerprint = certSha256
          .map((b) => b.toRadixString(16).toUpperCase().padLeft(2, '0'))
          .join();

      return _supabaseFingerprints.contains(fingerprint);
    };

    return client;
  }

  static bool verifyCertificate(X509Certificate cert) {
    final certBytes = cert.der;
    final certSha256 = sha256.convert(certBytes).bytes;
    final fingerprint = certSha256
        .map((b) => b.toRadixString(16).toUpperCase().padLeft(2, '0'))
        .join();
    return _supabaseFingerprints.contains(fingerprint);
  }
}

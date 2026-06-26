// lib/features/messaging/data/services/e2ee_service.dart
// End-to-End Encryption Service using X25519 + AES-GCM

import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

/// Manages E2EE key generation, exchange, and message encryption/decryption.
class E2eeService {
  final SupabaseClient _supabase;
  final FlutterSecureStorage _secureStorage;
  final Logger _logger = Logger();

  static const _privateKeyStorageKey = 'e2ee_private_key';
  static const _publicKeyStorageKey = 'e2ee_public_key';

  final _keyExchangeAlgorithm = X25519();
  final _cipher = AesGcm.with256bits();

  E2eeService(this._supabase, this._secureStorage);

  /// Initialize E2EE keys for the current user.
  /// Generates a new keypair if one doesn't exist locally.
  Future<void> initialize() async {
    final existingKey = await _secureStorage.read(key: _privateKeyStorageKey);
    if (existingKey != null) {
      _logger.d('E2EE: Keys already exist locally.');
      return;
    }

    _logger.i('E2EE: Generating new keypair...');
    final keyPair = await _keyExchangeAlgorithm.newKeyPair();
    final privateKeyBytes = await keyPair.extractPrivateKeyBytes();
    final publicKey = await keyPair.extractPublicKey();

    // Store private key securely on device
    await _secureStorage.write(
      key: _privateKeyStorageKey,
      value: base64Encode(privateKeyBytes),
    );
    await _secureStorage.write(
      key: _publicKeyStorageKey,
      value: base64Encode(publicKey.bytes),
    );

    // Publish public key to Supabase
    await _supabase.from('user_encryption_keys').upsert({
      'user_id': _supabase.auth.currentUser!.id,
      'public_key': base64Encode(publicKey.bytes),
      'key_algorithm': 'x25519',
    }, onConflict: 'user_id');

    _logger.i('E2EE: Keypair generated and public key published.');
  }

  /// Get the local private key.
  Future<SimpleKeyPairData> _getLocalKeyPair() async {
    final privateKeyB64 = await _secureStorage.read(key: _privateKeyStorageKey);
    final publicKeyB64 = await _secureStorage.read(key: _publicKeyStorageKey);

    if (privateKeyB64 == null || publicKeyB64 == null) {
      throw StateError('E2EE keys not initialized. Call initialize() first.');
    }

    final privateKeyBytes = base64Decode(privateKeyB64);
    final publicKeyBytes = base64Decode(publicKeyB64);

    return SimpleKeyPairData(
      privateKeyBytes,
      publicKey: SimplePublicKey(publicKeyBytes, type: KeyPairType.x25519),
      type: KeyPairType.x25519,
    );
  }

  /// Fetch a remote user's public key from Supabase.
  Future<SimplePublicKey?> getRemotePublicKey(String userId) async {
    try {
      final response = await _supabase
          .from('user_encryption_keys')
          .select('public_key')
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;

      final publicKeyB64 = response['public_key'] as String;
      return SimplePublicKey(
        base64Decode(publicKeyB64),
        type: KeyPairType.x25519,
      );
    } catch (e) {
      _logger.e('E2EE: Failed to fetch public key for $userId', error: e);
      return null;
    }
  }

  /// Derive a shared secret from our private key and the recipient's public key.
  Future<SecretKey> _deriveSharedSecret(SimplePublicKey remotePublicKey) async {
    final localKeyPair = await _getLocalKeyPair();
    return _keyExchangeAlgorithm.sharedSecretKey(
      keyPair: localKeyPair,
      remotePublicKey: remotePublicKey,
    );
  }

  /// Encrypt a plaintext message for a specific recipient.
  /// Returns a map with 'ciphertext' (base64) and 'iv' (base64).
  Future<Map<String, String>?> encryptMessage(
    String plaintext,
    String recipientUserId,
  ) async {
    try {
      final remotePublicKey = await getRemotePublicKey(recipientUserId);
      if (remotePublicKey == null) {
        _logger.w(
            'E2EE: No public key found for $recipientUserId. Sending unencrypted.');
        return null;
      }

      final sharedSecret = await _deriveSharedSecret(remotePublicKey);
      final nonce = _cipher.newNonce();
      final secretBox = await _cipher.encrypt(
        utf8.encode(plaintext),
        secretKey: sharedSecret,
        nonce: nonce,
      );

      return {
        'ciphertext': base64Encode(secretBox.concatenation()),
        'iv': base64Encode(nonce),
      };
    } catch (e) {
      _logger.e('E2EE: Encryption failed', error: e);
      return null;
    }
  }

  /// Decrypt an encrypted message from a specific sender.
  Future<String?> decryptMessage(
    String ciphertextB64,
    String ivB64,
    String senderUserId,
  ) async {
    try {
      final remotePublicKey = await getRemotePublicKey(senderUserId);
      if (remotePublicKey == null) {
        _logger.w('E2EE: Cannot decrypt, no public key for $senderUserId.');
        return null;
      }

      final sharedSecret = await _deriveSharedSecret(remotePublicKey);
      final concatenation = base64Decode(ciphertextB64);
      final secretBox = SecretBox.fromConcatenation(
        concatenation,
        nonceLength: _cipher.nonceLength,
        macLength: _cipher.macAlgorithm.macLength,
      );

      final decrypted = await _cipher.decrypt(
        secretBox,
        secretKey: sharedSecret,
      );

      return utf8.decode(decrypted);
    } catch (e) {
      _logger.e('E2EE: Decryption failed', error: e);
      return null;
    }
  }

  /// Check if E2EE keys are initialized locally.
  Future<bool> get isInitialized async {
    final key = await _secureStorage.read(key: _privateKeyStorageKey);
    return key != null;
  }
}
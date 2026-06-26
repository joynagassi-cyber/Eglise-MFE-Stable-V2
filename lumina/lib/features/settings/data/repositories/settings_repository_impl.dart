import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/i_settings_repository.dart';

/// FIX #1 — Stockage des paramètres chiffré (flutter_secure_storage).
///
/// Migration automatique depuis SharedPreferences v1 (plaintext) vers
/// FlutterSecureStorage v2 (chiffré AES sur Android, Keychain sur iOS).
///
/// Raison : les settings contiennent des préférences de confidentialité
/// (showEmail, showPhoneNumber, showProfilePhoto) classées comme PII.
/// Le stockage en clair constitue une violation GDPR/CCPA (OWASP A02:2021).
class SettingsRepositoryImpl implements ISettingsRepository {
  // v2 = clé sécurisée — changée délibérément pour forcer la migration
  static const _settingsKeyV2 = 'app_settings_v2';
  // v1 = ancienne clé plaintext (lecture seule pour migration)
  static const _settingsKeyV1 = 'app_settings_v1';

  final FlutterSecureStorage _secureStorage;
  final _logger = Logger();

  SettingsRepositoryImpl({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  @override
  Future<AppSettings> loadSettings() async {
    try {
      // 1. Lecture depuis le stockage sécurisé (chemin normal)
      final secureJson = await _secureStorage.read(key: _settingsKeyV2);
      if (secureJson != null) {
        return AppSettings.fromJson(
          Map<String, dynamic>.from(jsonDecode(secureJson)),
        );
      }

      // 2. Migration one-shot depuis SharedPreferences plaintext (v1 → v2)
      final prefs = await SharedPreferences.getInstance();
      final legacyJson = prefs.getString(_settingsKeyV1);
      if (legacyJson != null) {
        _logger.i('Migration settings plaintext → secure storage');
        // Écriture dans le stockage chiffré
        await _secureStorage.write(key: _settingsKeyV2, value: legacyJson);
        // Suppression de la copie en clair
        await prefs.remove(_settingsKeyV1);

        return AppSettings.fromJson(
          Map<String, dynamic>.from(jsonDecode(legacyJson)),
        );
      }
    } catch (e) {
      _logger.e('Échec chargement settings', error: e);
    }
    // Valeurs par défaut si aucune donnée sauvegardée
    return const AppSettings();
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    try {
      final json = jsonEncode(settings.toJson());
      // FIX #1 — Écriture chiffrée (AES sur Android, Keychain sur iOS)
      await _secureStorage.write(key: _settingsKeyV2, value: json);
      _logger.i('Settings sauvegardés de manière sécurisée');
    } catch (e) {
      _logger.e('Échec sauvegarde settings sécurisée', error: e);
      rethrow;
    }
  }

  @override
  Future<void> resetToDefaults() async {
    try {
      // Suppression depuis le stockage sécurisé
      await _secureStorage.delete(key: _settingsKeyV2);

      // Nettoyage de l'ancienne clé plaintext si elle existe encore
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_settingsKeyV1);

      _logger.i('Settings réinitialisés aux valeurs par défaut');
    } catch (e) {
      _logger.e('Échec reset settings', error: e);
    }
  }

  @override
  Future<Map<String, dynamic>> exportSettings() async {
    final settings = await loadSettings();
    return settings.toJson();
  }

  @override
  Future<void> importSettings(Map<String, dynamic> json) async {
    final settings = AppSettings.fromJson(json);
    await saveSettings(settings);
  }
}
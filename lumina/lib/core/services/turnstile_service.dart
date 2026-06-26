//  P0-SEC-05: Cloudflare Turnstile Bot Protection
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TurnstileService {
  static const _siteKey = String.fromEnvironment('TURNSTILE_SITE_KEY');
  static const _secretKey = String.fromEnvironment('TURNSTILE_SECRET_KEY');

  /// Vérifie le token Turnstile côté serveur
  static Future<bool> verifyToken(String token) async {
    if (kDebugMode) return true; // Skip en dev

    try {
      final response = await http.post(
        Uri.parse('https://challenges.cloudflare.com/turnstile/v0/siteverify'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'secret': _secretKey,
          'response': token,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      debugPrint('Turnstile verification error: $e');
      return false;
    }
  }

  static String get siteKey => _siteKey;
}

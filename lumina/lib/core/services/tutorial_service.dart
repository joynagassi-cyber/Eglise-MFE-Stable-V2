// lib/core/services/tutorial_service.dart
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tutorial_service.g.dart';

/// Service pour gérer l'état du tutoriel interactif par rôle.
///
/// Persiste via SharedPreferences :
///  - Coach-mark overlay (legacy) : `tutorial_dashboard_seen`
///  - Étapes complétées par rôle : `tutorial_steps_{roleCode}`
///  - Banner "premier lancement" : `tutorial_banner_dismissed_{roleCode}`
class TutorialService {
  static const String _keyTutorialSeen = 'tutorial_dashboard_seen';
  static const String _keyStepsPrefix = 'tutorial_steps_';
  static const String _keyBannerPrefix = 'tutorial_banner_dismissed_';

  final SharedPreferences _prefs;

  TutorialService(this._prefs);

  // ────────────────────────────────────────────────────────
  // LEGACY : Coach-mark overlay (rétro-compatible)
  // ────────────────────────────────────────────────────────

  /// Vérifie si le tutoriel overlay a déjà été vu
  bool hasSeenTutorial() {
    return _prefs.getBool(_keyTutorialSeen) ?? false;
  }

  /// Marque le tutoriel overlay comme vu
  Future<void> markTutorialAsSeen() async {
    await _prefs.setBool(_keyTutorialSeen, true);
  }

  /// Réinitialise le tutoriel overlay (pour "Revoir le tutoriel")
  Future<void> resetTutorial() async {
    await _prefs.setBool(_keyTutorialSeen, false);
  }

  // ────────────────────────────────────────────────────────
  // NOUVEAU : Étapes interactives par rôle
  // ────────────────────────────────────────────────────────

  /// Retourne les IDs des étapes complétées pour un rôle donné.
  List<String> getCompletedSteps(String roleCode) {
    final raw = _prefs.getString('$_keyStepsPrefix$roleCode');
    if (raw == null || raw.isEmpty) return [];
    try {
      return List<String>.from(jsonDecode(raw) as List);
    } catch (_) {
      return [];
    }
  }

  /// Marque une étape comme complétée pour un rôle.
  Future<void> markStepCompleted(String roleCode, String stepId) async {
    final completed = getCompletedSteps(roleCode);
    if (!completed.contains(stepId)) {
      completed.add(stepId);
      await _prefs.setString(
        '$_keyStepsPrefix$roleCode',
        jsonEncode(completed),
      );
    }
  }

  /// Réinitialise toutes les étapes pour un rôle.
  Future<void> resetTutorialForRole(String roleCode) async {
    await _prefs.remove('$_keyStepsPrefix$roleCode');
    await _prefs.remove('$_keyBannerPrefix$roleCode');
  }

  // ────────────────────────────────────────────────────────
  // BANNER "PREMIER LANCEMENT"
  // ────────────────────────────────────────────────────────

  /// Vérifie si le banner d'aide a été fermé pour un rôle.
  bool isBannerDismissed(String roleCode) {
    return _prefs.getBool('$_keyBannerPrefix$roleCode') ?? false;
  }

  /// Ferme définitivement le banner pour un rôle.
  Future<void> dismissBanner(String roleCode) async {
    await _prefs.setBool('$_keyBannerPrefix$roleCode', true);
  }
}

@Riverpod(keepAlive: true)
Future<TutorialService> tutorialService(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  return TutorialService(prefs);
}

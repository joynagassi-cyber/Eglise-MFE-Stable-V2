// lib/features/bible/presentation/providers/bible_settings_provider.dart
// Providers de paramètres Bible: traduction active + configuration TTS.

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lumina/features/bible/domain/entities/bible_entities.dart';

part 'bible_settings_provider.g.dart';

// ─────────────────────────────────────────────────────────
// TRADUCTION ACTIVE
// ─────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
class BibleTranslation extends _$BibleTranslation {
  static const _key = 'selected_bible_translation';

  @override
  String build() {
    _load();
    return 'ls1910';
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null) state = saved;
  }

  Future<void> setTranslation(String translationId) async {
    state = translationId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, translationId);
  }
}

// ─────────────────────────────────────────────────────────
// PARAMÈTRES TTS
// ─────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
class BibleTtsSettingsNotifier extends _$BibleTtsSettingsNotifier {
  static const _langKey = 'tts_language';
  static const _rateKey = 'tts_speech_rate';
  static const _pitchKey = 'tts_pitch';
  static const _volumeKey = 'tts_volume';
  static const _enabledKey = 'tts_enabled';

  @override
  BibleTtsSettings build() {
    _load();
    return const BibleTtsSettings();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = BibleTtsSettings(
      languageCode: prefs.getString(_langKey) ?? 'fr-FR',
      speechRate: prefs.getDouble(_rateKey) ?? 0.5,
      pitch: prefs.getDouble(_pitchKey) ?? 1.0,
      volume: prefs.getDouble(_volumeKey) ?? 1.0,
      isEnabled: prefs.getBool(_enabledKey) ?? false,
    );
  }

  Future<void> update(BibleTtsSettings settings) async {
    state = settings;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, settings.languageCode);
    await prefs.setDouble(_rateKey, settings.speechRate);
    await prefs.setDouble(_pitchKey, settings.pitch);
    await prefs.setDouble(_volumeKey, settings.volume);
    await prefs.setBool(_enabledKey, settings.isEnabled);
  }

  Future<void> setSpeechRate(double rate) =>
      update(state.copyWith(speechRate: rate.clamp(0.1, 1.0)));

  Future<void> setPitch(double pitch) =>
      update(state.copyWith(pitch: pitch.clamp(0.5, 2.0)));

  Future<void> setVolume(double volume) =>
      update(state.copyWith(volume: volume.clamp(0.0, 1.0)));

  Future<void> setLanguage(String code) =>
      update(state.copyWith(languageCode: code));

  Future<void> toggleEnabled() =>
      update(state.copyWith(isEnabled: !state.isEnabled));
}

// Alias court pour l'accès au state
@riverpod
BibleTtsSettings bibleTtsSettings(BibleTtsSettingsRef ref) =>
    ref.watch(bibleTtsSettingsNotifierProvider);

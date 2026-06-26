// lib/features/bible/domain/services/i_bible_tts_service.dart
// Interface abstraite du service TTS Bible.
// L'implémentation utilise le TTS natif du système (flutter_tts).

import 'package:lumina/features/bible/domain/entities/bible_entities.dart';

/// État du lecteur TTS
enum TtsPlaybackState { idle, playing, paused, stopped, error }

abstract class IBibleTtsService {
  /// Flux d'état de lecture (idle, playing, paused, etc.)
  Stream<TtsPlaybackState> get playbackStateStream;

  /// Flux indiquant l'index du verset en cours de lecture
  Stream<int> get currentVerseIndexStream;

  /// Vérifie si le TTS est disponible sur l'appareil
  Future<bool> isAvailable();

  /// Initialise le service avec les paramètres utilisateur
  Future<void> initialize(BibleTtsSettings settings);

  /// Lit un verset unique
  Future<void> speakVerse({
    required String text,
    required int verseNumber,
  });

  /// Lit un chapitre complet (mode boucle activable)
  Future<void> speakChapter({
    required List<String> verses,
    bool loop = false,
    int startFromVerse = 0,
  });

  /// Met en pause
  Future<void> pause();

  /// Reprend la lecture
  Future<void> resume();

  /// Arrête la lecture
  Future<void> stop();

  /// Met à jour les paramètres (vitesse, pitch, volume)
  Future<void> updateSettings(BibleTtsSettings settings);

  /// Libère les ressources
  Future<void> dispose();
}

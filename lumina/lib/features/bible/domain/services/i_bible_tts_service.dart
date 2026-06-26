// lib/features/bible/domain/services/i_bible_tts_service.dart

import 'package:lumina/features/bible/domain/entities/bible_entities.dart';

abstract class IBibleTtsService {
  /// Stream de l'état de lecture
  Stream<TtsPlaybackState> get playbackStateStream;
  
  /// Stream de l'index du verset en cours de lecture
  Stream<int> get currentVerseIndexStream;

  /// Vérifie si le moteur TTS est disponible sur l'appareil
  Future<bool> isAvailable();

  /// Initialise le moteur avec les paramètres utilisateur
  Future<void> initialize(BibleTtsSettings settings);

  /// Lit un verset spécifique
  Future<void> speakVerse({
    required String text,
    required int verseNumber,
  });

  /// Lit un chapitre complet
  Future<void> speakChapter({
    required List<String> verses,
    bool loop = false,
    int startFromVerse = 0,
  });

  /// Met en pause la lecture
  Future<void> pause();

  /// Reprend la lecture
  Future<void> resume();

  /// Arrête la lecture
  Future<void> stop();

  /// Met à jour les paramètres (langue, débit, etc.)
  Future<void> updateSettings(BibleTtsSettings settings);

  /// Libère les ressources
  Future<void> dispose();
}

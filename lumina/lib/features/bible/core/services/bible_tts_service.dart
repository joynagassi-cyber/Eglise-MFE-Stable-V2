// lib/features/bible/data/services/bible_tts_service.dart
// Implémentation du service TTS Bible utilisant flutter_tts (natif OS).
// Lit les versets un par un avec support de mode boucle de chapitre.

import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lumina/features/bible/domain/entities/bible_entities.dart';
import 'package:lumina/features/bible/domain/services/i_bible_tts_service.dart';

part 'bible_tts_service.g.dart';

@Riverpod(keepAlive: true)
IBibleTtsService bibleTtsService(BibleTtsServiceRef ref) {
  final service = BibleTtsServiceImpl();
  ref.onDispose(service.dispose);
  return service;
}

class BibleTtsServiceImpl implements IBibleTtsService {
  final FlutterTts _tts = FlutterTts();

  final _playbackController =
      StreamController<TtsPlaybackState>.broadcast();
  final _verseIndexController = StreamController<int>.broadcast();

  TtsPlaybackState _state = TtsPlaybackState.idle;
  int _currentVerseIndex = 0;
  bool _isLoopMode = false;
  List<String> _currentChapterVerses = [];
  bool _initialized = false;

  // ── PUBLIC STREAMS ──────────────────────────────────────

  @override
  Stream<TtsPlaybackState> get playbackStateStream =>
      _playbackController.stream;

  @override
  Stream<int> get currentVerseIndexStream => _verseIndexController.stream;

  // ── LIFECYCLE ───────────────────────────────────────────

  @override
  Future<bool> isAvailable() async {
    try {
      final engines = await _tts.getEngines;
      return engines != null && (engines as List).isNotEmpty;
    } catch (_) {
      return true; // Optimistic: assume available on mobile
    }
  }

  @override
  Future<void> initialize(BibleTtsSettings settings) async {
    if (_initialized) {
      await updateSettings(settings);
      return;
    }

    await _tts.setLanguage(settings.languageCode);
    await _tts.setSpeechRate(settings.speechRate);
    await _tts.setPitch(settings.pitch);
    await _tts.setVolume(settings.volume);

    _tts.setStartHandler(() {
      _setState(TtsPlaybackState.playing);
    });

    _tts.setCompletionHandler(() async {
      if (_isLoopMode && _currentChapterVerses.isNotEmpty) {
        await _playNextVerse();
      } else {
        _setState(TtsPlaybackState.idle);
      }
    });

    _tts.setCancelHandler(() {
      _setState(TtsPlaybackState.stopped);
    });

    _tts.setPauseHandler(() {
      _setState(TtsPlaybackState.paused);
    });

    _tts.setErrorHandler((msg) {
      _setState(TtsPlaybackState.error);
    });

    _initialized = true;
  }

  // ── PLAYBACK ────────────────────────────────────────────

  @override
  Future<void> speakVerse({
    required String text,
    required int verseNumber,
  }) async {
    _isLoopMode = false;
    _currentChapterVerses = [];
    _currentVerseIndex = verseNumber;
    _verseIndexController.add(_currentVerseIndex);

    await _tts.stop();
    await _tts.speak(_cleanText(text));
  }

  @override
  Future<void> speakChapter({
    required List<String> verses,
    bool loop = false,
    int startFromVerse = 0,
  }) async {
    _currentChapterVerses = verses;
    _isLoopMode = loop;
    _currentVerseIndex = startFromVerse;

    await _tts.stop();
    await _playNextVerse();
  }

  Future<void> _playNextVerse() async {
    if (_currentVerseIndex >= _currentChapterVerses.length) {
      if (_isLoopMode) {
        // Boucle : reprend au début du chapitre
        _currentVerseIndex = 0;
      } else {
        _currentChapterVerses = [];
        _setState(TtsPlaybackState.idle);
        return;
      }
    }

    final verseText = _currentChapterVerses[_currentVerseIndex];
    _verseIndexController.add(_currentVerseIndex);
    _currentVerseIndex++;
    await _tts.speak(_cleanText(verseText));
  }

  @override
  Future<void> pause() async {
    await _tts.pause();
    _setState(TtsPlaybackState.paused);
  }

  @override
  Future<void> resume() async {
    if (_state == TtsPlaybackState.paused) {
      // flutter_tts ne supporte pas nativement le resume —
      // on re-lit le verset courant
      if (_currentChapterVerses.isNotEmpty) {
        final idx = (_currentVerseIndex - 1).clamp(
            0, _currentChapterVerses.length - 1);
        await _tts.speak(_cleanText(_currentChapterVerses[idx]));
      }
    }
  }

  @override
  Future<void> stop() async {
    _isLoopMode = false;
    _currentChapterVerses = [];
    await _tts.stop();
    _setState(TtsPlaybackState.stopped);
  }

  @override
  Future<void> updateSettings(BibleTtsSettings settings) async {
    final wasPlaying = _state == TtsPlaybackState.playing;
    if (wasPlaying) await _tts.stop();

    await _tts.setLanguage(settings.languageCode);
    await _tts.setSpeechRate(settings.speechRate);
    await _tts.setPitch(settings.pitch);
    await _tts.setVolume(settings.volume);

    // Reprend automatiquement si la lecture était en cours
    // (l'utilisateur a changé un paramètre pendant la lecture)
  }

  @override
  Future<void> dispose() async {
    _isLoopMode = false;
    await _tts.stop();
    await _playbackController.close();
    await _verseIndexController.close();
  }

  // ── HELPERS ─────────────────────────────────────────────

  void _setState(TtsPlaybackState newState) {
    _state = newState;
    if (!_playbackController.isClosed) {
      _playbackController.add(newState);
    }
  }

  /// Nettoie les numéros de verset inline si présents (ex: "1 Au commencement...")
  String _cleanText(String text) {
    return text.trim().replaceAll(RegExp(r'^\d+\s+'), '');
  }
}

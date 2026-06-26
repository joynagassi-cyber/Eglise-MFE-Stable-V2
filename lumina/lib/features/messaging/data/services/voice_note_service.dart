// lib/features/messaging/data/services/voice_note_service.dart
// Service d'enregistrement et de gestion des notes vocales

import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumina/core/logging/app_logger.dart';
import 'package:logger/logger.dart';

/// States for the voice recorder
enum VoiceRecordingState { idle, recording, paused }

/// Service for recording, uploading, and managing voice notes.
class VoiceNoteService {
  final SupabaseClient _supabase;
  final Logger _logger = Logger();
  final AudioRecorder _recorder = AudioRecorder();

  static const int maxFileSizeBytes = 5 * 1024 * 1024; // 5 Mo
  static const Duration maxDuration = Duration(minutes: 5);

  VoiceRecordingState _state = VoiceRecordingState.idle;
  VoiceRecordingState get state => _state;

  DateTime? _recordingStartTime;
  Timer? _durationTimer;
  String? _currentPath;

  // Streams
  final _stateController = StreamController<VoiceRecordingState>.broadcast();
  Stream<VoiceRecordingState> get stateStream => _stateController.stream;

  final _durationController = StreamController<Duration>.broadcast();
  Stream<Duration> get durationStream => _durationController.stream;

  final _amplitudeController = StreamController<double>.broadcast();
  Stream<double> get amplitudeStream => _amplitudeController.stream;

  VoiceNoteService(this._supabase);

  /// Check if the device can record audio.
  Future<bool> hasPermission() async {
    return _recorder.hasPermission();
  }

  /// Start recording a voice note.
  Future<bool> startRecording() async {
    try {
      if (!await hasPermission()) {
        _logger.w('VoiceNote: No microphone permission');
        return false;
      }

      final dir = await getTemporaryDirectory();
      _currentPath =
          '${dir.path}/voice_note_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
          numChannels: 1,
        ),
        path: _currentPath!,
      );

      _state = VoiceRecordingState.recording;
      _stateController.add(_state);
      _recordingStartTime = DateTime.now();

      // Start duration timer
      _durationTimer =
          Timer.periodic(const Duration(milliseconds: 100), (_) async {
        if (_state == VoiceRecordingState.recording &&
            _recordingStartTime != null) {
          final elapsed = DateTime.now().difference(_recordingStartTime!);
          _durationController.add(elapsed);

          // Auto-stop at max duration
          if (elapsed >= maxDuration) {
            await stopRecording();
          }

          // Get amplitude for waveform
          try {
            final amplitude = await _recorder.getAmplitude();
            // Normalize amplitude from dB (-160 to 0) to 0.0-1.0
            final normalized = ((amplitude.current + 60) / 60).clamp(0.0, 1.0);
            _amplitudeController.add(normalized);
          } catch (e, st) {
            AppLogger.e('Erreur lors de la récupération de l\'amplitude du vocal', 'VoiceNoteService', e, st);
          }
        }
      });

      _logger.i('VoiceNote: Recording started');
      return true;
    } catch (e) {
      _logger.e('VoiceNote: Failed to start recording', error: e);
      return false;
    }
  }

  /// Stop recording and return the file path.
  Future<String?> stopRecording() async {
    try {
      _durationTimer?.cancel();
      _durationTimer = null;

      final path = await _recorder.stop();
      _state = VoiceRecordingState.idle;
      _stateController.add(_state);
      _recordingStartTime = null;

      if (path == null) return null;

      // Check file size
      final file = File(path);
      if (await file.exists()) {
        final size = await file.length();
        if (size > maxFileSizeBytes) {
          _logger.w('VoiceNote: File too large ($size bytes), deleting');
          await file.delete();
          return null;
        }
      }

      _logger.i('VoiceNote: Recording stopped, saved to $path');
      return path;
    } catch (e) {
      _logger.e('VoiceNote: Failed to stop recording', error: e);
      _state = VoiceRecordingState.idle;
      _stateController.add(_state);
      return null;
    }
  }

  /// Cancel the current recording.
  Future<void> cancelRecording() async {
    try {
      _durationTimer?.cancel();
      _durationTimer = null;
      await _recorder.stop();

      // Delete the partial file
      if (_currentPath != null) {
        final file = File(_currentPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }

      _state = VoiceRecordingState.idle;
      _stateController.add(_state);
      _recordingStartTime = null;
      _logger.i('VoiceNote: Recording cancelled');
    } catch (e) {
      _logger.e('VoiceNote: Failed to cancel recording', error: e);
    }
  }

  /// Upload a recorded voice note to Supabase Storage.
  Future<String?> uploadVoiceNote(
    String filePath,
    String conversationId,
  ) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return null;

      final bytes = await file.readAsBytes();
      final fileName = 'voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      final storagePath = 'chat_attachments/$conversationId/$fileName';

      await _supabase.storage
          .from('chat-files')
          .uploadBinary(storagePath, bytes,
              fileOptions: const FileOptions(
                contentType: 'audio/mp4',
              ));

      final url =
          _supabase.storage.from('chat-files').getPublicUrl(storagePath);

      // Clean up the temp file
      await file.delete();

      _logger.i('VoiceNote: Uploaded to $url');
      return url;
    } catch (e) {
      _logger.e('VoiceNote: Upload failed', error: e);
      return null;
    }
  }

  /// Get the current recording duration.
  Duration get currentDuration {
    if (_recordingStartTime == null) return Duration.zero;
    return DateTime.now().difference(_recordingStartTime!);
  }

  /// Clean up resources.
  void dispose() {
    _durationTimer?.cancel();
    _recorder.dispose();
    _stateController.close();
    _durationController.close();
    _amplitudeController.close();
  }
}
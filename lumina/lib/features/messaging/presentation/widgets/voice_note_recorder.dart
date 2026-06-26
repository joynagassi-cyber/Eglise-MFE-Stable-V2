// lib/features/messaging/presentation/widgets/voice_note_recorder.dart
// Widget d'enregistrement de notes vocales avec visualisation d'amplitude

import 'dart:async';
import 'package:lumina/core/extensions/context_extension.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/features/messaging/data/services/voice_note_service.dart';

/// Callback when recording is complete with file path.
typedef OnRecordingComplete = void Function(String filePath);

/// A premium voice recorder overlay with real-time waveform visualization.
class VoiceNoteRecorder extends StatefulWidget {
  final VoiceNoteService voiceNoteService;
  final OnRecordingComplete onRecordingComplete;
  final VoidCallback onCancel;

  const VoiceNoteRecorder({
    super.key,
    required this.voiceNoteService,
    required this.onRecordingComplete,
    required this.onCancel,
  });

  @override
  State<VoiceNoteRecorder> createState() => _VoiceNoteRecorderState();
}

class _VoiceNoteRecorderState extends State<VoiceNoteRecorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final List<double> _amplitudes = [];
  StreamSubscription<double>? _amplitudeSub;
  StreamSubscription<Duration>? _durationSub;
  Duration _currentDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _startRecording();
  }

  Future<void> _startRecording() async {
    final started = await widget.voiceNoteService.startRecording();
    if (started) {
      _amplitudeSub =
          widget.voiceNoteService.amplitudeStream.listen((amplitude) {
        if (mounted) {
          setState(() {
            _amplitudes.add(amplitude);
            // Keep last 100 samples for display
            if (_amplitudes.length > 100) {
              _amplitudes.removeAt(0);
            }
          });
        }
      });

      _durationSub = widget.voiceNoteService.durationStream.listen((duration) {
        if (mounted) {
          setState(() => _currentDuration = duration);
        }
      });
    } else {
      if (mounted) widget.onCancel();
    }
  }

  Future<void> _stopAndSend() async {
    final path = await widget.voiceNoteService.stopRecording();
    if (path != null) {
      widget.onRecordingComplete(path);
    } else {
      widget.onCancel();
    }
  }

  Future<void> _cancel() async {
    await widget.voiceNoteService.cancelRecording();
    widget.onCancel();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _amplitudeSub?.cancel();
    _durationSub?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 2,
      ),
      decoration: BoxDecoration(
        color: context.colors.bgCard,
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: context.colors.bgTertiary,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Waveform
            SizedBox(
              height: 48,
              child: CustomPaint(
                size: const Size(double.infinity, 48),
                painter: _WaveformPainter(
                  amplitudes: _amplitudes,
                  color: context.colors.brandPrimary,
                  isDark: isDark,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cancel
                Semantics(
                  label: 'Annuler l\'enregistrement',
                  button: true,
                  child: IconButton(
                    onPressed: _cancel,
                    icon: Icon(Icons.close_rounded),
                    color: context.colors.errorText,
                    iconSize: AppSpacing.iconLg,
                  ),
                ),
                // Duration + Recording indicator
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: context.colors.errorText.withValues(
                              alpha: 0.5 + (_pulseController.value * 0.5),
                            ),
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      _formatDuration(_currentDuration),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.colors.textPrimary,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
                // Send
                Semantics(
                  label: 'Envoyer la note vocale',
                  button: true,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: context.colors.brandPrimaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: AppSpacing.shadowPrimary(context.colors.brandPrimary),
                    ),
                    child: IconButton(
                      onPressed: _stopAndSend,
                      icon: Icon(Icons.send_rounded),
                      color: context.colors.textInverse,
                      iconSize: AppSpacing.iconMd,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for the waveform visualization.
class _WaveformPainter extends CustomPainter {
  final List<double> amplitudes;
  final Color color;
  final bool isDark;

  _WaveformPainter({
    required this.amplitudes,
    required this.color,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (amplitudes.isEmpty) return;

    const barWidth = 3.0;
    const gap = 2.0;
    const totalBarWidth = barWidth + gap;
    final maxBars = (size.width / totalBarWidth).floor();
    final displayAmplitudes = amplitudes.length > maxBars
        ? amplitudes.sublist(amplitudes.length - maxBars)
        : amplitudes;

    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = barWidth;

    final fadePaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = barWidth;

    final centerY = size.height / 2;
    final maxBarHeight = size.height * 0.8;

    for (int i = 0; i < displayAmplitudes.length; i++) {
      final amp = displayAmplitudes[i];
      final barHeight = max(4.0, amp * maxBarHeight);
      final x = i * totalBarWidth;

      // Fade older bars
      final opacity = i / displayAmplitudes.length;
      final p = opacity > 0.5 ? paint : fadePaint;

      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return amplitudes.length != oldDelegate.amplitudes.length;
  }
}

// lib/features/messaging/presentation/widgets/voice_note_player.dart
// Widget de lecture de notes vocales avec forme d'onde

import 'dart:math';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lumina/core/theme/app_spacing.dart';
/// A compact audio player for voice notes with waveform visualization.
class VoiceNotePlayer extends StatefulWidget {
  final String audioUrl;
  final bool isMe;
  final String duration;

  const VoiceNotePlayer({
    super.key,
    required this.audioUrl,
    this.isMe = false,
    this.duration = '0:00',
  });

  @override
  State<VoiceNotePlayer> createState() => _VoiceNotePlayerState();
}

class _VoiceNotePlayerState extends State<VoiceNotePlayer> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // Generate random waveform bars for visual representation
  late List<double> _waveformData;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Generate pseudo-random waveform for visual appeal
    final random = Random(widget.audioUrl.hashCode);
    _waveformData = List.generate(30, (_) => 0.2 + random.nextDouble() * 0.8);

    _audioPlayer.onDurationChanged.listen((d) {
      if (mounted) setState(() => _totalDuration = d);
    });

    _audioPlayer.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      if (_position == Duration.zero) {
        await _audioPlayer.play(UrlSource(widget.audioUrl));
      } else {
        await _audioPlayer.resume();
      }
      setState(() => _isPlaying = true);
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = _totalDuration.inMilliseconds > 0
        ? _position.inMilliseconds / _totalDuration.inMilliseconds
        : 0.0;

    final accentColor = widget.isMe ? context.colors.textInverse : context.colors.brandPrimary;
    final dimColor = widget.isMe
        ? context.colors.textInverse.withValues(alpha: 0.4)
        : context.colors.brandPrimary.withValues(alpha: 0.3);
    final textColor = widget.isMe
        ? context.colors.textInverse.withValues(alpha: 0.8)
        : (theme.brightness == Brightness.dark
            ? context.colors.textSecondaryDark
            : context.colors.textSecondaryLight);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Play/Pause button
        Semantics(
          label: _isPlaying ? 'Mettre en pause' : 'Écouter la note vocale',
          button: true,
          child: GestureDetector(
            onTap: _togglePlay,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: widget.isMe ? 0.2 : 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: accentColor,
                size: AppSpacing.iconMd,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        // Waveform
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 28,
                child: CustomPaint(
                  size: const Size(double.infinity, 28),
                  painter: _PlaybackWaveformPainter(
                    waveformData: _waveformData,
                    progress: progress,
                    activeColor: accentColor,
                    inactiveColor: dimColor,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _isPlaying || _position > Duration.zero
                    ? _formatDuration(_position)
                    : widget.duration,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                  color: textColor,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Custom painter for playback waveform visualization.
class _PlaybackWaveformPainter extends CustomPainter {
  final List<double> waveformData;
  final double progress;
  final Color activeColor;
  final Color inactiveColor;

  _PlaybackWaveformPainter({
    required this.waveformData,
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (waveformData.isEmpty) return;

    const barWidth = 3.0;
    const gap = 2.0;
    const totalBarWidth = barWidth + gap;
    final maxBars = (size.width / totalBarWidth).floor();
    final barsToShow = min(maxBars, waveformData.length);

    final centerY = size.height / 2;
    final maxBarHeight = size.height * 0.85;
    final progressIndex = (progress * barsToShow).floor();

    for (int i = 0; i < barsToShow; i++) {
      final dataIndex = (i * waveformData.length / barsToShow)
          .floor()
          .clamp(0, waveformData.length - 1);
      final amp = waveformData[dataIndex];
      final barHeight = max(4.0, amp * maxBarHeight);
      final x = i * totalBarWidth;

      final paint = Paint()
        ..color = i <= progressIndex ? activeColor : inactiveColor
        ..strokeCap = StrokeCap.round
        ..strokeWidth = barWidth;

      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PlaybackWaveformPainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

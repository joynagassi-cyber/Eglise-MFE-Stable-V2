// lib/features/bible/presentation/widgets/tts_control_bar.dart
// Barre de contrôle TTS flottante pour le lecteur Bible.
// Apparaît en bas de l'écran quand le TTS est actif.

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../../core/theme/app_spacing.dart';
// import 'package:lumina/features/bible/domain/services/i_bible_tts_service.dart';
import 'package:lumina/features/bible/reader/providers/bible_notifier.dart';
import 'package:lumina/features/bible/core/providers/bible_settings_provider.dart';
// import '../../../../core/theme/lumina_colors_extension.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:lumina/features/bible/domain/entities/bible_entities.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class TtsControlBar extends ConsumerWidget {
  const TtsControlBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ttsState =
        ref.watch(bibleNotifierProvider.select((s) => s.ttsState));
    final verseIndex =
        ref.watch(bibleNotifierProvider.select((s) => s.speakingVerseIndex));
    final loopMode =
        ref.watch(bibleNotifierProvider.select((s) => s.ttsLoopMode));
    final notifier = ref.read(bibleNotifierProvider.notifier);

    final isVisible = ttsState == TtsPlaybackState.playing ||
        ttsState == TtsPlaybackState.paused;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: isVisible
          ? _TtsBar(
              state: ttsState,
              verseIndex: verseIndex,
              loopMode: loopMode,
              onPlay: () => notifier.startChapterReading(loop: loopMode),
              onPause: notifier.pauseTts,
              onStop: notifier.stopTts,
              onToggleLoop: notifier.toggleLoopMode,
              onOpenSettings: () => _showTtsSettings(context, ref),
            )
          : const SizedBox.shrink(),
    );
  }

  void _showTtsSettings(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _TtsSettingsSheet(),
    );
  }
}

class _TtsBar extends StatelessWidget {
  final TtsPlaybackState state;
  final int verseIndex;
  final bool loopMode;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onStop;
  final VoidCallback onToggleLoop;
  final VoidCallback onOpenSettings;

  const _TtsBar({
    required this.state,
    required this.verseIndex,
    required this.loopMode,
    required this.onPlay,
    required this.onPause,
    required this.onStop,
    required this.onToggleLoop,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: context.colors.surfacePrimary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: context.colors.bgScrim.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: context.colors.accent.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Icône micro
          Icon(Icons.mic, color: context.colors.accent, size: 20),
          SizedBox(width: 8),
          // Info verset
          Expanded(
            child: Text(
              verseIndex >= 0
                  ? 'Verset ${verseIndex + 1}'
                  : 'Lecture du chapitre',
              style: AppTypography.labelMedium.copyWith(
                color: context.colors.accent,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Bouton boucle
          IconButton(
            icon: Icon(
              Icons.repeat,
              color: loopMode ? context.colors.accent : context.colors.iconSecondary,
              size: 20,
            ),
            tooltip: loopMode ? 'Boucle activée' : 'Activer boucle',
            onPressed: onToggleLoop,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          // Play/Pause
          IconButton(
            icon: Icon(
              state == TtsPlaybackState.playing
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_filled,
              color: context.colors.accent,
              size: 32,
            ),
            onPressed: state == TtsPlaybackState.playing ? onPause : onPlay,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          // Stop
          IconButton(
            icon: Icon(Icons.stop_circle_outlined, size: 24),
            onPressed: onStop,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          // Settings
          IconButton(
            icon: Icon(Icons.tune, size: 20),
            onPressed: onOpenSettings,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// TTS SETTINGS SHEET
// ─────────────────────────────────────────────────────────

class _TtsSettingsSheet extends ConsumerWidget {
  const _TtsSettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(bibleTtsSettingsNotifierProvider);
    final notifier = ref.read(bibleTtsSettingsNotifierProvider.notifier);
    final bibleNotifier = ref.read(bibleNotifierProvider.notifier);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text('Paramètres de lecture audio',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
              )),
          SizedBox(height: 20),

          // Langue
          _SettingRow(
            label: 'Langue',
            child: DropdownButton<String>(
              value: settings.languageCode,
              underline: SizedBox(),
              items: const [
                DropdownMenuItem(value: 'fr-FR', child: Text('Français (FR)')),
                DropdownMenuItem(value: 'fr-BE', child: Text('Français (BE)')),
                DropdownMenuItem(value: 'en-US', child: Text('English (US)')),
                DropdownMenuItem(value: 'en-GB', child: Text('English (GB)')),
              ],
              onChanged: (v) async {
                if (v != null) {
                  await notifier.setLanguage(v);
                  await bibleNotifier.updateTtsSettings(settings.copyWith(languageCode: v));
                }
              },
            ),
          ),

          // Vitesse
          _SettingRow(
            label: 'Vitesse (${settings.speechRate.toStringAsFixed(1)}x)',
            child: Slider(
              value: settings.speechRate,
              min: 0.1,
              max: 1.0,
              divisions: 9,
              onChanged: (v) async {
                await notifier.setSpeechRate(v);
                await bibleNotifier.updateTtsSettings(settings.copyWith(speechRate: v));
              },
            ),
          ),

          // Hauteur
          _SettingRow(
            label: 'Hauteur (${settings.pitch.toStringAsFixed(1)})',
            child: Slider(
              value: settings.pitch,
              min: 0.5,
              max: 2.0,
              divisions: 15,
              onChanged: (v) async {
                await notifier.setPitch(v);
                await bibleNotifier.updateTtsSettings(settings.copyWith(pitch: v));
              },
            ),
          ),

          // Volume
          _SettingRow(
            label: 'Volume (${(settings.volume * 100).round()}%)',
            child: Slider(
              value: settings.volume,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              onChanged: (v) async {
                await notifier.setVolume(v);
                await bibleNotifier.updateTtsSettings(settings.copyWith(volume: v));
              },
            ),
          ),

          SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String label;
  final Widget child;

  const _SettingRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: AppTypography.bodyMedium),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

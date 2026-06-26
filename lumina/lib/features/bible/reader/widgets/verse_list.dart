// lib/features/bible/presentation/widgets/verse_list.dart
// Widget de liste des versets — performant avec ListView.builder.
// Gère: sélection, surlignage, TTS highlight, appui long, tap.

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:lumina/features/bible/domain/entities/bible_entities.dart';
// import 'package:lumina/features/bible/domain/services/i_bible_tts_service.dart';
import 'package:lumina/features/bible/reader/providers/bible_notifier.dart';
// import 'package:lumina/core/theme/lumina_colors_extension.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class VerseList extends ConsumerWidget {
  final List<String> verses;
  final List<BibleAnnotation> annotations;
  final Function(int verseIndex, String verseText) onVerseLongPress;
  final Function(int verseIndex, String verseText) onVerseTap;
  final double fontSize;

  const VerseList({
    super.key,
    required this.verses,
    required this.annotations,
    required this.onVerseLongPress,
    required this.onVerseTap,
    this.fontSize = 17,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedVerses =
        ref.watch(bibleNotifierProvider.select((s) => s.selectedVerses));
    final speakingIndex =
        ref.watch(bibleNotifierProvider.select((s) => s.speakingVerseIndex));
    final ttsState =
        ref.watch(bibleNotifierProvider.select((s) => s.ttsState));

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: verses.length,
      itemBuilder: (context, index) {
        final verseText = verses[index];
        final isSelected = selectedVerses.contains(index);
        final isSpeaking = speakingIndex == index &&
            ttsState == TtsPlaybackState.playing;
        final annotation = _getAnnotationForVerse(index + 1);

        return _VerseItem(
          index: index,
          text: verseText,
          isSelected: isSelected,
          isSpeaking: isSpeaking,
          annotation: annotation,
          fontSize: fontSize,
          onTap: () => onVerseTap(index, verseText),
          onLongPress: () => onVerseLongPress(index, verseText),
        );
      },
    );
  }

  BibleAnnotation? _getAnnotationForVerse(int verse) {
    try {
      return annotations.firstWhere(
        (a) => a.verse == verse && a.type == BibleAnnotationType.highlight,
      );
    } catch (_) {
      return null;
    }
  }
}

class _VerseItem extends StatelessWidget {
  final int index;
  final String text;
  final bool isSelected;
  final bool isSpeaking;
  final BibleAnnotation? annotation;
  final double fontSize;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _VerseItem({
    required this.index,
    required this.text,
    required this.isSelected,
    required this.isSpeaking,
    required this.annotation,
    required this.fontSize,
    required this.onTap,
    required this.onLongPress,
  });

  Color? _getBackgroundColor(BuildContext context) {
    if (isSpeaking) return context.colors.brandPrimary.withValues(alpha: 0.15);
    if (isSelected) return context.colors.brandPrimary.withValues(alpha: 0.1);
    if (annotation?.color != null) {
      try {
        final colorStr = annotation!.color!.trim();
        final colorValue = int.tryParse(colorStr.startsWith('#') ? '0xFF${colorStr.substring(1)}' : '0x$colorStr') ?? 0;
        return Color(colorValue).withValues(alpha: 0.35);
      } catch (_) {
        return context.colors.bibleHighlightYellow.withValues(alpha: 0.3);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _getBackgroundColor(context),
          borderRadius: BorderRadius.circular(8),
          border: isSpeaking
              ? Border.all(color: context.colors.accent.withOpacity(0.5), width: 1)
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        margin: const EdgeInsets.only(bottom: 2),
        child: RichText(
          text: TextSpan(
            style: AppTypography.bodyLarge.copyWith(
              fontSize: fontSize,
              height: 1.7,
              color: context.colors.textPrimary,
            ),
            children: [
              // Numéro du verset
              TextSpan(
                text: '${index + 1} ',
                style: TextStyle(
                  color: isSpeaking
                      ? context.colors.brandPrimary
                      : context.colors.brandPrimary.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize * 0.7,
                  fontFeatures: const [FontFeature.superscripts()],
                ),
              ),
              // Texte du verset
              TextSpan(text: text),
            ],
          ),
        ),
      ),
    );
  }
}


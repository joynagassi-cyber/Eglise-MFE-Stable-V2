// lib/features/bible/presentation/widgets/verse_action_sheet.dart
// Feuille d'actions sur un verset sélectionné.
// Actions: Lire (TTS), Surligner, Annoter, Copier, Signet.

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:lumina/features/bible/domain/entities/bible_entities.dart';
import 'package:lumina/features/bible/reader/providers/bible_notifier.dart';
import '../../../../core/theme/lumina_colors_extension.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

// Constantes de couleurs de surlignage
const _kHighlightColors = [
  '#FFE082', // Jaune
  '#A5D6A7', // Vert
  '#90CAF9', // Bleu
  '#EF9A9A', // Rouge
  '#CE93D8', // Violet clair
  '#FFCC80', // Orange
];

Future<void> showVerseActionSheet({
  required BuildContext context,
  required WidgetRef ref,
  required int verseIndex,
  required String verseText,
  BibleAnnotation? existingAnnotation,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: LuminaColorsExtension.of(context).bgPrimary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _VerseActionSheet(
      verseIndex: verseIndex,
      verseText: verseText,
    ),
  );
}

class _VerseActionSheet extends ConsumerStatefulWidget {
  final int verseIndex;
  final String verseText;

  const _VerseActionSheet({
    required this.verseIndex,
    required this.verseText,
  });

  @override
  ConsumerState<_VerseActionSheet> createState() => _VerseActionSheetState();
}

class _VerseActionSheetState extends ConsumerState<_VerseActionSheet> {
  bool _showNoteInput = false;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(bibleNotifierProvider.notifier);
    final state = ref.read(bibleNotifierProvider);
    final isBookmarked = notifier.isBookmarked(widget.verseIndex);
    final verseNum = widget.verseIndex + 1;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
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
          const SizedBox(height: 12),

          // Référence
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: context.colors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Verset $verseNum',
                  style: AppTypography.labelMedium.copyWith(
                    color: context.colors.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              widget.verseText,
              style: AppTypography.bodyMedium.copyWith(
                fontStyle: FontStyle.italic,
                color: context.colors.textSecondary,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Divider(height: 24),

          // Actions principales
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              _ActionChip(
                icon: Icons.volume_up_outlined,
                label: 'Lire',
                onTap: () async {
                  Navigator.of(context).pop();
                  await notifier.speakVerse(widget.verseIndex);
                },
              ),
              _ActionChip(
                icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                label: isBookmarked ? 'Retiré' : 'Signet',
                color: isBookmarked ? context.colors.accent : null,
                onTap: () async {
                  Navigator.of(context).pop();
                  await notifier.toggleBookmark(
                    verse: widget.verseIndex,
                    verseText: widget.verseText,
                  );
                },
              ),
              _ActionChip(
                icon: Icons.edit_note,
                label: 'Note',
                onTap: () =>
                    setState(() => _showNoteInput = !_showNoteInput),
              ),
              _ActionChip(
                icon: Icons.copy,
                label: 'Copier',
                onTap: () {
                  Navigator.of(context).pop();
                  Clipboard.setData(ClipboardData(
                    text:
                        '${state.currentBook} ${state.currentChapter}:$verseNum'
                        ' — ${widget.verseText}',
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Verset copié !')),
                  );
                },
              ),
              _ActionChip(
                icon: Icons.headset_mic_outlined,
                label: 'Chapitre',
                onTap: () async {
                  Navigator.of(context).pop();
                  await notifier.startChapterReading(loop: false);
                },
              ),
            ],
          ),

          // Palette surlignage
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text('Surligner:',
                    style: AppTypography.labelSmall
                        .copyWith(color: context.colors.textTertiary)),
                const SizedBox(width: 8),
                ..._kHighlightColors.map((hex) => _ColorDot(
                      hexColor: hex,
                      onTap: () async {
                        Navigator.of(context).pop();
                        await notifier.saveHighlight(
                          verse: widget.verseIndex,
                          colorHex: hex,
                        );
                      },
                    )),
              ],
            ),
          ),

          // Saisie de note
          if (_showNoteInput) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _noteController,
                    maxLines: 3,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Ajouter une note…',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      if (_noteController.text.trim().isEmpty) return;
                      Navigator.of(context).pop();
                      await notifier.saveNote(
                        verse: widget.verseIndex,
                        content: _noteController.text.trim(),
                      );
                    },
                    child: const Text('Enregistrer la note'),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.colors.accent;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: effectiveColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: effectiveColor.withOpacity(0.15)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 22, color: effectiveColor),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: effectiveColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final String hexColor;
  final VoidCallback onTap;

  const _ColorDot({required this.hexColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Color(
      int.tryParse('0xFF${hexColor.replaceAll('#', '')}') ?? 0xFFFFFF88,
    );
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: context.colors.borderSubtle),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}

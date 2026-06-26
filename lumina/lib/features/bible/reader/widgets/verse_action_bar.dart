import 'dart:async';
import 'dart:ui';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lumina/features/bible/reader/providers/bible_notifier.dart';
import 'package:lumina/features/bible/annotations/widgets/note_editor_dialog.dart';
// import 'package:lumina/core/theme/lumina_colors_extension.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class VerseActionBar extends ConsumerWidget {
  final Set<int> selectedVerses;
  final VoidCallback onClear;

  const VerseActionBar({
    super.key,
    required this.selectedVerses,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (selectedVerses.isEmpty) return const SizedBox.shrink();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 100 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildColorPicker(context, ref),
              SizedBox(height: 8),
              _buildMainToolbar(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorPicker(BuildContext context, WidgetRef ref) {
    final colors = [
      {'color': context.colors.bibleHighlightYellow, 'name': 'Jaune'},
      {'color': context.colors.bibleHighlightGreen, 'name': 'Vert'},
      {'color': context.colors.bibleHighlightBlue, 'name': 'Bleu'},
      {'color': context.colors.bibleHighlightPink, 'name': 'Rose'},
      {'color': context.colors.bibleHighlightRed, 'name': 'Rouge'},
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.colors.bgOverlay.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: context.colors.borderSubtle.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...colors.map((c) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: GestureDetector(
                      onTap: () async {
                        await HapticFeedback.lightImpact();
                        final colorHex = (c['color'] as Color).value.toRadixString(16).padLeft(8, '0');
                        for (final v in selectedVerses) {
                          await ref.read(bibleNotifierProvider.notifier).saveHighlight(
                                verse: v,
                                colorHex: colorHex,
                                category: c['name'] as String,
                              );
                        }
                        onClear();
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: c['color'] as Color,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: (c['color'] as Color).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
              SizedBox(width: 4),
              Container(width: 1, height: 24, color: context.colors.borderSubtle),
              SizedBox(width: 4),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(Icons.format_color_reset, color: context.colors.textPrimary, size: 20),
                onPressed: () {
                  // TODO: Implement color removal
                  onClear();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainToolbar(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: context.colors.bgOverlay.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: context.colors.borderSubtle.withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 12.0,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ToolbarAction(
                icon: Icons.note_add_outlined,
                label: 'Note',
                onTap: () {
                  unawaited(HapticFeedback.mediumImpact());
                  final first = selectedVerses.toList()..sort();
                  if (first.isNotEmpty) {
                    NoteEditorDialog.show(context, verseIndex: first.first);
                  }
                },
              ),
              _ToolbarAction(
                icon: Icons.copy_outlined,
                label: 'Copier',
                onTap: () {
                  unawaited(HapticFeedback.mediumImpact());
                  _handleCopy(ref, context);
                },
              ),
              _ToolbarAction(
                icon: Icons.share_outlined,
                label: 'Partager',
                onTap: () {
                  unawaited(HapticFeedback.mediumImpact());
                  _handleShare(ref, context);
                },
              ),
              _ToolbarAction(
                icon: Icons.bookmark_add_outlined,
                label: 'Signet',
                onTap: () {
                  unawaited(HapticFeedback.mediumImpact());
                  _handleBookmark(ref, context);
                },
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: onClear,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.colors.errorBg.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: context.colors.errorText, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCopy(WidgetRef ref, BuildContext context) {
    final state = ref.read(bibleNotifierProvider);
    final verses = state.chapter?.verses;
    if (verses == null) return;

    final sortedIndices = selectedVerses.toList()..sort();
    final text = sortedIndices.map((i) => '${i + 1}. ${verses[i]}').join('\n');
    
    final reference = '${state.currentBook} ${state.currentChapter}:${sortedIndices.map((i) => i + 1).join(',')}';
    final fullText = '$reference\n\n$text';

    Clipboard.setData(ClipboardData(text: fullText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Versets copiés ($reference)'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    onClear();
  }

  void _handleBookmark(WidgetRef ref, BuildContext context) async {
    final state = ref.read(bibleNotifierProvider);
    final verses = state.chapter?.verses;
    if (verses == null) return;

    for (final v in selectedVerses) {
      await ref.read(bibleNotifierProvider.notifier).toggleBookmark(
        verse: v,
        verseText: verses[v],
      );
    }
    
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Favoris mis à jour'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    onClear();
  }

  void _handleShare(WidgetRef ref, BuildContext context) {
    final state = ref.read(bibleNotifierProvider);
    final verses = state.chapter?.verses;
    if (verses == null) return;

    final sortedIndices = selectedVerses.toList()..sort();
    final text = sortedIndices.map((i) => '${i + 1}. ${verses[i]}').join('\n');
    final reference =
        '${state.currentBook} ${state.currentChapter}:${sortedIndices.map((i) => i + 1).join(',')}';
    final fullText = ' $reference\n\n$text\n\n— Lumina';

    Share.share(fullText);
    onClear();
  }
}

class _ToolbarAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ToolbarAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: context.colors.iconPrimary, size: 22),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: context.colors.textPrimary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// lib/features/bible/presentation/widgets/chapter_nav_bar.dart
// Barre de navigation entre chapitres (Précédent / Indicateur / Suivant).

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/features/bible/reader/providers/bible_notifier.dart';

class ChapterNavBar extends ConsumerWidget {
  final int chapter;
  final int totalChapters;
  final String bookName;

  const ChapterNavBar({
    super.key,
    required this.chapter,
    required this.totalChapters,
    required this.bookName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(bibleNotifierProvider.notifier);
    final isLoading =
        ref.watch(bibleNotifierProvider.select((s) => s.isLoadingChapter));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.colors.bgPrimary,
        border: Border(
          top: BorderSide(color: context.colors.borderSubtle, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Bouton précédent
            _NavButton(
              icon: Icons.chevron_left,
              label: 'Préc.',
              enabled: chapter > 1 && !isLoading,
              onTap: notifier.prevChapter,
            ),

            // Indicateur central
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading)
                    const SizedBox(
                      height: 16,
                      width: 16,
                      child: LoadingDots(size: 24),
                    )
                  else
                    Text(
                      'Chapitre $chapter / $totalChapters',
                      style: AppTypography.labelSmall.copyWith(
                        color: context.colors.textTertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  // Barre de progression
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: AppProgressBar(
                      value: totalChapters > 0 ? chapter / totalChapters : 0,
                      height: 3,
                      backgroundColor: context.colors.borderSubtle,
                      color: context.colors.accent,
                    ),
                  ),
                ],
              ),
            ),

            // Bouton suivant
            _NavButton(
              icon: Icons.chevron_right,
              label: 'Suiv.',
              enabled: chapter < totalChapters && !isLoading,
              onTap: notifier.nextChapter,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: enabled ? onTap : null,
      icon: Icon(icon, size: 20),
      label: Text(label, style: AppTypography.labelSmall),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        foregroundColor: enabled ? context.colors.accent : context.colors.textDisabled,
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';

import '../../../../core/router/app_routes.dart';
import 'package:lumina/features/bible/core/repositories/bible_repository_impl.dart';
// import 'package:lumina/core/theme/lumina_colors_extension.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

/// Premium "Verse of the Day" card with gradient, icon, and tap-to-read.
class VerseOfTheDayCard extends ConsumerWidget {
  const VerseOfTheDayCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(bibleRepositoryProvider);
    final votd = repo.getVerseOfTheDay();
    final colors = context.colors;

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: GestureDetector(
        onTap: () {
          final book = votd['book'] ?? 'JHN';
          final chapter = votd['chapter'] ?? '3';
          context.push(
            AppRoutes.bibleReader
                .replaceFirst(':book', book)
                .replaceFirst(':chapter', chapter),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.brandPrimary.withValues(alpha: 0.15),
                colors.brandSecondary.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colors.brandPrimary.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: colors.brandPrimary.withValues(alpha: 0.08),
                blurRadius: 12.0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.brandPrimary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: colors.brandPrimary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'VERSET DU JOUR',
                    style: TextStyle(
                      color: colors.brandPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: colors.brandPrimary.withValues(alpha: 0.5),
                    size: 14,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '"${votd['text'] ?? ''}"',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  height: 1.6,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Text(
                '— ${votd['ref'] ?? ''}',
                style: TextStyle(
                  color: colors.brandPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

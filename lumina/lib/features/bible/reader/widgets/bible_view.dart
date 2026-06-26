import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
import 'package:lumina/features/bible/core/models/bible_models.dart';
import 'package:lumina/features/bible/data/services/bible_service.dart';
import 'package:lumina/features/bible/reader/widgets/reading_streak_badge.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class BibleView extends ConsumerStatefulWidget {
  const BibleView({super.key});

  @override
  ConsumerState<BibleView> createState() => _BibleViewState();
}

class _BibleViewState extends ConsumerState<BibleView> {
  late Future<List<BibleChapterModel>> _recentReadingsFuture;
  late Map<String, String> _verseOfTheDay;

  @override
  void initState() {
    super.initState();
    _verseOfTheDay = ref.read(bibleServiceProvider.notifier).getVerseOfTheDay();
    _recentReadingsFuture =
        ref.read(bibleServiceProvider.notifier).getRecentReadings();
  }

  String _getBookName(String id) {
    final books = ref.read(bibleServiceProvider.notifier).getBooks();
    final book =
        books.firstWhere((b) => b['id'] == id, orElse: () => {'name': id});
    return book['name'] ?? id;
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) {
      return 'Il y a ${diff.inDays} jour${diff.inDays > 1 ? 's' : ''}';
    }
    if (diff.inHours > 0) {
      return 'Il y a ${diff.inHours} heure${diff.inHours > 1 ? 's' : ''}';
    }
    if (diff.inMinutes > 0) {
      return 'Il y a ${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''}';
    }
    return 'À l\'instant';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedEntrance.fromBottom(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.xl),

            // 1. CINEMATIC HEADER
            _buildCinematicHeader(context),

            const SizedBox(height: AppSpacing.lg),

            // 1.5 QUICK ACTIONS (Search + Bookmarks)
            _buildQuickActions(context),

            const SizedBox(height: AppSpacing.md),

            // 1.6 READING STREAK
            const ReadingStreakBadge(),

            const SizedBox(height: AppSpacing.xl),

            // 2. VERSET DU JOUR (GLOWING)
            _buildGlowingVerseCard(context),

            const SizedBox(height: AppSpacing.xl),

            // 3. EXPLORER LA PAROLE
            _buildExploreSection(context, ref),

            const SizedBox(height: AppSpacing.xl),

            // 4. PLANS DE LECTURE
            _buildPlansSection(context),

            const SizedBox(height: AppSpacing.xl),

            // 5. LECTURE RÉCENTE
            _buildRecentReading(context),

            const SizedBox(height: AppSpacing.xl * 3),
          ],
        ),
      ),
    );
  }

  Widget _buildCinematicHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'IMMERSION',
          style: AppTypography.editorialSection.copyWith(
            color: context.colors.accent.withOpacity(0.6),
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Sainte Bible',
          style: AppTypography.h1.copyWith(
            color: context.colors.textOnBrand,
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ScaleButtonWrapper(
            child: GlassCard(
              onTap: () => context.push(AppRoutes.bibleSearch),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              backgroundColor: context.colors.bgSecondary.withOpacity(0.4),
              borderRadius: 14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_rounded,
                      color: context.colors.accent.withOpacity(0.7), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Rechercher',
                    style: AppTypography.editorialSection.copyWith(
                      color: context.colors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: ScaleButtonWrapper(
            child: GlassCard(
              onTap: () => context.push(AppRoutes.bibleBookmarks),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              backgroundColor: context.colors.bgSecondary.withOpacity(0.4),
              borderRadius: 14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_rounded,
                      color: context.colors.accent.withOpacity(0.7), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Mes Favoris',
                    style: AppTypography.editorialSection.copyWith(
                      color: context.colors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlowingVerseCard(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      backgroundColor: context.colors.bgPrimary.withOpacity(0.85),
      borderColor: context.colors.accent.withOpacity(0.4),
      borderRadius: 24,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: context.colors.accent.withOpacity(0.3),
                  blurRadius: 12.0,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.local_fire_department_rounded,
              color: context.colors.accent,
              size: 28,
              shadows: [
                Shadow(
                  color: context.colors.accent.withOpacity(0.6),
                  blurRadius: 12.0,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '"${_verseOfTheDay['text']}"',
            textAlign: TextAlign.center,
            style: AppTypography.editorialDisplay.copyWith(
              color: context.colors.textOnBrand.withOpacity(0.95),
              fontSize: 18,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            _verseOfTheDay['ref']!,
            style: AppTypography.editorialSection.copyWith(
              color: context.colors.accent,
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          GradientButton(
            text: 'LIRE MAINTENANT',
            onPressed: () => context.push(AppRoutes.bibleReader
                .replaceFirst(':book', _verseOfTheDay['book']!)
                .replaceFirst(':chapter', _verseOfTheDay['chapter']!)),
            gradient: context.colors.brandGradient,
            width: 200,
          ),
        ],
      ),
    );
  }

  Widget _buildExploreSection(BuildContext context, WidgetRef ref) {
    final bibleService = ref.read(bibleServiceProvider.notifier);
    final books = bibleService.getBooks();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EXPLORER LES LIVRES'.toUpperCase(),
          style: AppTypography.editorialSection.copyWith(
            color: context.colors.accent.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: books.length,
          separatorBuilder: (context, _) =>
              const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final book = books[index];
            return _buildBookExpansionTile(context, book['name']!, book['id']!);
          },
        ),
      ],
    );
  }

  Widget _buildBookExpansionTile(BuildContext context, String name, String id) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: GlassCard(
        padding: EdgeInsets.zero,
        backgroundColor: context.colors.bgSecondary.withOpacity(0.3),
        borderRadius: 16,
        child: ExpansionTile(
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
          leading: Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.accent.withOpacity(0.1),
            ),
            child: Icon(Icons.book_rounded,
                color: context.colors.accent, size: 18),
          ),
          title: Text(
            name,
            style: AppTypography.bodySmallStyle.copyWith(
              color: context.colors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconColor: context.colors.accent,
          collapsedIconColor: context.colors.iconDisabled,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    List.generate(BibleService.getChapterCount(id), (index) {
                  final chapter = index + 1;
                  return InkWell(
                    onTap: () => context.push(
                      AppRoutes.bibleReader
                          .replaceFirst(':book', id)
                          .replaceFirst(':chapter', '$chapter'),
                    ),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: context.colors.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: context.colors.accent.withOpacity(0.2)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$chapter',
                        style:
                            TextStyle(color: context.colors.textPrimary, fontSize: 12),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlansSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PLANS DE LECTURE'.toUpperCase(),
          style: AppTypography.editorialSection.copyWith(
            color: context.colors.accent.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ScaleButtonWrapper(
          child: GlassCard(
            onTap: () => context.push(AppRoutes.biblePlans),
            padding: const EdgeInsets.all(AppSpacing.xl),
            backgroundColor: context.colors.accent.withOpacity(0.05),
            borderColor: context.colors.accent.withOpacity(0.2),
            borderRadius: 20,
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: context.colors.brandGradient,
                  ),
                  child: Icon(Icons.calendar_month_rounded,
                      color: context.colors.textOnBrand, size: 24),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Découvrir les Plans',
                        style: AppTypography.h3
                            .copyWith(color: context.colors.textPrimary, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Bible en 1 an, Proverbes, Psaumes...',
                        style: AppTypography.editorialDisplay.copyWith(
                          color: context.colors.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: context.colors.accent, size: 16), // Leaving primaryFire for button accent if it fits, but context.colors.accent is safer
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentReading(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DERNIÈRES LECTURES'.toUpperCase(),
          style: AppTypography.editorialSection.copyWith(
            color: context.colors.accent.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        FutureBuilder<List<BibleChapterModel>>(
          future: _recentReadingsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingState());
            }
            if (snapshot.hasError) {
              return Text('Impossible de charger le texte biblique',
                  style: TextStyle(color: context.colors.errorText));
            }

            final readings = snapshot.data ?? [];
            if (readings.isEmpty) {
              return Text('Aucune lecture récente',
                  style: AppTypography.bodySmallStyle
                      .copyWith(color: context.colors.textDisabled));
            }

            return Column(
              children: readings
                  .map((r) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: GlassCard(
                          onTap: () => context.push(AppRoutes.bibleReader
                              .replaceFirst(':book', r.bookIdentifier)
                              .replaceFirst(
                                  ':chapter', r.chapterNumber.toString())),
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          backgroundColor:
                              context.colors.bgSecondary.withOpacity(0.3),
                          borderRadius: 20,
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: context.colors.accentGradient,
                                ),
                                child: Icon(Icons.history_rounded,
                                    color: context.colors.textOnBrand, size: 24),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Text(
                                        '${_getBookName(r.bookIdentifier)} ${r.chapterNumber}',
                                        style: AppTypography.editorialDisplay
                                            .copyWith(
                                                color: context.colors.textPrimary,
                                                fontSize: 16),
                                      ),
                                      Text(
                                        _formatTimeAgo(r.lastReadAt),
                                        style: AppTypography.bodySmallStyle
                                            .copyWith(
                                                color: context.colors.textTertiary),
                                      ),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right_rounded,
                                  color: context.colors.accent),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

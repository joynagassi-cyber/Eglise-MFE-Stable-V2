import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/features/bible/core/repositories/bible_repository_impl.dart';
// import '../../../../core/theme/lumina_colors_extension.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class BookPickerSheet extends ConsumerStatefulWidget {
  final Function(String bookId, int chapter) onSelect;

  const BookPickerSheet({
    super.key,
    required this.onSelect,
  });

  @override
  ConsumerState<BookPickerSheet> createState() => _BookPickerSheetState();
}

class _BookPickerSheetState extends ConsumerState<BookPickerSheet> {
  String? _selectedBook;
  int _selectedChapter = 1;
  bool _showingChapters = false;

  @override
  Widget build(BuildContext context) {
    final books = ref.read(bibleRepositoryProvider).getAllBooks();

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      backgroundColor: context.colors.bgPrimary.withOpacity(0.95),
      borderRadius: 32,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _showingChapters
                    ? 'SÉLECTIONNER CHAPITRE'
                    : 'SÉLECTIONNER UN LIVRE',
                style: AppTypography.editorialSection.copyWith(
                  color: context.colors.accent,
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
              if (_showingChapters)
                IconButton(
                  icon: Icon(Icons.arrow_back_rounded,
                      color: context.colors.iconPrimary, size: 20),
                  tooltip: 'Retour aux livres',
                  onPressed: () => setState(() => _showingChapters = false),
                ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Divider(color: context.colors.borderSubtle),
          SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 400,
            child:
                _showingChapters ? _buildChapterGrid() : _buildBookList(books),
          ),
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildBookList(List<dynamic> books) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        final isSelected = _selectedBook == book.identifier;

        Widget header = const SizedBox.shrink();
        if (book.identifier == 'GEN') {
          header = _buildTestamentHeader('Ancien Testament', isFirst: true);
        } else if (book.identifier == 'MAT') {
          header = _buildTestamentHeader('Nouveau Testament', isFirst: false);
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header,
            ListTile(
              onTap: () => setState(() {
                _selectedBook = book.identifier;
                _showingChapters = true;
              }),
              leading: Icon(
                Icons.book_rounded,
                color: isSelected ? context.colors.accent : context.colors.iconSecondary,
                size: 20,
              ),
              title: Text(
                book.name,
                style: TextStyle(
                  color: isSelected ? context.colors.accent : context.colors.textSecondary,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: Icon(Icons.chevron_right_rounded,
                  color: context.colors.iconSecondary),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTestamentHeader(String title, {required bool isFirst}) {
    return Padding(
      padding: EdgeInsets.only(
        top: isFirst ? 0 : AppSpacing.xl,
        bottom: AppSpacing.sm,
        left: AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              gradient: context.colors.brandGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Text(
            title.toUpperCase(),
            style: AppTypography.editorialSection.copyWith(
              color: context.colors.accent,
              fontSize: 13,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterGrid() {
    final book = ref.read(bibleRepositoryProvider).getBookByIdentifier(_selectedBook ?? '');
    final chapterCount = book?.chapterCount ?? 1;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: chapterCount,
      itemBuilder: (context, index) {
        final chapter = index + 1;
        return GestureDetector(
          onTap: () {
            setState(() => _selectedChapter = chapter);
            widget.onSelect(_selectedBook!, chapter);
            Navigator.pop(context);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _selectedChapter == chapter
                  ? context.colors.accent.withOpacity(0.2)
                  : context.colors.surfacePrimary,
              border: Border.all(
                color: _selectedChapter == chapter
                    ? context.colors.accent
                    : context.colors.borderSubtle,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              chapter.toString(),
              style: AppTypography.editorialDisplay.copyWith(
                color: _selectedChapter == chapter
                    ? context.colors.accent
                    : context.colors.textPrimary,
                fontSize: 18,
              ),
            ),
          ),
        );
      },
    );
  }
}

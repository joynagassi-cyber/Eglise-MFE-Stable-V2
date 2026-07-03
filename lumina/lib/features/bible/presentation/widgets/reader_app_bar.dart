import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:lumina/features/bible/core/repositories/bible_repository_impl.dart';
import 'package:lumina/features/bible/reader/providers/bible_notifier.dart';
// import '../../../../core/theme/lumina_colors_extension.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class ReaderAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String bookName;
  final int chapter;
  final int totalChapters;
  final VoidCallback onBookTap;
  final VoidCallback onToggleSearch;

  const ReaderAppBar({
    super.key,
    required this.bookName,
    required this.chapter,
    required this.totalChapters,
    required this.onBookTap,
    required this.onToggleSearch,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bibleNotifierProvider);

    return AppBar(
      backgroundColor: context.colors.surfacePrimary,
      elevation: 0,
      scrolledUnderElevation: 1,
      title: InkWell(
        onTap: onBookTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  '$bookName $chapter',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.arrow_drop_down, size: 20),
            ],
          ),
        ),
      ),
      actions: [
        // Bouton recherche
        IconButton(
          icon: Icon(
            state.isSearching ? Icons.search_off : Icons.search,
            color: state.isSearching ? context.colors.accent : null,
          ),
          tooltip: 'Rechercher',
          onPressed: onToggleSearch,
        ),
        // Menu contextuel
        _OverflowMenu(chapter: chapter, totalChapters: totalChapters),
      ],
    );
  }
}

class _OverflowMenu extends ConsumerWidget {
  final int chapter;
  final int totalChapters;

  const _OverflowMenu({required this.chapter, required this.totalChapters});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert),
      tooltip: 'Plus d\'options',
      onSelected: (value) async {
        final notifier = ref.read(bibleNotifierProvider.notifier);
        switch (value) {
          case 'translations':
            _showTranslationPicker(context, ref);
            break;
          case 'sync':
            await notifier.importLocalBibles();
            break;
        }
      },
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: 'translations',
          child: ListTile(
            leading: Icon(Icons.translate),
            title: Text('Changer de version'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: 'sync',
          child: ListTile(
            leading: Icon(Icons.download),
            title: Text('Importer les Bibles'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  void _showTranslationPicker(BuildContext context, WidgetRef ref) {
    final state = ref.read(bibleNotifierProvider);
    final notifier = ref.read(bibleNotifierProvider.notifier);
    final translations =
        ref.read(bibleRepositoryProvider).getAvailableTranslations();

    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Version de la Bible',
                style: Theme.of(context).textTheme.titleMedium),
          ),
          Divider(height: 1),
          ...translations.map((t) => ListTile(
                title: Text(t.name),
                subtitle: Text(t.shortName),
                trailing: state.currentTranslation == t.id
                    ? Icon(Icons.check, color: context.colors.successText)
                    : null,
                onTap: () {
                  Navigator.of(context).pop();
                  notifier.changeTranslation(t.id);
                },
              )),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

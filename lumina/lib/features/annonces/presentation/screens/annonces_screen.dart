import "package:lumina/core/widgets/widgets.dart";
// lib/features/annonces/presentation/screens/annonces_screen.dart
// Écran des annonces - Fire Theme

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/utils/haptic_helper.dart';



import 'package:lumina/features/annonces/domain/entities/annonce.dart';
import 'package:lumina/features/annonces/domain/entities/annonce_type.dart';
import 'package:lumina/features/annonces/presentation/providers/annonce_providers.dart';
import 'package:lumina/features/annonces/presentation/widgets/add_annonce_dialog.dart';
import 'package:lumina/core/services/offline_sync_manager.dart';

class AnnoncesScreen extends ConsumerStatefulWidget {
  const AnnoncesScreen({super.key});

  @override
  ConsumerState<AnnoncesScreen> createState() => _AnnoncesScreenState();
}

class _AnnoncesScreenState extends ConsumerState<AnnoncesScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  AnnonceType? _selectedType;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final annoncesAsync = _selectedType != null
        ? ref.watch(annoncesProvider)
        : _searchQuery.isNotEmpty
            ? ref.watch(annonceSearchProvider(_searchQuery))
            : ref.watch(annoncesProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = context.colors.textPrimary;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, textColor),
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenPadding.copyWith(bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchField(context, isDark),
                  const SizedBox(height: AppSpacing.md),
                  _buildTypeChips(context, isDark),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
          annoncesAsync.when(
            data: (annonces) {
              if (annonces.isEmpty) {
                return SliverToBoxAdapter(
                  child: _buildEmptyState(context, isDark),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final annonce = annonces[index];
                  return AnimatedEntrance.fromBottom(
                    delay: Duration(milliseconds: 100 + (index * 50)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenHorizontalPadding,
                        vertical: AppSpacing.xs,
                      ),
                      child: _AnnonceCard(annonce: annonce),
                    ),
                  );
                }, childCount: annonces.length),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xxl),
                child: LoadingState(),
              ),
            ),
            error: (e, _) => SliverToBoxAdapter(
              child: EmptyState(
                icon: Icons.error_outline,
                title: 'Erreur de chargement',
                subtitle: e.toString(),
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
      floatingActionButton: Semantics(
        label: 'Créer une nouvelle annonce',
        button: true,
        child: Container(
          decoration: BoxDecoration(
            gradient: context.colors.brandPrimaryGradient,
            borderRadius: AppSpacing.borderRadiusLg,
            boxShadow: AppSpacing.shadowPrimary(context.colors.brandPrimary),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                await HapticHelper.light();
                if (context.mounted) {
                  _showAddAnnonceDialog(context);
                }
              },
              borderRadius: AppSpacing.borderRadiusLg,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.mlg,
                  vertical: AppSpacing.smd + 2,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded,
                      color: context.colors.textOnBrand,
                      size: AppSpacing.iconMd,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Annonce',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: context.colors.textOnBrand,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Color textColor) {
    final theme = Theme.of(context);
    return SliverAppBar(
      expandedHeight: 100.0,
      floating: false,
      pinned: true,
      backgroundColor: context.colors.bgCard,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(
          left: AppSpacing.mlg,
          bottom: AppSpacing.md,
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs + 2),
              decoration: BoxDecoration(
                gradient: context.colors.brandPrimaryGradient,
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: Icon(Icons.campaign_rounded,
                color: context.colors.textOnBrand,
                size: AppSpacing.iconXs,
              ),
            ),
            const SizedBox(width: AppSpacing.sm + 2),
            Text(
              'Annonces',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    return TextField(
      controller: _searchController,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: context.colors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: 'Rechercher une annonce...',
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: context.colors.textTertiary,
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: context.colors.textSecondary,
        ),
        filled: true,
        fillColor: context.colors.bgCard,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide(
            color: context.colors.borderSubtle,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusMd,
          borderSide: BorderSide(color: context.colors.brandPrimary, width: 2),
        ),
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
          if (value.isNotEmpty && _selectedType != null) {
            _selectedType = null;
          }
        });
      },
    );
  }

  Widget _buildTypeChips(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTypeChip(context, null, 'Toutes', isDark),
          const SizedBox(width: 8),
          ...AnnonceType.allTypes.map(
            (type) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildTypeChip(context, type, type.label, isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(
    BuildContext context,
    AnnonceType? type,
    String label,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    final isSelected = _selectedType == type;
    return Semantics(
      label: 'Filtrer par $label',
      button: true,
      selected: isSelected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await HapticHelper.selection();
            setState(() {
              _selectedType = isSelected ? null : type;
              _searchQuery = '';
              _searchController.clear();
            });
          },
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: AppSpacing.animationFast,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? context.colors.brandPrimary : context.colors.bgCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    isSelected ? context.colors.brandPrimary : context.colors.borderSubtle,
              ),
            ),
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : context.colors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final isSearching = _searchQuery.isNotEmpty || _selectedType != null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
        child: AnimatedEntrance.fade(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: context.colors.brandPrimary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSearching
                      ? Icons.search_off_rounded
                      : Icons.campaign_outlined,
                  size: AppSpacing.iconFeature,
                  color: context.colors.brandPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                isSearching ? 'Aucun résultat trouvé' : 'Aucune annonce',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Text(
                  isSearching
                      ? 'Nous n\'avons rien trouvé pour "$_searchQuery". Essayez d\'autres mots-clés ou filtres.'
                      : 'Il n\'y a pas d\'annonces pour le moment. Revenez plus tard ou créez-en une.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
              if (isSearching) ...[
                const SizedBox(height: AppSpacing.lg),
                TextButton.icon(
                  onPressed: () {
                    HapticHelper.light();
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                      _selectedType = null;
                    });
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('RÉINITIALISER LES FILTRES'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showAddAnnonceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddAnnonceDialog(),
    );
  }
}

class _AnnonceCard extends ConsumerWidget {
  final Annonce annonce;

  const _AnnonceCard({required this.annonce});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final type = AnnonceType.fromString(annonce.type);

    // Watch for sync pending status
    final isPending =
        ref.watch(isRecordPendingProvider(annonce.id)).value ?? false;

    return Semantics(
      label:
          '${annonce.title}, ${type.label}, ${annonce.date.day}/${annonce.date.month}/${annonce.date.year}',
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticHelper.light();
            context.push(AppRoutes.annonceDetailsWithId(annonce.id));
          },
          borderRadius: AppSpacing.borderRadiusCard,
          child: Container(
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: context.colors.bgCard,
              borderRadius: AppSpacing.borderRadiusCard,
              border: Border.all(
                color: isPending
                    ? context.colors.warningText.withValues(alpha: 0.5)
                    : context.colors.borderSubtle,
                width: isPending ? 1.5 : 1,
              ),
              boxShadow: AppSpacing.shadowSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.smd),
                          decoration: BoxDecoration(
                            color: context.colors.brandPrimary.withValues(alpha: 0.1),
                            borderRadius: AppSpacing.borderRadiusMd,
                          ),
                          child: Text(
                            type.icon,
                            style: const TextStyle(fontSize: AppSpacing.lg),
                          ),
                        ),
                        if (isPending)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(color: context.colors.warningText,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.sync,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  annonce.title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: context.colors.textPrimary,
                                  ),
                                ),
                              ),
                              if (isPending)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Synchro...',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: context.colors.warningText,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              if (annonce.isPinned)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.sm,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: context.colors.brandSecondary.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: AppSpacing.borderRadiusSm,
                                    ),
                                    child: Text(
                                      'Épinglé',
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: context.colors.brandSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            type.label,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (annonce.summary != null && annonce.summary!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.smd),
                  Text(
                    annonce.summary!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: AppSpacing.smd),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: AppSpacing.iconXs,
                      color: context.colors.textTertiary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${annonce.date.day}/${annonce.date.month}/${annonce.date.year}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: context.colors.textTertiary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Icon(
                      Icons.visibility_outlined,
                      size: AppSpacing.iconXs,
                      color: context.colors.textTertiary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${annonce.viewsCount}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: context.colors.textTertiary,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: AppSpacing.iconMd,
                      color: context.colors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

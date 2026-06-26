import 'package:lumina/core/widgets/shimmer_loading.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/auth_provider.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/utils/haptic_helper.dart';
import '../../../../core/widgets/animated_entrance.dart';
import '../providers/category_providers.dart';
import '../../domain/entities/transaction_category.dart';
import '../../domain/entities/enums/category_type.dart';
import '../widgets/category_tree_widget.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';

/// Écran de liste des catégories de transactions
///
/// Affiche la hiérarchie complète des catégories (parent/enfant)
/// avec tabs pour séparer Revenus et Dépenses
class CategoryListScreen extends ConsumerStatefulWidget {
  const CategoryListScreen({super.key});

  @override
  ConsumerState<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends ConsumerState<CategoryListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: Semantics(
          label: 'Retour',
          button: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await HapticHelper.light();
              if (context.mounted) {
                context.pop();
              }
            },
          ),
        ),
        title: const Text('Catégories de Transactions'),
        actions: [
          // Bouton synchronisation
          Semantics(
            label: 'Synchroniser les catégories',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.sync, size: AppSpacing.iconMd),
              onPressed: () async {
                await HapticHelper.medium();
                final actions = ref.read(categoryActionsProvider);
                try {
                  await actions.syncCategories();
                  await HapticHelper.success();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Synchronisation réussie'),
                        backgroundColor: context.colors.successText,
                      ),
                    );
                  }
                } catch (e) {
                  await HapticHelper.error();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erreur synchronisation: $e'),
                        backgroundColor: context.colors.errorText,
                      ),
                    );
                  }
                }
              },
            ),
          ),
          // Bouton menu
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'seed') {
                _showSeedConfirmation();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'seed',
                child: Row(
                  children: [
                    Icon(Icons.start),
                    SizedBox(width: 8),
                    Text('Initialiser catégories par défaut'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Revenus', icon: Icon(Icons.arrow_upward)),
            Tab(text: 'Dépenses', icon: Icon(Icons.arrow_downward)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCategoryTab(CategoryType.income),
          _buildCategoryTab(CategoryType.expense),
        ],
      ),
      floatingActionButton: Semantics(
        label: 'Créer une nouvelle catégorie',
        button: true,
        child: FloatingActionButton.extended(
          onPressed: () async {
            await HapticHelper.light();
            if (context.mounted) {
              unawaited(context.push(
                AppRoutes.ministereRubriquesNew,
                extra: _tabController.index == 0
                    ? CategoryType.income
                    : CategoryType.expense,
              ));
            }
          },
          icon: const Icon(Icons.add, size: AppSpacing.iconMd),
          label: const Text('Nouvelle catégorie'),
        ),
      ),
    );
  }

  Widget _buildCategoryTab(CategoryType type) {
    final categoriesAsync = ref.watch(rootCategoriesProvider(type));

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return AnimatedEntrance.fade(
            delay: const Duration(milliseconds: 200),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    type == CategoryType.income
                        ? Icons.trending_up
                        : Icons.trending_down,
                    size: AppSpacing.iconHero,
                    color: context.colors.textTertiary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Aucune catégorie',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Ajoutez votre première catégorie ou\ninitialisez les catégories par défaut',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.colors.textTertiary),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return AnimatedEntrance.fromBottom(
              delay: Duration(milliseconds: 100 + (index * 50)),
              child: CategoryTreeWidget(
                category: category,
                onTap: () => _navigateToForm(category),
                onDelete: () => _deleteCategory(category),
              ),
            );
          },
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: ShimmerCardList(
          itemCount: 10,
          itemHeight: 60,
        ),
      ),
      error: (error, stack) => Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: context.colors.errorText),
            const SizedBox(height: 16),
            const Text('Impossible de charger les catégories'),
          ],
        ),
      ),
    );
  }

  void _navigateToForm(TransactionCategory category) {
    context.push(
      AppRoutes.ministereRubriquesEdit,
      extra: category,
    );
  }

  void _deleteCategory(TransactionCategory category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer "${category.name}" ?\n\n'
          'Les sous-catégories seront également affectées.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: context.colors.errorText),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final actions = ref.read(categoryActionsProvider);
        await actions.deleteCategory(category.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Catégorie supprimée'),
              backgroundColor: context.colors.successText,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur suppression: $e'),
              backgroundColor: context.colors.errorText,
            ),
          );
        }
      }
    }
  }

  void _showSeedConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Initialiser les catégories'),
        content: const Text(
          'Cela va créer 60+ catégories prédéfinies \n'
          '(Dîmes, Offrandes, Salaires, etc.).\n\n'
          'Cette action ne supprime pas les catégories existantes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Initialiser'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final actions = ref.read(categoryActionsProvider);
        final churchId = ref.read(activeChurchIdProvider);
        await actions.seedDefaultCategories(churchId);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Catégories initialisées avec succès'),
              backgroundColor: context.colors.successText,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Une erreur est survenue'),
              backgroundColor: context.colors.errorText,
            ),
          );
        }
      }
    }
  }
}

import 'package:lumina/core/widgets/shimmer_loading.dart';
import 'package:lumina/core/extensions/context_extension.dart';
// lib/features/sacraments/presentation/screens/sacrament_list_screen.dart
// Liste Sacrements - Deep Purple Theme (Alternative View)

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/animated_entrance.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/features/sacraments/presentation/providers/sacrament_providers.dart';
import 'package:lumina/features/sacraments/domain/entities/sacrament.dart';

class SacramentListScreen extends ConsumerStatefulWidget {
  const SacramentListScreen({super.key});

  @override
  ConsumerState<SacramentListScreen> createState() =>
      _SacramentListScreenState();
}

class _SacramentListScreenState extends ConsumerState<SacramentListScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Select provider based on query
    final sacramentsAsync = _searchQuery.isEmpty
        ? ref.watch(sacramentsProvider)
        : ref.watch(sacramentSearchProvider(_searchQuery));

    final theme = Theme.of(context);
    final textColor = context.colors.textPrimary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tous les Sacrements',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher (nom, type, célébrant...)',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: theme.cardColor.withValues(alpha: 0.8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),

          // List or Loading/Error
          Expanded(
            child: sacramentsAsync.when(
              data: (sacraments) {
                if (sacraments.isEmpty) {
                  return _buildEmptyState(context);
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    0,
                    AppSpacing.md,
                    AppSpacing.md,
                  ),
                  itemCount: sacraments.length,
                  separatorBuilder: (_, __) =>
                      SizedBox(height: AppSpacing.smd),
                  itemBuilder: (context, index) => AnimatedEntrance.fromBottom(
                    delay: Duration(milliseconds: 100 + (index * 50)),
                    child: _SacramentListTile(sacrament: sacraments[index]),
                  ),
                );
              },
              loading: () => Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: ShimmerCardList(
                  itemCount: 8,
                  itemHeight: 70,
                ),
              ),
              error: (err, stack) => Center(child: Text('Impossible de charger les sacrements')),
            ),
          ),
        ],
      ),
      floatingActionButton: Semantics(
        label: 'Ajouter un nouveau sacrement',
        button: true,
        child: Container(
          decoration: BoxDecoration(
            gradient: context.colors.brandPrimaryGradient,
            borderRadius: AppSpacing.borderRadiusLg,
            boxShadow: AppSpacing.shadowPrimary(context.colors.brandPrimary),
          ),
          child: FloatingActionButton.extended(
            onPressed: () async {
              await HapticHelper.light();
              if (context.mounted) {
                unawaited(context.push(AppRoutes.sacramentsNouveau));
              }
            },
            label: Text(
              'Nouveau',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            icon: Icon(Icons.add_rounded),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_edu,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? 'Aucun sacrement enregistré'
                : 'Aucun résultat trouvé',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

class _SacramentListTile extends StatelessWidget {
  final Sacrament sacrament;
  const _SacramentListTile({required this.sacrament});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = DateFormat('dd/MM/yyyy').format(sacrament.date);

    return Semantics(
      label: '${sacrament.type.label} de ${sacrament.displayName}, le $dateStr',
      button: true,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.bgCard,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: context.colors.borderSubtle,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          leading: Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: context.colors.brandPrimary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              sacrament.type.icon,
              style: const TextStyle(fontSize: AppSpacing.iconMd),
            ),
          ),
          title: Text(
            sacrament.displayName,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'Le $dateStr à ${sacrament.location ?? "Lieu inconnu"}',
            style: theme.textTheme.bodySmall,
          ),
          trailing: Icon(Icons.chevron_right_rounded,
            color: context.colors.brandPrimary,
          ),
          onTap: () async {
            await HapticHelper.light();
            if (context.mounted) {
              unawaited(context.push(AppRoutes.sacramentDetailsWithId(sacrament.id)));
            }
          },
        ),
      ),
    );
  }
}

import "package:lumina/core/widgets/widgets.dart";
// lib/features/bergers/presentation/screens/team_list_screen.dart
import 'dart:async';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/core/theme/app_spacing.dart';



import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/features/bergers/presentation/providers/team_provider.dart';
import 'package:lumina/features/bergers/presentation/widgets/team_card.dart';

class TeamListScreen extends ConsumerWidget {
  const TeamListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamAsync = ref.watch(teamListProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                left: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              title: Semantics(
                label: 'Équipe Pastorale',
                header: true,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Équipe Pastorale',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      '',
                      style: TextStyle(fontSize: AppSpacing.iconLg),
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [context.colors.brandSecondary, Colors.black]
                        : [
                            context.colors.brandSecondary,
                            context.colors.brandSecondary.withValues(alpha: 0.8),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            actions: [
              Semantics(
                label: 'Rechercher',
                button: true,
                child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: AppSpacing.iconMd,
                  ),
                  onPressed: () async {
                    await HapticHelper.light();
                    // TODO: Implement search
                  },
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.md),
            sliver: teamAsync.when(
              data: (leaders) {
                if (leaders.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: AppSpacing.xxl),
                      child: AnimatedEntrance.fromBottom(
                        child: EmptyState(
                          icon: Icons.group_add_rounded,
                          title: 'Aucun leader défini',
                          subtitle: 'Ajoutez des membres à l\'équipe pastorale',
                        ),
                      ),
                    ),
                  );
                }
                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return AnimatedEntrance.fromBottom(
                      delay: Duration(milliseconds: 100 + (index * 50)),
                      child: TeamCard(member: leaders[index]),
                    );
                  }, childCount: leaders.length),
                );
              },
              loading: () => SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: AppSpacing.xxl),
                  child: LoadingState(),
                ),
              ),
              error: (err, _) => SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Text(
                      'Impossible de charger les équipes',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: context.colors.errorText,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedEntrance.fromBottom(
        delay: const Duration(milliseconds: 600),
        child: Semantics(
          label: 'Nouveau membre',
          button: true,
          child: FloatingActionButton.extended(
            onPressed: () async {
              await HapticHelper.medium();
              if (context.mounted) {
                unawaited(context.push(AppRoutes.brebisNouveau));
              }
            },
            icon: Icon(Icons.person_add, size: AppSpacing.iconMd),
            label: Text('Nouveau'),
            backgroundColor: context.colors.brandSecondary,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

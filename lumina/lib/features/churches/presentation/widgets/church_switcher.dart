import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/features/churches/domain/entities/church.dart';
import 'package:lumina/features/churches/presentation/providers/church_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/core/widgets/shimmer_loading.dart';

/// Widget pour changer d'église active
///
/// Affiche un dropdown avec les églises accessibles
/// et permet de switcher entre elles
class ChurchSwitcher extends ConsumerWidget {
  const ChurchSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userChurchesAsync = ref.watch(userChurchesProvider);
    final activeChurchAsync = ref.watch(activeChurchProvider);

    return userChurchesAsync.when(
      data: (churches) {
        if (churches.isEmpty) {
          return const SizedBox.shrink();
        }

        return activeChurchAsync.when(
          data: (activeChurch) {
            return Semantics(
              label: 'Changer d\'église',
              button: true,
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.church, size: AppSpacing.iconMd),
                tooltip: 'Changer d\'église',
                onSelected: (churchId) async {
                  await HapticHelper.selection();
                  await ref
                      .read(churchSwitcherProvider.notifier)
                      .switchToChurch(churchId);
                },
                itemBuilder: (context) {
                  return churches.map((church) {
                    final isActive = church.id == activeChurch?.id;
                    return PopupMenuItem<String>(
                      value: church.id,
                      child: Row(
                        children: [
                          Icon(
                            _getChurchIcon(church.type),
                            size: AppSpacing.iconMd,
                            color: isActive
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                          const SizedBox(width: AppSpacing.smd),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  church.name,
                                  style: TextStyle(
                                    fontWeight: isActive
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isActive
                                        ? Theme.of(context).colorScheme.primary
                                        : null,
                                  ),
                                ),
                                Text(
                                  _getChurchTypeLabel(church.type),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          if (isActive)
                            Icon(
                              Icons.check_circle,
                              size: AppSpacing.iconMd,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                        ],
                      ),
                    );
                  }).toList();
                },
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getChurchIcon(activeChurch?.type ?? ChurchType.main),
                      size: AppSpacing.iconMd,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          activeChurch?.name ?? 'Aucune église',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        if (activeChurch != null)
                          Text(
                            _getChurchTypeLabel(activeChurch.type),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                          ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(Icons.arrow_drop_down, size: AppSpacing.iconMd),
                  ],
                ),
              ),
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(8.0),
            child: ShimmerCircle(size: 24),
          ),
          error: (_, __) => const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(8.0),
        child: ShimmerCircle(size: 24),
      ),
      error: (_, __) => const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
    );
  }

  IconData _getChurchIcon(ChurchType type) {
    return switch (type) {
      ChurchType.main => Icons.church,
      ChurchType.branch => Icons.church_outlined,
      ChurchType.affiliate => Icons.account_balance,
    };
  }

  String _getChurchTypeLabel(ChurchType type) {
    return switch (type) {
      ChurchType.main => 'Église Principale',
      ChurchType.branch => 'Annexe',
      ChurchType.affiliate => 'Filiale',
    };
  }
}

/// Version compacte du ChurchSwitcher pour les espaces restreints
class ChurchSwitcherCompact extends ConsumerWidget {
  const ChurchSwitcherCompact({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeChurchAsync = ref.watch(activeChurchProvider);

    return activeChurchAsync.when(
      data: (activeChurch) {
        if (activeChurch == null) {
          return const SizedBox.shrink();
        }

        return Semantics(
          label: 'Changer d\'église',
          button: true,
          child: InkWell(
            onTap: () async {
              await HapticHelper.light();
              if (context.mounted) {
                await context.push(AppRoutes.churches);
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.church,
                    size: AppSpacing.iconSm,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      activeChurch.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: AppSpacing.iconSm,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(8.0),
        child: ShimmerBox(width: 80, height: 16),
      ),
      error: (_, __) => const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 16),
    );
  }
}
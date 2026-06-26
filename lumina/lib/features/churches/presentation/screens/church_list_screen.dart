import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/features/churches/domain/entities/church.dart';
import 'package:lumina/features/churches/presentation/providers/church_providers.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/utils/haptic_helper.dart';

class ChurchListScreen extends ConsumerWidget {
  const ChurchListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final churchesAsync = ref.watch(userChurchesProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Églises'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigation pour ajouter/rejoindre une église
            },
          ),
        ],
      ),
      body: churchesAsync.when(
        data: (churches) {
          if (churches.isEmpty) {
            return const Center(child: Text('Aucune église trouvée'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: churches.length,
            itemBuilder: (context, index) {
              final church = churches[index];
              return _ChurchCard(church: church, isDark: isDark);
            },
          );
        },
        loading: () => const ShimmerCardList(
          itemCount: 3,
          itemHeight: 80,
        ),
        error: (err, _) => const Center(child: Text('Impossible de charger les églises')),
      ),
    );
  }
}

class _ChurchCard extends ConsumerWidget {
  final Church church;
  final bool isDark;

  const _ChurchCard({required this.church, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeChurchAsync = ref.watch(activeChurchProvider);
    final isActive = activeChurchAsync.value?.id == church.id;

    return Semantics(
      label:
          'Église : ${church.name}. Type : ${_getChurchTypeLabel(church.type)}.'
          '${isActive ? ' Actuellement sélectionnée.' : ''}',
      selected: isActive,
      child: Card(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        child: InkWell(
          onTap: () async {
            await HapticHelper.medium();
            await ref
                .read(churchSwitcherProvider.notifier)
                .switchToChurch(church.id);
          },
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: (isActive ? context.colors.brandPrimary : Colors.grey)
                      .withOpacity(0.1),
                  child: Icon(
                    _getChurchIcon(church.type),
                    color: isActive ? context.colors.brandPrimary : Colors.grey,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            church.name,
                            style:
                                Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: isActive
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Icon(
                            church.isSynced ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
                            size: 14,
                            color: church.isSynced 
                                ? context.colors.successText.withOpacity(0.5)
                                : context.colors.errorText,
                          ),
                        ],
                      ),
                      Text(
                        _getChurchTypeLabel(church.type),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (isActive)
                  Icon(Icons.check_circle, color: context.colors.brandPrimary),
              ],
            ),
          ),
        ),
      ),
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

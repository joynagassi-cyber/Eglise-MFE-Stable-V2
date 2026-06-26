import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/features/bergers/presentation/providers/shepherd_providers.dart';
// import 'package:lumina/features/bergers/domain/entities/shepherd.dart';
import 'package:go_router/go_router.dart';

class ShepherdDetailScreen extends ConsumerWidget {
  final String shepherdId;

  const ShepherdDetailScreen({super.key, required this.shepherdId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shepherdAsync = ref.watch(currentShepherdProvider(shepherdId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du Berger'),
        actions: [
          shepherdAsync.when(
            data: (shepherd) => shepherd != null
                ? IconButton(
                    icon: Icon(Icons.edit_rounded),
                    onPressed: () => context.push('/bergers/$shepherdId/modifier', extra: shepherd),
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: shepherdAsync.when(
        data: (shepherd) {
          if (shepherd == null) {
            return Center(child: Text('Berger non trouvé'));
          }
          return SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: shepherd.photoUrl != null
                        ? NetworkImage(shepherd.photoUrl!)
                        : null,
                    child: shepherd.photoUrl == null
                        ? Icon(Icons.person, size: 50)
                        : null,
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
                Center(
                  child: Text(
                    '${shepherd.firstName} ${shepherd.lastName}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.colors.brandPrimary.withValues(alpha: 0.1),
                      borderRadius: AppSpacing.borderRadiusSm,
                    ),
                    child: Text(
                      shepherd.level,
                      style: TextStyle(
                        color: context.colors.brandPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.xl),
                _buildSection(context, 'Biographie', shepherd.bio ?? 'Aucune biographie disponible'),
                SizedBox(height: AppSpacing.lg),
                _buildSection(context, 'Spécialités', shepherd.specialties.join(', ')),
              ],
            ),
          );
        },
        loading: () => Center(child: LoadingState()),
        error: (e, st) => Center(child: Text('Erreur: $e')),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          content.isEmpty ? 'Non renseigné' : content,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

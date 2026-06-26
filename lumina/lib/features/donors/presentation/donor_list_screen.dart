// import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/theme/app_breakpoints.dart';
import 'package:lumina/core/widgets/widgets.dart';
// import 'package:lumina/core/theme/app_typography.dart';
import 'providers/donor_providers.dart';
import '../data/models/donor_models.dart';
import '../domain/donor_analytics_service.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class DonorListScreen extends ConsumerWidget {
  const DonorListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final donorsAsync = ref.watch(donorsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Donateurs'),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _DonorSearchDelegate(ref),
              );
            },
          ),
        ],
      ),
      body: donorsAsync.when(
        data: (donors) {
          if (donors.isEmpty) {
            return const EmptyState(
              icon: Icons.people_outline,
              title: 'Aucun donateur trouvé',
              subtitle: 'Commencez par ajouter un nouveau donateur',
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: AppBreakpoints.horizontalPadding(context),
              vertical: AppSpacing.md,
            ),
            itemCount: donors.length,
            itemBuilder: (context, index) {
              final donor = donors[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: AnimatedEntrance(
                  delay: Duration(milliseconds: index * 50),
                  child: _DonorCard(donor: donor),
                ),
              );
            },
          );
        },
        loading: () => const LoadingState(skeleton: FireSkeletonMemberList()),
        error: (e, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Erreur',
          subtitle: e.toString(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.donorsNew),
        backgroundColor: context.colors.brandPrimary,
        foregroundColor: context.colors.textOnBrand,
        child: Icon(Icons.person_add_rounded),
      ),
    );
  }
}

class _DonorCard extends StatelessWidget {
  final Donor donor;

  const _DonorCard({required this.donor});

  @override
  Widget build(BuildContext context) {

//     final isDark = theme.brightness == Brightness.dark;
    final color =
        donor.type == 'organization' ? context.colors.infoText : context.colors.successText;

    return GlassCard(
      onTap: () => context.push(AppRoutes.donorDetailWithId(donor.id)),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          _buildAvatar(color),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  donor.displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  donor.email ?? donor.phone ?? 'Aucun contact',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.colors.textSecondary,
                  ),
                ),
                SizedBox(height: 8),
                _buildSegmentBadge(context, donor),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${donor.totalDonated?.toInt() ?? 0} F',
                style: TextStyle(fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: context.colors.brandPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                '${donor.donationCount ?? 0} dons',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(Color color) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Center(
        child: Icon(
          donor.type == 'organization'
              ? Icons.business_rounded
              : Icons.person_rounded,
          color: color,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildSegmentBadge(BuildContext context, Donor donor) {
    final segment = DonorAnalyticsService.getDonorSegment(donor);
    Color color = context.colors.textTertiary;

    if (segment.contains('VIP')) {
      color = context.colors.warningText;
    } else if (segment.contains('Fidèle')) {
      color = context.colors.brandPrimary;
    } else if (segment.contains('Régulier')) {
      color = context.colors.successText;
    } else if (segment.contains('Ponctuel')) {
      color = context.colors.infoText;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        segment.toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
          color: color,
        ),
      ),
    );
  }
}

class _DonorSearchDelegate extends SearchDelegate<String> {
  final WidgetRef _ref;

  _DonorSearchDelegate(this._ref)
      : super(
          searchFieldLabel: 'Rechercher un donateur...',
          searchFieldStyle: const TextStyle(fontSize: 16),
        );

  @override
  List<Widget>? buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(
            icon: Icon(Icons.clear_rounded),
            onPressed: () => query = '',
          ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back_rounded),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults(context);

  Widget _buildSearchResults(BuildContext context) {
    final donorsAsync = _ref.watch(donorsProvider);

    return donorsAsync.when(
      data: (donors) {
        final filtered = donors.where((d) {
          final q = query.toLowerCase();
          return d.displayName.toLowerCase().contains(q) ||
              (d.email?.toLowerCase().contains(q) ?? false) ||
              (d.phone?.toLowerCase().contains(q) ?? false);
        }).toList();

        if (filtered.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 48,
                  color: context.colors.borderSubtle,
                ),
                SizedBox(height: 16),
                Text(
                  query.isEmpty
                      ? 'Tapez pour rechercher...'
                      : 'Aucun résultat pour "$query"',
                  style: TextStyle(color: context.colors.textTertiary),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final donor = filtered[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    context.colors.brandPrimary.withValues(alpha: 0.1),
                child: Icon(
                  donor.type == 'organization'
                      ? Icons.business_rounded
                      : Icons.person_rounded,
                  color: context.colors.brandPrimary,
                  size: 20,
                ),
              ),
              title: Text(
                donor.displayName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(donor.email ?? donor.phone ?? ''),
              trailing: Text(
                '${donor.totalDonated?.toInt() ?? 0} F',
                style: TextStyle(fontWeight: FontWeight.bold,
                  color: context.colors.brandPrimary,
                ),
              ),
              onTap: () {
                close(context, donor.id);
                context.push(AppRoutes.donorDetailWithId(donor.id));
              },
            );
          },
        );
      },
      loading: () => const FireSkeletonMemberList(),
      error: (e, _) => Center(child: Text('Impossible de charger les donateurs')),
    );
  }
}
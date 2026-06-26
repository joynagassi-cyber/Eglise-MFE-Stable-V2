// import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'providers/donor_providers.dart';
import '../data/models/donor_models.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/theme/app_spacing.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class DonorDetailScreen extends ConsumerWidget {
  final String donorId;
  const DonorDetailScreen({required this.donorId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final donorAsync = ref.watch(donorProvider(donorId));
    final donationsAsync = ref.watch(donorDonationsProvider(donorId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Détail Donateur'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => context.push(AppRoutes.donorEditWithId(donorId)),
          ),
        ],
      ),
      body: donorAsync.when(
        data: (donor) {
          if (donor == null) {
            return Center(child: Text('Donateur non trouvé'));
          }
          return Column(
            children: [
              _buildHeader(context, donor),
              Divider(),
              Expanded(
                child: donationsAsync.when(
                  data: (donations) =>
                      _buildDonationHistory(context, ref, donations),
                  loading: () => const FireShimmer(
                    child: FireSkeletonDetails(),
                  ),
                  error: (e, st) => AppErrorWidget(
                    message: 'Impossible de charger l\'historique des dons',
                    technicalDetails: e.toString(),
                    onRetry: () => ref.refresh(donorDonationsProvider(donorId)),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const FireShimmer(
          child: FireSkeletonDetails(),
        ),
        error: (e, st) => AppErrorWidget(
          message: 'Impossible de charger les détails du donateur',
          technicalDetails: e.toString(),
          onRetry: () => ref.refresh(donorProvider(donorId)),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            context.push(AppRoutes.donorRecordDonationWithDonorId(donorId)),
        icon: Icon(Icons.add),
        label: Text('Enregistrer un Don'),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Donor donor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            child: Text(donor.displayName.isNotEmpty
                ? donor.displayName.characters.first.toUpperCase()
                : '?'),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  donor.displayName,
                  style: AppTypography.h4.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                Text(
                  donor.type.toUpperCase(),
                  style: TextStyle(color: context.colors.textTertiary),
                ),
                if (donor.email != null && donor.email!.isNotEmpty)
                  Text(donor.email!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationHistory(
    BuildContext context,
    WidgetRef ref,
    List<Donation> donations,
  ) {
    if (donations.isEmpty) {
      return Center(child: Text('Aucun don enregistré pour le moment.'));
    }

    final campaignsAsync = ref.watch(donationCampaignsProvider);

    return ListView.builder(
      itemCount: donations.length,
      itemBuilder: (context, index) {
        final donation = donations[index];
        final campaignName = campaignsAsync.when(
          data: (campaigns) => campaigns
              .where((c) => c.id == donation.campaignId)
              .firstOrNull
              ?.title,
          loading: () => null,
          error: (_, __) => null,
        );

        return ListTile(
          leading: Icon(Icons.monetization_on, color: context.colors.successText),
          title: Text(
            '${donation.amount.toStringAsFixed(0)} ${donation.currency}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat('dd/MM/yyyy').format(donation.donationDate)),
              if (campaignName != null)
                Text(
                  'Campagne: $campaignName',
                  style: TextStyle(fontSize: 10,
                    color: context.colors.brandPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: context.colors.brandPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
            ),
            child: Text(
              donation.donationType,
              style: TextStyle(
                fontSize: 10,
                color: context.colors.brandPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
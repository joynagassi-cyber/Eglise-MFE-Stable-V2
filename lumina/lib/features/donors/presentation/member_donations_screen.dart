// import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/providers/auth_provider.dart';
import 'package:lumina/core/providers/repository_providers_finance.dart';
import '../../profile/presentation/providers/profile_provider.dart';
import '../domain/entities/donor_entities.dart';
import 'providers/donor_providers.dart';
import 'package:lumina/core/theme/app_typography.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

/// Un provider déduit le donateur lié à l'utilisateur actuel
final currentDonorProvider = FutureProvider.autoDispose<Donor?>((ref) async {
  final session = ref.watch(currentSessionProvider);
  if (session == null) return null;

  final donors = await ref.watch(donorsProvider.future);
  final myEmail = session.email.toLowerCase();

  try {
    return donors.firstWhere(
      (d) => d.email?.toLowerCase() == myEmail,
    );
  } catch (e) {
    return null; // Aucun donateur trouvé pour cet email
  }
});

class MemberDonationsScreen extends ConsumerWidget {
  const MemberDonationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final donorAsync = ref.watch(currentDonorProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Finances & Dons'),
      ),
      body: donorAsync.when(
        data: (donor) {
          if (donor == null) {
            return _buildNoDonorView(context, ref);
          }
          return _buildDonorView(context, ref, donor);
        },
        loading: () => Center(child: LoadingState()),
        error: (e, st) => Center(child: Text('Impossible de charger le donateur')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            _handleNewDonation(context, ref, donorAsync.valueOrNull),
        icon: Icon(Icons.favorite),
        label: Text('Faire un Don'),
        backgroundColor: context.colors.brandPrimary,
        foregroundColor: context.colors.textOnBrand,
      ),
    );
  }

  Widget _buildNoDonorView(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monetization_on_outlined,
                size: 80, color: context.colors.textTertiary),
            SizedBox(height: AppSpacing.md),
            Text(
              'Aucun historique de dons',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: AppSpacing.sm),
            Text('Vous n\'avez pas encore enregistré de dîme ou d\'offrande à votre nom. Cliquez sur le bouton ci-dessous pour faire votre premier don.',
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonorView(BuildContext context, WidgetRef ref, Donor donor) {
    final donationsAsync = ref.watch(donorDonationsProvider(donor.id));

    return Column(
      children: [
        // En-tête de résumé
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: context.colors.brandPrimaryGradient,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppSpacing.radiusLg),
              bottomRight: Radius.circular(AppSpacing.radiusLg),
            ),
          ),
          child: Column(
                children: [
                  Text(
                    'Total de mes contributions',
                    style: TextStyle(
                        color: context.colors.textOnBrand.withValues(alpha: 0.7),
                        fontSize: 16),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    '${donor.totalDonated?.toStringAsFixed(0) ?? 0} XAF',
                    style: AppTypography.h3.copyWith(
                      color: context.colors.textOnBrand,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history,
                          color: context.colors.textOnBrand.withValues(alpha: 0.7),
                          size: 16),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        '${donor.donationCount ?? 0} dons effectués',
                        style: TextStyle(
                            color: context.colors.textOnBrand.withValues(alpha: 0.7)),
                      ),
                    ],
                  ),
                ],
          ),
        ),

        SizedBox(height: AppSpacing.md),

        // Liste des dons
        Expanded(
          child: donationsAsync.when(
            data: (donations) {
              if (donations.isEmpty) {
                return Center(
                    child: Text('Aucun don dans l\'historique.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: donations.length,
                itemBuilder: (context, index) {
                  final donation = donations[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: context.colors.brandPrimaryContainer,
                        child: Icon(Icons.volunteer_activism,
                            color: context.colors.brandPrimary),
                      ),
                      title: Text(
                        '${donation.amount.toStringAsFixed(0)} ${donation.currency}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        DateFormat('dd MMMM yyyy')
                            .format(donation.donationDate),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              context.colors.brandPrimary.withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        child: Text(
                          _formatDonationType(donation.donationType),
                          style: TextStyle(fontSize: 12,
                            color: context.colors.brandPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => Center(child: LoadingState()),
            error: (e, _) => Center(child: Text('Impossible de charger les dons')),
          ),
        ),
      ],
    );
  }

  String _formatDonationType(String type) {
    switch (type) {
      case 'tithe':
        return 'Dîme';
      case 'offering':
        return 'Offrande';
      case 'special_offering':
        return 'Offrande Spéciale';
      case 'thanksgiving':
        return 'Action de Grâce';
      case 'project':
        return 'Projet';
      case 'mission':
        return 'Mission';
      default:
        return type;
    }
  }

  Future<void> _handleNewDonation(
      BuildContext context, WidgetRef ref, Donor? existingDonor) async {
    String donorId;

    if (existingDonor != null) {
      donorId = existingDonor.id;
    } else {
      // Créer un profil donateur à la volée avant de rediriger
      final session = ref.read(currentSessionProvider);
      final profile = ref.read(profileStateProvider).valueOrNull;
      final churchId = ref.read(activeChurchIdProvider);

      if (session == null) return;

      final newDonor = Donor(
        id: '', // Sera généré par Supabase
        churchId: churchId,
        displayName: profile?.fullName ?? session.email,
        email: session.email,
        type: 'individual',
      );

      try {
        await ref.read(donorRepositoryProvider).saveDonor(newDonor, churchId);
        // On re-fetch pour obtenir l'ID assigné
        ref.invalidate(donorsProvider);
        final freshDonors = await ref.read(donorsProvider.future);
        final createdDonor = freshDonors.firstWhere(
            (d) => d.email?.toLowerCase() == session.email.toLowerCase());
        donorId = createdDonor.id;
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur création donateur: $e')));
        }
        return;
      }
    }

    if (context.mounted) {
      unawaited(context.push(AppRoutes.donorRecordDonationWithDonorId(donorId)));
    }
  }
}

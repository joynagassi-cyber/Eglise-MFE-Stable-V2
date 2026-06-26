import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/providers/repository_providers_finance.dart';
import '../../data/models/donor_models.dart';
import '../../../../core/providers/auth_provider.dart';

// On utilise le provider centralisé généré par Riverpod
// Imported from the split finance repository module.

final donorsProvider = FutureProvider.autoDispose<List<Donor>>((ref) async {
  final repo = ref.watch(donorRepositoryProvider);
  final churchId = ref.watch(activeChurchIdProvider);
  return repo.getDonors(churchId: churchId);
});

final donorProvider =
    FutureProvider.autoDispose.family<Donor?, String>((ref, id) async {
  final repo = ref.watch(donorRepositoryProvider);
  return repo.getDonorById(id);
});

final donorStatsProvider = FutureProvider.autoDispose<Map<String, dynamic>>((
  ref,
) async {
  final repo = ref.watch(donorRepositoryProvider);
  final churchId = ref.watch(activeChurchIdProvider);
  return repo.getDonorStats(churchId: churchId);
});

final donorDonationsProvider = FutureProvider.autoDispose
    .family<List<Donation>, String>((ref, donorId) async {
  final repo = ref.watch(donorRepositoryProvider);
  return repo.getDonationsByDonor(donorId);
});

final donationCampaignsProvider =
    FutureProvider.autoDispose<List<DonationCampaign>>((ref) async {
  final repo = ref.watch(donorRepositoryProvider);
  final churchId = ref.watch(activeChurchIdProvider);
  return repo.getDonationCampaigns(churchId: churchId);
});

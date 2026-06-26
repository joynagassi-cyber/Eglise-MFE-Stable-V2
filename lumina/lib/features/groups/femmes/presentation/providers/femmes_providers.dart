import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/training.dart';
import '../../domain/entities/mutual_aid_request.dart';
import 'package:lumina/core/providers/repository_providers_groups.dart';
import 'package:lumina/core/providers/repository_providers_profile.dart';
import 'package:lumina/features/membres/domain/entities/member.dart';

/// Provider pour la liste des formations d'un groupe spécifique.
final trainingsProvider =
    FutureProvider.family<List<Training>, String>((ref, groupId) async {
  final repository = ref.watch(femmesRepositoryProvider);
  final result = await repository.getTrainings(groupId);
  return result.fold(
    (l) => throw l,
    (r) => r,
  );
});

/// Provider pour la liste des demandes d'entraide d'un groupe spécifique.
final mutualAidRequestsProvider =
    FutureProvider.family<List<MutualAidRequest>, String>((ref, groupId) async {
  final repository = ref.watch(femmesRepositoryProvider);
  final result = await repository.getMutualAidRequests(groupId);
  return result.fold(
    (l) => throw l,
    (r) => r,
  );
});

/// Provider pour les membres du groupe (pour les anniversaires).
final femmesGroupMembersProvider =
    FutureProvider.family<List<Member>, String>((ref, groupId) async {
  // Ici on utilise le repository des membres pour récupérer les membres du groupe
  final memberRepo = ref.watch(memberRepositoryProvider);
  final result = await memberRepo.getMembersByGroup(groupId);
  return result.fold(
    (l) => throw l,
    (r) => r,
  );
});

/// Provider pour les KPIs du Dashboard Femmes.
final femmesDashboardProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, groupId) async {
  final trainings = await ref.watch(trainingsProvider(groupId).future);
  final requests = await ref.watch(mutualAidRequestsProvider(groupId).future);
  final members = await ref.watch(femmesGroupMembersProvider(groupId).future);

  // Statistiques Entraide
  final activeRequests = requests.where((r) => r.status == 'active').length;
  final closedRequests = requests
      .where((r) => r.status == 'closed' || r.status == 'fulfilled')
      .length;
  final responsesThisMonth =
      requests.fold<int>(0, (sum, r) => sum + r.responsesCount);

  // Anniversaires du mois
  final now = DateTime.now();
  final birthdaysThisMonth = members.where((m) {
    if (m.birthDate == null) return false;
    return m.birthDate!.month == now.month;
  }).toList();

  return {
    'active_requests': activeRequests,
    'closed_requests': closedRequests,
    'responses_this_month': responsesThisMonth,
    'birthdays_count': birthdaysThisMonth.length,
    'upcoming_birthdays': birthdaysThisMonth,
    'trainings_count': trainings.length,
    // On peut ajouter d'autres calculs ici
  };
});

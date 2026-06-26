import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/group_project.dart';
import '../../domain/entities/mentorship_pair.dart';
import 'package:lumina/core/providers/repository_providers_groups.dart';

/// Provider pour la liste des projets d'un groupe spécifique.
final groupProjectsProvider =
    FutureProvider.family<List<GroupProject>, String>((ref, groupId) async {
  final repository = ref.watch(hommesRepositoryProvider);
  final result = await repository.getProjects(groupId);
  return result.fold(
    (l) => throw l,
    (r) => r,
  );
});

/// Provider pour la liste des binômes de mentorat d'un groupe spécifique.
final mentorshipPairsProvider =
    FutureProvider.family<List<MentorshipPair>, String>((ref, groupId) async {
  final repository = ref.watch(hommesRepositoryProvider);
  final result = await repository.getMentorshipPairs(groupId);
  return result.fold(
    (l) => throw l,
    (r) => r,
  );
});

/// Provider pour les KPIs du Groupe des Hommes (Projets, Budget, Mentorat).
final hommesDashboardProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, groupId) async {
  final projects = await ref.watch(groupProjectsProvider(groupId).future);
  final mentorship = await ref.watch(mentorshipPairsProvider(groupId).future);

  // Calcul du budget total
  double totalBudgetTarget = 0;
  double totalSpent = 0;
  int completedProjects = 0;

  for (var p in projects) {
    totalBudgetTarget += p.budgetTarget;
    totalSpent += p.budgetSpent;
    if (p.status == ProjectStatus.completed) completedProjects++;
  }

  final double budgetExecution =
      totalBudgetTarget > 0 ? (totalSpent / totalBudgetTarget) : 0;

  // Stats mentorat
  final int activeMentorships =
      mentorship.where((m) => m.status == MentorshipStatus.active).length;

  return {
    'total_projects': projects.length,
    'completed_projects': completedProjects,
    'total_budget_target': totalBudgetTarget,
    'total_spent': totalSpent,
    'budget_execution': budgetExecution,
    'total_mentorships': mentorship.length,
    'active_mentorships': activeMentorships,
    'projects_status_data': _calculateProjectStatusData(projects),
  };
});

Map<String, int> _calculateProjectStatusData(List<GroupProject> projects) {
  final data = <String, int>{
    'Planifié': 0,
    'En cours': 0,
    'Terminé': 0,
  };

  for (var p in projects) {
    if (p.status == ProjectStatus.completed) {
      data['Terminé'] = data['Terminé']! + 1;
    } else if (p.status == ProjectStatus.inProgress) {
      data['En cours'] = data['En cours']! + 1;
    } else {
      data['Planifié'] = data['Planifié']! + 1;
    }
  }
  return data;
}

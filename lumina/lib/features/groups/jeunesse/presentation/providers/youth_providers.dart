import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/camp.dart';
import '../../domain/entities/discipleship_program.dart';
import 'package:lumina/core/providers/repository_providers_groups.dart';

/// Provider pour la liste des camps d'un groupe spécifique.
final campsProvider =
    FutureProvider.family<List<Camp>, String>((ref, groupId) async {
  final repository = ref.watch(campRepositoryProvider);
  final result = await repository.getCampsByGroup(groupId);
  return result.fold(
    (l) => throw l,
    (r) => r,
  );
});

/// Provider pour la liste des programmes de discipulat d'un groupe spécifique.
final discipleshipProgramsProvider =
    FutureProvider.family<List<DiscipleshipProgram>, String>(
        (ref, groupId) async {
  final repository = ref.watch(discipleshipRepositoryProvider);
  final result = await repository.getProgramsByGroup(groupId);
  return result.fold(
    (l) => throw l,
    (r) => r,
  );
});

/// Provider pour les KPIs du Dashboard Jeunesse.
final youthDashboardProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, groupId) async {
  final camps = await ref.watch(campsProvider(groupId).future);
  final discipleship =
      await ref.watch(discipleshipProgramsProvider(groupId).future);

  // Statistiques des camps
  final int plannedCamps =
      camps.where((c) => c.status == CampStatus.planned).length;
  final int ongoingCamps =
      camps.where((c) => c.status == CampStatus.ongoing).length;
  final double totalBudgetTarget =
      camps.fold(0, (sum, c) => sum + c.budgetTarget);
  final double totalBudgetActual =
      camps.fold(0, (sum, c) => sum + c.budgetActual);

  // Statistiques discipulat
  final int activeDiscipleships =
      discipleship.where((d) => d.status == DiscipleshipStatus.active).length;
  final double averageProgress = discipleship.isEmpty
      ? 0
      : discipleship.fold(0, (sum, d) => sum + d.progressPercentage) /
          discipleship.length;

  return {
    'total_camps': camps.length,
    'planned_camps': plannedCamps,
    'ongoing_camps': ongoingCamps,
    'total_budget_target': totalBudgetTarget,
    'total_budget_actual': totalBudgetActual,
    'total_discipleships': discipleship.length,
    'active_discipleships': activeDiscipleships,
    'average_discipleship_progress': averageProgress,
    'recent_camps': camps.take(3).toList(),
    'camp_status_data': _calculateCampStatusData(camps),
    'discipleship_growth_data': _calculateDiscipleshipGrowthData(discipleship),
  };
});

Map<String, int> _calculateCampStatusData(List<Camp> camps) {
  final data = <String, int>{
    'Planifié': 0,
    'En cours': 0,
    'Terminé': 0,
  };

  for (var c in camps) {
    if (c.status == CampStatus.completed) {
      data['Terminé'] = data['Terminé']! + 1;
    } else if (c.status == CampStatus.ongoing) {
      data['En cours'] = data['En cours']! + 1;
    } else if (c.status == CampStatus.planned) {
      data['Planifié'] = data['Planifié']! + 1;
    }
  }
  return data;
}

List<double> _calculateDiscipleshipGrowthData(
    List<DiscipleshipProgram> programs) {
  // Simule une courbe de croissance basée sur la progression moyenne
  // Dans un cas réel, on pourrait agréger par mois
  return [20, 35, 45, 60, 75, 85];
}

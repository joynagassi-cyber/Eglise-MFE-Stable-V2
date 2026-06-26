import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/features/groups/chorale/domain/entities/sheet_music.dart';
import 'package:lumina/features/groups/chorale/domain/entities/rehearsal.dart';
import 'package:lumina/core/providers/repository_providers_groups.dart';

/// Provider pour la liste des partitions d'un groupe spécifique.
final sheetMusicProvider =
    FutureProvider.family<List<SheetMusic>, String>((ref, groupId) async {
  final repository = ref.watch(choraleRepositoryProvider);
  final result = await repository.getSheetMusic(groupId);
  return result.fold(
    (l) => throw l,
    (r) => r,
  );
});

/// Provider pour la liste des répétitions d'un groupe spécifique.
final rehearsalsProvider =
    FutureProvider.family<List<Rehearsal>, String>((ref, groupId) async {
  final repository = ref.watch(choraleRepositoryProvider);
  final result = await repository.getRehearsals(groupId);
  return result.fold(
    (l) => throw l,
    (r) => r,
  );
});

/// Provider pour les KPIs de la chorale (Membres, Présences).
final choraleMembersKpiProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, groupId) async {
  // Ici on pourrait agréger les données de présence aux répétitions
  final rehearsals = await ref.watch(rehearsalsProvider(groupId).future);

  int totalAttendance = 0;
  for (var r in rehearsals) {
    totalAttendance += (r.attendanceCount as num).toInt();
  }

  final double averageAttendance =
      rehearsals.isEmpty ? 0 : totalAttendance / rehearsals.length;

  return {
    'total_rehearsals': rehearsals.length,
    'average_attendance': averageAttendance.toStringAsFixed(1),
    'last_rehearsal_count':
        rehearsals.isNotEmpty ? rehearsals.first.attendanceCount : 0,
  };
});

/// Provider pour les KPIs des partitions.
final sheetMusicKpiProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, groupId) async {
  final sheetMusic = await ref.watch(sheetMusicProvider(groupId).future);

  final categories = <String, int>{};
  for (var s in sheetMusic) {
    if (s.category != null) {
      categories[s.category!] = (categories[s.category!] ?? 0) + 1;
    }
  }

  return {
    'total_sheets': sheetMusic.length,
    'categories_count': categories.length,
    'most_common_category': _getMostCommon(categories),
  };
});

String _getMostCommon(Map<String, int> map) {
  if (map.isEmpty) return 'Aucune';
  final sorted = map.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  return sorted.first.key;
}

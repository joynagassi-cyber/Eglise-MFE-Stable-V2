import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/group_attendance.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import 'package:lumina/core/providers/repository_providers_groups.dart';

part 'engagement_provider.g.dart';

class MemberEngagement {
  final String memberId;
  final double engagementRate; // 0.0 to 1.0
  final int totalSessions;
  final int attendedSessions;
  final EngagementLevel level;
  final bool isTrendingUp;

  const MemberEngagement({
    required this.memberId,
    required this.engagementRate,
    required this.totalSessions,
    required this.attendedSessions,
    required this.level,
    this.isTrendingUp = true,
  });
}

enum EngagementLevel {
  high, // > 80%
  medium, // 50-80%
  low, // < 50%
}

@riverpod
class GroupEngagement extends _$GroupEngagement {
  @override
  Future<Map<String, MemberEngagement>> build(String groupId) async {
    final repository = ref.watch(groupRepositoryProvider);
    final celebrationRepository = ref.watch(celebrationRepositoryProvider);

    // Récupérer l'historique des 3 derniers mois (90 jours)
    final since = DateTime.now().subtract(const Duration(days: 90));
    final history =
        await repository.getGroupAttendanceHistory(groupId, since: since);

    if (history.isEmpty) return {};

    // 1. Organiser les stats par membre pour le GROUPE
    final groupStats = <String, List<GroupAttendance>>{};
    for (final record in history) {
      groupStats.putIfAbsent(record.memberId, () => []).add(record);
    }

    final result = <String, MemberEngagement>{};
    for (final entry in groupStats.entries) {
      final memberId = entry.key;
      final groupAttendances = entry.value;

      // Stat Groupe
      final groupTotal = groupAttendances.length;
      final groupPresent = groupAttendances
          .where((a) =>
              a.status == AttendanceStatus.present ||
              a.status == AttendanceStatus.late)
          .length;
      final groupRate = groupTotal > 0 ? groupPresent / groupTotal : 0.0;

      // 2. Stat CULTE (Hybridation)
      final serviceAttendances =
          await celebrationRepository.getAttendanceByMember(memberId);
      // Filtrer sur la même période
      final recentServices = serviceAttendances
          .where((s) => s.checkInTime != null && s.checkInTime!.isAfter(since))
          .toList();

      final serviceTotal = recentServices.length;
      final servicePresent = recentServices.where((s) => s.isPresent).length;
      final serviceRate = serviceTotal > 0
          ? servicePresent / serviceTotal
          : groupRate; // Si pas de data culte, on ignore ou on prend le groupRate? On va dire que si pas de data, on ne pénalise pas.

      // 3. Calcul Hybride (Poids : 70% Groupe, 30% Culte si data dispos)
      double finalRate;
      if (serviceTotal > 0) {
        finalRate = (groupRate * 0.7) + (serviceRate * 0.3);
      } else {
        finalRate =
            groupRate; // On reste sur le groupe si pas de pointage culte pour ce membre
      }

      EngagementLevel level;
      if (finalRate >= 0.8) {
        level = EngagementLevel.high;
      } else if (finalRate >= 0.5) {
        level = EngagementLevel.medium;
      } else {
        level = EngagementLevel.low;
      }

      // Tendance basés sur les 8 derniers évènements (Groupe+Culte ou Groupe seul)
      // Pour rester simple, on garde la tendance sur le Groupe qui est l'unité de base de ce dashboard
      bool isTrendingUp = true;
      if (groupAttendances.length >= 8) {
        final recent = groupAttendances
            .take(4)
            .where((a) => a.status == AttendanceStatus.present)
            .length;
        final older = groupAttendances
            .skip(4)
            .take(4)
            .where((a) => a.status == AttendanceStatus.present)
            .length;
        isTrendingUp = recent >= older;
      }

      result[memberId] = MemberEngagement(
        memberId: memberId,
        engagementRate: finalRate,
        totalSessions: (groupTotal + serviceTotal).toInt(),
        attendedSessions: (groupPresent + servicePresent).toInt(),
        level: level,
        isTrendingUp: isTrendingUp,
      );
    }

    return result;
  }
}

@riverpod
Future<List<MemberEngagement>> topEngagedMembers(
    TopEngagedMembersRef ref, String groupId) async {
  final engagementMap =
      await ref.watch(groupEngagementProvider(groupId).future);
  final list = engagementMap.values.toList();
  list.sort((a, b) => b.engagementRate.compareTo(a.engagementRate));
  return list.take(5).toList();
}

@riverpod
Future<List<MemberEngagement>> membersAtRisk(
    MembersAtRiskRef ref, String groupId) async {
  final engagementMap =
      await ref.watch(groupEngagementProvider(groupId).future);
  return engagementMap.values
      .where((e) => e.level == EngagementLevel.low || !e.isTrendingUp)
      .toList();
}

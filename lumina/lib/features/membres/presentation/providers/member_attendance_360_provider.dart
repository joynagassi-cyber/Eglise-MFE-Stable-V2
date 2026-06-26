import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumina/features/groups/domain/entities/group_attendance.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import 'package:lumina/core/providers/repository_providers_groups.dart';

part 'member_attendance_360_provider.g.dart';

class MemberAttendanceStats {
  final int totalSessions;
  final int attendedSessions;
  final double attendanceRate;
  final List<UnifiedAttendanceRecord> history;

  const MemberAttendanceStats({
    required this.totalSessions,
    required this.attendedSessions,
    required this.attendanceRate,
    required this.history,
  });
}

class UnifiedAttendanceRecord {
  final DateTime date;
  final String source; // 'Groupe' or 'Culte'
  final String status;
  final String? notes;
  final bool isPresent;

  const UnifiedAttendanceRecord({
    required this.date,
    required this.source,
    required this.status,
    required this.isPresent,
    this.notes,
  });
}

@riverpod
Future<MemberAttendanceStats> memberAttendance360(
  MemberAttendance360Ref ref,
  String memberId,
) async {
  final groupRepo = ref.watch(groupRepositoryProvider);
  final celebrationRepo = ref.watch(celebrationRepositoryProvider);

  // 1. Récupérer l'historique des groupes
  final groupHistory = await groupRepo.getMemberAttendanceHistory(memberId);

  // 2. Récupérer l'historique des cultes
  // Note: On pourrait ajouter une méthode spécifique au repo si besoin,
  // mais ici on suppose que le repo peut filtrer par memberId globalement
  final serviceHistory = await celebrationRepo.getAttendanceByMember(memberId);

  final allRecords = <UnifiedAttendanceRecord>[];

  for (final record in groupHistory) {
    allRecords.add(UnifiedAttendanceRecord(
      date: record.attendanceDate,
      source: 'Groupe',
      status: record.status.name.toUpperCase(),
      isPresent: record.status == AttendanceStatus.present ||
          record.status == AttendanceStatus.late,
      notes: record.notes,
    ));
  }

  for (final record in serviceHistory) {
    allRecords.add(UnifiedAttendanceRecord(
      date:
          record.checkInTime ?? DateTime.now(), // Fallback if no time recorded
      source: 'Culte',
      status: record.isPresent ? 'PRÉSENT' : 'ABSENT',
      isPresent: record.isPresent,
      notes: record.notes,
    ));
  }

  // Trier par date décroissante
  allRecords.sort((a, b) => b.date.compareTo(a.date));

  final attended = allRecords.where((r) => r.isPresent).length;
  final total = allRecords.length;

  return MemberAttendanceStats(
    totalSessions: total,
    attendedSessions: attended,
    attendanceRate: total > 0 ? attended / total : 0.0,
    history: allRecords,
  );
}

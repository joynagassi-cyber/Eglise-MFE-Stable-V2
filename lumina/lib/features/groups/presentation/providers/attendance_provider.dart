import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/group_attendance.dart';
import 'package:lumina/core/providers/repository_providers_groups.dart';

part 'attendance_provider.g.dart';

@riverpod
class AttendanceController extends _$AttendanceController {
  @override
  FutureOr<List<GroupAttendance>> build(
      String churchId, String groupId, DateTime date) async {
    final repository = ref.watch(groupRepositoryProvider);
    return repository.getAttendance(groupId, date);
  }

  Future<void> updateStatus(String memberId, AttendanceStatus status) async {
    final currentState = state.valueOrNull ?? [];
    final normalizedDate = DateTime(date.year, date.month, date.day);

    final existingIndex =
        currentState.indexWhere((a) => a.memberId == memberId);

    final List<GroupAttendance> updatedList;
    if (existingIndex != -1) {
      updatedList = List.from(currentState);
      updatedList[existingIndex] =
          currentState[existingIndex].copyWith(status: status);
    } else {
      updatedList = [
        ...currentState,
        GroupAttendance(
          id: DateTime.now().millisecondsSinceEpoch.toString(), // Temp ID
          churchId: churchId,
          groupId: groupId,
          memberId: memberId,
          attendanceDate: normalizedDate,
          status: status,
        ),
      ];
    }

    state = AsyncValue.data(updatedList);
  }

  Future<void> save() async {
    final attendance = state.valueOrNull;
    if (attendance == null || attendance.isEmpty) return;

    final repository = ref.read(groupRepositoryProvider);
    await repository.saveAttendance(attendance);
  }
}

@riverpod
Stream<List<GroupAttendance>> groupAttendanceStream(
  GroupAttendanceStreamRef ref,
  String churchId,
  String groupId,
  DateTime date,
) {
  final repository = ref.watch(groupRepositoryProvider);
  return repository.watchAttendance(groupId, date);
}

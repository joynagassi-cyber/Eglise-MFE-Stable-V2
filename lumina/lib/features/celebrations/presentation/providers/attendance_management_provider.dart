import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/service_attendance.dart';
import '../../domain/repositories/i_celebration_repository.dart';

part 'attendance_management_provider.g.dart';

@riverpod
class AttendanceManagementController extends _$AttendanceManagementController {
  @override
  FutureOr<List<ServiceAttendance>> build(String serviceId) async {
    final repository = ref.watch(celebrationRepositoryProvider);
    return repository.getAttendance(serviceId);
  }

  Future<void> updateAttendance(String memberId, bool isPresent) async {
    final currentState = state.valueOrNull ?? [];

    final existingIndex =
        currentState.indexWhere((a) => a.memberId == memberId);

    final List<ServiceAttendance> updatedList;
    if (existingIndex != -1) {
      updatedList = List.from(currentState);
      updatedList[existingIndex] = currentState[existingIndex].copyWith(
        isPresent: isPresent,
        checkInTime: isPresent ? DateTime.now() : null,
      );
    } else {
      updatedList = [
        ...currentState,
        ServiceAttendance(
          id: '', // Will be handled by repo/DB
          serviceId: serviceId,
          memberId: memberId,
          isPresent: isPresent,
          checkInTime: isPresent ? DateTime.now() : null,
        ),
      ];
    }

    state = AsyncValue.data(updatedList);
  }

  Future<void> save() async {
    final attendance = state.valueOrNull;
    if (attendance == null) return;

    state = const AsyncValue.loading();
    try {
      final repository = ref.read(celebrationRepositoryProvider);
      await repository.saveAttendance(attendance);
      state = AsyncValue.data(attendance);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

@riverpod
Stream<List<ServiceAttendance>> serviceAttendanceStream(
  ServiceAttendanceStreamRef ref,
  String serviceId,
) {
  final repository = ref.watch(celebrationRepositoryProvider);
  return repository.watchAttendance(serviceId);
}
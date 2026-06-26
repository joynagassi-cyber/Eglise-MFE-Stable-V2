import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/church_service.dart';
import '../entities/service_attendance.dart';

abstract class ICelebrationRepository {
  Future<List<ChurchService>> getServices(String churchId);
  Future<ChurchService?> getService(String id);
  Future<void> createService(ChurchService service);
  Future<void> updateService(ChurchService service);
  Future<void> deleteService(String id);
  Stream<List<ChurchService>> watchServices(String churchId);

  // Presence Management
  Future<List<ServiceAttendance>> getAttendance(String serviceId);
  Future<void> saveAttendance(List<ServiceAttendance> attendance);
  Stream<List<ServiceAttendance>> watchAttendance(String serviceId);
  Future<List<ServiceAttendance>> getAttendanceByMember(String memberId);
}

final celebrationRepositoryProvider = Provider<ICelebrationRepository>((ref) {
  throw UnimplementedError('celebrationRepositoryProvider not overridden');
});
import '../entities/shepherd.dart';
import '../entities/pastoral_visit.dart';

abstract class IShepherdRepository {
  Future<List<Shepherd>> getShepherds({String? churchId});
  Future<Shepherd?> getShepherdById(String id);
  Future<Shepherd?> getShepherdByMemberId(String memberId);

  Future<Shepherd> createShepherd(Shepherd shepherd);
  Future<Shepherd> updateShepherd(Shepherd shepherd);
  Future<void> deleteShepherd(String id);

  // Pastoral visits and notes
  Future<List<PastoralVisit>> getPastoralVisits({String? shepherdId});

  Future<void> logPastoralVisit(PastoralVisit visit);
}
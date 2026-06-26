import '../entities/sacrament.dart';
import '../entities/sacrament_type.dart';

abstract class ISacramentRepository {
  Future<List<Sacrament>> getSacraments({
    String? churchId,
    SacramentType? type,
    String? memberId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Sacrament?> getSacramentById(String id);

  Future<Sacrament> createSacrament(Sacrament sacrament);

  Future<Sacrament> updateSacrament(Sacrament sacrament);

  Future<void> deleteSacrament(String id);

  Future<List<Sacrament>> searchSacraments(String query);

  Future<List<Sacrament>> getMemberSacraments(String memberId);

  Future<bool> hasSacrament(String memberId, SacramentType type);
}
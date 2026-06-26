import '../entities/annonce.dart';
import '../entities/commentaire.dart';

abstract class IAnnonceRepository {
  Future<List<Annonce>> getAnnonces({
    String? churchId,
    String? type,
    String? status,
    bool? isPublished,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  });

  Stream<List<Annonce>> watchAnnonces({required String churchId});

  Future<Annonce?> getAnnonceById(String id);

  Future<Annonce> createAnnonce(Annonce annonce);

  Future<Annonce> updateAnnonce(Annonce annonce);

  Future<void> deleteAnnonce(String id);

  Future<List<Annonce>> searchAnnonces(String query);

  Future<List<Annonce>> getPublishedAnnonces({String? churchId, int? limit});

  Future<List<Annonce>> getPinnedAnnonces({String? churchId, int? limit});

  Future<void> incrementViews(String id);

  Future<void> likeAnnonce(String id, String userId);

  Future<void> unlikeAnnonce(String id, String userId);

  Future<List<Commentaire>> getCommentaires(String annonceId);

  Future<Commentaire> addCommentaire(Commentaire commentaire);

  Future<void> deleteCommentaire(String id);

  Future<void> likeCommentaire(String id, String userId);

  Future<void> unlikeCommentaire(String id, String userId);
}
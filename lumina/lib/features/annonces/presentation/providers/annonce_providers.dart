import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import '../../domain/entities/annonce.dart';
import '../../domain/entities/commentaire.dart';

final annoncesProvider = FutureProvider<List<Annonce>>((ref) async {
  final repository = ref.watch(annonceRepositoryProvider);
  return await repository.getAnnonces();
});

final publishedAnnoncesProvider = FutureProvider<List<Annonce>>((ref) async {
  final repository = ref.watch(annonceRepositoryProvider);
  return await repository.getPublishedAnnonces(limit: 20);
});

final pinnedAnnoncesProvider = FutureProvider<List<Annonce>>((ref) async {
  final repository = ref.watch(annonceRepositoryProvider);
  return await repository.getPinnedAnnonces(limit: 5);
});

final annonceSearchProvider = FutureProvider.family<List<Annonce>, String>((
  ref,
  query,
) async {
  final repository = ref.watch(annonceRepositoryProvider);
  return await repository.searchAnnonces(query);
});

final annonceByIdProvider = FutureProvider.family<Annonce?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(annonceRepositoryProvider);
  return await repository.getAnnonceById(id);
});

final commentairesProvider = FutureProvider.family<List<Commentaire>, String>((
  ref,
  annonceId,
) async {
  final repository = ref.watch(annonceRepositoryProvider);
  return await repository.getCommentaires(annonceId);
});

class AnnonceNotifier extends AsyncNotifier<List<Annonce>> {
  @override
  Future<List<Annonce>> build() async {
    final repository = ref.read(annonceRepositoryProvider);
    return await repository.getAnnonces();
  }

  Future<void> addAnnonce(Annonce annonce) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(annonceRepositoryProvider);
      await repository.createAnnonce(annonce);
      return await repository.getAnnonces();
    });
  }

  Future<void> updateAnnonce(Annonce annonce) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(annonceRepositoryProvider);
      await repository.updateAnnonce(annonce);
      return await repository.getAnnonces();
    });
  }

  Future<void> deleteAnnonce(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(annonceRepositoryProvider);
      await repository.deleteAnnonce(id);
      return await repository.getAnnonces();
    });
  }

  Future<void> publishAnnonce(String id) async {
    final repository = ref.read(annonceRepositoryProvider);
    final annonce = await repository.getAnnonceById(id);
    if (annonce != null) {
      final updated = annonce.copyWith(
        isPublished: true,
        status: 'PUBLIE',
        publishedAt: DateTime.now(),
      );
      await repository.updateAnnonce(updated);
    }
  }

  Future<void> unpublishAnnonce(String id) async {
    final repository = ref.read(annonceRepositoryProvider);
    final annonce = await repository.getAnnonceById(id);
    if (annonce != null) {
      final updated = annonce.copyWith(
        isPublished: false,
        status: 'BROUILLON',
        publishedAt: null,
      );
      await repository.updateAnnonce(updated);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(annonceRepositoryProvider);
      return await repository.getAnnonces();
    });
  }
}

final annonceNotifierProvider =
    AsyncNotifierProvider<AnnonceNotifier, List<Annonce>>(AnnonceNotifier.new);

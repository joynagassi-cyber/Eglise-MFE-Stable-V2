import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/providers/auth_provider.dart';
import 'package:lumina/core/providers/repository_providers_profile.dart';
import '../../domain/entities/profile.dart';

part 'profile_provider.g.dart';

// FIX #8 — keepAlive: true supprimé pour éviter les fuites mémoire.
// Chaque changement de userId (changement d'église ou déconnexion) invalide
// automatiquement le provider, libérant le stream Supabase associé.
@riverpod
Stream<Profile?> profileState(ProfileStateRef ref) {
  final userId = ref.watch(currentUserIdProvider);
  final churchId = ref.watch(activeChurchIdProvider);

  if (userId == null) return Stream.value(null);

  // Lifecycle logging pour le debugging des fuites mémoire
  ref.onDispose(() {
    AppLogger.i(
      'Profile stream disposé — userId: $userId / churchId: $churchId',
      'PROFILE_PROVIDER',
    );
  });

  return ref.watch(profileRepositoryProvider).watchProfile(userId);
}

// FIX #8 — otherUserProfile: rethrow l'erreur au lieu de retourner null silencieusement.
// Permet à l'UI de distinguer "aucun profil" de "erreur de chargement".
@riverpod
Future<Profile?> otherUserProfile(
    OtherUserProfileRef ref, String userId) async {
  final repository = ref.watch(profileRepositoryProvider);
  final result = await repository.getProfile(userId);

  return result.fold(
    (failure) {
      AppLogger.e(
        'Impossible de charger le profil de: $userId',
        'PROFILE_PROVIDER',
        failure,
      );
      throw failure; // AsyncError émis → l'UI peut afficher un état d'erreur
    },
    (profile) => profile,
  );
}

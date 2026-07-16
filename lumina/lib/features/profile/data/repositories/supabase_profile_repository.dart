import 'dart:io';
import 'package:dartz/dartz.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/app_date_time.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../../membres/domain/repositories/member_repository.dart';

class SupabaseProfileRepository implements ProfileRepository {
  final SupabaseClient _client;
  final MemberRepository _memberRepository;
  static const _tag = 'PROFILE_REPO';

  SupabaseProfileRepository(this._client, this._memberRepository);

  // ─── getProfile ─────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, Profile>> getProfile(String id) async {
    try {
      final response =
          await _client.from('profiles').select().eq('id', id).single();
      return Right(Profile.fromJson(response));
    } on PostgrestException catch (e) {
      // FIX #11 — Différenciation des erreurs Postgrest
      if (e.code == 'PGRST116') {
        AppLogger.w('Profile not found: $id', _tag);
        return const Left(
            ServerFailure('Profil introuvable', code: 'NOT_FOUND'));
      } else if (e.code == '42501') {
        AppLogger.w('RLS denied access to profile: $id', _tag);
        return const Left(
            PermissionFailure('Accès refusé au profil', code: 'FORBIDDEN'));
      }
      AppLogger.e('Erreur Postgrest récupération profil: $id', _tag, e);
      return Left(ServerFailure(e.message, code: e.code));
    } on FormatException catch (e) {
      AppLogger.e('Erreur parsing profil: $id', _tag, e);
      return const Left(
          ServerFailure('Données profil invalides', code: 'PARSE_ERROR'));
    } on SocketException catch (e) {
      AppLogger.e('Erreur réseau récupération profil: $id', _tag, e);
      return const Left(NetworkFailure('Pas de connexion réseau'));
    } catch (e) {
      AppLogger.e('Erreur inattendue récupération profil: $id', _tag, e);
      return Left(ServerFailure(e.toString()));
    }
  }

  // ─── updateProfile ───────────────────────────────────────────────────────

  @override
  Future<Either<Failure, Profile>> updateProfile(Profile profile) async {
    try {
      final data = profile.toJson();
      // Sanitization : champs système non modifiables directement
      data.remove('created_at');
      data.remove('updated_at');
      data.remove('last_sign_in_at');
      // Sécurité : Empêcher l'escalade de privilèges
      data.remove('role_id');
      data.remove('role_level');
      data.remove('church_id');
      data.remove('needs_onboarding');

      final response = await _client
          .from('profiles')
          .update(data)
          .eq('id', profile.id)
          .select()
          .single();

      final updatedProfile = Profile.fromJson(response);

      // FIX #4 — Race condition: suivre le résultat de la synchro legacy.
      // On attend mais on ne bloque pas le succès principal sur un échec legacy.
      try {
        await _syncToLegacyMember(updatedProfile);
        AppLogger.i('Profile et membre legacy synchronisés avec succès', _tag);
      } catch (syncError) {
        // Non-bloquant : la synchro legacy est secondaire.
        // L'utilisateur a bien mis à jour son profil principal.
        AppLogger.w(
          'Synchro legacy échouée (non-bloquant) pour: ${profile.id} - Erreur: $syncError',
          _tag,
        );
      }

      return Right(updatedProfile);
    } on PostgrestException catch (e) {
      AppLogger.e(
          'Erreur Postgrest mise à jour profil: ${profile.id}', _tag, e);
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      AppLogger.e('Erreur mise à jour profil: ${profile.id}', _tag, e);
      return Left(ServerFailure(e.toString()));
    }
  }

  // ─── completeOnboarding ──────────────────────────────────────────────────

  @override
  Future<Either<Failure, Unit>> completeOnboarding(String id) async {
    try {
      await _client.from('profiles').update({
        'needs_onboarding': false,
        'onboarding_completed_at': AppDateTime.nowIso(),
      }).eq('id', id);

      return const Right(unit);
    } catch (e) {
      AppLogger.e('Erreur completion onboarding: $id', _tag, e);
      return Left(ServerFailure(e.toString()));
    }
  }

  // ─── watchProfile ────────────────────────────────────────────────────────

  @override
  Stream<Profile?> watchProfile(String id) {
    // Emit null IMMEDIATELY (profile is enrichment, not a prerequisite).
    // Supabase realtime stream can take up to 8s (timeout) or block indefinitely
    // if the profiles row does not yet exist (post-role-code onboarding).
    // By emitting null upfront, the UI shows the dashboard immediately
    // and updates the firstName when the profile arrives.
    final controller = StreamController<Profile?>.broadcast();
    // Émettre null immédiatement, puis relayer le flux Supabase.
    controller.add(null);
    final realtime = _client
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((data) {
          if (data.isEmpty) return null;
          try {
            return Profile.fromJson(data.first);
          } catch (e) {
            AppLogger.e('Erreur parsing profil stream: $id', _tag, e);
            throw const ServerFailure('Données profil invalides',
                code: 'PARSE_ERROR');
          }
        })
        .handleError((e, stack) {
          AppLogger.e('Erreur stream profil: $id', _tag, e);
        })
        .timeout(
          const Duration(seconds: 8),
          onTimeout: (sink) {
            AppLogger.w(
              'Profile stream timeout (stream maintenu actif): $id',
              _tag,
            );
            sink.add(null);
          },
        );
    realtime.listen(
      controller.add,
      onError: (e, st) {
        if (!controller.isClosed) controller.addError(e, st);
      },
      onDone: () {
        if (!controller.isClosed) controller.close();
      },
    );
    return controller.stream;
  }

  // ─── _syncToLegacyMember (privé) ─────────────────────────────────────────

  Future<void> _syncToLegacyMember(Profile profile) async {
    final memberResult = await _memberRepository.getMemberById(profile.id);

    await memberResult.fold(
      (failure) async {
        // Pas forcément une erreur — le profil peut ne pas avoir de membre legacy
        AppLogger.w(
          'Membre legacy non trouvé pour synchro: ${profile.id}',
          _tag,
        );
      },
      (member) async {
        final updatedMember = member.copyWith(
          firstName: profile.firstName ?? member.firstName,
          lastName: profile.lastName ?? member.lastName,
          email: profile.email ?? member.email,
          photoUrl: profile.avatarUrl ?? member.photoUrl,
        );
        await _memberRepository.updateMember(updatedMember);
        AppLogger.i('Synchronisation legacy membre réussie', _tag);
      },
    );
  }
}

// lib/features/auth/domain/usecases/sign_in_with_google_use_case.dart

import 'package:dartz/dartz.dart';
import '../../../../core/auth/domain/entities/user_session.dart';
import '../../../../core/error/failures.dart';
import '../exceptions/google_auth_exceptions.dart';
import '../repositories/auth_repository.dart';
import '../repositories/i_google_auth_service.dart';

class SignInWithGoogleUseCase {
  final IGoogleAuthService authGoogleService;
  final AuthRepository authRepository;

  SignInWithGoogleUseCase({
    required this.authGoogleService,
    required this.authRepository,
  });

  Future<Either<Failure, UserSession?>> call() async {
    try {
      // 1. Appel du flux natif Google Sign-In.
      final authResult = await authGoogleService.signInWithGoogle();

      // 2. Validation du token par le backend Supabase.
      return await authRepository.signInWithGoogleTokens(
        idToken: authResult.idToken,
        accessToken: authResult.accessToken,
      );
    } on GoogleAuthCancelledException {
      return const Right(null);
    } on GoogleAuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erreur lors de la connexion Google : $e'));
    }
  }
}

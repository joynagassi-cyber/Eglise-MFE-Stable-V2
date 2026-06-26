// lib/features/auth/domain/repositories/auth_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/auth/domain/entities/user_session.dart';
import '../models/auth_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserSession>> login({
    required String email,
    required String password,
    String? captchaToken,
  });

  Future<Either<Failure, UserSession?>> register({
    required String email,
    required String password,
    required String name,
    String? churchId,
    String? captchaToken,
  });

  Future<Either<Failure, UserSession?>> signInWithGoogleTokens({
    required String idToken,
    required String accessToken,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserSession?>> loadSavedSession();

  Future<Either<Failure, void>> requestPasswordReset({
    required String email,
    String? captchaToken,
  });

  Future<Either<Failure, void>> resetPassword({
    required String resetToken,
    required String newPassword,
  });

  Future<Either<Failure, void>> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  });

  Future<Either<Failure, UserSession>> switchActiveChurch({
    required String userId,
    required String newChurchId,
  });

  Future<Either<Failure, bool>> verifyAdminCode(String code);

  Future<AppAuthUser?> getCurrentUser();

  User? get currentUser;
  bool get isAuthenticated;

  Stream<UserSession?> watchAuthState();

  // Compatibility methods
  Future<Either<Failure, void>> saveSession(UserSession session);
  Future<Either<Failure, void>> clearSavedSession();
  Future<Either<Failure, UserSession?>> getCurrentSession();
  Future<Either<Failure, UserSession>> refreshSession(
      {required String refreshToken});
  Future<Either<Failure, bool>> validateSession(UserSession session);
  Future<Either<Failure, void>> invalidateSession(String sessionId);
  Future<Either<Failure, List<String>>> getAccessibleChurches(
      {required String userId});
  Future<Either<Failure, UserSession?>> loginWithToken(String token);
}
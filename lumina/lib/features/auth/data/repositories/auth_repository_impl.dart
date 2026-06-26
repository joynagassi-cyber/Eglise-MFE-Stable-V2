// lib/features/auth/data/repositories/auth_repository_impl.dart
// ⛔ DEAD CODE — Use SupabaseAuthRepository instead (bound in repository_providers_auth.dart).
// Legacy stub kept only for reference; all methods throw.
// Remove this file once all imports are confirmed absent (grep shows zero).

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/models/auth_user.dart'; // Corrected path
import '../../../../core/auth/domain/entities/user_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/supabase_auth_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

@Deprecated('Use SupabaseAuthRepository instead')
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseAuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, UserSession>> login({
    required String email,
    required String password,
    String? captchaToken,
  }) async {
    // This is a legacy implementation. SupabaseAuthRepository should be used instead.
    return const Left(
        AuthFailure('Legacy implementation - use SupabaseAuthRepository'));
  }

  @override
  Future<Either<Failure, UserSession?>> register({
    required String email,
    required String password,
    required String name,
    String? churchId,
    String? captchaToken,
  }) async {
    return const Left(
        AuthFailure('Legacy implementation - use SupabaseAuthRepository'));
  }

  @override
  Future<Either<Failure, UserSession?>> signInWithGoogleTokens({
    required String idToken,
    required String accessToken,
  }) async {
    return const Left(AuthFailure('Legacy implementation'));
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _dataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserSession?>> loadSavedSession() async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> requestPasswordReset(
      {required String email, String? captchaToken}) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> resetPassword(
      {required String resetToken, required String newPassword}) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> changePassword(
      {required String userId,
      required String currentPassword,
      required String newPassword}) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, UserSession>> switchActiveChurch(
      {required String userId, required String newChurchId}) async {
    return const Left(AuthFailure('Legacy implementation'));
  }

  @override
  Future<Either<Failure, bool>> verifyAdminCode(String code) async {
    return const Right(false);
  }

  @override
  Future<AppAuthUser?> getCurrentUser() async {
    final user = _dataSource.getCurrentUser();
    if (user == null) return null;
    return AppAuthUser(
      id: user.id,
      email: user.email ?? '',
      firstName: user.userMetadata?['first_name'] as String?,
      lastName: user.userMetadata?['last_name'] as String?,
    );
  }

  @override
  supabase.User? get currentUser => null;

  @override
  bool get isAuthenticated => false;

  @override
  Stream<UserSession?> watchAuthState() => Stream.value(null);

  @override
  Future<Either<Failure, void>> saveSession(UserSession session) async =>
      const Right(null);

  @override
  Future<Either<Failure, void>> clearSavedSession() async => const Right(null);

  @override
  Future<Either<Failure, UserSession?>> getCurrentSession() async =>
      const Right(null);

  @override
  Future<Either<Failure, UserSession>> refreshSession(
      {required String refreshToken}) async {
    return const Left(AuthFailure('Legacy implementation'));
  }

  @override
  Future<Either<Failure, bool>> validateSession(UserSession session) async =>
      const Right(true);

  @override
  Future<Either<Failure, void>> invalidateSession(String sessionId) async =>
      const Right(null);

  @override
  Future<Either<Failure, List<String>>> getAccessibleChurches(
          {required String userId}) async =>
      const Right([]);

  @override
  Future<Either<Failure, UserSession?>> loginWithToken(String token) async =>
      const Right(null);
}
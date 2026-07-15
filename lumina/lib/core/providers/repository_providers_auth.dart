import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lumina/core/data/local/isar_service.dart';
import 'package:lumina/core/providers/app_env_provider.dart';
import 'package:lumina/core/providers/supabase_provider.dart';
import 'package:lumina/features/auth/data/datasources/google_auth_service.dart';
import 'package:lumina/features/auth/data/datasources/user_context_remote_datasource.dart';
import 'package:lumina/features/auth/data/repositories/role_code_repository.dart';
import 'package:lumina/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:lumina/features/auth/data/repositories/supabase_role_repository.dart';
import 'package:lumina/features/auth/data/repositories/user_context_repository_impl.dart';
import 'package:lumina/features/auth/domain/repositories/auth_repository.dart';
import 'package:lumina/features/auth/domain/repositories/i_google_auth_service.dart';
import 'package:lumina/features/auth/domain/repositories/role_repository.dart';
import 'package:lumina/features/auth/domain/repositories/user_context_repository.dart';
import 'package:lumina/features/auth/domain/usecases/sign_in_with_google_use_case.dart';

part 'repository_providers_auth.g.dart';

@Riverpod(keepAlive: true)
RoleCodeRepository roleCodeRepository(RoleCodeRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  return RoleCodeRepository(supabase);
}

@Riverpod(keepAlive: true)
RoleRepository roleRepository(RoleRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final isar = ref.watch(isarServiceProvider);
  return SupabaseRoleRepository(supabase: supabase, isar: isar);
}

@Riverpod(keepAlive: true)
UserContextRepository userContextRepository(UserContextRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final remoteDataSource = UserContextRemoteDataSource(supabase);
  return UserContextRepositoryImpl(remoteDataSource);
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final userContext = ref.watch(userContextRepositoryProvider);
  final roles = ref.watch(roleRepositoryProvider);
  return SupabaseAuthRepository(
    supabase: supabase,
    userContextRepository: userContext,
    roleRepository: roles,
  );
}

@Riverpod(keepAlive: true)
IGoogleAuthService googleAuthService(GoogleAuthServiceRef ref) {
  final webClientId = ref.watch(googleWebClientIdProvider);
  return GoogleAuthServiceImpl(webClientId: webClientId);
}

@Riverpod(keepAlive: true)
SignInWithGoogleUseCase signInWithGoogleUseCase(
  SignInWithGoogleUseCaseRef ref,
) {
  final authGoogleService = ref.watch(googleAuthServiceProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  return SignInWithGoogleUseCase(
    authGoogleService: authGoogleService,
    authRepository: authRepository,
  );
}

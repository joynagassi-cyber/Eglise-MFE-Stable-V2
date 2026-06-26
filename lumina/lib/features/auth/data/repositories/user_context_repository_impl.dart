import '../../../../core/auth/domain/entities/user_context.dart';
import '../../domain/repositories/user_context_repository.dart';
import '../datasources/user_context_remote_datasource.dart';

class UserContextRepositoryImpl implements UserContextRepository {
  final UserContextRemoteDataSource _remoteDataSource;

  UserContextRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserContext> getUserContext() async {
    return await _remoteDataSource.fetchUserContext();
  }
}
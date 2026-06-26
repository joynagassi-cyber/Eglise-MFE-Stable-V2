import 'package:dartz/dartz.dart';
import 'package:lumina/core/error/failures.dart';
import '../entities/group.dart';
import '../repositories/i_group_repository.dart';

class GetGroupsUseCase {
  final IGroupRepository repository;

  GetGroupsUseCase(this.repository);

  Future<Either<Failure, List<Group>>> call(String churchId) async {
    try {
      final result = await repository.getGroups(churchId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
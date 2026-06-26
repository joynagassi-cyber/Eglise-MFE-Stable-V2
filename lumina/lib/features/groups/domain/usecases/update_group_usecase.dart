import 'package:dartz/dartz.dart';
import 'package:lumina/core/error/failures.dart';
import '../entities/group.dart';
import '../repositories/i_group_repository.dart';

class UpdateGroupUseCase {
  final IGroupRepository repository;

  UpdateGroupUseCase(this.repository);

  Future<Either<Failure, void>> call(Group group) async {
    if (group.name.isEmpty) {
      return const Left(ValidationFailure('Group name is required'));
    }
    try {
      await repository.updateGroup(group);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
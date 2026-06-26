import 'package:dartz/dartz.dart';
import 'package:lumina/core/error/failures.dart';
import '../repositories/i_group_repository.dart';

class DeleteGroupUseCase {
  final IGroupRepository repository;

  DeleteGroupUseCase(this.repository);

  Future<Either<Failure, void>> call(String groupId,
      {required String churchId}) async {
    if (groupId.isEmpty) {
      return const Left(ValidationFailure('Group ID cannot be empty'));
    }
    try {
      await repository.deleteGroup(groupId, churchId: churchId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
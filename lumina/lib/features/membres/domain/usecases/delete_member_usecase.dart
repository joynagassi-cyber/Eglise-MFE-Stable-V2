import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/member_repository.dart';

class DeleteMemberUseCase {
  final MemberRepository repository;

  DeleteMemberUseCase(this.repository);

  Future<Either<Failure, void>> call(String memberId) async {
    if (memberId.isEmpty) {
      return const Left(ValidationFailure('Member ID cannot be empty'));
    }
    return repository.deleteMember(memberId);
  }
}
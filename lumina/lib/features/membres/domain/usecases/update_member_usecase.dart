import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/member.dart';
import '../repositories/member_repository.dart';

class UpdateMemberUseCase {
  final MemberRepository repository;

  UpdateMemberUseCase(this.repository);

  Future<Either<Failure, void>> call(Member member) async {
    if (member.firstName.isEmpty || member.lastName.isEmpty) {
      return const Left(
          ValidationFailure('First name and last name are required'));
    }
    return repository.updateMember(member);
  }
}
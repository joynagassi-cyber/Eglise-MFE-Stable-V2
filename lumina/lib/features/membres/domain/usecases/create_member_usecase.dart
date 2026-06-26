import 'package:dartz/dartz.dart';
import 'package:lumina/core/error/failures.dart';
import 'package:lumina/features/membres/domain/entities/member.dart';
import 'package:lumina/features/membres/domain/repositories/member_repository.dart';

class CreateMemberUseCase {
  final MemberRepository repository;

  CreateMemberUseCase(this.repository);

  Future<Either<Failure, void>> call(Member member) async {
    if (member.firstName.isEmpty || member.lastName.isEmpty) {
      return const Left(
          ValidationFailure('First name and last name are required'));
    }

    return repository.createMember(member);
  }
}
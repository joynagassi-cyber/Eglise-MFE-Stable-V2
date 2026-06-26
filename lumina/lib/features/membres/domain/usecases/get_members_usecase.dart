import 'package:dartz/dartz.dart';
import 'package:lumina/core/error/failures.dart';
import 'package:lumina/features/membres/domain/entities/member.dart';
import 'package:lumina/features/membres/domain/repositories/member_repository.dart';

class GetMembersParams {
  final String? search;
  final int page;
  final int perPage;

  const GetMembersParams({
    this.search,
    this.page = 1,
    this.perPage = 50,
  });
}

class GetMembersUseCase {
  final MemberRepository repository;

  GetMembersUseCase(this.repository);

  Future<Either<Failure, List<Member>>> call(GetMembersParams params) async {
    return repository.getMembers(
      page: params.page,
      perPage: params.perPage,
      search: params.search,
    );
  }
}
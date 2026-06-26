import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/member.dart';
import '../../domain/repositories/member_repository.dart';
import 'package:lumina/core/providers/repository_providers_profile.dart';

class GetMembersUseCase {
  final MemberRepository _repository;

  GetMembersUseCase(this._repository);

  Future<List<Member>> execute({
    int page = 1,
    int perPage = 25,
    String? search,
  }) async {
    final result = await _repository.getMembers(
      page: page,
      perPage: perPage,
      search: search,
    );
    return result.fold(
      (failure) => throw Exception(failure.message),
      (members) => members,
    );
  }
}

final getMembersUseCaseProvider = Provider<GetMembersUseCase>((ref) {
  final repository = ref.watch(memberRepositoryProvider);
  return GetMembersUseCase(repository);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/member_repository.dart';
import 'package:lumina/core/providers/repository_providers_profile.dart';

class DeleteMemberUseCase {
  final MemberRepository _repository;

  DeleteMemberUseCase(this._repository);

  Future<void> execute(String id) async {
    await _repository.deleteMember(id);
  }
}

final deleteMemberUseCaseProvider = Provider<DeleteMemberUseCase>((ref) {
  final repository = ref.watch(memberRepositoryProvider);
  return DeleteMemberUseCase(repository);
});

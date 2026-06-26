import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/member.dart';
import '../../domain/repositories/member_repository.dart';
import 'package:lumina/core/providers/repository_providers_profile.dart';

class SaveMemberUseCase {
  final MemberRepository _repository;

  SaveMemberUseCase(this._repository);

  Future<void> execute(Member member) async {
    final result = member.id.isEmpty || member.id == 'new'
        ? await _repository.createMember(member)
        : await _repository.updateMember(member);
    result.fold(
      (failure) => throw Exception(failure.message),
      (_) {},
    );
  }
}

final saveMemberUseCaseProvider = Provider<SaveMemberUseCase>((ref) {
  final repository = ref.watch(memberRepositoryProvider);
  return SaveMemberUseCase(repository);
});

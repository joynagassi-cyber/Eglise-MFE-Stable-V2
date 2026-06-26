import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/member.dart';
import '../providers/member_list_provider.dart';
import '../../domain/usecases/save_member_use_case.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import 'package:lumina/core/providers/repository_providers_profile.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/providers/auth_provider.dart';
import 'package:lumina/core/providers/user_context_provider.dart';
import '../../../../core/domain/entities/enums/audit_action.dart';

/// État du formulaire membre
class MemberFormState {
  final Member member;
  final File? selectedPhoto;
  final bool isLoading;
  final String? error;

  MemberFormState({
    required this.member,
    this.selectedPhoto,
    this.isLoading = false,
    this.error,
  });

  MemberFormState copyWith({
    Member? member,
    File? selectedPhoto,
    bool? isLoading,
    String? error,
  }) {
    return MemberFormState(
      member: member ?? this.member,
      selectedPhoto: selectedPhoto ?? this.selectedPhoto,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Contrôleur pour le formulaire de création/édition de membre
class MemberFormController
    extends AutoDisposeFamilyAsyncNotifier<MemberFormState, String?> {
  @override
  Future<MemberFormState> build(String? memberId) async {
    final churchId = ref.watch(activeChurchIdProvider);

    if (memberId != null) {
      final repository = ref.watch(memberRepositoryProvider);
      final result = await repository.getMemberById(memberId);
      final member = result.fold(
        (failure) => throw Exception(failure.message),
        (m) => m,
      );
      return MemberFormState(member: member);
    }

    return MemberFormState(
      member: Member.create(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        churchId: churchId,
        lastName: '',
        firstName: '',
      ),
    );
  }

  void updateMember(Member Function(Member) updates) {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    state = AsyncValue.data(
      currentState.copyWith(member: updates(currentState.member)),
    );
  }

  void setPhoto(File? photo) {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(selectedPhoto: photo));
  }

  Future<bool> submit() async {
    final currentState = state.valueOrNull;
    if (currentState == null) return false;

    state = AsyncValue.data(
      currentState.copyWith(isLoading: true, error: null),
    );

    try {
      final useCase = ref.read(saveMemberUseCaseProvider);
      final member = currentState.member;
      final isUpdate = member.id.isNotEmpty && !member.id.contains('temp');

      // Injecter UserContext et memberRepositoryProvider
      final userContext = ref.read(userContextNotifierProvider).value;
      if (userContext == null) throw Exception('Utilisateur non authentifié');

      final memberRepository = ref.read(memberRepositoryProvider);

      await useCase.execute(member);

      // Audit Log
      final auditMetadata = {
        'actor_name': userContext.user.email,
        'role_used': userContext.role.label,
        'dashboard_source': 'Admin', // Membre management is usually Admin
        'church_id': userContext.churchId,
      };

      await ref.read(auditRepositoryProvider).logAction(
            action: isUpdate ? AuditAction.update : AuditAction.insert,
            entityType: 'member',
            entityId: member.id,
            newData: member.toJson(),
            actorId: userContext.user.id,
            metadata: auditMetadata,
          );

      // Upload de la photo si présente
      if (currentState.selectedPhoto != null) {
        await memberRepository.uploadMemberPhoto(
          member.id,
          currentState.selectedPhoto!,
        );
      }

      ref.invalidate(memberListProvider);
      return true;
    } catch (e, stack) {
      AppLogger.e(
          'Erreur lors de la sauvegarde du membre', 'MemberForm', e, stack);
      rethrow;
    }
  }
}

final memberFormProvider = AsyncNotifierProvider.autoDispose
    .family<MemberFormController, MemberFormState, String?>(
  MemberFormController.new,
);

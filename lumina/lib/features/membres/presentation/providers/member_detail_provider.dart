import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/member.dart';
import '../../data/models/member_models.dart' hide Member;
import 'package:lumina/core/providers/repository_providers_profile.dart';
import '../../../../core/providers/auth_provider.dart';

final memberDetailProvider = FutureProvider.family<Member?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(memberRepositoryProvider);
  final result = await repository.getMemberById(id);
  return result.fold((_) => null, (member) => member);
});

final currentMemberProvider = FutureProvider<Member?>((ref) async {
  final session = ref.watch(currentSessionProvider);
  if (session == null) return null;

  // Dans le nouveau système, l'ID du membre est lié au userId
  final repository = ref.watch(memberRepositoryProvider);
  final result = await repository.getMemberByUserId(session.userId);
  return result.fold((_) => null, (member) => member);
});

final familyRelationshipsProvider =
    FutureProvider.family<List<FamilyRelationship>, String>((
  ref,
  memberId,
) async {
  final repository = ref.watch(memberRepositoryProvider);
  final result = await repository.getFamilyRelationships(memberId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (relationships) => relationships,
  );
});

final spiritualTrackingProvider =
    FutureProvider.family<SpiritualTracking?, String>((ref, memberId) async {
  final repository = ref.watch(memberRepositoryProvider);
  final result = await repository.getSpiritualTracking(memberId);
  return result.fold((_) => null, (tracking) => tracking);
});

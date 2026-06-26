import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import 'package:lumina/features/communaute/domain/entities/circle.dart';

part 'circle_controller.g.dart';

@riverpod
class CircleController extends _$CircleController {
  @override
  Future<List<Circle>> build({required String churchId}) async {
    final repo = ref.watch(circleRepositoryProvider);
    return repo.getCircles(churchId: churchId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final repo = ref.read(circleRepositoryProvider);
      return repo.getCircles(churchId: churchId);
    });
  }

  Future<void> createCircle(Circle circle) async {
    final repo = ref.read(circleRepositoryProvider);
    await repo.createCircle(circle);
    ref.invalidateSelf();
  }

  Future<void> updateCircle(Circle circle) async {
    final repo = ref.read(circleRepositoryProvider);
    await repo.updateCircle(circle);
    ref.invalidateSelf();
  }

  Future<void> deleteCircle(String id) async {
    final repo = ref.read(circleRepositoryProvider);
    await repo.deleteCircle(id);
    ref.invalidateSelf();
  }

  Future<void> addMember({
    required String circleId,
    required String memberId,
    String role = 'member',
  }) async {
    final repo = ref.read(circleRepositoryProvider);
    await repo.addMemberToCircle(
      circleId: circleId,
      memberId: memberId,
      role: role,
    );
    ref.invalidateSelf();
  }

  Future<void> removeMember({
    required String circleId,
    required String memberId,
  }) async {
    final repo = ref.read(circleRepositoryProvider);
    await repo.removeMemberFromCircle(
      circleId: circleId,
      memberId: memberId,
    );
    ref.invalidateSelf();
  }
}

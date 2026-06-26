import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/prayer_vigil.dart';
import '../../domain/entities/permanent_prayer_subject.dart';
import '../../domain/repositories/intercession_repository.dart';
import '../../data/repositories/intercession_repository_impl.dart';
import '../../../../../core/services/offline_sync_manager.dart';
import '../../../../../core/data/local/isar_service.dart';

part 'intercession_providers.g.dart';

@riverpod
IntercessionRepository intercessionRepository(IntercessionRepositoryRef ref) {
  return IntercessionRepositoryImpl(
    Supabase.instance.client,
    ref.watch(isarServiceProvider),
    ref.watch(offlineSyncManagerProvider),
  );
}

@riverpod
class PrayerVigilsNotifier extends _$PrayerVigilsNotifier {
  @override
  Future<List<PrayerVigil>> build(String groupId) async {
    final repo = ref.watch(intercessionRepositoryProvider);
    final result = await repo.getPrayerVigils(groupId);
    return result.fold(
      (l) => throw Exception(l.message),
      (r) => r,
    );
  }

  Future<void> addVigil(PrayerVigil vigil) async {
    state = const AsyncValue.loading();
    final result =
        await ref.read(intercessionRepositoryProvider).createPrayerVigil(vigil);
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) => ref.invalidateSelf(),
    );
  }
}

@riverpod
class PermanentPrayerSubjectsNotifier
    extends _$PermanentPrayerSubjectsNotifier {
  @override
  Future<List<PermanentPrayerSubject>> build(String groupId) async {
    final repo = ref.watch(intercessionRepositoryProvider);
    final result = await repo.getPermanentPrayerSubjects(groupId);
    return result.fold(
      (l) => throw Exception(l.message),
      (r) => r,
    );
  }

  Future<void> addSubject(PermanentPrayerSubject subject) async {
    state = const AsyncValue.loading();
    final result = await ref
        .read(intercessionRepositoryProvider)
        .createPermanentPrayerSubject(subject);
    result.fold(
      (l) => state = AsyncValue.error(l, StackTrace.current),
      (r) => ref.invalidateSelf(),
    );
  }
}

@riverpod
class IntercessionKpisNotifier extends _$IntercessionKpisNotifier {
  @override
  Future<Map<String, dynamic>> build(String groupId) async {
    final vigilsAsync = ref.watch(prayerVigilsNotifierProvider(groupId));
    final subjectsAsync =
        ref.watch(permanentPrayerSubjectsNotifierProvider(groupId));

    if (vigilsAsync is AsyncData && subjectsAsync is AsyncData) {
      final vigils = vigilsAsync.value!;
      final subjects = subjectsAsync.value!;

      final totalVigils = vigils.length;
      final activeSubjects = subjects.where((s) => s.isActive).length;
      final totalParticipants =
          vigils.fold(0, (sum, v) => sum + v.participantsCount);
      final ongoingVigilCount =
          vigils.where((v) => v.status == 'ongoing').length;

      return {
        'totalVigils': totalVigils,
        'activeSubjects': activeSubjects,
        'totalParticipants': totalParticipants,
        'ongoingVigils': ongoingVigilCount,
      };
    }

    return {
      'totalVigils': 0,
      'activeSubjects': 0,
      'totalParticipants': 0,
      'ongoingVigils': 0,
    };
  }
}
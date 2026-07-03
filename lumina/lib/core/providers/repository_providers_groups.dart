import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lumina/core/data/local/isar_service.dart';
import 'package:lumina/core/providers/supabase_provider.dart';
import 'package:lumina/core/services/offline_sync_manager.dart';
import 'package:lumina/features/groups/data/repositories/group_repository_impl.dart';
import 'package:lumina/features/groups/domain/repositories/i_group_repository.dart';
import 'package:lumina/features/groups/chorale/data/repositories/chorale_repository_impl.dart';
import 'package:lumina/features/groups/chorale/domain/repositories/chorale_repository.dart';
import 'package:lumina/features/groups/femmes/data/repositories/femmes_repository_impl.dart';
import 'package:lumina/features/groups/femmes/domain/repositories/femmes_repository.dart';
import 'package:lumina/features/groups/hommes/data/repositories/hommes_repository_impl.dart';
import 'package:lumina/features/groups/hommes/domain/repositories/hommes_repository.dart';
import 'package:lumina/features/groups/jeunesse/data/repositories/camp_repository_impl.dart';
import 'package:lumina/features/groups/jeunesse/data/repositories/discipleship_repository_impl.dart';

part 'repository_providers_groups.g.dart';

@Riverpod(keepAlive: true)
IGroupRepository groupRepository(GroupRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final isar = ref.watch(isarServiceProvider);
  final syncManager = ref.watch(offlineSyncManagerProvider);
  return GroupRepositoryImpl(supabase, isar, syncManager, ref);
}

@Riverpod(keepAlive: true)
ChoraleRepository choraleRepository(ChoraleRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final isar = ref.watch(isarServiceProvider);
  final syncManager = ref.watch(offlineSyncManagerProvider);
  return ChoraleRepositoryImpl(supabase, isar, syncManager);
}

@Riverpod(keepAlive: true)
HommesRepository hommesRepository(HommesRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final isar = ref.watch(isarServiceProvider);
  final syncManager = ref.watch(offlineSyncManagerProvider);
  return HommesRepositoryImpl(supabase, isar, syncManager);
}

@Riverpod(keepAlive: true)
FemmesRepository femmesRepository(FemmesRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final isar = ref.watch(isarServiceProvider);
  final syncManager = ref.watch(offlineSyncManagerProvider);
  return FemmesRepositoryImpl(supabase, isar, syncManager);
}

@Riverpod(keepAlive: true)
CampRepositoryImpl campRepository(CampRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final isar = ref.watch(isarServiceProvider);
  final syncManager = ref.watch(offlineSyncManagerProvider);
  return CampRepositoryImpl(supabase, isar, syncManager);
}

@Riverpod(keepAlive: true)
DiscipleshipRepositoryImpl discipleshipRepository(
  DiscipleshipRepositoryRef ref,
) {
  final supabase = ref.watch(supabaseProvider);
  final isar = ref.watch(isarServiceProvider);
  final syncManager = ref.watch(offlineSyncManagerProvider);
  return DiscipleshipRepositoryImpl(supabase, isar, syncManager);
}

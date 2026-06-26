import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/supabase_provider.dart';
import '../../../../core/data/local/isar_service.dart';
import '../../../../core/services/offline_sync_manager.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/i_task_repository.dart';
import '../../data/repositories/task_repository_impl.dart';

part 'tasks_provider.g.dart';

@Riverpod(keepAlive: true)
ITaskRepository taskRepository(TaskRepositoryRef ref) {
  final client = ref.watch(supabaseClientProvider);
  final isar = ref.watch(isarServiceProvider);
  final syncManager = ref.watch(offlineSyncManagerProvider);

  return TaskRepositoryImpl(client, isar, syncManager);
}

@riverpod
Future<Task?> task(TaskRef ref, String id) {
  return ref.watch(taskRepositoryProvider).getTaskById(id);
}

@riverpod
Stream<List<Task>> watchTasks(WatchTasksRef ref,
    {TaskType? type, String? groupId, String? assignedToId}) {
  final repository = ref.watch(taskRepositoryProvider);
  // churchId normally comes from a global provider like activeChurchIdProvider
  // but for broad scope we might skip or use null.
  return repository.watchTasks(
      type: type, groupId: groupId, assignedToId: assignedToId);
}

@riverpod
class TasksController extends _$TasksController {
  @override
  FutureOr<void> build() {}

  Future<void> createTask(Task task) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () async => await ref.read(taskRepositoryProvider).createTask(task));
  }

  Future<void> updateTask(Task task) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () async => await ref.read(taskRepositoryProvider).updateTask(task));
  }

  Future<void> deleteTask(String id, {String? churchId}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async => await ref
        .read(taskRepositoryProvider)
        .deleteTask(id, churchId: churchId));
  }

  Future<void> markCompleted(Task task) async {
    final updated = task.copyWith(
      status: TaskStatus.completed,
      completionPercent: 100,
      completedAt: DateTime.now(),
    );
    await updateTask(updated);
  }
}

@riverpod
Stream<List<Task>> memberTasks(MemberTasksRef ref, String memberId) {
  return ref.watch(taskRepositoryProvider).watchTasks(assignedToId: memberId);
}
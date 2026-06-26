import '../entities/task.dart';

abstract class ITaskRepository {
  Future<List<Task>> getTasks({
    String? churchId,
    TaskType? type,
    TaskStatus? status,
    String? assignedToId,
    String? groupId,
  });

  Future<Task?> getTaskById(String id);

  Future<Task> createTask(Task task);

  Future<Task> updateTask(Task task);

  Future<void> deleteTask(String id, {String? churchId});

  Stream<List<Task>> watchTasks({
    String? churchId,
    TaskType? type,
    String? groupId,
    String? assignedToId,
  });

  Future<List<Task>> getOverdueTasks({String? churchId});

  Future<List<Task>> getUpcomingTasks({String? churchId, int days = 7});
}
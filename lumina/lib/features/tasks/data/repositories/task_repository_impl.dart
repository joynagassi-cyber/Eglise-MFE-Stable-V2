import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/data/local/isar_service.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/services/offline_sync_manager.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/i_task_repository.dart';
import '../models/task_model.dart';
import '../../../../core/utils/app_date_time.dart';

class TaskRepositoryImpl implements ITaskRepository {
  final SupabaseClient _client;
  final IsarService _isar;
  final OfflineSyncManager _syncManager;

  TaskRepositoryImpl(this._client, this._isar, this._syncManager);

  @override
  Future<List<Task>> getTasks({
    String? churchId,
    TaskType? type,
    TaskStatus? status,
    String? assignedToId,
    String? groupId,
  }) async {
    try {
      if (_isar.isReady) {
        final localModels = await _isar.taskModels.where().findAll();
        if (localModels.isNotEmpty) {
          var tasks = localModels.map((m) => m.toDomain()).toList();

          if (churchId != null) {
            tasks = tasks.where((t) => t.churchId == churchId).toList();
          }
          if (type != null) {
            tasks = tasks.where((t) => t.type == type).toList();
          }
          if (status != null) {
            tasks = tasks.where((t) => t.status == status).toList();
          }
          if (assignedToId != null) {
            tasks = tasks.where((t) => t.assignedToId == assignedToId).toList();
          }
          if (groupId != null) {
            tasks = tasks.where((t) => t.groupId == groupId).toList();
          }
          return tasks;
        }
      }

      var query = _client.from('tasks').select();

      if (churchId != null) query = query.eq('church_id', churchId);
      if (type != null) query = query.eq('type', type.name.toUpperCase());
      if (status != null) query = query.eq('status', status.name.toUpperCase());
      if (assignedToId != null) query = query.eq('assignee_id', assignedToId);
      if (groupId != null) query = query.eq('group_id', groupId);

      final records = await query.order('created_at', ascending: false);
      final tasks = records.map(_mapRecordToDomain).toList();

      if (_isar.isReady) {
        await _saveTasksToLocal(tasks);
      }
      return tasks;
    } catch (e) {
      if (_isar.isReady) {
        final localModels = await _isar.taskModels.where().findAll();
        var tasks = localModels.map((m) => m.toDomain()).toList();
        if (type != null) {
          tasks = tasks.where((t) => t.type == type).toList();
        }
        if (status != null) {
          tasks = tasks.where((t) => t.status == status).toList();
        }
        if (assignedToId != null) {
          tasks = tasks.where((t) => t.assignedToId == assignedToId).toList();
        }
        if (groupId != null) {
          tasks = tasks.where((t) => t.groupId == groupId).toList();
        }
        return tasks;
      }
      return [];
    }
  }

  @override
  Future<Task?> getTaskById(String id) async {
    if (_isar.isReady) {
      final localModel =
          await _isar.taskModels.filter().idEqualTo(id).findFirst();
      if (localModel != null) return localModel.toDomain();
    }

    try {
      final record =
          await _client.from('tasks').select().eq('id', id).maybeSingle();
      if (record == null) return null;
      final task = _mapRecordToDomain(record);

      if (_isar.isReady) {
        await _isar.saveTask(TaskModel.fromDomain(task));
      }
      return task;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Task> createTask(Task task) async {
    final model = TaskModel.fromDomain(task)
      ..lastSyncedAt = AppDateTime.nowUtc();

    if (_isar.isReady) {
      await _isar.saveTask(model);
    }

    try {
      final body = _taskToJson(task);
      body['id'] = task.id;

      await _client.from('tasks').insert(body);

      if (_isar.isReady) {
        model.lastSyncedAt = AppDateTime.nowUtc();
        await _isar.saveTask(model);
      }
      return task;
    } catch (e) {
      if (_isar.isReady) {
        AppLogger.w(
            'Failed to sync create task, queuing offline action', 'TASK_REPO');
        await _syncManager.registerAction(
          entityType: 'tasks',
          action: 'INSERT',
          payload: _taskToJson(task),
          recordId: task.id,
          churchId: task.churchId ?? '',
        );
      }
      return task;
    }
  }

  @override
  Future<Task> updateTask(Task task) async {
    final model = TaskModel.fromDomain(task)
      ..lastSyncedAt = AppDateTime.nowUtc();

    if (_isar.isReady) {
      await _isar.saveTask(model);
    }

    try {
      final body = _taskToJson(task);
      var query = _client.from('tasks').update(body).eq('id', task.id);
      if (task.churchId != null) query = query.eq('church_id', task.churchId!);
      await query;

      if (_isar.isReady) {
        model.lastSyncedAt = AppDateTime.nowUtc();
        await _isar.saveTask(model);
      }
      return task;
    } catch (e) {
      if (_isar.isReady) {
        AppLogger.w(
            'Failed to sync update task, queuing offline action', 'TASK_REPO');
        await _syncManager.registerAction(
          entityType: 'tasks',
          action: 'UPDATE',
          payload: _taskToJson(task),
          recordId: task.id,
          churchId: task.churchId ?? '',
        );
      }
      return task;
    }
  }

  @override
  Future<void> deleteTask(String id, {String? churchId}) async {
    if (_isar.isReady) {
      final localModel =
          await _isar.taskModels.filter().idEqualTo(id).findFirst();
      if (localModel != null) {
        await _isar.deleteTask(localModel.isarId);
      }
    }

    try {
      var query = _client.from('tasks').delete().eq('id', id);
      if (churchId != null) query = query.eq('church_id', churchId);
      await query;
    } catch (e) {
      if (_isar.isReady) {
        AppLogger.w(
            'Failed to sync delete task, queuing offline action', 'TASK_REPO');
        await _syncManager.registerAction(
          entityType: 'tasks',
          action: 'DELETE',
          payload: {'id': id},
          recordId: id,
          churchId: churchId ?? '',
        );
      }
    }
  }

  @override
  Stream<List<Task>> watchTasks({
    String? churchId,
    TaskType? type,
    String? groupId,
    String? assignedToId,
  }) async* {
    if (!_isar.isReady) {
      dynamic query = _client.from('tasks').stream(primaryKey: ['id']);
      if (churchId != null) query = query.eq('church_id', churchId);

      yield* query.map((records) {
        var tasks = records.map(_mapRecordToDomain).toList();
        if (groupId != null) {
          tasks = tasks.where((t) => t.groupId == groupId).toList();
        }
        if (type != null) {
          tasks = tasks.where((t) => t.type == type).toList();
        }
        if (assignedToId != null) {
          tasks = tasks.where((t) => t.assignedToId == assignedToId).toList();
        }
        _sortTasks(tasks);
        return tasks;
      });
      return;
    }

    yield* _isar.taskModels.where().watch(fireImmediately: true).map((models) {
      var tasks = models.map((m) => m.toDomain()).toList();
      if (churchId != null) {
        tasks = tasks.where((t) => t.churchId == churchId).toList();
      }
      if (type != null) {
        tasks = tasks.where((t) => t.type == type).toList();
      }
      if (groupId != null) {
        tasks = tasks.where((t) => t.groupId == groupId).toList();
      }
      if (assignedToId != null) {
        tasks = tasks.where((t) => t.assignedToId == assignedToId).toList();
      }
      _sortTasks(tasks);
      return tasks;
    });
  }

  void _sortTasks(List<Task> tasks) {
    tasks.sort((a, b) {
      if (a.status != b.status) {
        return a.status.index.compareTo(b.status.index); // Pending first
      }
      if (a.dueDate != null && b.dueDate != null) {
        return a.dueDate!.compareTo(b.dueDate!);
      }
      return 0;
    });
  }

  @override
  Future<List<Task>> getOverdueTasks({String? churchId}) async {
    final now = AppDateTime.nowUtc();
    return (await getTasks(churchId: churchId))
        .where((t) =>
            t.dueDate != null &&
            t.dueDate!.isBefore(now) &&
            t.status != TaskStatus.completed)
        .toList();
  }

  @override
  Future<List<Task>> getUpcomingTasks({String? churchId, int days = 7}) async {
    final now = AppDateTime.nowUtc();
    final end = now.add(Duration(days: days));
    return (await getTasks(churchId: churchId))
        .where((t) =>
            t.dueDate != null &&
            t.dueDate!.isAfter(now) &&
            t.dueDate!.isBefore(end))
        .toList();
  }

  Task _mapRecordToDomain(Map<String, dynamic> record) {
    return Task.fromJson(record);
  }

  Map<String, dynamic> _taskToJson(Task task) {
    return task.toJson();
  }

  Future<void> _saveTasksToLocal(List<Task> tasks) async {
    if (!_isar.isReady) return;
    await _isar.db.writeTxn(() async {
      for (var t in tasks) {
        await _isar.taskModels.put(TaskModel.fromDomain(t));
      }
    });
  }
}

extension IsarTaskHelper on IsarService {
  Future<void> saveTask(TaskModel task) async {
    if (!isReady) return;
    await db.writeTxn(() async {
      await taskModels.put(task);
    });
  }

  Future<void> deleteTask(Id id) async {
    if (!isReady) return;
    await db.writeTxn(() async {
      await taskModels.delete(id);
    });
  }
}
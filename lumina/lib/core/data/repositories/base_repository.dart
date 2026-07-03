import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../local/isar_service.dart';
import '../../utils/retry_helper.dart';
import '../../utils/supabase_extensions.dart';
import '../../performance/performance_monitor.dart';

/// Repository de base avec fonctionnalités communes
abstract class BaseRepository<T> {
  final SupabaseClient supabase;
  final IsarService isar;
  final Ref ref;

  BaseRepository(this.supabase, this.isar, this.ref);

  String get tableName;
  T fromJson(Map<String, dynamic> json);

  Future<List<T>> getAll({int page = 1, int perPage = 50}) async {
    return PerformanceMonitor().measureAsync(
      'db_get_all',
      () => RetryHelper.withRetry(
        operation: () async {
          var query = supabase.from(tableName).select().scoped(ref);

          final start = (page - 1) * perPage;
          final response =
              await query.range(start, start + perPage - 1).withTimeout();

          return (response as List)
              .map((e) => fromJson(e as Map<String, dynamic>))
              .toList();
        },
      ),
      metadata: {'table': tableName},
    );
  }

  Future<T> getById(String id) async {
    return PerformanceMonitor().measureAsync(
      'db_get_by_id',
      () => RetryHelper.withRetry(
        operation: () async {
          var query = supabase.from(tableName).select().eq('id', id).scoped(ref);
          final record = await query.single().withTimeout();
          return fromJson(record);
        },
      ),
      metadata: {'table': tableName},
    );
  }

  Future<void> create(Map<String, dynamic> data) async {
    return PerformanceMonitor().measureAsync(
      'db_create',
      () => RetryHelper.withRetry(
        operation: () async {
          await supabase.from(tableName).insertScoped(ref, values: data).withTimeout();
        },
      ),
      metadata: {'table': tableName},
    );
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    return PerformanceMonitor().measureAsync(
      'db_update',
      () => RetryHelper.withRetry(
        operation: () async {
          var query = supabase.from(tableName).update(data).eq('id', id);
          query = query.scoped(ref);
          await query.withTimeout();
        },
      ),
      metadata: {'table': tableName},
    );
  }

  Future<void> delete(String id) async {
    return PerformanceMonitor().measureAsync(
      'db_delete',
      () => RetryHelper.withRetry(
        operation: () async {
          var query = supabase.from(tableName).delete().eq('id', id);
          query = query.scoped(ref);
          await query.withTimeout();
        },
      ),
      metadata: {'table': tableName},
    );
  }
}

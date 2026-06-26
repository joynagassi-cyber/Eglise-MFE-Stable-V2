import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/local/isar_service.dart';
import '../services/offline_sync_manager.dart';
import '../logging/app_logger.dart';

part 'system_health_check.g.dart';

@riverpod
class SystemHealthCheck extends _$SystemHealthCheck {
  @override
  Future<Map<String, bool>> build() async {
    return checkAll();
  }

  Future<Map<String, bool>> checkAll() async {
    final results = <String, bool>{};

    // 1. Check Supabase Connectivity
    try {
      final supabase = Supabase.instance.client;
      await supabase.from('churches').select('id').limit(1);
      results['supabase'] = true;
    } catch (e) {
      results['supabase'] = false;
      AppLogger.e('HealthCheck: Supabase unreachable', 'OMEGA', e);
    }

    // 2. Check Isar
    try {
      final isar = ref.read(isarServiceProvider);
      await isar.memberModels.count();
      results['isar'] = true;
    } catch (e) {
      results['isar'] = false;
      AppLogger.e('HealthCheck: Isar error', 'OMEGA', e);
    }

    // 3. Check Sync Queue
    try {
      ref.read(offlineSyncManagerProvider);
      // Simple check if provider is alive or queue can be read
      results['sync_queue'] = true;
    } catch (e) {
      results['sync_queue'] = false;
    }

    return results;
  }
}

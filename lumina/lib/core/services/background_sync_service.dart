import 'package:workmanager/workmanager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumina/core/data/local/isar_service.dart';
import 'package:lumina/core/services/offline_sync_manager.dart';
import 'package:lumina/core/logging/app_logger.dart';

class BackgroundSyncService {
  static const _syncTaskName = 'sync_queue_task';
  static const _syncFrequency = Duration(minutes: 15);

  static void initialize() {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );

    Workmanager().registerPeriodicTask(
      _syncTaskName,
      _syncTaskName,
      frequency: _syncFrequency,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );

    AppLogger.i('Background sync initialized (every 15min)', 'BG_SYNC');
  }

  static void cancelAll() {
    Workmanager().cancelAll();
    AppLogger.i('Background sync cancelled', 'BG_SYNC');
  }

  static Future<void> triggerManualSync() async {
    await Workmanager().registerOneOffTask(
      'manual_sync',
      _syncTaskName,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      AppLogger.i('Background sync started', 'BG_SYNC');

      // 1. Charger l'environnement
      await dotenv.load(fileName: ".env");
      final url = dotenv.env['SUPABASE_URL'];
      final key = dotenv.env['SUPABASE_ANON_KEY'];

      if (url == null || key == null) {
        throw Exception('Missing Supabase configuration in background isolate');
      }

      // 2. Initialiser Supabase et Isar
      await Supabase.initialize(url: url, anonKey: key);
      final isarService = await IsarService.init();

      // 3. Exécuter la synchronisation
      await OfflineSyncManager.syncItemsStandalone(
        Supabase.instance.client,
        isarService,
      );

      AppLogger.i('Background sync completed', 'BG_SYNC');
      return true;
    } catch (e, st) {
      AppLogger.e('Background sync failed', 'BG_SYNC', e, st);
      return false;
    }
  });
}

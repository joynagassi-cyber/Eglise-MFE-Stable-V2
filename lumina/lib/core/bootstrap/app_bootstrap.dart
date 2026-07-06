import 'dart:async';

import 'package:lumina/core/api/supabase_service.dart';
import 'package:lumina/core/config/image_cache_config.dart';
import 'package:lumina/core/data/local/isar_service.dart';
import 'package:lumina/core/logging/app_logger.dart';
import 'package:lumina/core/logging/error_reporter.dart';
import 'package:lumina/core/services/offline_sync_manager.dart';
import 'package:lumina/core/services/push_notification_service.dart';
import 'package:lumina/core/services/system_permissions_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lumina/core/providers/shared_preferences_provider.dart';

typedef DotEnvLoader = Future<void> Function(String fileName);
typedef EnvReader = String? Function(String key);
typedef SupabaseInitializer = Future<Object?> Function({
  required String url,
  required String anonKey,
  required bool debug,
});
typedef IsarInitializer = Future<IsarService> Function();
typedef DelayFn = Future<void> Function(Duration duration);

class AppBootstrapResult {
  final ProviderContainer container;
  final IsarService isarService;
  final SharedPreferences sharedPreferences;

  const AppBootstrapResult({
    required this.container,
    required this.isarService,
    required this.sharedPreferences,
  });
}

class AppBootstrap {
  static Future<AppBootstrapResult> initialize({
    required String loggerTag,
    required String dotenvFileName,
    required bool debugSupabase,
    Duration? dotenvTimeout,
    Duration loggerTimeout = const Duration(seconds: 5),
    Duration criticalInitTimeout = const Duration(seconds: 15),
    int maxAttempts = 3,
    void Function()? setupGlobalErrorHandlers,
    Future<void> Function()? initLogger,
    void Function()? configureImageCache,
    DotEnvLoader? loadDotEnv,
    EnvReader? readEnv,
    SupabaseInitializer? initSupabase,
    IsarInitializer? initIsar,
    DelayFn? delay,
  }) async {
    (setupGlobalErrorHandlers ?? ErrorReporter.instance.setupGlobalHandlers)();
    await (initLogger ?? AppLogger.instance.initialize)(timeout: loggerTimeout);
    (configureImageCache ?? ImageCacheConfig.configure)();

    // ─── 1. Charger les variables d'environnement ─────────────────────────────
    // Priority: --dart-define (compile-time) > flutter_dotenv (runtime .env file)
    // This allows CI to inject secrets via --dart-define without needing a .env file.
    String? getEnv(String key) {
      // First, try compile-time dart-define (set by CI via --dart-define)
      final dartDefine = const String.fromEnvironment(key);
      if (dartDefine.isNotEmpty) return dartDefine;
      // Fallback: runtime dotenv (local dev with .env file)
      return (readEnv ?? (k) => dotenv.env[k])(key);
    }

    // Load dotenv file for local development (silently fails if file doesn't exist)
    try {
      final dotenvLoader = loadDotEnv ?? (fileName) => dotenv.load(fileName: fileName);
      if (dotenvTimeout != null) {
        await dotenvLoader(dotenvFileName).timeout(dotenvTimeout);
      } else {
        await dotenvLoader(dotenvFileName);
      }
    } catch (e) {
      // .env file not found — OK in CI mode where --dart-define provides everything
      AppLogger.d('No .env file found (expected in CI mode)', 'APP_BOOTSTRAP');
    }

    final supabaseUrl = getEnv('SUPABASE_URL');
    final supabaseAnonKey = getEnv('SUPABASE_ANON_KEY');

    if (supabaseUrl == null || supabaseAnonKey == null) {
      throw Exception(
        'Configuration Supabase manquante. '
        'Fournir SUPABASE_URL et SUPABASE_ANON_KEY via --dart-define ou le fichier $dotenvFileName.',
      );
    }

    final supabaseInitializer = initSupabase ??
        ({
          required String url,
          required String anonKey,
          required bool debug,
        }) {
          return Supabase.initialize(
            url: url,
            anonKey: anonKey,
            debug: debug,
            authOptions: const FlutterAuthClientOptions(
              authFlowType: AuthFlowType.pkce,
            ),
          );
        };
    final isarInitializer = initIsar ?? IsarService.init;
    final delayFn = delay ?? (duration) => Future.delayed(duration);

    IsarService? isarService;
    SharedPreferences? prefs;
    var attempt = 0;
    while (attempt < maxAttempts && isarService == null) {
      attempt++;
      try {
        final initResults = await Future.wait<Object?>([
          supabaseInitializer(
            url: supabaseUrl,
            anonKey: supabaseAnonKey,
            debug: debugSupabase,
          ),
          isarInitializer(),
          SharedPreferences.getInstance(),
        ]).timeout(criticalInitTimeout);
        isarService = initResults[1] as IsarService;
        prefs = initResults[2] as SharedPreferences;
      } catch (e) {
        if (attempt >= maxAttempts) {
          rethrow;
        }

        AppLogger.w(
          'Init attempt $attempt failed, retrying in ${attempt * 2}s...',
          loggerTag,
        );
        await delayFn(Duration(seconds: attempt * 2));
      }
    }

    if (isarService == null || prefs == null) {
      throw Exception('Initialization failed');
    }

    final container = ProviderContainer(
      overrides: [
        isarServiceProvider.overrideWithValue(isarService),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );

    return AppBootstrapResult(
      container: container,
      isarService: isarService,
      sharedPreferences: prefs,
    );
  }

  static Future<void> initializeSecondaryServices(
    ProviderContainer container, {
    required String loggerTag,
    bool requestSystemPermissions = false,
    Duration permissionsTimeout = const Duration(seconds: 5),
    Duration supabaseServiceTimeout = const Duration(seconds: 10),
    Duration offlineSyncTimeout = const Duration(seconds: 5),
    Duration pushNotificationTimeout = const Duration(seconds: 5),
  }) async {
    try {
      if (requestSystemPermissions) {
        await container
            .read(systemPermissionsServiceProvider)
            .requestAllPermissions()
            .timeout(
          permissionsTimeout,
          onTimeout: () {
            AppLogger.w('System permissions request timed out', loggerTag);
          },
        );
      }

      await container.read(supabaseServiceProvider.future).timeout(
        supabaseServiceTimeout,
        onTimeout: () {
          AppLogger.w('Supabase initialization timed out', loggerTag);
          return Supabase.instance.client;
        },
      );

      await Future.wait(
        [
          container.read(offlineSyncManagerProvider).initialize().timeout(
            offlineSyncTimeout,
            onTimeout: () {
              AppLogger.w(
                'Offline sync manager initialization timed out',
                loggerTag,
              );
            },
          ),
          container.read(pushNotificationServiceProvider).initialize().timeout(
            pushNotificationTimeout,
            onTimeout: () {
              AppLogger.w(
                'Push notification service initialization timed out',
                loggerTag,
              );
            },
          ),
        ],
        eagerError: false,
      );
    } catch (e, stack) {
      AppLogger.e(
        'Secondary services initialization failed: $e',
        loggerTag,
        e,
        stack,
      );
    }
  }
}

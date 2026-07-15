import 'dart:async';
import 'package:lumina/core/bootstrap/app_bootstrap.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/logging/app_logger.dart';
import 'core/performance/performance_monitor.dart';
import 'core/widgets/restoration_wrapper.dart';

void main() async {
  // Ensure Flutter is ready
  WidgetsFlutterBinding.ensureInitialized();

  // Start performance monitoring early
  PerformanceMonitor().startMonitoring();

  // Screen orientation & System UI
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  try {
    // Les secrets CI sont injectés via --dart-define (compile-time).
    // Ils prennent priorité sur le fichier .env local.
    const ciSupabaseUrl = String.fromEnvironment('SUPABASE_URL');
    const ciSupabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    const ciGoogleWebClientId =
        String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');

    final bootstrap = await AppBootstrap.initialize(
      loggerTag: 'PROD',
      dotenvFileName: '.env',
      debugSupabase: false,
      dotenvTimeout: const Duration(seconds: 5),
      ciSupabaseUrl: ciSupabaseUrl.isNotEmpty ? ciSupabaseUrl : null,
      ciSupabaseAnonKey: ciSupabaseAnonKey.isNotEmpty ? ciSupabaseAnonKey : null,
      ciGoogleWebClientId:
          ciGoogleWebClientId.isNotEmpty ? ciGoogleWebClientId : null,
    );

    // Async secondary services
    unawaited(AppBootstrap.initializeSecondaryServices(
      bootstrap.container,
      loggerTag: 'PROD',
    ));

    AppLogger.i('Starting application...', 'PROD');

    // Sentry & App Launch
    // Priority: --dart-define (compile-time) > dotenv (runtime)
    const environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'production');
    const sentryDsn = String.fromEnvironment('SENTRY_DSN', defaultValue: '');

    if (sentryDsn.isNotEmpty) {
      await SentryFlutter.init(
        (options) {
          options.dsn = sentryDsn;
          options.environment = environment;
          options.tracesSampleRate = 0.2;
        },
        appRunner: () => runApp(
          UncontrolledProviderScope(
            container: bootstrap.container,
            child: const RestorationWrapper(child: LuminaApp()),
          ),
        ),
      );
    } else {
      runApp(
        UncontrolledProviderScope(
          container: bootstrap.container,
          child: const RestorationWrapper(child: LuminaApp()),
        ),
      );
    }

    // Performance recording
    final startupTime = PerformanceMonitor().coldStartupMs;
    AppLogger.i(
        'Application started successfully in ${startupTime}ms', 'PROD');

    PerformanceMonitor().recordColdStartup();
    PerformanceMonitor().startFrameMonitoring();
  } catch (e, stack) {
    AppLogger.f('FATAL STARTUP ERROR', 'PROD', e, stack);
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: _ProductionInitErrorScreen(error: e.toString()),
      ),
    );
    return;
  }
}

class _ProductionInitErrorScreen extends StatelessWidget {
  final String error;
  const _ProductionInitErrorScreen({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded,
                size: 64,
                color: context.colors.errorText,
              ),
              SizedBox(height: 16),
              Text(
                'Erreur de démarrage critique',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              SelectableText(error, textAlign: TextAlign.center),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text('Quitter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LuminaApp extends ConsumerWidget {
  const LuminaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Lumina',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      restorationScopeId: 'app',
    );
  }
}

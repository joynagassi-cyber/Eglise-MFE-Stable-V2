// lib/main.dart
//
// Initialisation Simplifiée & Sécurisée — Refonte Auth 2026
// Gère l'initialisation de Supabase, Isar et des services avec Retry Logic.

import 'dart:async';
import 'package:lumina/core/bootstrap/app_bootstrap.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lumina/l10n/app_localizations.dart';

import 'core/theme/app_theme.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'core/router/app_router.dart';
import 'core/providers/theme_provider.dart';
import 'core/services/app_lifecycle_service.dart';
import 'core/widgets/connectivity_banner.dart';

// Widget racine permettant de relancer l'app sans quitter le processus.
// Utilise par _BootstrapErrorApp pour le bouton REESSAYER.
class _RestartWidget extends StatefulWidget {
  final Widget child;
  const _RestartWidget({required this.child});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  State<_RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<_RestartWidget> {
  Key _key = UniqueKey();

  void restartApp() => setState(() => _key = UniqueKey());

  @override
  Widget build(BuildContext context) =>
      KeyedSubtree(key: _key, child: widget.child);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Localisation & Image Cache
  await initializeDateFormatting('fr_FR', null);
  Intl.defaultLocale = 'fr_FR';

  try {
    // 2. Firebase Init
    await Firebase.initializeApp();

    final bootstrap = await AppBootstrap.initialize(
      loggerTag: 'MAIN',
      dotenvFileName: '.env',
      debugSupabase: kDebugMode,
    );

    // 3. Secondary Services (Non-blocking)
    unawaited(AppBootstrap.initializeSecondaryServices(
      bootstrap.container,
      loggerTag: 'MAIN',
      requestSystemPermissions: true,
    ));

    // 4. Run App
    runApp(
      _RestartWidget(
        child: UncontrolledProviderScope(
          container: bootstrap.container,
          child: const MyApp(),
        ),
      ),
    );
  } catch (e) {
    debugPrint('CRITICAL BOOTSTRAP FAILURE: $e');
    runApp(_RestartWidget(child: _BootstrapErrorApp(error: e.toString())));
    return;
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Lumina',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        return AppLifecycleObserver(
          child: ConnectivityBanner(
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}

class _BootstrapErrorApp extends StatelessWidget {
  final String error;
  const _BootstrapErrorApp({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: Scaffold(
        backgroundColor: context.colors.bgPageDark,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bolt_rounded,
                    size: 80, color: context.colors.brandPrimary),
                SizedBox(height: AppSpacing.lg),
                Text(
                  'Échec de l\'initialisation',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors
                        .white, // Gardé blanc pour contraste sur fond sombre Bootstrap
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                SizedBox(height: AppSpacing.xxl),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () => _RestartWidget.restartApp(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.brandPrimary,
                      foregroundColor: context.colors.textOnBrand,
                    ),
                    child: Text('RÉESSAYER'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// lib/core/providers/theme_provider.dart
//
// Provider Riverpod pour la gestion du thème Lumina.
// Persistance via SharedPreferences (déjà dans le pubspec).
//
// CHANGELOG:
//   - FEAT: création initiale pour le support dark/light mode dynamique

import 'package:flutter/material.dart' as flutter show ThemeMode;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logging/app_logger.dart';

part 'theme_provider.g.dart';

@Riverpod(keepAlive: true)
class ThemeMode extends _$ThemeMode {
  static const _key = 'lumina_theme_mode';

  @override
  flutter.ThemeMode build() {
    _init();
    return flutter.ThemeMode.system;
  }

  Future<void> _init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_key);

      state = switch (saved) {
        'dark' => flutter.ThemeMode.dark,
        'light' => flutter.ThemeMode.light,
        _ => flutter.ThemeMode.system,
      };

      AppLogger.i('Theme initialized: ${state.name}', 'THEME');
    } catch (e) {
      AppLogger.e('Failed to load theme preference', 'THEME', e);
      state = flutter.ThemeMode.system;
    }
  }

  Future<void> setTheme(flutter.ThemeMode mode) async {
    try {
      state = mode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, mode.name);
      AppLogger.i('Theme changed to ${mode.name}', 'THEME');
    } catch (e) {
      AppLogger.e('Failed to save theme preference', 'THEME', e);
    }
  }

  Future<void> toggle() async {
    await setTheme(
      state == flutter.ThemeMode.dark
          ? flutter.ThemeMode.light
          : flutter.ThemeMode.dark,
    );
  }
}

// lib/core/extensions/build_context_extensions.dart
// Extension générale sur BuildContext — AUTO-GÉNÉRÉ par fix_errors_v2.py
// Importer ce fichier partout où "context.colors" est utilisé.

import 'package:flutter/material.dart';
import 'package:lumina/l10n/app_localizations.dart';

extension AppContextExtensions on BuildContext {
  // DEPRECATED — use context_extension.dart
  // Fusionné dans BuildContextExtension (lib/core/extensions/context_extension.dart)
  
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  bool get isDarkMode => theme.brightness == Brightness.dark;
}

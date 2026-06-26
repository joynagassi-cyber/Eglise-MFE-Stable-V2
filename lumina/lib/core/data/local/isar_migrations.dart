import 'package:isar/isar.dart';

/// Gestion des migrations Isar
class IsarMigrations {
  static const int currentVersion = 3;

  static Future<void> migrate(Isar isar, int oldVersion, int newVersion) async {
    if (oldVersion < 1 && newVersion >= 1) {
      await _migrateToV1(isar);
    }
    if (oldVersion < 2 && newVersion >= 2) {
      await _migrateToV2(isar);
    }
    if (oldVersion < 3 && newVersion >= 3) {
      await _migrateToV3(isar);
    }
  }

  static Future<void> _migrateToV1(Isar isar) async {
    // Migration initiale - rien à faire
  }

  static Future<void> _migrateToV2(Isar isar) async {
    // Migration vers V2 - rien à faire (les valeurs par défaut Isar s'appliquent)
  }

  static Future<void> _migrateToV3(Isar isar) async {
    // Migration vers V3 - rien à faire (les valeurs par défaut Isar s'appliquent)
  }
}

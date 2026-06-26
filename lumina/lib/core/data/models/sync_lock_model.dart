import 'package:isar/isar.dart';

part 'sync_lock_model.g.dart';

/// Modèle pour gérer les verrous de synchronisation au niveau de la base de données.
/// Remplace les variables statiques volatiles par une persistance robuste.
@collection
class SyncLockModel {
  Id id = 0; // Toujours 0 pour avoir une seule instance (Singleton DB)

  /// True si une synchronisation est en cours
  bool isActive = false;

  /// Timestamp du début de la synchro pour gérer les timeouts
  DateTime? lockedAt;

  /// Identifiant du worker qui a pris le verrou (foreground vs background)
  String? lockedBy;

  /// Indique si le verrou a expiré (ex: crash du worker)
  bool get isExpired {
    if (lockedAt == null) return true;
    return DateTime.now().difference(lockedAt!) > const Duration(minutes: 5);
  }
}

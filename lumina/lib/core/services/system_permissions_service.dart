// lib/core/services/system_permissions_service.dart
// Service centralisé pour la gestion des permissions système (Caméra, Micro, Stockage, Notifications)

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logging/app_logger.dart';

final systemPermissionsServiceProvider =
    Provider<SystemPermissionsService>((ref) {
  return SystemPermissionsService();
});

class SystemPermissionsService {
  /// Demande toutes les permissions critiques au démarrage.
  /// Cette méthode est conçue pour être appelée une seule fois (ou au besoin).
  Future<void> requestAllPermissions() async {
    AppLogger.i(
        'Début de la demande groupée de permissions système', 'PERMISSIONS');

    try {
      // 1. Liste des permissions à demander
      final permissions = [
        Permission.camera,
        Permission.microphone,
        Permission.notification,
        Permission.storage,
      ];

      // 2. Demande séquentielle (pour éviter de brusquer l'utilisateur)
      // Note: Sur certaines plateformes/versions, plusieurs dialogs peuvent s'enchaîner.
      for (final permission in permissions) {
        final status = await permission.status;

        if (status.isDenied || status.isLimited) {
          AppLogger.i('Demande de permission : ${permission.toString()}',
              'PERMISSIONS');
          await permission.request();
        } else {
          AppLogger.d('Permission déjà accordée : ${permission.toString()}',
              'PERMISSIONS');
        }
      }

      AppLogger.i('Fin de la demande groupée de permissions', 'PERMISSIONS');
    } catch (e, st) {
      AppLogger.e(
          'Erreur lors de la demande des permissions', 'PERMISSIONS', e, st);
    }
  }

  /// Vérifie le statut d'une permission spécifique
  Future<bool> isGranted(Permission permission) async {
    return await permission.isGranted;
  }

  /// Ouvre les paramètres de l'application si une permission est définitivement refusée
  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}

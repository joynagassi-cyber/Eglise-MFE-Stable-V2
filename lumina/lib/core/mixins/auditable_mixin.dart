
import '../domain/entities/enums/audit_action.dart';
import '../../features/audit/domain/services/audit_service.dart';
import '../providers/user_context_provider.dart';

/// Mixin pour faciliter le logging d'actions d'audit depuis n'importe quel Notifier ou Provider.
mixin AuditableMixin {
  /// Enregistre une action d'audit.
  /// 
  /// [ref] est nécessaire pour accéder aux providers d'audit et de contexte utilisateur.
  /// [action] le type d'action (insert, update, delete, etc.).
  /// [entityType] le nom de la table ou du type d'entité concerné.
  /// [entityId] l'identifiant unique de l'entité.
  /// [oldData] les données avant modification (optionnel).
  /// [newData] les données après modification (optionnel).
  /// [metadata] informations complémentaires (optionnel).
  Future<void> logAuditAction(
    dynamic ref, {
    required AuditAction action,
    required String entityType,
    required String entityId,
    Map<String, dynamic>? oldData,
    Map<String, dynamic>? newData,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final userContext = ref.read(userContextNotifierProvider).valueOrNull;
      final auditRepo = ref.read(auditRepositoryProvider);

      await auditRepo.logAction(
        action: action,
        entityType: entityType,
        entityId: entityId,
        oldData: oldData,
        newData: newData,
        actorId: userContext?.user.id,
        metadata: {
          if (userContext != null) 'actor_name': userContext.user.email,
          if (userContext?.role.label != null) 'role': userContext!.role.label,
          ...?metadata,
        },
      );
    } catch (e) {
      // On ne bloque pas l'exécution principale si l'audit échoue,
      // mais on devrait loguer l'erreur technique.
      // (On pourra utiliser AppLogger ici plus tard).
    }
  }
}

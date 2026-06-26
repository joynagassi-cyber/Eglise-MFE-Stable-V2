import 'package:intl/intl.dart';
import '../../core/auth/domain/entities/user_context.dart';

/// Helper pour formater les logs d'activité avec traçabilité nominative.
///
/// Format : [Civilité] [Nom] · [RoleBadge] · [Action] · [Date]
///
/// Exemple : "M. Jean Dupont · Trésorier · a approuvé la transaction #42 · il y a 2h"
class ActivityLogHelper {
  ActivityLogHelper._();

  /// Formatage d'une entrée de log d'activité nominative.
  static String format({
    required UserContext user,
    required String action,
    DateTime? timestamp,
  }) {
    final fullName = user.user.name.isNotEmpty ? user.user.name : 'Utilisateur';
    final roleLabel = user.role.code.isNotEmpty
        ? _humanizeRole(user.role.code)
        : 'Membre';
    final dateStr = _formatRelativeDate(timestamp ?? DateTime.now());

    return '$fullName · $roleLabel · $action · $dateStr';
  }

  /// Formatage simplifié avec nom et rôle seulement.
  static String formatShort({
    required String firstName,
    required String lastName,
    required String roleCode,
    required String action,
    DateTime? timestamp,
  }) {
    final fullName = '$firstName $lastName'.trim();
    final roleLabel = _humanizeRole(roleCode);
    final dateStr = _formatRelativeDate(timestamp ?? DateTime.now());

    return '$fullName · $roleLabel · $action · $dateStr';
  }

  static String _humanizeRole(String code) {
    return switch (code.toLowerCase()) {
      'super_admin' || 'superadmin' => 'Super Admin',
      'administrateur_systeme' => 'Admin Système',
      'administrateur_systeme_adjoint' => 'Admin Adjoint',
      'tresorier' => 'Trésorier',
      'tresorier_adjoint' => 'Trésorier Adjoint',
      'comptable' => 'Comptable',
      'comptable_adjoint' => 'Comptable Adjoint',
      'commissaire_aux_comptes' => 'Commissaire aux Comptes',
      'auditeur_interne' => 'Auditeur Interne',
      'validateur_transaction' => 'Validateur',
      'secretaire_general' => 'Secrétaire Général',
      'secretaire_general_adjoint' => 'Secrétaire Gén. Adjoint',
      'pasteur_principal' => 'Pasteur Principal',
      'pasteur' => 'Pasteur',
      'pasteur_adjoint' => 'Pasteur Adjoint',
      'president' => 'Président',
      'vice_president' => 'Vice-Président',
      'president_hommes' => 'Prés. Hommes',
      'president_hommes_adjoint' => 'Prés. Adj. Hommes',
      'presidente_femmes' => 'Prés. Femmes',
      'presidente_femmes_adjointe' => 'Prés. Adj. Femmes',
      'president_jeunesse' => 'Prés. Jeunesse',
      'president_jeunesse_adjoint' => 'Prés. Adj. Jeunesse',
      'chef_chorale' => 'Chef Chorale',
      'maitre_chorale' => 'Maître Chorale',
      'chef_intercession' => 'Chef Intercession',
      'responsable_enfants' => 'Resp. Enfants',
      'moniteur_enfants' => 'Moniteur Enfants',
      'organisateur_evenement' => 'Organisateur Événement',
      'coordinateur_formation' => 'Coord. Formation',
      'responsable_mission' => 'Resp. Mission',
      'conseiller_principal' => 'Conseiller Principal',
      'conseiller' => 'Conseiller',
      'gestionnaire_documents' => 'Gest. Documents',
      'responsable_archives' => 'Resp. Archives',
      'webmaster' => 'Webmaster',
      'benevole' => 'Bénévole',
      'donateur' => 'Donateur',
      'visiteur_temporaire' => 'Visiteur',
      'responsable_groupe' => 'Resp. Groupe',
      'gestionnaire_budget_event' => 'Gest. Budget Événement',
      _ => code.replaceAll('_', ' '),
    };
  }

  static String _formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'à l\'instant';
    if (diff.inMinutes < 60) return 'il y a ${diff.inMinutes}min';
    if (diff.inHours < 24) return 'il y a ${diff.inHours}h';
    if (diff.inDays < 7) return 'il y a ${diff.inDays}j';

    return DateFormat('dd/MM/yyyy à HH:mm', 'fr_FR').format(date);
  }
}

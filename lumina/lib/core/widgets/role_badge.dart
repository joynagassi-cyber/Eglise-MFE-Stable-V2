import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';

/// Badge visuel indicant le rôle utilisateur, avec couleur par cluster.
///
/// Couvre les 46 rôles du système Lumina avec des couleurs distinctes :
/// - **Gouvernance** (super_admin, admin) → Rouge
/// - **Finance** (tresorier, comptable, etc.) → Teal
/// - **Administratif** (secretaire_general, gestionnaire_documents) → Orange
/// - **Pastoral** (pasteur, conseiller) → Or
/// - **Département** (president_hommes, chef_chorale, etc.) → Bleu
/// - **Audit** (commissaire, auditeur) → Anthracite
/// - **Opérationnel** (organisateur, coordinateur) → Warm orange
/// - **Limité** (benevole, donateur, visiteur) → Gris
class RoleBadge extends StatelessWidget {
  final String roleCode;
  final String? customLabel;

  const RoleBadge({
    super.key,
    required this.roleCode,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getRoleConfig(context, roleCode.toLowerCase());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: config.color.withValues(alpha: 0.3)),
      ),
      child: Text(
        customLabel ?? config.label,
        style: TextStyle(
          color: config.color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  _RoleVisual _getRoleConfig(BuildContext context, String role) {
    // ── GOUVERNANCE SYSTÈME (Rouge) ─────────────────────────
    final govColor = context.colors.errorText;
    // ── FINANCE (Teal) ──────────────────────────────────────
    final finColor = context.colors.incomeColor;
    // ── ADMINISTRATIF (Orange primary) ──────────────────────
    final adminColor = context.colors.brandPrimary;
    // ── PASTORAL (Or) ───────────────────────────────────────
    const pastoralColor = Color(0xFFD4AF37); // Keeping Gold as it's a specific identity color
    // ── MINISTÈRE (Bleu) ────────────────────────────────────
    const departmentColor = Color(0xFF2563EB); // Blue 600
    // ── AUDIT (Anthracite) ──────────────────────────────────
    final auditColor = context.colors.textSecondary;
    // ── OPÉRATIONNEL (Amber warm) ───────────────────────────
    final opsColor = context.colors.warningIcon;
    // ── LIMITÉ (Gris) ───────────────────────────────────────
    final limitedColor = context.colors.textDisabled;

    return switch (role) {
      // ── GOUVERNANCE ──────────────────────────────────────
      'super_admin' || 'superadmin' => _RoleVisual('Super Admin', govColor),
      'admin' || 'administrateur' => _RoleVisual('Administrateur', govColor),
      'president' || 'président' => const _RoleVisual('Président', Color(0xFF6B4E71)),
      'vice_president' => const _RoleVisual('Vice-Président', Color(0xFF6B4E71)),
      'webmaster' => _RoleVisual('Webmaster', govColor),

      // ── FINANCE ──────────────────────────────────────────
      'tresorier' => _RoleVisual('Trésorier', finColor),
      'tresorier_adjoint' => _RoleVisual('Trésorier Adjoint', finColor),
      'comptable' => _RoleVisual('Comptable', finColor),
      'comptable_adjoint' => _RoleVisual('Comptable Adjoint', finColor),
      'validateur_transaction' => _RoleVisual('Validateur', finColor),
      'gestionnaire_budget_event' => _RoleVisual('Gest. Budget', finColor),

      // ── ADMINISTRATIF ────────────────────────────────────
      'administrateur_systeme' => _RoleVisual('Admin Système', adminColor),
      'administrateur_systeme_adjoint' => _RoleVisual('Admin Adjoint', adminColor),
      'secretaire_general' => _RoleVisual('Secrétaire Général', adminColor),
      'secretaire_general_adjoint' => _RoleVisual('Secrétaire Adj.', adminColor),
      'gestionnaire_documents' => _RoleVisual('Gest. Documents', adminColor),
      'responsable_archives' => _RoleVisual('Resp. Archives', adminColor),

      // ── PASTORAL ─────────────────────────────────────────
      'pasteur_principal' => const _RoleVisual('Pasteur Principal', pastoralColor),
      'pasteur' => const _RoleVisual('Pasteur', pastoralColor),
      'pasteur_adjoint' => const _RoleVisual('Pasteur Adjoint', pastoralColor),
      'conseiller_principal' => const _RoleVisual('Conseiller Principal', pastoralColor),
      'conseiller' => const _RoleVisual('Conseiller', pastoralColor),

      // ── MINISTÈRE ────────────────────────────────────────
      'president_hommes' => _RoleVisual('Prés. Hommes', context.colors.hommesColor),
      'president_hommes_adjoint' => _RoleVisual('Prés. Adj. Hommes', context.colors.hommesColor),
      'presidente_femmes' => _RoleVisual('Prés. Femmes', context.colors.femmesColor),
      'presidente_femmes_adjointe' => _RoleVisual('Prés. Adj. Femmes', context.colors.femmesColor),
      'president_jeunesse' => _RoleVisual('Prés. Jeunesse', context.colors.jeunesseColor),
      'president_jeunesse_adjoint' => _RoleVisual('Prés. Adj. Jeunesse', context.colors.jeunesseColor),
      'chef_chorale' => _RoleVisual('Chef Chorale', context.colors.choraleColor),
      'maitre_chorale' => _RoleVisual('Maître Chorale', context.colors.choraleColor),
      'chef_intercession' => _RoleVisual('Chef Intercession', context.colors.intercessionColor),
      'responsable_enfants' => _RoleVisual('Resp. Enfants', context.colors.enfantsColor),
      'moniteur_enfants' => _RoleVisual('Moniteur Enfants', context.colors.enfantsColor),
      'responsable_groupe' || 'leader' => const _RoleVisual('Leader', departmentColor),

      // Leaders legacy
      final String r when r.contains('responsable') || r.contains('chef') =>
        const _RoleVisual('Leader', departmentColor),

      // ── AUDIT ────────────────────────────────────────────
      'commissaire_aux_comptes' => _RoleVisual('Commissaire', auditColor),
      'auditeur_interne' => _RoleVisual('Auditeur', auditColor),

      // ── OPÉRATIONNEL ─────────────────────────────────────
      'organisateur_evenement' => _RoleVisual('Organisateur', opsColor),
      'coordinateur_formation' => _RoleVisual('Coord. Formation', opsColor),
      'responsable_mission' => _RoleVisual('Resp. Mission', opsColor),

      // ── LIMITÉ ───────────────────────────────────────────
      'benevole' => _RoleVisual('Bénévole', limitedColor),
      'donateur' => _RoleVisual('Donateur', limitedColor),
      'visiteur_temporaire' || 'visiteur' || 'visitor' =>
        _RoleVisual('Visiteur', limitedColor),

      // ── FALLBACK ─────────────────────────────────────────
      _ => _RoleVisual('Membre MFE-JC', context.colors.brandPrimary),
    };
  }


}

class _RoleVisual {
  final String label;
  final Color color;
  const _RoleVisual(this.label, this.color);
}

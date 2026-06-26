import 'package:flutter/material.dart';
import '../../../core/router/app_routes.dart';
import '../domain/entities/tutorial_step.dart';

/// Configurations de tutoriel pour chaque rôle prioritaire dans Lumina.
///
/// Chaque configuration cible les routes GoRouter RÉELLES du codebase.
/// Les rôles non listés reçoivent une configuration générique.
class TutorialConfigs {
  TutorialConfigs._();

  /// Retourne la config tutoriel pour un rôle donné.
  /// Fallback vers [_genericConfig] si le rôle n'est pas mappé.
  static TutorialConfig getConfigForRole(String roleCode) {
    return _configs[roleCode.toLowerCase()] ?? _genericConfig;
  }

  /// Liste des rôles ayant une config dédiée.
  static List<String> get supportedRoles => _configs.keys.toList();

  // ──────────────────────────────────────────────────────────
  // CONFIG GÉNÉRIQUE (fallback)
  // ──────────────────────────────────────────────────────────

  static const TutorialConfig _genericConfig = TutorialConfig(
    roleCode: 'generic',
    roleDisplayName: 'Membre',
    roleDescription:
        'Votre rôle est en cours de configuration. '
        'Voici les actions de base disponibles.',
    roleIcon: Icons.person_outline_rounded,
    steps: [
      TutorialStep(
        id: 'generic_dashboard',
        title: 'Accéder à votre espace',
        description: 'Consultez votre tableau de bord personnel.',
        targetRoute: '/dashboard',
        icon: Icons.dashboard_rounded,
      ),
      TutorialStep(
        id: 'generic_annonces',
        title: 'Voir les annonces',
        description: 'Restez informé des nouvelles de l\'église.',
        targetRoute: '/communication/annonces',
        icon: Icons.campaign_rounded,
      ),
      TutorialStep(
        id: 'generic_calendar',
        title: 'Consulter le calendrier',
        description: 'Retrouvez les événements à venir.',
        targetRoute: '/calendrier',
        icon: Icons.calendar_month_rounded,
      ),
    ],
  );

  // ──────────────────────────────────────────────────────────
  // CONFIGS PAR RÔLE
  // ──────────────────────────────────────────────────────────

  static final Map<String, TutorialConfig> _configs = {
    // ── TRÉSORIER ──────────────────────────────────────────
    'tresorier': const TutorialConfig(
      roleCode: 'tresorier',
      roleDisplayName: 'Trésorier',
      roleDescription:
          'Vous gérez les finances de l\'église. '
          'Voici les actions essentielles pour bien commencer.',
      roleIcon: Icons.account_balance_wallet_rounded,
      steps: [
        TutorialStep(
          id: 'tresorier_finances',
          title: 'Voir les finances',
          description:
              'Consultez le tableau de bord financier avec les revenus et dépenses.',
          targetRoute: AppRoutes.finance,
          icon: Icons.bar_chart_rounded,
        ),
        TutorialStep(
          id: 'tresorier_history',
          title: 'Historique des transactions',
          description:
              'Consultez toutes les transactions passées et leur détail.',
          targetRoute: AppRoutes.financeHistory,
          icon: Icons.receipt_long_rounded,
        ),
        TutorialStep(
          id: 'tresorier_accounts',
          title: 'Gérer les comptes bancaires',
          description:
              'Ajoutez et suivez les comptes bancaires de l\'église.',
          targetRoute: AppRoutes.financeAccounts,
          icon: Icons.account_balance_rounded,
        ),
        TutorialStep(
          id: 'tresorier_bilan',
          title: 'Consulter le bilan',
          description:
              'Générez et consultez le bilan financier complet.',
          targetRoute: AppRoutes.bilan,
          icon: Icons.assessment_rounded,
        ),
        TutorialStep(
          id: 'tresorier_approvals',
          title: 'Valider les dépenses',
          description:
              'Approuvez ou rejetez les transactions en attente.',
          targetRoute: AppRoutes.approvals,
          icon: Icons.verified_rounded,
        ),
      ],
    ),

    'tresorier_adjoint': const TutorialConfig(
      roleCode: 'tresorier_adjoint',
      roleDisplayName: 'Trésorier Adjoint',
      roleDescription:
          'Vous assistez le trésorier dans la gestion financière.',
      roleIcon: Icons.account_balance_wallet_outlined,
      steps: [
        TutorialStep(
          id: 'tresadj_finances',
          title: 'Voir les finances',
          description: 'Consultez l\'état financier de l\'église.',
          targetRoute: AppRoutes.finance,
          icon: Icons.bar_chart_rounded,
        ),
        TutorialStep(
          id: 'tresadj_history',
          title: 'Historique des transactions',
          description: 'Parcourez les transactions passées.',
          targetRoute: AppRoutes.financeHistory,
          icon: Icons.receipt_long_rounded,
        ),
        TutorialStep(
          id: 'tresadj_donors',
          title: 'Gérer les donateurs',
          description: 'Consultez la liste des donateurs et leurs contributions.',
          targetRoute: AppRoutes.donors,
          icon: Icons.volunteer_activism_rounded,
        ),
      ],
    ),

    // ── SECRÉTAIRE GÉNÉRAL ─────────────────────────────────
    'secretaire_general': const TutorialConfig(
      roleCode: 'secretaire_general',
      roleDisplayName: 'Secrétaire Général',
      roleDescription:
          'Vous gérez les membres et les documents officiels de l\'église.',
      roleIcon: Icons.edit_document,
      steps: [
        TutorialStep(
          id: 'sg_members',
          title: 'Voir la liste des membres',
          description:
              'Consultez tous les membres enregistrés de l\'église.',
          targetRoute: AppRoutes.brebis,
          icon: Icons.people_rounded,
        ),
        TutorialStep(
          id: 'sg_add_member',
          title: 'Ajouter un nouveau membre',
          description:
              'Enregistrez une nouvelle personne dans l\'église.',
          targetRoute: AppRoutes.brebisNouveau,
          icon: Icons.person_add_rounded,
        ),
        TutorialStep(
          id: 'sg_sacraments',
          title: 'Gérer les sacrements',
          description:
              'Enregistrez les baptêmes, mariages et autres sacrements.',
          targetRoute: AppRoutes.sacraments,
          icon: Icons.water_drop_rounded,
        ),
        TutorialStep(
          id: 'sg_communication',
          title: 'Communications',
          description:
              'Envoyez des annonces et gérez les communications.',
          targetRoute: AppRoutes.communication,
          icon: Icons.campaign_rounded,
        ),
        TutorialStep(
          id: 'sg_celebrations',
          title: 'Gérer les célébrations',
          description:
              'Suivez les cultes et prenez les présences globales.',
          targetRoute: AppRoutes.vieSpirituelleCelebrations,
          icon: Icons.church_rounded,
        ),
      ],
    ),

    'secretaire_general_adjoint': const TutorialConfig(
      roleCode: 'secretaire_general_adjoint',
      roleDisplayName: 'Secrétaire Général Adjoint',
      roleDescription:
          'Vous assistez le secrétaire général dans ses tâches.',
      roleIcon: Icons.edit_note_rounded,
      steps: [
        TutorialStep(
          id: 'sgadj_members',
          title: 'Voir la liste des membres',
          description: 'Consultez les membres enregistrés.',
          targetRoute: AppRoutes.brebis,
          icon: Icons.people_rounded,
        ),
        TutorialStep(
          id: 'sgadj_communication',
          title: 'Communications',
          description: 'Consultez et créez des annonces.',
          targetRoute: AppRoutes.communication,
          icon: Icons.campaign_rounded,
        ),
        TutorialStep(
          id: 'sgadj_celebrations',
          title: 'Suivre les célébrations',
          description: 'Consultez l\'historique des cultes.',
          targetRoute: AppRoutes.vieSpirituelleCelebrations,
          icon: Icons.church_rounded,
        ),
      ],
    ),

    // ── PASTEUR PRINCIPAL ──────────────────────────────────
    'pasteur_principal': const TutorialConfig(
      roleCode: 'pasteur_principal',
      roleDisplayName: 'Pasteur Principal',
      roleDescription:
          'Vous supervisez la vie spirituelle et organisationnelle '
          'de l\'église.',
      roleIcon: Icons.shield_rounded,
      steps: [
        TutorialStep(
          id: 'pp_dashboard',
          title: 'Tableau de bord global',
          description:
              'Voyez d\'un coup d\'œil la santé de votre église.',
          targetRoute: AppRoutes.dashboard,
          icon: Icons.dashboard_rounded,
        ),
        TutorialStep(
          id: 'pp_members',
          title: 'Consulter les membres',
          description:
              'Parcourez la liste complète des membres de l\'église.',
          targetRoute: AppRoutes.brebis,
          icon: Icons.people_rounded,
        ),
        TutorialStep(
          id: 'pp_events',
          title: 'Gérer les événements',
          description:
              'Créez et suivez les événements spirituels.',
          targetRoute: AppRoutes.vieSpirituelleEvents,
          icon: Icons.event_rounded,
        ),
        TutorialStep(
          id: 'pp_groups',
          title: 'Suivre les groupes',
          description:
              'Consultez l\'activité de chaque groupe ministériel.',
          targetRoute: '/groups',
          icon: Icons.groups_rounded,
        ),
        TutorialStep(
          id: 'pp_ministere',
          title: 'MFE-JC et rapports',
          description:
              'Accédez aux rapports globaux et au suivi organisationnel.',
          targetRoute: AppRoutes.ministere,
          icon: Icons.analytics_rounded,
        ),
      ],
    ),

    // ── PASTEUR ────────────────────────────────────────────
    'pasteur': const TutorialConfig(
      roleCode: 'pasteur',
      roleDisplayName: 'Pasteur',
      roleDescription:
          'Vous participez à la direction spirituelle de l\'église.',
      roleIcon: Icons.auto_awesome_rounded,
      steps: [
        TutorialStep(
          id: 'pasteur_members',
          title: 'Consulter les membres',
          description: 'Accédez au répertoire des fidèles.',
          targetRoute: AppRoutes.brebis,
          icon: Icons.people_rounded,
        ),
        TutorialStep(
          id: 'pasteur_spiritual',
          title: 'Vie spirituelle',
          description: 'Gérez les jalons et célébrations.',
          targetRoute: AppRoutes.vieSpirituelle,
          icon: Icons.self_improvement_rounded,
        ),
        TutorialStep(
          id: 'pasteur_events',
          title: 'Événements',
          description: 'Créez et suivez les événements.',
          targetRoute: AppRoutes.vieSpirituelleEvents,
          icon: Icons.event_rounded,
        ),
        TutorialStep(
          id: 'pasteur_communication',
          title: 'Communications',
          description: 'Envoyez des messages et annonces.',
          targetRoute: AppRoutes.communication,
          icon: Icons.chat_bubble_rounded,
        ),
        TutorialStep(
          id: 'pasteur_groups',
          title: 'Groupes',
          description: 'Suivez l\'activité des groupes.',
          targetRoute: '/groups',
          icon: Icons.groups_rounded,
        ),
      ],
    ),

    'pasteur_adjoint': const TutorialConfig(
      roleCode: 'pasteur_adjoint',
      roleDisplayName: 'Pasteur Adjoint',
      roleDescription:
          'Vous assistez le pasteur dans ses tâches pastorales.',
      roleIcon: Icons.auto_awesome_outlined,
      steps: [
        TutorialStep(
          id: 'pa_members',
          title: 'Consulter les membres',
          description: 'Parcourez la liste des fidèles.',
          targetRoute: AppRoutes.brebis,
          icon: Icons.people_rounded,
        ),
        TutorialStep(
          id: 'pa_events',
          title: 'Événements',
          description: 'Consultez et aidez à organiser les événements.',
          targetRoute: AppRoutes.vieSpirituelleEvents,
          icon: Icons.event_rounded,
        ),
        TutorialStep(
          id: 'pa_groups',
          title: 'Groupes',
          description: 'Suivez les groupes ministériels.',
          targetRoute: '/groups',
          icon: Icons.groups_rounded,
        ),
      ],
    ),

    // ── PRÉSIDENT / VICE-PRÉSIDENT ─────────────────────────
    'president': const TutorialConfig(
      roleCode: 'president',
      roleDisplayName: 'Président',
      roleDescription:
          'Vous présidez le conseil d\'administration de l\'église.',
      roleIcon: Icons.gavel_rounded,
      steps: [
        TutorialStep(
          id: 'pres_dashboard',
          title: 'Tableau de bord exécutif',
          description: 'Vue globale de la santé de l\'église.',
          targetRoute: AppRoutes.dashboard,
          icon: Icons.dashboard_rounded,
        ),
        TutorialStep(
          id: 'pres_finance',
          title: 'Rapports financiers',
          description: 'Consultez l\'état des finances.',
          targetRoute: AppRoutes.finance,
          icon: Icons.bar_chart_rounded,
        ),
        TutorialStep(
          id: 'pres_members',
          title: 'Membres',
          description: 'Consultez la liste des membres.',
          targetRoute: AppRoutes.brebis,
          icon: Icons.people_rounded,
        ),
        TutorialStep(
          id: 'pres_audit',
          title: 'Audit et traçabilité',
          description: 'Consultez les logs d\'activité.',
          targetRoute: AppRoutes.audit,
          icon: Icons.policy_rounded,
        ),
      ],
    ),

    'vice_president': const TutorialConfig(
      roleCode: 'vice_president',
      roleDisplayName: 'Vice-Président',
      roleDescription:
          'Vous suppléez le président et assurez la continuité.',
      roleIcon: Icons.gavel_outlined,
      steps: [
        TutorialStep(
          id: 'vp_dashboard',
          title: 'Tableau de bord',
          description: 'Vue globale de l\'église.',
          targetRoute: AppRoutes.dashboard,
          icon: Icons.dashboard_rounded,
        ),
        TutorialStep(
          id: 'vp_finance',
          title: 'Rapports financiers',
          description: 'Consultez les finances en lecture.',
          targetRoute: AppRoutes.finance,
          icon: Icons.bar_chart_rounded,
        ),
        TutorialStep(
          id: 'vp_members',
          title: 'Membres',
          description: 'Parcourez la communauté.',
          targetRoute: AppRoutes.brebis,
          icon: Icons.people_rounded,
        ),
      ],
    ),

    // ── PRÉSIDENT HOMMES ───────────────────────────────────
    'president_hommes': const TutorialConfig(
      roleCode: 'president_hommes',
      roleDisplayName: 'Président des Hommes',
      roleDescription:
          'Vous dirigez le département des hommes. '
          'Voici comment gérer votre groupe.',
      roleIcon: Icons.man_rounded,
      steps: [
        TutorialStep(
          id: 'ph_group',
          title: 'Voir mon groupe',
          description: 'Accédez au tableau de bord du groupe Hommes.',
          targetRoute: '/groups', // Fallback : la liste des groupes
          icon: Icons.groups_rounded,
        ),
        TutorialStep(
          id: 'ph_events',
          title: 'Créer un événement',
          description: 'Planifiez une activité pour votre groupe.',
          targetRoute: AppRoutes.vieSpirituelleEventsNew,
          icon: Icons.event_available_rounded,
        ),
        TutorialStep(
          id: 'ph_communication',
          title: 'Envoyer une communication',
          description: 'Informez les membres de votre groupe.',
          targetRoute: AppRoutes.communication,
          icon: Icons.campaign_rounded,
        ),
      ],
    ),

    'president_hommes_adjoint': const TutorialConfig(
      roleCode: 'president_hommes_adjoint',
      roleDisplayName: 'Président Adjoint des Hommes',
      roleDescription: 'Vous assistez le président du département des hommes.',
      roleIcon: Icons.man_2_rounded,
      steps: [
        TutorialStep(
          id: 'pha_group',
          title: 'Voir le groupe Hommes',
          description: 'Consultez les membres et activités.',
          targetRoute: '/groups',
          icon: Icons.groups_rounded,
        ),
        TutorialStep(
          id: 'pha_events',
          title: 'Créer un événement',
          description: 'Planifiez une activité pour le groupe.',
          targetRoute: AppRoutes.vieSpirituelleEventsNew,
          icon: Icons.event_available_rounded,
        ),
      ],
    ),

    // ── PRÉSIDENTE FEMMES ──────────────────────────────────
    'presidente_femmes': const TutorialConfig(
      roleCode: 'presidente_femmes',
      roleDisplayName: 'Présidente des Femmes',
      roleDescription:
          'Vous dirigez le département des femmes. '
          'Voici comment gérer votre groupe.',
      roleIcon: Icons.woman_rounded,
      steps: [
        TutorialStep(
          id: 'pf_group',
          title: 'Voir mon groupe',
          description: 'Accédez au tableau de bord du groupe Femmes.',
          targetRoute: '/groups',
          icon: Icons.groups_rounded,
        ),
        TutorialStep(
          id: 'pf_events',
          title: 'Créer un événement',
          description: 'Planifiez une activité pour votre groupe.',
          targetRoute: AppRoutes.vieSpirituelleEventsNew,
          icon: Icons.event_available_rounded,
        ),
        TutorialStep(
          id: 'pf_communication',
          title: 'Envoyer une communication',
          description: 'Informez les membres de votre groupe.',
          targetRoute: AppRoutes.communication,
          icon: Icons.campaign_rounded,
        ),
      ],
    ),

    'presidente_femmes_adjointe': const TutorialConfig(
      roleCode: 'presidente_femmes_adjointe',
      roleDisplayName: 'Présidente Adjointe des Femmes',
      roleDescription: 'Vous assistez la présidente du département des femmes.',
      roleIcon: Icons.woman_2_rounded,
      steps: [
        TutorialStep(
          id: 'pfa_group',
          title: 'Voir le groupe Femmes',
          description: 'Consultez les membres et activités.',
          targetRoute: '/groups',
          icon: Icons.groups_rounded,
        ),
        TutorialStep(
          id: 'pfa_events',
          title: 'Créer un événement',
          description: 'Planifiez une activité pour le groupe.',
          targetRoute: AppRoutes.vieSpirituelleEventsNew,
          icon: Icons.event_available_rounded,
        ),
      ],
    ),

    // ── PRÉSIDENT JEUNESSE ─────────────────────────────────
    'president_jeunesse': const TutorialConfig(
      roleCode: 'president_jeunesse',
      roleDisplayName: 'Président de la Jeunesse',
      roleDescription:
          'Vous dirigez le département de la jeunesse. '
          'Voici comment gérer votre groupe.',
      roleIcon: Icons.school_rounded,
      steps: [
        TutorialStep(
          id: 'pj_group',
          title: 'Voir mon groupe',
          description: 'Accédez au tableau de bord du groupe Jeunesse.',
          targetRoute: '/groups',
          icon: Icons.groups_rounded,
        ),
        TutorialStep(
          id: 'pj_events',
          title: 'Créer un événement',
          description:
              'Planifiez une activité pour les jeunes.',
          targetRoute: AppRoutes.vieSpirituelleEventsNew,
          icon: Icons.event_available_rounded,
        ),
        TutorialStep(
          id: 'pj_communication',
          title: 'Envoyer une communication',
          description: 'Informez les jeunes de votre groupe.',
          targetRoute: AppRoutes.communication,
          icon: Icons.campaign_rounded,
        ),
      ],
    ),

    'president_jeunesse_adjoint': const TutorialConfig(
      roleCode: 'president_jeunesse_adjoint',
      roleDisplayName: 'Président Adjoint de la Jeunesse',
      roleDescription: 'Vous assistez le président de la jeunesse.',
      roleIcon: Icons.school_outlined,
      steps: [
        TutorialStep(
          id: 'pja_group',
          title: 'Voir le groupe Jeunesse',
          description: 'Consultez les membres et activités.',
          targetRoute: '/groups',
          icon: Icons.groups_rounded,
        ),
        TutorialStep(
          id: 'pja_events',
          title: 'Créer un événement',
          description: 'Planifiez une activité.',
          targetRoute: AppRoutes.vieSpirituelleEventsNew,
          icon: Icons.event_available_rounded,
        ),
      ],
    ),

    // ── CHEF CHORALE ───────────────────────────────────────
    'chef_chorale': const TutorialConfig(
      roleCode: 'chef_chorale',
      roleDisplayName: 'Chef de Chorale',
      roleDescription:
          'Vous dirigez la chorale. '
          'Gérez vos membres et votre répertoire.',
      roleIcon: Icons.music_note_rounded,
      steps: [
        TutorialStep(
          id: 'cc_group',
          title: 'Voir la chorale',
          description:
              'Accédez aux membres et au tableau de bord de la chorale.',
          targetRoute: '/groups',
          icon: Icons.groups_rounded,
        ),
        TutorialStep(
          id: 'cc_events',
          title: 'Planifier une répétition',
          description:
              'Créez un événement pour organiser une répétition.',
          targetRoute: AppRoutes.vieSpirituelleEventsNew,
          icon: Icons.event_available_rounded,
        ),
        TutorialStep(
          id: 'cc_communication',
          title: 'Communiquer avec la chorale',
          description: 'Envoyez des messages à vos choristes.',
          targetRoute: AppRoutes.communication,
          icon: Icons.campaign_rounded,
        ),
      ],
    ),

    'maitre_chorale': const TutorialConfig(
      roleCode: 'maitre_chorale',
      roleDisplayName: 'Maître de Chorale',
      roleDescription: 'Vous gérez le répertoire musical et les pupitres.',
      roleIcon: Icons.queue_music_rounded,
      steps: [
        TutorialStep(
          id: 'mc_group',
          title: 'Voir la chorale',
          description: 'Consultez les membres de la chorale.',
          targetRoute: '/groups',
          icon: Icons.groups_rounded,
        ),
        TutorialStep(
          id: 'mc_events',
          title: 'Planifier une répétition',
          description: 'Organisez les répétitions.',
          targetRoute: AppRoutes.vieSpirituelleEventsNew,
          icon: Icons.event_available_rounded,
        ),
      ],
    ),

    // ── CHEF INTERCESSION ──────────────────────────────────
    'chef_intercession': const TutorialConfig(
      roleCode: 'chef_intercession',
      roleDisplayName: 'Chef d\'Intercession',
      roleDescription:
          'Vous gérez le groupe de prière et d\'intercession.',
      roleIcon: Icons.volunteer_activism_rounded,
      steps: [
        TutorialStep(
          id: 'ci_group',
          title: 'Voir le groupe d\'intercession',
          description: 'Accédez aux intercesseurs et sessions.',
          targetRoute: '/groups',
          icon: Icons.groups_rounded,
        ),
        TutorialStep(
          id: 'ci_events',
          title: 'Planifier une session de prière',
          description: 'Créez un événement de prière.',
          targetRoute: AppRoutes.vieSpirituelleEventsNew,
          icon: Icons.event_available_rounded,
        ),
        TutorialStep(
          id: 'ci_communication',
          title: 'Partager les sujets de prière',
          description: 'Envoyez les sujets d\'intercession.',
          targetRoute: AppRoutes.communication,
          icon: Icons.campaign_rounded,
        ),
      ],
    ),

    // ── RESPONSABLE ENFANTS ────────────────────────────────
    'responsable_enfants': const TutorialConfig(
      roleCode: 'responsable_enfants',
      roleDisplayName: 'Responsable des Enfants',
      roleDescription: 'Vous gérez les enfants et le culte école.',
      roleIcon: Icons.child_care_rounded,
      steps: [
        TutorialStep(
          id: 're_group',
          title: 'Voir le groupe enfants',
          description: 'Consultez les enfants enregistrés.',
          targetRoute: '/groups',
          icon: Icons.groups_rounded,
        ),
        TutorialStep(
          id: 're_events',
          title: 'Créer une activité',
          description: 'Planifiez une activité pour les enfants.',
          targetRoute: AppRoutes.vieSpirituelleEventsNew,
          icon: Icons.event_available_rounded,
        ),
      ],
    ),

    'moniteur_enfants': const TutorialConfig(
      roleCode: 'moniteur_enfants',
      roleDisplayName: 'Moniteur Enfants',
      roleDescription: 'Vous animez le culte école des enfants.',
      roleIcon: Icons.child_friendly_rounded,
      steps: [
        TutorialStep(
          id: 'me_group',
          title: 'Voir les enfants',
          description: 'Consultez votre groupe d\'enfants.',
          targetRoute: '/groups',
          icon: Icons.groups_rounded,
        ),
        TutorialStep(
          id: 'me_calendar',
          title: 'Calendrier',
          description: 'Consultez le programme des activités.',
          targetRoute: AppRoutes.calendrier,
          icon: Icons.calendar_month_rounded,
        ),
      ],
    ),

    // ── ORGANISATEUR ÉVÉNEMENT ──────────────────────────────
    'organisateur_evenement': const TutorialConfig(
      roleCode: 'organisateur_evenement',
      roleDisplayName: 'Organisateur d\'Événement',
      roleDescription:
          'Vous organisez les événements de l\'église.',
      roleIcon: Icons.event_note_rounded,
      steps: [
        TutorialStep(
          id: 'oe_events',
          title: 'Voir les événements',
          description:
              'Consultez tous les événements planifiés.',
          targetRoute: AppRoutes.vieSpirituelleEvents,
          icon: Icons.event_rounded,
        ),
        TutorialStep(
          id: 'oe_create',
          title: 'Créer un événement',
          description:
              'Planifiez un nouvel événement avec tous les détails.',
          targetRoute: AppRoutes.vieSpirituelleEventsNew,
          icon: Icons.event_available_rounded,
        ),
        TutorialStep(
          id: 'oe_calendar',
          title: 'Calendrier',
          description: 'Vérifiez les disponibilités dans le calendrier.',
          targetRoute: AppRoutes.calendrier,
          icon: Icons.calendar_month_rounded,
        ),
      ],
    ),

    // ── ADMINISTRATEUR SYSTÈME ──────────────────────────────
    'administrateur_systeme': const TutorialConfig(
      roleCode: 'administrateur_systeme',
      roleDisplayName: 'Administrateur Système',
      roleDescription:
          'Vous administrez les utilisateurs et la configuration '
          'de Lumina.',
      roleIcon: Icons.admin_panel_settings_rounded,
      steps: [
        TutorialStep(
          id: 'as_roles',
          title: 'Gérer les rôles',
          description:
              'Consultez et configurez les rôles utilisateurs.',
          targetRoute: AppRoutes.adminRoles,
          icon: Icons.manage_accounts_rounded,
        ),
        TutorialStep(
          id: 'as_codes',
          title: 'Codes d\'accès',
          description:
              'Gérez les codes secrets d\'attribution de rôle.',
          targetRoute: AppRoutes.adminCodes,
          icon: Icons.vpn_key_rounded,
        ),
        TutorialStep(
          id: 'as_audit',
          title: 'Consulter les logs',
          description:
              'Vérifiez les actions effectuées dans l\'application.',
          targetRoute: AppRoutes.audit,
          icon: Icons.history_rounded,
        ),
        TutorialStep(
          id: 'as_settings',
          title: 'Paramètres de l\'église',
          description:
              'Configurez les paramètres généraux de votre église.',
          targetRoute: AppRoutes.adminSettings,
          icon: Icons.settings_rounded,
        ),
      ],
    ),

    'administrateur_systeme_adjoint': const TutorialConfig(
      roleCode: 'administrateur_systeme_adjoint',
      roleDisplayName: 'Administrateur Adjoint',
      roleDescription: 'Vous assistez l\'administrateur système.',
      roleIcon: Icons.admin_panel_settings_outlined,
      steps: [
        TutorialStep(
          id: 'asa_roles',
          title: 'Consulter les rôles',
          description: 'Consultez la configuration des rôles.',
          targetRoute: AppRoutes.adminRoles,
          icon: Icons.manage_accounts_rounded,
        ),
        TutorialStep(
          id: 'asa_audit',
          title: 'Consulter les logs',
          description: 'Vérifiez les actions récentes.',
          targetRoute: AppRoutes.audit,
          icon: Icons.history_rounded,
        ),
      ],
    ),

    // ── VALIDATEUR TRANSACTION ──────────────────────────────
    'validateur_transaction': const TutorialConfig(
      roleCode: 'validateur_transaction',
      roleDisplayName: 'Validateur de Transaction',
      roleDescription:
          'Vous approuvez les transactions financières avant exécution.',
      roleIcon: Icons.verified_user_rounded,
      steps: [
        TutorialStep(
          id: 'vt_approvals',
          title: 'Transactions en attente',
          description:
              'Consultez les transactions qui attendent votre approbation.',
          targetRoute: AppRoutes.approvals,
          icon: Icons.pending_actions_rounded,
        ),
        TutorialStep(
          id: 'vt_history',
          title: 'Historique des transactions',
          description:
              'Consultez toutes les transactions passées.',
          targetRoute: AppRoutes.financeHistory,
          icon: Icons.receipt_long_rounded,
        ),
        TutorialStep(
          id: 'vt_finance',
          title: 'Vue financière',
          description: 'Consultez l\'état financier global.',
          targetRoute: AppRoutes.finance,
          icon: Icons.bar_chart_rounded,
        ),
      ],
    ),

    // ── COMPTABLE ──────────────────────────────────────────
    'comptable': const TutorialConfig(
      roleCode: 'comptable',
      roleDisplayName: 'Comptable',
      roleDescription: 'Vous tenez la comptabilité formelle de l\'église.',
      roleIcon: Icons.calculate_rounded,
      steps: [
        TutorialStep(
          id: 'cpt_finance',
          title: 'Tableau de bord financier',
          description: 'Consultez l\'état des finances.',
          targetRoute: AppRoutes.finance,
          icon: Icons.bar_chart_rounded,
        ),
        TutorialStep(
          id: 'cpt_history',
          title: 'Historique des transactions',
          description: 'Parcourez les écritures comptables.',
          targetRoute: AppRoutes.financeHistory,
          icon: Icons.receipt_long_rounded,
        ),
        TutorialStep(
          id: 'cpt_bilan',
          title: 'Bilan comptable',
          description: 'Générez et consultez le bilan.',
          targetRoute: AppRoutes.bilan,
          icon: Icons.assessment_rounded,
        ),
        TutorialStep(
          id: 'cpt_reconciliation',
          title: 'Réconciliation',
          description: 'Vérifiez la concordance des comptes.',
          targetRoute: AppRoutes.financeReconciliation,
          icon: Icons.sync_alt_rounded,
        ),
      ],
    ),

    'comptable_adjoint': const TutorialConfig(
      roleCode: 'comptable_adjoint',
      roleDisplayName: 'Comptable Adjoint',
      roleDescription: 'Vous assistez le comptable.',
      roleIcon: Icons.calculate_outlined,
      steps: [
        TutorialStep(
          id: 'cpta_finance',
          title: 'Voir les finances',
          description: 'Consultez les données financières.',
          targetRoute: AppRoutes.finance,
          icon: Icons.bar_chart_rounded,
        ),
        TutorialStep(
          id: 'cpta_history',
          title: 'Historique',
          description: 'Parcourez les transactions.',
          targetRoute: AppRoutes.financeHistory,
          icon: Icons.receipt_long_rounded,
        ),
      ],
    ),

    // ── COMMISSAIRE AUX COMPTES ────────────────────────────
    'commissaire_aux_comptes': const TutorialConfig(
      roleCode: 'commissaire_aux_comptes',
      roleDisplayName: 'Commissaire aux Comptes',
      roleDescription: 'Vous vérifiez la conformité des comptes de l\'église.',
      roleIcon: Icons.policy_rounded,
      steps: [
        TutorialStep(
          id: 'cac_finance',
          title: 'Accéder aux finances',
          description: 'Consultez l\'intégralité du module financier.',
          targetRoute: AppRoutes.finance,
          icon: Icons.bar_chart_rounded,
        ),
        TutorialStep(
          id: 'cac_bilan',
          title: 'Consulter le bilan',
          description: 'Analysez le bilan financier.',
          targetRoute: AppRoutes.bilan,
          icon: Icons.assessment_rounded,
        ),
        TutorialStep(
          id: 'cac_audit',
          title: 'Audit et traçabilité',
          description: 'Consultez les logs d\'activité.',
          targetRoute: AppRoutes.audit,
          icon: Icons.history_rounded,
        ),
      ],
    ),

    // ── AUDITEUR INTERNE ───────────────────────────────────
    'auditeur_interne': const TutorialConfig(
      roleCode: 'auditeur_interne',
      roleDisplayName: 'Auditeur Interne',
      roleDescription:
          'Vous effectuez l\'audit interne de l\'église.',
      roleIcon: Icons.find_in_page_rounded,
      steps: [
        TutorialStep(
          id: 'ai_audit',
          title: 'Tableau de bord audit',
          description: 'Consultez les logs et anomalies.',
          targetRoute: AppRoutes.audit,
          icon: Icons.policy_rounded,
        ),
        TutorialStep(
          id: 'ai_history',
          title: 'Historique des actions',
          description: 'Parcourez l\'historique complet.',
          targetRoute: AppRoutes.auditHistory,
          icon: Icons.history_rounded,
        ),
        TutorialStep(
          id: 'ai_finance',
          title: 'Finances (lecture)',
          description: 'Consultez les données financières.',
          targetRoute: AppRoutes.finance,
          icon: Icons.bar_chart_rounded,
        ),
      ],
    ),

    // ── COORDINATEUR FORMATION ──────────────────────────────
    'coordinateur_formation': const TutorialConfig(
      roleCode: 'coordinateur_formation',
      roleDisplayName: 'Coordinateur de Formation',
      roleDescription: 'Vous coordonnez les formations et séminaires.',
      roleIcon: Icons.co_present_rounded,
      steps: [
        TutorialStep(
          id: 'cf_events',
          title: 'Voir les formations',
          description: 'Consultez les événements de formation.',
          targetRoute: AppRoutes.vieSpirituelleEvents,
          icon: Icons.event_rounded,
        ),
        TutorialStep(
          id: 'cf_create',
          title: 'Créer une formation',
          description: 'Planifiez un nouveau séminaire.',
          targetRoute: AppRoutes.vieSpirituelleEventsNew,
          icon: Icons.event_available_rounded,
        ),
        TutorialStep(
          id: 'cf_calendar',
          title: 'Calendrier',
          description: 'Consultez les disponibilités.',
          targetRoute: AppRoutes.calendrier,
          icon: Icons.calendar_month_rounded,
        ),
      ],
    ),

    // ── RESPONSABLE MISSION ────────────────────────────────
    'responsable_mission': const TutorialConfig(
      roleCode: 'responsable_mission',
      roleDisplayName: 'Responsable Mission',
      roleDescription: 'Vous gérez les missions évangéliques.',
      roleIcon: Icons.public_rounded,
      steps: [
        TutorialStep(
          id: 'rm_events',
          title: 'Événements de mission',
          description: 'Consultez les missions planifiées.',
          targetRoute: AppRoutes.vieSpirituelleEvents,
          icon: Icons.event_rounded,
        ),
        TutorialStep(
          id: 'rm_create',
          title: 'Planifier une mission',
          description: 'Créez un événement de mission.',
          targetRoute: AppRoutes.vieSpirituelleEventsNew,
          icon: Icons.event_available_rounded,
        ),
        TutorialStep(
          id: 'rm_communication',
          title: 'Communications',
          description: 'Partagez les rapports de terrain.',
          targetRoute: AppRoutes.communication,
          icon: Icons.campaign_rounded,
        ),
      ],
    ),

    // ── BÉNÉVOLE ───────────────────────────────────────────
    'benevole': const TutorialConfig(
      roleCode: 'benevole',
      roleDisplayName: 'Bénévole',
      roleDescription:
          'Vous contribuez à la vie de l\'église. '
          'Voici votre espace.',
      roleIcon: Icons.handshake_rounded,
      steps: [
        TutorialStep(
          id: 'ben_calendar',
          title: 'Mon calendrier',
          description: 'Consultez les événements auxquels vous participez.',
          targetRoute: AppRoutes.calendrier,
          icon: Icons.calendar_month_rounded,
        ),
        TutorialStep(
          id: 'ben_tasks',
          title: 'Mes tâches',
          description: 'Voyez les tâches qui vous sont assignées.',
          targetRoute: AppRoutes.communicationTasks,
          icon: Icons.task_alt_rounded,
        ),
        TutorialStep(
          id: 'ben_annonces',
          title: 'Annonces',
          description: 'Restez informé des nouvelles de l\'église.',
          targetRoute: AppRoutes.communicationAnnonces,
          icon: Icons.campaign_rounded,
        ),
      ],
    ),

    // ── DONATEUR ───────────────────────────────────────────
    'donateur': const TutorialConfig(
      roleCode: 'donateur',
      roleDisplayName: 'Donateur',
      roleDescription:
          'Merci pour votre générosité ! '
          'Voici comment suivre vos contributions.',
      roleIcon: Icons.favorite_rounded,
      steps: [
        TutorialStep(
          id: 'don_donations',
          title: 'Mes donations',
          description: 'Consultez l\'historique de vos dons.',
          targetRoute: AppRoutes.memberDonations,
          icon: Icons.volunteer_activism_rounded,
        ),
        TutorialStep(
          id: 'don_annonces',
          title: 'Annonces',
          description: 'Restez informé des nouvelles.',
          targetRoute: AppRoutes.communicationAnnonces,
          icon: Icons.campaign_rounded,
        ),
      ],
    ),

    // ── VISITEUR TEMPORAIRE ─────────────────────────────────
    'visiteur_temporaire': const TutorialConfig(
      roleCode: 'visiteur_temporaire',
      roleDisplayName: 'Visiteur',
      roleDescription:
          'Bienvenue ! Voici ce que vous pouvez consulter.',
      roleIcon: Icons.visibility_rounded,
      steps: [
        TutorialStep(
          id: 'vis_annonces',
          title: 'Annonces',
          description: 'Consultez les annonces publiques.',
          targetRoute: AppRoutes.communicationAnnonces,
          icon: Icons.campaign_rounded,
        ),
        TutorialStep(
          id: 'vis_calendar',
          title: 'Calendrier',
          description: 'Consultez les événements à venir.',
          targetRoute: AppRoutes.calendrier,
          icon: Icons.calendar_month_rounded,
        ),
      ],
    ),

    // ── RESPONSABLE GROUPE (GÉNÉRIQUE) ─────────────────────
    'responsable_groupe': const TutorialConfig(
      roleCode: 'responsable_groupe',
      roleDisplayName: 'Responsable de Groupe',
      roleDescription: 'Vous gérez votre groupe ministériel.',
      roleIcon: Icons.groups_3_rounded,
      steps: [
        TutorialStep(
          id: 'rg_group',
          title: 'Voir mon groupe',
          description: 'Accédez à votre tableau de bord de groupe.',
          targetRoute: '/groups',
          icon: Icons.groups_rounded,
        ),
        TutorialStep(
          id: 'rg_events',
          title: 'Créer un événement',
          description: 'Planifiez une activité pour votre groupe.',
          targetRoute: AppRoutes.vieSpirituelleEventsNew,
          icon: Icons.event_available_rounded,
        ),
        TutorialStep(
          id: 'rg_communication',
          title: 'Communiquer',
          description: 'Envoyez des messages à votre groupe.',
          targetRoute: AppRoutes.communication,
          icon: Icons.campaign_rounded,
        ),
      ],
    ),

    // ── WEBMASTER ──────────────────────────────────────────
    'webmaster': const TutorialConfig(
      roleCode: 'webmaster',
      roleDisplayName: 'Webmaster',
      roleDescription:
          'Vous gérez la présence numérique de l\'église.',
      roleIcon: Icons.web_rounded,
      steps: [
        TutorialStep(
          id: 'wm_communication',
          title: 'Communications',
          description: 'Gérez les publications et annonces.',
          targetRoute: AppRoutes.communication,
          icon: Icons.campaign_rounded,
        ),
        TutorialStep(
          id: 'wm_social',
          title: 'Réseau social',
          description: 'Publiez sur le fil social de l\'église.',
          targetRoute: AppRoutes.communicationSocial,
          icon: Icons.share_rounded,
        ),
        TutorialStep(
          id: 'wm_events',
          title: 'Événements',
          description: 'Promouvez les événements de l\'église.',
          targetRoute: AppRoutes.vieSpirituelleEvents,
          icon: Icons.event_rounded,
        ),
      ],
    ),

    // ── SUPER ADMIN ────────────────────────────────────────
    'super_admin': const TutorialConfig(
      roleCode: 'super_admin',
      roleDisplayName: 'Super Administrateur',
      roleDescription:
          'Vous avez un accès complet à toute la plateforme.',
      roleIcon: Icons.security_rounded,
      steps: [
        TutorialStep(
          id: 'sa_dashboard',
          title: 'Tableau de bord global',
          description: 'Vue d\'ensemble multi-église.',
          targetRoute: AppRoutes.dashboard,
          icon: Icons.dashboard_rounded,
        ),
        TutorialStep(
          id: 'sa_churches',
          title: 'Gérer les églises',
          description: 'Administrez les comptes d\'église.',
          targetRoute: AppRoutes.churches,
          icon: Icons.church_rounded,
        ),
        TutorialStep(
          id: 'sa_roles',
          title: 'Gestion des rôles',
          description: 'Configurez les permissions.',
          targetRoute: AppRoutes.adminRoles,
          icon: Icons.manage_accounts_rounded,
        ),
        TutorialStep(
          id: 'sa_audit',
          title: 'Audit global',
          description: 'Consultez tous les logs.',
          targetRoute: AppRoutes.audit,
          icon: Icons.policy_rounded,
        ),
        TutorialStep(
          id: 'sa_settings',
          title: 'Paramètres système',
          description: 'Configuration globale.',
          targetRoute: AppRoutes.adminSettings,
          icon: Icons.settings_rounded,
        ),
      ],
    ),

    // ── CONSEILLERS ────────────────────────────────────────
    'conseiller_principal': const TutorialConfig(
      roleCode: 'conseiller_principal',
      roleDisplayName: 'Conseiller Principal',
      roleDescription: 'Vous conseillez la direction de l\'église.',
      roleIcon: Icons.psychology_rounded,
      steps: [
        TutorialStep(
          id: 'cp_dashboard',
          title: 'Vue d\'ensemble',
          description: 'Consultez les indicateurs clés.',
          targetRoute: AppRoutes.dashboard,
          icon: Icons.dashboard_rounded,
        ),
        TutorialStep(
          id: 'cp_finance',
          title: 'Rapports financiers',
          description: 'Consultez les finances en lecture.',
          targetRoute: AppRoutes.finance,
          icon: Icons.bar_chart_rounded,
        ),
        TutorialStep(
          id: 'cp_members',
          title: 'Membres',
          description: 'Consultez la communauté.',
          targetRoute: AppRoutes.brebis,
          icon: Icons.people_rounded,
        ),
      ],
    ),

    'conseiller': const TutorialConfig(
      roleCode: 'conseiller',
      roleDisplayName: 'Conseiller',
      roleDescription: 'Vous participez aux décisions collégiales.',
      roleIcon: Icons.psychology_alt_rounded,
      steps: [
        TutorialStep(
          id: 'cons_dashboard',
          title: 'Vue d\'ensemble',
          description: 'Consultez les indicateurs.',
          targetRoute: AppRoutes.dashboard,
          icon: Icons.dashboard_rounded,
        ),
        TutorialStep(
          id: 'cons_annonces',
          title: 'Annonces',
          description: 'Consultez les communications.',
          targetRoute: AppRoutes.communicationAnnonces,
          icon: Icons.campaign_rounded,
        ),
      ],
    ),

    // ── GESTIONNAIRE DOCUMENTS / ARCHIVES ──────────────────
    'gestionnaire_documents': const TutorialConfig(
      roleCode: 'gestionnaire_documents',
      roleDisplayName: 'Gestionnaire Documents',
      roleDescription: 'Vous gérez les archives documentaires.',
      roleIcon: Icons.folder_rounded,
      steps: [
        TutorialStep(
          id: 'gd_communication',
          title: 'Documents et publications',
          description: 'Gérez les documents officiels.',
          targetRoute: AppRoutes.communication,
          icon: Icons.description_rounded,
        ),
        TutorialStep(
          id: 'gd_annonces',
          title: 'Annonces',
          description: 'Publiez les communications officielles.',
          targetRoute: AppRoutes.communicationAnnonces,
          icon: Icons.campaign_rounded,
        ),
      ],
    ),

    'responsable_archives': const TutorialConfig(
      roleCode: 'responsable_archives',
      roleDisplayName: 'Responsable Archives',
      roleDescription: 'Vous gérez l\'archivage à long terme.',
      roleIcon: Icons.inventory_2_rounded,
      steps: [
        TutorialStep(
          id: 'ra_communication',
          title: 'Archives documentaires',
          description: 'Accédez aux archives.',
          targetRoute: AppRoutes.communication,
          icon: Icons.description_rounded,
        ),
      ],
    ),

    // ── GESTIONNAIRE BUDGET ÉVÉNEMENT ──────────────────────
    'gestionnaire_budget_event': const TutorialConfig(
      roleCode: 'gestionnaire_budget_event',
      roleDisplayName: 'Gestionnaire Budget Événement',
      roleDescription: 'Vous gérez le budget alloué à un événement.',
      roleIcon: Icons.request_quote_rounded,
      steps: [
        TutorialStep(
          id: 'gbe_events',
          title: 'Voir les événements',
          description: 'Consultez les événements en cours.',
          targetRoute: AppRoutes.vieSpirituelleEvents,
          icon: Icons.event_rounded,
        ),
        TutorialStep(
          id: 'gbe_finance',
          title: 'Budget événementiel',
          description: 'Suivez les dépenses de l\'événement.',
          targetRoute: AppRoutes.finance,
          icon: Icons.bar_chart_rounded,
        ),
      ],
    ),
  };
}
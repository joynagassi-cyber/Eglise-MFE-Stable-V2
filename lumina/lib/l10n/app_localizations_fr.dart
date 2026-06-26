// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get dashboardTitle => 'Tableau de Bord';

  @override
  String get quickActions => 'Actions Rapides';

  @override
  String get balance => 'Solde';

  @override
  String get members => 'Membres';

  @override
  String get incomeMonth => 'Entrées (Mois)';

  @override
  String get expenseMonth => 'Sorties (Mois)';

  @override
  String get loading => 'Chargement des données...';

  @override
  String get errorOccurred => 'Une erreur est survenue';

  @override
  String get retry => 'Réessayer';

  @override
  String get cancel => 'Annuler';

  @override
  String get auditSecurity => 'Audit & Sécurité';

  @override
  String get surveillanceReports => 'Surveillance et Rapports';

  @override
  String get rbacAdmin => 'Administration RBAC';

  @override
  String get rolesPermissions => 'Gestion des Rôles et Permissions';

  @override
  String get permissionsMatrix => 'Matrice des Permissions';

  @override
  String get auditReportSaved => 'Rapport d\'Audit sauvegardé dans \"Lumina\"';

  @override
  String exportError(String error) {
    return 'Erreur export: $error';
  }

  @override
  String get groupDashboard => 'Tableau de Bord Groupe';

  @override
  String get membersArea => 'Espace Membres';

  @override
  String get activities => 'Activités';

  @override
  String get expenses => 'Dépenses';

  @override
  String get reports => 'Rapports';

  @override
  String get quickNavigation => 'Navigation Rapide';

  @override
  String get community => 'Communauté';

  @override
  String get communityDescription => 'Membres, groupes, visiteurs';

  @override
  String get spiritualLife => 'Vie Spirituelle';

  @override
  String get spiritualLifeDescription => 'Sacrements, célébrations, événements';

  @override
  String get team => 'Équipe';

  @override
  String get teamDescription => 'Bergers, équipes pastorales';

  @override
  String get ministry => 'Ministère';

  @override
  String get ministryDescription => 'Finance, églises, rubriques';

  @override
  String get communication => 'Communication';

  @override
  String get communicationDescription => 'Annonces, social, messagerie';

  @override
  String get calendar => 'Calendrier';

  @override
  String get calendarDescription => 'Événements et rendez-vous';

  @override
  String groupDashboardTitle(String role) {
    return 'Dashboard $role';
  }

  @override
  String groupManagement(String group) {
    return 'Gestion du groupe : $group';
  }

  @override
  String get groupActions => 'Actions du Groupe';

  @override
  String get memberContributions => 'Cotisations Membres';

  @override
  String get alertsVigilance => 'Alertes & Vigilance';

  @override
  String get sundayChecklist => 'Checklist de Dimanche';

  @override
  String get viewAll => 'Voir tout';

  @override
  String groupDataRestricted(String group) {
    return 'Toutes les données affichées ici sont restreintes au scope du groupe \"$group\".';
  }

  @override
  String birthdaysAlert(int count) {
    return '$count Anniversaire(s)';
  }

  @override
  String get birthdaysSubtitle => 'À fêter cette semaine !';

  @override
  String absenceAlerts(int count) {
    return '$count Alerte(s) d\'absence';
  }

  @override
  String get absenceSubtitle => 'Plus de 3 absences consécutives';

  @override
  String newMilestones(int count) {
    return '$count Nouveaux Jalons';
  }

  @override
  String get milestonesSubtitle => 'Membres ayant progressé ce mois';

  @override
  String get noAlerts => 'Aucune alerte pour le moment.';

  @override
  String get topEngagedMembers => 'Top Fidèles Engagés';

  @override
  String get insufficientEngagementData =>
      'Données d\'engagement insuffisantes';

  @override
  String get groupMembers => 'Membres du Groupe';

  @override
  String get groupBudget => 'Budget Groupe';

  @override
  String get presence => 'Présence';

  @override
  String get addMember => 'Ajouter Membre';

  @override
  String get transfer => 'Transfert';

  @override
  String get quarterlyBilan => 'Bilan Trim.';

  @override
  String get history => 'Historique';

  @override
  String get quarterlyBilanTitle => 'Bilan Trimestriel';

  @override
  String get quarterlyBilanConfirm =>
      'Voulez-vous clôturer le trimestre et transférer les fonds vers la caisse générale ?\n\nCela générera une transaction de transfert sortante de votre caisse de groupe vers le compte principal de l\'église.';

  @override
  String get later => 'Plus tard';

  @override
  String get transferFonds => 'Transférer';

  @override
  String get insufficientBalance => 'Solde insuffisant pour un transfert.';

  @override
  String get transferSuccess => 'Transfert trimestriel effectué avec succès !';

  @override
  String get sundayServicePrep => 'Préparation du Culte';

  @override
  String get bilan_title => 'Bilan Financier';

  @override
  String get bilan_export_pdf => 'Exporter PDF';

  @override
  String get bilan_report_ready => 'Le rapport est prêt';

  @override
  String get bilan_data_incomplete => 'Données incomplètes pour cette période';

  @override
  String get bilan_revenues => 'Recettes';

  @override
  String get bilan_expenses => 'Dépenses';

  @override
  String get bilan_net_balance => 'Solde Net';

  @override
  String get bilan_sealed => 'Bilan Scellé';

  @override
  String get bilan_temporal_evolution => 'Évolution Temporelle';

  @override
  String get bilan_dimension_analysis => 'Analyse par Dimensions';

  @override
  String get bilan_by_category => 'Par Catégorie';

  @override
  String get bilan_by_month => 'Par Mois';

  @override
  String get donors_title => 'Gestion des Donateurs';

  @override
  String get donors_evolution => 'Évolution des Dons';

  @override
  String get donors_last_6_months => '6 derniers mois';

  @override
  String get donors_active_campaigns => 'Campagnes Actives';

  @override
  String get donors_all_campaigns => 'Toutes les Campagnes';

  @override
  String get donors_quick_actions => 'Actions Rapides';

  @override
  String get donors_action_list => 'Liste Donateurs';

  @override
  String get donors_action_record => 'Saisir un Don';

  @override
  String get donors_stats_loading => 'Chargement des stats...';

  @override
  String get donors_new_donor => 'Nouveau Donateur';

  @override
  String get donors_stat_total => 'Total Collecté';

  @override
  String get donors_stat_avg => 'Don Moyen';

  @override
  String get donors_stat_retention => 'Taux Rétention';
}

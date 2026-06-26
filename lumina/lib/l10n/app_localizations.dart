import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// Titre principal du tableau de bord
  ///
  /// In fr, this message translates to:
  /// **'Tableau de Bord'**
  String get dashboardTitle;

  /// No description provided for @quickActions.
  ///
  /// In fr, this message translates to:
  /// **'Actions Rapides'**
  String get quickActions;

  /// No description provided for @balance.
  ///
  /// In fr, this message translates to:
  /// **'Solde'**
  String get balance;

  /// No description provided for @members.
  ///
  /// In fr, this message translates to:
  /// **'Membres'**
  String get members;

  /// No description provided for @incomeMonth.
  ///
  /// In fr, this message translates to:
  /// **'Entrées (Mois)'**
  String get incomeMonth;

  /// No description provided for @expenseMonth.
  ///
  /// In fr, this message translates to:
  /// **'Sorties (Mois)'**
  String get expenseMonth;

  /// No description provided for @loading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement des données...'**
  String get loading;

  /// No description provided for @errorOccurred.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get errorOccurred;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @auditSecurity.
  ///
  /// In fr, this message translates to:
  /// **'Audit & Sécurité'**
  String get auditSecurity;

  /// No description provided for @surveillanceReports.
  ///
  /// In fr, this message translates to:
  /// **'Surveillance et Rapports'**
  String get surveillanceReports;

  /// No description provided for @rbacAdmin.
  ///
  /// In fr, this message translates to:
  /// **'Administration RBAC'**
  String get rbacAdmin;

  /// No description provided for @rolesPermissions.
  ///
  /// In fr, this message translates to:
  /// **'Gestion des Rôles et Permissions'**
  String get rolesPermissions;

  /// No description provided for @permissionsMatrix.
  ///
  /// In fr, this message translates to:
  /// **'Matrice des Permissions'**
  String get permissionsMatrix;

  /// No description provided for @auditReportSaved.
  ///
  /// In fr, this message translates to:
  /// **'Rapport d\'Audit sauvegardé dans \"Lumina\"'**
  String get auditReportSaved;

  /// No description provided for @exportError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur export: {error}'**
  String exportError(String error);

  /// No description provided for @groupDashboard.
  ///
  /// In fr, this message translates to:
  /// **'Tableau de Bord Groupe'**
  String get groupDashboard;

  /// No description provided for @membersArea.
  ///
  /// In fr, this message translates to:
  /// **'Espace Membres'**
  String get membersArea;

  /// No description provided for @activities.
  ///
  /// In fr, this message translates to:
  /// **'Activités'**
  String get activities;

  /// No description provided for @expenses.
  ///
  /// In fr, this message translates to:
  /// **'Dépenses'**
  String get expenses;

  /// No description provided for @reports.
  ///
  /// In fr, this message translates to:
  /// **'Rapports'**
  String get reports;

  /// No description provided for @quickNavigation.
  ///
  /// In fr, this message translates to:
  /// **'Navigation Rapide'**
  String get quickNavigation;

  /// No description provided for @community.
  ///
  /// In fr, this message translates to:
  /// **'Communauté'**
  String get community;

  /// No description provided for @communityDescription.
  ///
  /// In fr, this message translates to:
  /// **'Membres, groupes, visiteurs'**
  String get communityDescription;

  /// No description provided for @spiritualLife.
  ///
  /// In fr, this message translates to:
  /// **'Vie Spirituelle'**
  String get spiritualLife;

  /// No description provided for @spiritualLifeDescription.
  ///
  /// In fr, this message translates to:
  /// **'Sacrements, célébrations, événements'**
  String get spiritualLifeDescription;

  /// No description provided for @team.
  ///
  /// In fr, this message translates to:
  /// **'Équipe'**
  String get team;

  /// No description provided for @teamDescription.
  ///
  /// In fr, this message translates to:
  /// **'Bergers, équipes pastorales'**
  String get teamDescription;

  /// No description provided for @ministry.
  ///
  /// In fr, this message translates to:
  /// **'Ministère'**
  String get ministry;

  /// No description provided for @ministryDescription.
  ///
  /// In fr, this message translates to:
  /// **'Finance, églises, rubriques'**
  String get ministryDescription;

  /// No description provided for @communication.
  ///
  /// In fr, this message translates to:
  /// **'Communication'**
  String get communication;

  /// No description provided for @communicationDescription.
  ///
  /// In fr, this message translates to:
  /// **'Annonces, social, messagerie'**
  String get communicationDescription;

  /// No description provided for @calendar.
  ///
  /// In fr, this message translates to:
  /// **'Calendrier'**
  String get calendar;

  /// No description provided for @calendarDescription.
  ///
  /// In fr, this message translates to:
  /// **'Événements et rendez-vous'**
  String get calendarDescription;

  /// No description provided for @groupDashboardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Dashboard {role}'**
  String groupDashboardTitle(String role);

  /// No description provided for @groupManagement.
  ///
  /// In fr, this message translates to:
  /// **'Gestion du groupe : {group}'**
  String groupManagement(String group);

  /// No description provided for @groupActions.
  ///
  /// In fr, this message translates to:
  /// **'Actions du Groupe'**
  String get groupActions;

  /// No description provided for @memberContributions.
  ///
  /// In fr, this message translates to:
  /// **'Cotisations Membres'**
  String get memberContributions;

  /// No description provided for @alertsVigilance.
  ///
  /// In fr, this message translates to:
  /// **'Alertes & Vigilance'**
  String get alertsVigilance;

  /// No description provided for @sundayChecklist.
  ///
  /// In fr, this message translates to:
  /// **'Checklist de Dimanche'**
  String get sundayChecklist;

  /// No description provided for @viewAll.
  ///
  /// In fr, this message translates to:
  /// **'Voir tout'**
  String get viewAll;

  /// No description provided for @groupDataRestricted.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les données affichées ici sont restreintes au scope du groupe \"{group}\".'**
  String groupDataRestricted(String group);

  /// No description provided for @birthdaysAlert.
  ///
  /// In fr, this message translates to:
  /// **'{count} Anniversaire(s)'**
  String birthdaysAlert(int count);

  /// No description provided for @birthdaysSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'À fêter cette semaine !'**
  String get birthdaysSubtitle;

  /// No description provided for @absenceAlerts.
  ///
  /// In fr, this message translates to:
  /// **'{count} Alerte(s) d\'absence'**
  String absenceAlerts(int count);

  /// No description provided for @absenceSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Plus de 3 absences consécutives'**
  String get absenceSubtitle;

  /// No description provided for @newMilestones.
  ///
  /// In fr, this message translates to:
  /// **'{count} Nouveaux Jalons'**
  String newMilestones(int count);

  /// No description provided for @milestonesSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Membres ayant progressé ce mois'**
  String get milestonesSubtitle;

  /// No description provided for @noAlerts.
  ///
  /// In fr, this message translates to:
  /// **'Aucune alerte pour le moment.'**
  String get noAlerts;

  /// No description provided for @topEngagedMembers.
  ///
  /// In fr, this message translates to:
  /// **'Top Fidèles Engagés'**
  String get topEngagedMembers;

  /// No description provided for @insufficientEngagementData.
  ///
  /// In fr, this message translates to:
  /// **'Données d\'engagement insuffisantes'**
  String get insufficientEngagementData;

  /// No description provided for @groupMembers.
  ///
  /// In fr, this message translates to:
  /// **'Membres du Groupe'**
  String get groupMembers;

  /// No description provided for @groupBudget.
  ///
  /// In fr, this message translates to:
  /// **'Budget Groupe'**
  String get groupBudget;

  /// No description provided for @presence.
  ///
  /// In fr, this message translates to:
  /// **'Présence'**
  String get presence;

  /// No description provided for @addMember.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter Membre'**
  String get addMember;

  /// No description provided for @transfer.
  ///
  /// In fr, this message translates to:
  /// **'Transfert'**
  String get transfer;

  /// No description provided for @quarterlyBilan.
  ///
  /// In fr, this message translates to:
  /// **'Bilan Trim.'**
  String get quarterlyBilan;

  /// No description provided for @history.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get history;

  /// No description provided for @quarterlyBilanTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bilan Trimestriel'**
  String get quarterlyBilanTitle;

  /// No description provided for @quarterlyBilanConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous clôturer le trimestre et transférer les fonds vers la caisse générale ?\n\nCela générera une transaction de transfert sortante de votre caisse de groupe vers le compte principal de l\'église.'**
  String get quarterlyBilanConfirm;

  /// No description provided for @later.
  ///
  /// In fr, this message translates to:
  /// **'Plus tard'**
  String get later;

  /// No description provided for @transferFonds.
  ///
  /// In fr, this message translates to:
  /// **'Transférer'**
  String get transferFonds;

  /// No description provided for @insufficientBalance.
  ///
  /// In fr, this message translates to:
  /// **'Solde insuffisant pour un transfert.'**
  String get insufficientBalance;

  /// No description provided for @transferSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Transfert trimestriel effectué avec succès !'**
  String get transferSuccess;

  /// No description provided for @sundayServicePrep.
  ///
  /// In fr, this message translates to:
  /// **'Préparation du Culte'**
  String get sundayServicePrep;

  /// No description provided for @bilan_title.
  ///
  /// In fr, this message translates to:
  /// **'Bilan Financier'**
  String get bilan_title;

  /// No description provided for @bilan_export_pdf.
  ///
  /// In fr, this message translates to:
  /// **'Exporter PDF'**
  String get bilan_export_pdf;

  /// No description provided for @bilan_report_ready.
  ///
  /// In fr, this message translates to:
  /// **'Le rapport est prêt'**
  String get bilan_report_ready;

  /// No description provided for @bilan_data_incomplete.
  ///
  /// In fr, this message translates to:
  /// **'Données incomplètes pour cette période'**
  String get bilan_data_incomplete;

  /// No description provided for @bilan_revenues.
  ///
  /// In fr, this message translates to:
  /// **'Recettes'**
  String get bilan_revenues;

  /// No description provided for @bilan_expenses.
  ///
  /// In fr, this message translates to:
  /// **'Dépenses'**
  String get bilan_expenses;

  /// No description provided for @bilan_net_balance.
  ///
  /// In fr, this message translates to:
  /// **'Solde Net'**
  String get bilan_net_balance;

  /// No description provided for @bilan_sealed.
  ///
  /// In fr, this message translates to:
  /// **'Bilan Scellé'**
  String get bilan_sealed;

  /// No description provided for @bilan_temporal_evolution.
  ///
  /// In fr, this message translates to:
  /// **'Évolution Temporelle'**
  String get bilan_temporal_evolution;

  /// No description provided for @bilan_dimension_analysis.
  ///
  /// In fr, this message translates to:
  /// **'Analyse par Dimensions'**
  String get bilan_dimension_analysis;

  /// No description provided for @bilan_by_category.
  ///
  /// In fr, this message translates to:
  /// **'Par Catégorie'**
  String get bilan_by_category;

  /// No description provided for @bilan_by_month.
  ///
  /// In fr, this message translates to:
  /// **'Par Mois'**
  String get bilan_by_month;

  /// No description provided for @donors_title.
  ///
  /// In fr, this message translates to:
  /// **'Gestion des Donateurs'**
  String get donors_title;

  /// No description provided for @donors_evolution.
  ///
  /// In fr, this message translates to:
  /// **'Évolution des Dons'**
  String get donors_evolution;

  /// No description provided for @donors_last_6_months.
  ///
  /// In fr, this message translates to:
  /// **'6 derniers mois'**
  String get donors_last_6_months;

  /// No description provided for @donors_active_campaigns.
  ///
  /// In fr, this message translates to:
  /// **'Campagnes Actives'**
  String get donors_active_campaigns;

  /// No description provided for @donors_all_campaigns.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les Campagnes'**
  String get donors_all_campaigns;

  /// No description provided for @donors_quick_actions.
  ///
  /// In fr, this message translates to:
  /// **'Actions Rapides'**
  String get donors_quick_actions;

  /// No description provided for @donors_action_list.
  ///
  /// In fr, this message translates to:
  /// **'Liste Donateurs'**
  String get donors_action_list;

  /// No description provided for @donors_action_record.
  ///
  /// In fr, this message translates to:
  /// **'Saisir un Don'**
  String get donors_action_record;

  /// No description provided for @donors_stats_loading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement des stats...'**
  String get donors_stats_loading;

  /// No description provided for @donors_new_donor.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau Donateur'**
  String get donors_new_donor;

  /// No description provided for @donors_stat_total.
  ///
  /// In fr, this message translates to:
  /// **'Total Collecté'**
  String get donors_stat_total;

  /// No description provided for @donors_stat_avg.
  ///
  /// In fr, this message translates to:
  /// **'Don Moyen'**
  String get donors_stat_avg;

  /// No description provided for @donors_stat_retention.
  ///
  /// In fr, this message translates to:
  /// **'Taux Rétention'**
  String get donors_stat_retention;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

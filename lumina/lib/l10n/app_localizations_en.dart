// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get balance => 'Balance';

  @override
  String get members => 'Members';

  @override
  String get incomeMonth => 'Income (Month)';

  @override
  String get expenseMonth => 'Expenses (Month)';

  @override
  String get loading => 'Loading data...';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get auditSecurity => 'Audit & Security';

  @override
  String get surveillanceReports => 'Monitoring and Reports';

  @override
  String get rbacAdmin => 'RBAC Administration';

  @override
  String get rolesPermissions => 'Role & Permission Management';

  @override
  String get permissionsMatrix => 'Permissions Matrix';

  @override
  String get auditReportSaved => 'Audit report saved in \"Lumina\"';

  @override
  String exportError(String error) {
    return 'Export error: $error';
  }

  @override
  String get groupDashboard => 'Group Dashboard';

  @override
  String get membersArea => 'Members Area';

  @override
  String get activities => 'Activities';

  @override
  String get expenses => 'Expenses';

  @override
  String get reports => 'Reports';

  @override
  String get quickNavigation => 'Quick Navigation';

  @override
  String get community => 'Community';

  @override
  String get communityDescription => 'Members, groups, visitors';

  @override
  String get spiritualLife => 'Spiritual Life';

  @override
  String get spiritualLifeDescription => 'Sacraments, celebrations, events';

  @override
  String get team => 'Team';

  @override
  String get teamDescription => 'Shepherds, pastoral teams';

  @override
  String get ministry => 'Ministry';

  @override
  String get ministryDescription => 'Finance, churches, sections';

  @override
  String get communication => 'Communication';

  @override
  String get communicationDescription => 'Announcements, social, messaging';

  @override
  String get calendar => 'Calendar';

  @override
  String get calendarDescription => 'Events and appointments';

  @override
  String groupDashboardTitle(String role) {
    return '$role Dashboard';
  }

  @override
  String groupManagement(String group) {
    return 'Group Management: $group';
  }

  @override
  String get groupActions => 'Group Actions';

  @override
  String get memberContributions => 'Member Contributions';

  @override
  String get alertsVigilance => 'Alerts & Monitoring';

  @override
  String get sundayChecklist => 'Sunday Checklist';

  @override
  String get viewAll => 'View all';

  @override
  String groupDataRestricted(String group) {
    return 'All data shown here are restricted to the scale of group \"$group\".';
  }

  @override
  String birthdaysAlert(int count) {
    return '$count Birthday(s)';
  }

  @override
  String get birthdaysSubtitle => 'To celebrate this week!';

  @override
  String absenceAlerts(int count) {
    return '$count Absence Alert(s)';
  }

  @override
  String get absenceSubtitle => 'More than 3 consecutive absences';

  @override
  String newMilestones(int count) {
    return '$count New Milestones';
  }

  @override
  String get milestonesSubtitle => 'Members who progressed this month';

  @override
  String get noAlerts => 'No alerts at the moment.';

  @override
  String get topEngagedMembers => 'Top Engaged Members';

  @override
  String get insufficientEngagementData => 'Insufficient engagement data';

  @override
  String get groupMembers => 'Group Members';

  @override
  String get groupBudget => 'Group Budget';

  @override
  String get presence => 'Attendance';

  @override
  String get addMember => 'Add Member';

  @override
  String get transfer => 'Transfer';

  @override
  String get quarterlyBilan => 'Quarterly Report';

  @override
  String get history => 'History';

  @override
  String get quarterlyBilanTitle => 'Quarterly Report';

  @override
  String get quarterlyBilanConfirm =>
      'Do you want to close the quarter and transfer funds to the general fund?\n\nThis will generate an outgoing transfer transaction from your group fund to the main church account.';

  @override
  String get later => 'Later';

  @override
  String get transferFonds => 'Transfer';

  @override
  String get insufficientBalance => 'Insufficient balance for transfer.';

  @override
  String get transferSuccess => 'Quarterly transfer successfully completed!';

  @override
  String get sundayServicePrep => 'Sunday Service Preparation';

  @override
  String get bilan_title => 'Financial Report';

  @override
  String get bilan_export_pdf => 'Export PDF';

  @override
  String get bilan_report_ready => 'The report is ready';

  @override
  String get bilan_data_incomplete => 'Incomplete data for this period';

  @override
  String get bilan_revenues => 'Revenues';

  @override
  String get bilan_expenses => 'Expenses';

  @override
  String get bilan_net_balance => 'Net Balance';

  @override
  String get bilan_sealed => 'Sealed Report';

  @override
  String get bilan_temporal_evolution => 'Temporal Evolution';

  @override
  String get bilan_dimension_analysis => 'Dimension Analysis';

  @override
  String get bilan_by_category => 'By Category';

  @override
  String get bilan_by_month => 'By Month';

  @override
  String get donors_title => 'Donor Management';

  @override
  String get donors_evolution => 'Donations Evolution';

  @override
  String get donors_last_6_months => 'Last 6 months';

  @override
  String get donors_active_campaigns => 'Active Campaigns';

  @override
  String get donors_all_campaigns => 'All Campaigns';

  @override
  String get donors_quick_actions => 'Quick Actions';

  @override
  String get donors_action_list => 'Donor List';

  @override
  String get donors_action_record => 'Record Donation';

  @override
  String get donors_stats_loading => 'Loading stats...';

  @override
  String get donors_new_donor => 'New Donor';

  @override
  String get donors_stat_total => 'Total Collected';

  @override
  String get donors_stat_avg => 'Average Donation';

  @override
  String get donors_stat_retention => 'Retention Rate';
}

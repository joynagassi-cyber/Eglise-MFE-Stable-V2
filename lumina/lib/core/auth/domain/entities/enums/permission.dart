import 'package:equatable/equatable.dart';
import 'package:lumina/core/utils/string_extensions.dart';

class PermissionArgs extends Equatable {
  final String resource;
  final String action;

  const PermissionArgs(this.resource, this.action);

  @override
  List<Object?> get props => [resource, action];

  @override
  String toString() => '$resource:$action';
}

enum Permission {
  // Global / Dashboard
  dashboardView('dashboard_view'),
  dashboardAdvancedStats('dashboard_advanced_stats'),

  // Membres
  membersView('members_view'),
  membersCreate('members_create'),
  membersEdit('members_edit'),
  membersDelete('members_delete'),
  membersExport('members_export'),
  membersSensitiveData('members_sensitive_data'),

  // Finance
  financeView('finance_view'),
  financeCreate('finance_create'),
  financeEdit('finance_edit'),
  financeDelete('finance_delete'),
  financeApprove('finance_approve'),
  financeExport('finance_export'),
  financeReports('finance_reports'),
  financeBalanceView('finance_balance_view'),
  financeViewBalance('finance_view_balance'), // added to match ChurchRole

  // Events
  eventsView('events_view'),
  eventsCreate('events_create'),
  eventsEdit('events_edit'),
  eventsDelete('events_delete'),
  eventsManageRegistrations('events_manage_registrations'),
  eventsReports('events_reports'),

  // Groups
  groupsView('groups_view'),
  groupsCreate('groups_create'),
  groupsEdit('groups_edit'),
  groupsDelete('groups_delete'),
  groupsAssignMembers('groups_assign_members'),

  // Celebrations
  celebrationsView('celebrations_view'),
  celebrationsCreate('celebrations_create'),
  celebrationsEdit('celebrations_edit'),
  celebrationsDelete('celebrations_delete'),

  // Bergers (Shepherds)
  bergersView('bergers_view'),
  bergersCreate('bergers_create'),
  bergersEdit('bergers_edit'),
  bergersDelete('bergers_delete'),
  bergersAssignMembers('bergers_assign_members'),

  // Milestones (Étapes spirituelles)
  milestonesView('milestones_view'),
  milestonesCreate('milestones_create'),
  milestonesEdit('milestones_edit'),
  milestonesDelete('milestones_delete'),

  // Social
  socialView('social_view'),
  socialCreate('social_create'),
  socialEdit('social_edit'),
  socialModerate('social_moderate'),

  // Messagerie
  messagingView('messaging_view'),
  messagingSend('messaging_send'),
  messagingBroadcast('messaging_broadcast'),

  // Communications (alias)
  communicationsView('communications_view'),
  communicationsCreate('communications_create'),

  // Rubriques / Categories
  categoriesView('categories_view'),
  categoriesCreate('categories_create'),
  categoriesEdit('categories_edit'),
  categoriesDelete('categories_delete'),
  categoriesManageHierarchy('categories_manage_hierarchy'),

  // Comptes / Accounts
  accountsView('accounts_view'),
  accountsCreate('accounts_create'),
  accountsEdit('accounts_edit'),
  accountsDelete('accounts_delete'),
  accountsTransfer('accounts_transfer'),

  // Budget
  budgetView('budget_view'),
  budgetCreate('budget_create'),
  budgetEdit('budget_edit'),
  budgetDelete('budget_delete'),

  // Admin / Roles
  adminManageRoles('admin_manage_roles'),
  adminManageUsers('admin_manage_users'),
  adminManageChurches('admin_manage_churches'),
  adminViewLogs('admin_view_logs'),
  adminSettings('admin_settings'),
  adminSystemSettings('admin_system_settings'),

  // Documents
  documentsRead('documents_read'),
  documentsWrite('documents_write'),

  // Reports
  reportsExport('reports_export'),
  reportsView('reports_view'),

  // Audit
  auditView('audit_view'),

  // Common legacy mappings (to be updated gradually)
  viewDashboard('view_dashboard'),
  viewMembres('view_membres'),
  createMembre('create_membre'),
  editMembre('edit_membre'),
  deleteMembre('delete_membre'),
  exportMembres('export_membres'),
  viewFinance('view_finance'),
  createTransaction('create_transaction'),
  editTransaction('edit_transaction'),
  deleteTransaction('delete_transaction'),
  validateTransaction('validate_transaction'),
  exportFinance('export_finance'),
  viewEvents('view_events'),
  createEvent('create_event'),
  editEvent('edit_event'),
  deleteEvent('delete_event'),
  viewGroups('view_groups'),
  createGroup('create_group'),
  editGroup('edit_group'),
  deleteGroup('delete_group'),
  viewCelebrations('view_celebrations'),
  createCelebration('create_celebration'),
  editCelebration('edit_celebration'),
  deleteCelebration('delete_celebration'),
  manageUsers('manage_users'),
  manageRoles('manage_roles'),
  manageChurches('manage_churches'),
  viewLogs('view_logs'),
  manageSettings('manage_settings');

  final String code;
  const Permission(this.code);

  String get label {
    switch (this) {
      case Permission.dashboardView:
        return 'Tableau de bord';
      case Permission.membersView:
        return 'Voir les membres';
      case Permission.membersCreate:
        return 'Créer un membre';
      case Permission.membersEdit:
        return 'Modifier un membre';
      case Permission.membersDelete:
        return 'Supprimer un membre';
      case Permission.financeView:
        return 'Voir les finances';
      case Permission.financeCreate:
        return 'Enregistrer une transaction';
      case Permission.financeApprove:
        return 'Approuver les transactions';
      case Permission.eventsView:
        return 'Voir les événements';
      case Permission.groupsView:
        return 'Voir les groupes';
      case Permission.adminManageRoles:
        return 'Gérer les rôles';
      case Permission.adminManageUsers:
        return 'Gérer les utilisateurs';
      default:
        return code.replaceAll('_', ' ').capitalize();
    }
  }

  String get resource {
    final parts = code.split('_');
    if (parts.length > 1) return parts[0];

    switch (this) {
      case Permission.viewDashboard:
        return 'dashboard';
      case Permission.viewMembres:
        return 'members';
      case Permission.createMembre:
        return 'members';
      case Permission.editMembre:
        return 'members';
      case Permission.deleteMembre:
        return 'members';
      case Permission.viewFinance:
        return 'finance';
      case Permission.createTransaction:
        return 'finance';
      case Permission.validateTransaction:
        return 'finance';
      case Permission.viewEvents:
        return 'events';
      case Permission.viewGroups:
        return 'groups';
      case Permission.viewCelebrations:
        return 'celebrations';
      default:
        return parts[0];
    }
  }

  String get action {
    final parts = code.split('_');
    if (parts.length > 1) return parts[1];

    switch (this) {
      case Permission.viewDashboard:
        return 'view';
      case Permission.viewMembres:
        return 'view';
      case Permission.createMembre:
        return 'create';
      case Permission.editMembre:
        return 'edit';
      case Permission.deleteMembre:
        return 'delete';
      case Permission.viewFinance:
        return 'view';
      case Permission.createTransaction:
        return 'create';
      case Permission.validateTransaction:
        return 'approve';
      case Permission.viewEvents:
        return 'view';
      case Permission.viewGroups:
        return 'view';
      case Permission.viewCelebrations:
        return 'view';
      default:
        return 'view';
    }
  }

  String get module => resource;

  static Permission? fromCode(String code) {
    try {
      return Permission.values.firstWhere((p) => p.code == code);
    } catch (e) {
      return null;
    }
  }

  static List<Permission> fromCodes(List<String> codes) =>
      codes.map((c) => fromCode(c)).whereType<Permission>().toList();

  @override
  String toString() => code;
}

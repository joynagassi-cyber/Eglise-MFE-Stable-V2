/// Constantes de routage pour l'application Lumina
class AppRoutes {
  AppRoutes._();

  // Auth
  static const String splash = '/';
  static const String authHome = '/auth-home';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String onboarding = '/onboarding';
  static const String welcomeTour = '/welcome-tour';
  static const String onboardingAdminCode = '/onboarding/admin-code';
  static const String onboardingMember = '/onboarding/member';
  static const String onboardingSuperadmin = '/onboarding-superadmin';

  // Shell
  static const String dashboard = '/dashboard';
  static const String memberDonations = '/dashboard/donations';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String backupSettings = '/settings/backup';
  static const String adminCodes = '/settings/admin-codes';
  static const String finance = '/finance';
  static const String financeHistory = '/finance/history';
  static const String financeTransactionDetails = '/finance/transactions/detail';
  static const String financeInvoiceCapture = '/finance/transactions/capture';
  static const String financeAccounts = '/finance/accounts';
  static const String financeReconciliation = '/finance/reconciliation';
  static const String brebis = '/brebis';
  static const String brebisNouveau = '/brebis/nouveau';
  static const String brebisDetails = '/brebis/:id';
  static const String brebisModifier = '/brebis/:id/modifier';
  static const String brebisStats = '/brebis/stats';
  static const String brebisQr = '/brebis/qr';
  static const String brebisScanner = '/brebis/scanner';
  static const String bergers = '/bergers';
  static const String churches = '/churches';
  static const String sacraments = '/sacraments';
  static const String sacramentsNouveau = '/sacraments/nouveau';
  static const String bible = '/bible';
  static const String bibleReader = '/bible/:book/:chapter';
  static const String bibleShareStudio = 'bibleShareStudio';
  static const String bibleOffline = '/bible-offline';
  static const String biblePlans = '/bible/plans';
  static const String biblePlanDetail = '/bible/plans/:planId';
  static const String bibleSearch = '/bible/search';
  static const String bibleBookmarks = '/bible/bookmarks';

  // Équipe
  static const String equipe = '/equipe';
  static const String equipeVisites = '/equipe/visites';

  // Communauté
  static const String communaute = '/communaute';
  static const String communauteNouveau = '/communaute/nouveau';
  static const String communauteStats = '/communaute/stats';
  static const String communauteBirthdays = '/communaute?filter=birthdays';

  // Auth Extra
  static const String accessDenied = '/access-denied';

  // Communication
  static const String communication = '/communication';
  static const String communicationAnnonces = '/communication/annonces';
  static const String communicationAnnonceDetail =
      '/communication/annonces/:id';
  static const String communicationMessaging = '/communication/messaging';
  static const String communicationSocial = '/communication/social';
  static const String communicationSocialCreate =
      '/communication/social/create';
  static const String communicationSocialDetail =
      '/communication/social/detail';
  static const String communicationTasks = '/communication/tasks';
  static const String communicationTasksNew = '/communication/tasks/new';
  static const String communicationTasksEdit = '/communication/tasks/edit/:id';

  // Vie Spirituelle
  static const String vieSpirituelle = '/vie-spirituelle';
  static const String vieSpirituelleEvents = '/vie-spirituelle/events';
  static const String vieSpirituelleEventsNew = '/vie-spirituelle/events/new';
  static const String vieSpirituelleCelebrations =
      '/vie-spirituelle/celebrations';
  static const String vieSpirituelleJalons = '/vie-spirituelle/jalons';

  // MFE-JC
  static const String ministere = '/ministere';
  static const String ministereFinance = '/ministere/finance';
  static const String ministereChurches = '/ministere/churches';
  static const String ministereRubriques = '/ministere/rubriques';
  static const String ministereRubriquesNew = '/ministere/rubriques/new';
  static const String ministereRubriquesEdit = '/ministere/rubriques/edit';

  // Groups
  static const String groups = '/groups';
  static const String groupsNouveau = '/groups/nouveau';
  static const String groupsHommes = '/groups/:id/hommes';
  static const String groupsChorale = '/groups/:id/chorale';
  static const String groupsFemmes = '/groups/:id/femmes';
  static const String groupsEnfants = '/groups/:id/enfants';
  static const String groupsIntercession = '/groups/:id/intercession';

  // Group Dashboards (Specific)
  static const String groupDashboard = '/dashboard/group/:groupId';
  static const String groupFinance = '/dashboard/group/:groupId/finance';
  static const String groupEvents = '/dashboard/group/:groupId/events';
  static const String groupMembers = '/dashboard/group/:groupId/members';
  static const String groupDocuments = '/dashboard/group/:groupId/documents';
  static const String groupAttendance = '/dashboard/group/:groupId/attendance';
  static const String memberTransfer = '/dashboard/group/:groupId/transfer';

  // Calendrier
  static const String calendrier = '/calendrier';

  // BILAN (Expert Comptable)
  static const String bilan = '/bilan';

  // Admin Settings
  static const String adminSettings = '/admin/settings';
  static const String adminThemes = '/admin/themes';
  static const String adminBranding = '/admin/branding';
  static const String adminRoles = '/admin/roles';
  static const String adminRolesMatrix = '/admin/roles/matrix';

  // Audit
  static const String audit = '/audit';
  static const String auditDetail = '/audit/detail/:logId';
  static const String auditHistory = '/audit/history';

  // Approvals
  static const String approvals = '/approvals';

  // Tutorial
  static const String tutorial = '/tutorial';

  // Donors
  static const String donors = '/donors';
  static const String donorsList = '/donors/list';
  static const String donorsNew = '/donors/new';
  static const String donorsEdit = '/donors/edit/:id';
  static const String donorsDetail = '/donors/detail/:id';
  static const String donorsRecordDonation = '/donors/record-donation';

  // Helper for parameterized routes
  static String brebisDetailsWithId(String id) => '/brebis/$id';
  static String brebisModifierWithId(String id) => '/brebis/$id/modifier';
  static String groupDetailsWithId(String id) => '/groups/$id';
  static String groupModifierWithId(String id) => '/groups/$id/modifier';
  static String groupsHommesWithId(String id) => '/groups/$id/hommes';
  static String groupsChoraleWithId(String id) => '/groups/$id/chorale';
  static String groupsFemmesWithId(String id) => '/groups/$id/femmes';
  static String groupsEnfantsWithId(String id) => '/groups/$id/enfants';
  static String groupsIntercessionWithId(String id) =>
      '/groups/$id/intercession';
  static String eventDetailsWithId(String id) => '/vie-spirituelle/events/$id';
  static String eventEditWithId(String id) => '/vie-spirituelle/events/$id/edit';
  static String celebrationDetailsWithId(String id) =>
      '/vie-spirituelle/celebrations/$id';
  static String messagingConversationWithId(String id) =>
      '/communication/messaging/$id';

  // Group Dashboards (Dynamic)
  static String groupDashboardWithType(String type) => '/dashboard/$type';
  static String groupDashboardFinanceWithType(String type) =>
      '/dashboard/$type/finance';
  static String groupDashboardEventsWithType(String type) =>
      '/dashboard/$type/events';
  static String groupDashboardNewEventWithType(String type) =>
      '/dashboard/$type/events/new';
  static String groupDashboardMembersWithType(String type) =>
      '/dashboard/$type/members';
  static String groupDashboardDocumentsWithType(String type) =>
      '/dashboard/$type/documents';
  static String groupDashboardAttendanceWithType(String type) =>
      '/dashboard/$type/attendance';
  static String groupDashboardTransferWithType(String type) =>
      '/dashboard/$type/transfer';

  // Specific Group Dashboards (Id-based)
  static String groupDashboardFinanceWithId(String groupId) =>
      '/dashboard/group/$groupId/finance';
  static String groupDashboardEventsWithId(String groupId) =>
      '/dashboard/group/$groupId/events';
  static String groupDashboardMembersWithId(String groupId) =>
      '/dashboard/group/$groupId/members';
  static String annonceDetailsWithId(String id) =>
      '/communication/annonces/$id';
  static String taskEditWithId(String id) => '/communication/tasks/edit/$id';
  static String sacramentDetailsWithId(String id) => '/sacraments/$id';
  static String biblePlanDetailWithId(String id) => '/bible/plans/$id';

  // Group Dashboard Helpers
  static String groupDashboardPath(String groupId) =>
      '/dashboard/group/$groupId';
  static String groupFinancePath(String groupId) =>
      '/dashboard/group/$groupId/finance';
  static String groupEventsPath(String groupId) =>
      '/dashboard/group/$groupId/events';
  static String groupMembersPath(String groupId) =>
      '/dashboard/group/$groupId/members';
  static String groupDocumentsPath(String groupId) =>
      '/dashboard/group/$groupId/documents';
  static String groupAttendancePath(String groupId) =>
      '/dashboard/group/$groupId/attendance';

  static String memberTransferPath(String groupId) =>
      '/dashboard/group/$groupId/transfer';

  // Group Join Requests
  static String groupDashboardJoinRequestsWithId(String groupId) =>
      '/dashboard/group/$groupId/join-requests';

  // Audit Helpers
  static String auditDetailWithId(String logId) => '/audit/detail/$logId';

  // Donor Helpers
  static String donorEditWithId(String id) => '/donors/edit/$id';
  static String donorDetailWithId(String id) => '/donors/detail/$id';
  static String donorRecordDonationWithDonorId(String donorId) =>
      '/donors/record-donation?donorId=$donorId';

  // Superadmin dashboard aliases
  static String get members => brebis;
  static String get events => vieSpirituelleEvents;
  static String get memberNew => brebisNouveau;
  static String get financeTransactionNew => '/finance/transactions/new';
  static String get eventNew => vieSpirituelleEventsNew;
  static String get reports => ministereFinance;
}

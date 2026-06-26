// lib/core/logging/analytics_events.dart
// ============================================================================
// ANALYTICS EVENT DEFINITIONS
// Standardized event names for consistent tracking
// ============================================================================

/// Authentication events
abstract class AuthEvents {
  static const loginStarted = 'auth.login.started';
  static const loginSuccess = 'auth.login.success';
  static const loginFailed = 'auth.login.failed';
  static const logoutSuccess = 'auth.logout.success';
  static const registerStarted = 'auth.register.started';
  static const registerSuccess = 'auth.register.success';
  static const registerFailed = 'auth.register.failed';
  static const otpRequested = 'auth.otp.requested';
  static const otpVerified = 'auth.otp.verified';
  static const otpFailed = 'auth.otp.failed';
  static const passwordResetRequested = 'auth.password_reset.requested';
  static const passwordResetCompleted = 'auth.password_reset.completed';
  static const adminActivated = 'auth.admin.activated';
  static const sessionRefreshed = 'auth.session.refreshed';
}

/// Navigation events
abstract class NavEvents {
  static const screenView = 'nav.screen.view';
  static const tabChanged = 'nav.tab.changed';
  static const backPressed = 'nav.back.pressed';
  static const deepLinkOpened = 'nav.deeplink.opened';
}

/// Member management events
abstract class MemberEvents {
  static const viewed = 'member.viewed';
  static const created = 'member.created';
  static const updated = 'member.updated';
  static const deleted = 'member.deleted';
  static const searched = 'member.searched';
  static const filtered = 'member.filtered';
  static const photoUploaded = 'member.photo.uploaded';
  static const exported = 'member.exported';
}

/// Finance events
abstract class FinanceEvents {
  static const dashboardViewed = 'finance.dashboard.viewed';
  static const transactionCreated = 'finance.transaction.created';
  static const transactionUpdated = 'finance.transaction.updated';
  static const transactionDeleted = 'finance.transaction.deleted';
  static const budgetCreated = 'finance.budget.created';
  static const budgetUpdated = 'finance.budget.updated';
  static const reportGenerated = 'finance.report.generated';
  static const categoryCreated = 'finance.category.created';
}

/// Event/Calendar events
abstract class CalendarEvents {
  static const eventViewed = 'calendar.event.viewed';
  static const eventCreated = 'calendar.event.created';
  static const eventUpdated = 'calendar.event.updated';
  static const eventDeleted = 'calendar.event.deleted';
  static const celebrationViewed = 'calendar.celebration.viewed';
}

/// Communication events
abstract class CommEvents {
  static const annonceViewed = 'comm.annonce.viewed';
  static const annonceCreated = 'comm.annonce.created';
  static const postCreated = 'comm.post.created';
  static const postLiked = 'comm.post.liked';
  static const messageOpened = 'comm.message.opened';
  static const messageSent = 'comm.message.sent';
}

/// Sacrament events
abstract class SacramentEvents {
  static const recorded = 'sacrament.recorded';
  static const viewed = 'sacrament.viewed';
  static const certificateGenerated = 'sacrament.certificate.generated';
}

/// Team/Shepherd events
abstract class TeamEvents {
  static const memberInvited = 'team.member.invited';
  static const inviteAccepted = 'team.invite.accepted';
  static const roleChanged = 'team.role.changed';
  static const memberRemoved = 'team.member.removed';
}

/// Sync/Offline events
abstract class SyncEvents {
  static const syncStarted = 'sync.started';
  static const syncCompleted = 'sync.completed';
  static const syncFailed = 'sync.failed';
  static const offlineModeEntered = 'sync.offline.entered';
  static const onlineModeRestored = 'sync.online.restored';
}

/// Error events
abstract class ErrorEvents {
  static const apiError = 'error.api';
  static const networkError = 'error.network';
  static const validationError = 'error.validation';
  static const permissionDenied = 'error.permission_denied';
  static const unexpectedError = 'error.unexpected';
}

/// Performance events
abstract class PerfEvents {
  static const appStartup = 'perf.app.startup';
  static const screenLoad = 'perf.screen.load';
  static const apiLatency = 'perf.api.latency';
  static const imageLoad = 'perf.image.load';
}

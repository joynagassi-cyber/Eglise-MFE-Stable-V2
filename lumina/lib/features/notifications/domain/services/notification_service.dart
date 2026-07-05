import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/providers/auth_provider.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import 'package:lumina/core/logging/app_logger.dart';
import '../../domain/entities/app_notification_entity.dart';
import '../../domain/repositories/i_notification_repository.dart';

/// Types de notification standardisés
class NotificationTypeConst {
  static const String general = 'general';
  static const String event = 'event';
  static const String birthday = 'birthday';
  static const String reminder = 'reminder';
  static const String finance = 'finance';
  static const String group = 'group';
  static const String announcement = 'announcement';
  static const String member = 'member';
  static const String approval = 'approval';
  static const String system = 'system';
}

/// Service centralisé pour créer des notifications avec routage par rôle.
///
/// Utilise les RPCs Supabase (SECURITY DEFINER) pour insérer les notifications
/// en base, contournant les RLS côté client.
class NotificationService {
  final Ref _ref;

  NotificationService(this._ref);

  INotificationRepository get _repo =>
      _ref.read(notificationRepositoryProvider);

  String get _churchId => _ref.read(activeChurchIdProvider);

  /// Crée une notification pour un utilisateur spécifique
  Future<AppNotificationEntity?> notifyUser({
    required String userId,
    required String title,
    required String message,
    String type = NotificationTypeConst.general,
    String? linkUrl,
    Map<String, dynamic> payload = const {},
    String priority = 'NORMAL',
  }) async {
    return _repo.createNotification(
      userId: userId,
      title: title,
      message: message,
      type: type,
      linkUrl: linkUrl,
      payload: payload,
      priority: priority,
      churchId: _churchId,
    );
  }

  /// Crée une notification pour tous les admins de l'église courante
  Future<int> notifyAdmins({
    required String title,
    required String message,
    String type = NotificationTypeConst.general,
    String? linkUrl,
    Map<String, dynamic> payload = const {},
    String priority = 'NORMAL',
  }) async {
    if (_churchId.isEmpty || _churchId == 'global') {
      AppLogger.w('Cannot notify admins: no active church', 'NOTIF_SVC');
      return 0;
    }
    return _repo.createNotificationsForAdmins(
      churchId: _churchId,
      title: title,
      message: message,
      type: type,
      linkUrl: linkUrl,
      payload: payload,
      priority: priority,
    );
  }

  /// Crée une notification pour les chefs de groupe de l'église courante
  Future<int> notifyGroupLeaders({
    required String title,
    required String message,
    String type = NotificationTypeConst.general,
    String? linkUrl,
    Map<String, dynamic> payload = const {},
    String priority = 'NORMAL',
  }) async {
    if (_churchId.isEmpty || _churchId == 'global') {
      AppLogger.w('Cannot notify group leaders: no active church', 'NOTIF_SVC');
      return 0;
    }
    return _repo.createNotificationsForGroupLeaders(
      churchId: _churchId,
      title: title,
      message: message,
      type: type,
      linkUrl: linkUrl,
      payload: payload,
      priority: priority,
    );
  }

  /// Crée une notification pour tous les membres d'un groupe spécifique
  Future<int> notifyGroupMembers({
    required String groupId,
    required String title,
    required String message,
    String type = NotificationTypeConst.general,
    String? linkUrl,
    Map<String, dynamic> payload = const {},
    String priority = 'NORMAL',
  }) async {
    if (groupId.isEmpty) {
      AppLogger.w('Cannot notify group members: no group ID', 'NOTIF_SVC');
      return 0;
    }
    return _repo.createNotificationsForGroup(
      groupId: groupId,
      title: title,
      message: message,
      type: type,
      linkUrl: linkUrl,
      payload: payload,
      priority: priority,
    );
  }

  /// Crée une notification pour tous les membres de l'église courante
  Future<int> notifyAllMembers({
    required String title,
    required String message,
    String type = NotificationTypeConst.general,
    String? linkUrl,
    Map<String, dynamic> payload = const {},
    String priority = 'NORMAL',
  }) async {
    if (_churchId.isEmpty || _churchId == 'global') {
      AppLogger.w('Cannot notify all members: no active church', 'NOTIF_SVC');
      return 0;
    }
    return _repo.createNotificationsForAllMembers(
      churchId: _churchId,
      title: title,
      message: message,
      type: type,
      linkUrl: linkUrl,
      payload: payload,
      priority: priority,
    );
  }

  // ─── Helpers métier ────────────────────────────────────────────────────

  /// Notifie quand un nouveau groupe est créé (cible : admins)
  Future<void> onGroupCreated({
    required String groupName,
    required String groupId,
  }) async {
    await notifyAdmins(
      title: 'Nouveau groupe créé',
      message: 'Le groupe "$groupName" a été créé',
      type: NotificationTypeConst.group,
      linkUrl: '/groups/$groupId',
      payload: {'group_id': groupId, 'group_name': groupName},
    );
  }

  /// Notifie quand un membre rejoint un groupe (cible : chefs de groupe)
  Future<void> onMemberJoinedGroup({
    required String groupId,
    required String groupName,
    required String memberName,
    String? memberId,
  }) async {
    await notifyGroupLeaders(
      title: 'Nouveau membre dans le groupe',
      message: '$memberName a rejoint le groupe "$groupName"',
      type: NotificationTypeConst.group,
      linkUrl: '/groups/$groupId',
      payload: {
        'group_id': groupId,
        'member_name': memberName,
        if (memberId != null) 'member_id': memberId,
      },
    );
    // Notifier aussi le membre lui-même
  }

  /// Notifie quand un membre est retiré d'un groupe
  Future<void> onMemberRemovedFromGroup({
    required String groupId,
    required String groupName,
    required String memberUserId,
  }) async {
    await notifyUser(
      userId: memberUserId,
      title: 'Retiré du groupe',
      message: 'Vous avez été retiré du groupe "$groupName"',
      type: NotificationTypeConst.group,
      linkUrl: '/groups',
    );
  }

  /// Notifie quand un événement est créé (cible : tous les membres)
  Future<void> onEventCreated({
    required String eventTitle,
    required String eventId,
    required DateTime eventDate,
  }) async {
    await notifyAllMembers(
      title: 'Nouvel événement',
      message: '$eventTitle — ${_formatDate(eventDate)}',
      type: NotificationTypeConst.event,
      linkUrl: '/events/$eventId',
      payload: {
        'event_id': eventId,
        'event_date': eventDate.toIso8601String(),
      },
    );
  }

  /// Notifie quand un membre s'inscrit à un événement (cible : admins)
  Future<void> onMemberRegisteredToEvent({
    required String eventTitle,
    required String eventId,
    required String memberName,
  }) async {
    await notifyAdmins(
      title: 'Inscription à un événement',
      message: '$memberName s\'est inscrit à "$eventTitle"',
      type: NotificationTypeConst.event,
      linkUrl: '/events/$eventId',
      payload: {
        'event_id': eventId,
        'event_title': eventTitle,
        'member_name': memberName,
      },
    );
  }

  /// Notifie quand une annonce est publiée (cible : tous les membres)
  Future<void> onAnnouncementCreated({
    required String title,
    required String announcementId,
  }) async {
    await notifyAllMembers(
      title: 'Nouvelle annonce',
      message: title,
      type: NotificationTypeConst.announcement,
      linkUrl: '/annonces/$announcementId',
      payload: {'annonce_id': announcementId},
    );
  }

  /// Notifie quand un nouveau membre est créé (cible : admins)
  Future<void> onMemberCreated({
    required String memberName,
    required String memberId,
    String? email,
  }) async {
    await notifyAdmins(
      title: 'Nouveau membre',
      message: '$memberName a été ajouté à l\'église',
      type: NotificationTypeConst.member,
      linkUrl: '/membres/$memberId',
      payload: {'member_id': memberId, 'member_name': memberName},
    );
  }

  /// Notifie le membre lui-même qu'il a été ajouté
  Future<void> onMemberCreatedNotifyUser({
    required String userId,
    required String memberName,
  }) async {
    await notifyUser(
      userId: userId,
      title: 'Bienvenue !',
      message: 'Votre profil a été créé. Bienvenue dans l\'église !',
      type: NotificationTypeConst.member,
      linkUrl: '/profile',
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Provider pour le service de notifications centralisé
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref);
});

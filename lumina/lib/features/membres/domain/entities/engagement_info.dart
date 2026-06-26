// lib/features/membres/domain/entities/engagement_info.dart
// Informations sur l'engagement dans l'église

import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums/enums.dart';

part 'engagement_info.freezed.dart';
part 'engagement_info.g.dart';

/// Rôle actif dans l'église
@freezed
class ChurchRole with _$ChurchRole {
  const ChurchRole._();

  const factory ChurchRole({
    required ChurchRoleType type,
    required String title,
    String? department,
    String? ministry,
    DateTime? startDate,
    DateTime? endDate,
    @Default(true) bool isActive,
    String? notes,
  }) = _ChurchRole;

  /// Durée dans ce rôle
  int? get yearsInRole {
    if (startDate == null) return null;
    final end = endDate ?? DateTime.now();
    return end.difference(startDate!).inDays ~/ 365;
  }

  factory ChurchRole.fromJson(Map<String, dynamic> json) =>
      _$ChurchRoleFromJson(json);
}

/// Ministère ou département
@freezed
class MinistryMembership with _$MinistryMembership {
  const factory MinistryMembership({
    required String ministryId,
    required String ministryName,
    String? role,
    DateTime? joinDate,
    DateTime? leaveDate,
    @Default(true) bool isActive,
    @Default(false) bool isLeader,
  }) = _MinistryMembership;

  factory MinistryMembership.fromJson(Map<String, dynamic> json) =>
      _$MinistryMembershipFromJson(json);
}

/// Cellule de maison
@freezed
class CellMembership with _$CellMembership {
  const factory CellMembership({
    required String cellId,
    required String cellName,
    String? cellLeaderName,
    String? cellLocation,
    DateTime? joinDate,
    @Default(true) bool isActive,
    @Default(false) bool isLeader,
    @Default(false) bool isHost, // Accueille la cellule chez lui
  }) = _CellMembership;

  factory CellMembership.fromJson(Map<String, dynamic> json) =>
      _$CellMembershipFromJson(json);
}

/// Niveau de fidélité/assiduité
enum AttendanceLevel {
  veryActive, // Très assidu
  active, // Assidu
  regular, // Régulier
  occasional, // Occasionnel
  rare, // Rare
  absent; // Absent

  String get label {
    switch (this) {
      case AttendanceLevel.veryActive:
        return 'Très assidu';
      case AttendanceLevel.active:
        return 'Assidu';
      case AttendanceLevel.regular:
        return 'Régulier';
      case AttendanceLevel.occasional:
        return 'Occasionnel';
      case AttendanceLevel.rare:
        return 'Rare';
      case AttendanceLevel.absent:
        return 'Absent';
    }
  }

  int get colorValue {
    switch (this) {
      case AttendanceLevel.veryActive:
        return 0xFF10B981; // Green
      case AttendanceLevel.active:
        return 0xFF22C55E; // Light green
      case AttendanceLevel.regular:
        return 0xFF3B82F6; // Blue
      case AttendanceLevel.occasional:
        return 0xFFF59E0B; // Amber
      case AttendanceLevel.rare:
        return 0xFFF97316; // Orange
      case AttendanceLevel.absent:
        return 0xFFEF4444; // Red
    }
  }
}

/// Informations d'engagement complètes
@freezed
class EngagementInfo with _$EngagementInfo {
  const EngagementInfo._();

  const factory EngagementInfo({
    // Rôles
    @Default([]) List<ChurchRole> roles,
    ChurchRoleType? primaryRole,

    // Ministères
    @Default([]) List<MinistryMembership> ministries,

    // Cellule de maison
    CellMembership? cell,

    // Assiduité
    @Default(AttendanceLevel.regular) AttendanceLevel attendanceLevel,
    DateTime? lastAttendanceDate,
    DateTime? lastCellAttendanceDate,
    @Default(0) int attendanceStreakWeeks,

    // Contributions
    @Default(false) bool isRegularTither,
    @Default(false) bool isOfferingGiver,
    DateTime? lastContributionDate,

    // Bénévolat
    @Default([]) List<String> volunteerAreas,
    @Default(0) int volunteerHoursThisYear,

    // Événements
    @Default(0) int eventsAttendedThisYear,
    @Default([]) List<String> upcomingEventIds,

    // Disponibilité
    @Default([]) List<String> availableDays,
    String? availabilityNotes,
    @Default([]) List<String> skills,
    @Default([]) List<String> talents,

    // Formation suivie
    @Default([]) List<String> completedTrainings,
    @Default([]) List<String> currentTrainings,
  }) = _EngagementInfo;

  /// Rôle actif principal
  ChurchRole? get currentPrimaryRole {
    final activeRoles = roles.where((r) => r.isActive).toList();
    if (activeRoles.isEmpty) return null;
    if (primaryRole != null) {
      final match = activeRoles.where((r) => r.type == primaryRole).toList();
      if (match.isNotEmpty) return match.first;
    }
    // Retourne le rôle avec le niveau le plus élevé (plus petit = plus important)
    activeRoles.sort((a, b) => a.type.level.compareTo(b.type.level));
    return activeRoles.firstOrNull;
  }

  /// Ministères actifs
  List<MinistryMembership> get activeMinistries =>
      ministries.where((m) => m.isActive).toList();

  /// Nombre de rôles actifs
  int get activeRoleCount => roles.where((r) => r.isActive).length;

  /// Est un leader (responsable de quelque chose)
  bool get isLeader =>
      roles.any((r) => r.isActive && r.type.level <= 8) ||
      ministries.any((m) => m.isLeader) ||
      (cell?.isLeader ?? false);

  /// Résumé de l'engagement
  String get engagementSummary {
    final parts = <String>[];
    final primary = currentPrimaryRole;
    if (primary != null) {
      parts.add(primary.title);
    }
    if (activeMinistries.isNotEmpty) {
      parts.add('${activeMinistries.length} ministère(s)');
    }
    if (cell != null && cell!.isActive) {
      parts.add('Cellule: ${cell!.cellName}');
    }
    parts.add(attendanceLevel.label);
    return parts.join(' • ');
  }

  factory EngagementInfo.fromJson(Map<String, dynamic> json) =>
      _$EngagementInfoFromJson(json);
}
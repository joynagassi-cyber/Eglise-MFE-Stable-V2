// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'engagement_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChurchRoleImpl _$$ChurchRoleImplFromJson(Map<String, dynamic> json) =>
    _$ChurchRoleImpl(
      type: $enumDecode(_$ChurchRoleTypeEnumMap, json['type']),
      title: json['title'] as String,
      department: json['department'] as String?,
      ministry: json['ministry'] as String?,
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      isActive: json['is_active'] as bool? ?? true,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$ChurchRoleImplToJson(_$ChurchRoleImpl instance) =>
    <String, dynamic>{
      'type': _$ChurchRoleTypeEnumMap[instance.type]!,
      'title': instance.title,
      'department': instance.department,
      'ministry': instance.ministry,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'is_active': instance.isActive,
      'notes': instance.notes,
    };

const _$ChurchRoleTypeEnumMap = {
  ChurchRoleType.superintendent: 'superintendent',
  ChurchRoleType.federationPresident: 'federationPresident',
  ChurchRoleType.seniorPastor: 'seniorPastor',
  ChurchRoleType.associatePastor: 'associatePastor',
  ChurchRoleType.elderDeacon: 'elderDeacon',
  ChurchRoleType.treasurer: 'treasurer',
  ChurchRoleType.secretary: 'secretary',
  ChurchRoleType.cellLeader: 'cellLeader',
  ChurchRoleType.ministryLeader: 'ministryLeader',
  ChurchRoleType.worshipLeader: 'worshipLeader',
  ChurchRoleType.choirDirector: 'choirDirector',
  ChurchRoleType.youthLeader: 'youthLeader',
  ChurchRoleType.womenLeader: 'womenLeader',
  ChurchRoleType.menLeader: 'menLeader',
  ChurchRoleType.sundaySchoolTeacher: 'sundaySchoolTeacher',
  ChurchRoleType.usher: 'usher',
  ChurchRoleType.member: 'member',
  ChurchRoleType.volunteer: 'volunteer',
};

_$MinistryMembershipImpl _$$MinistryMembershipImplFromJson(
        Map<String, dynamic> json) =>
    _$MinistryMembershipImpl(
      ministryId: json['ministry_id'] as String,
      ministryName: json['ministry_name'] as String,
      role: json['role'] as String?,
      joinDate: json['join_date'] == null
          ? null
          : DateTime.parse(json['join_date'] as String),
      leaveDate: json['leave_date'] == null
          ? null
          : DateTime.parse(json['leave_date'] as String),
      isActive: json['is_active'] as bool? ?? true,
      isLeader: json['is_leader'] as bool? ?? false,
    );

Map<String, dynamic> _$$MinistryMembershipImplToJson(
        _$MinistryMembershipImpl instance) =>
    <String, dynamic>{
      'ministry_id': instance.ministryId,
      'ministry_name': instance.ministryName,
      'role': instance.role,
      'join_date': instance.joinDate?.toIso8601String(),
      'leave_date': instance.leaveDate?.toIso8601String(),
      'is_active': instance.isActive,
      'is_leader': instance.isLeader,
    };

_$CellMembershipImpl _$$CellMembershipImplFromJson(Map<String, dynamic> json) =>
    _$CellMembershipImpl(
      cellId: json['cell_id'] as String,
      cellName: json['cell_name'] as String,
      cellLeaderName: json['cell_leader_name'] as String?,
      cellLocation: json['cell_location'] as String?,
      joinDate: json['join_date'] == null
          ? null
          : DateTime.parse(json['join_date'] as String),
      isActive: json['is_active'] as bool? ?? true,
      isLeader: json['is_leader'] as bool? ?? false,
      isHost: json['is_host'] as bool? ?? false,
    );

Map<String, dynamic> _$$CellMembershipImplToJson(
        _$CellMembershipImpl instance) =>
    <String, dynamic>{
      'cell_id': instance.cellId,
      'cell_name': instance.cellName,
      'cell_leader_name': instance.cellLeaderName,
      'cell_location': instance.cellLocation,
      'join_date': instance.joinDate?.toIso8601String(),
      'is_active': instance.isActive,
      'is_leader': instance.isLeader,
      'is_host': instance.isHost,
    };

_$EngagementInfoImpl _$$EngagementInfoImplFromJson(Map<String, dynamic> json) =>
    _$EngagementInfoImpl(
      roles: (json['roles'] as List<dynamic>?)
              ?.map((e) => ChurchRole.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      primaryRole:
          $enumDecodeNullable(_$ChurchRoleTypeEnumMap, json['primary_role']),
      ministries: (json['ministries'] as List<dynamic>?)
              ?.map(
                  (e) => MinistryMembership.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      cell: json['cell'] == null
          ? null
          : CellMembership.fromJson(json['cell'] as Map<String, dynamic>),
      attendanceLevel: $enumDecodeNullable(
              _$AttendanceLevelEnumMap, json['attendance_level']) ??
          AttendanceLevel.regular,
      lastAttendanceDate: json['last_attendance_date'] == null
          ? null
          : DateTime.parse(json['last_attendance_date'] as String),
      lastCellAttendanceDate: json['last_cell_attendance_date'] == null
          ? null
          : DateTime.parse(json['last_cell_attendance_date'] as String),
      attendanceStreakWeeks:
          (json['attendance_streak_weeks'] as num?)?.toInt() ?? 0,
      isRegularTither: json['is_regular_tither'] as bool? ?? false,
      isOfferingGiver: json['is_offering_giver'] as bool? ?? false,
      lastContributionDate: json['last_contribution_date'] == null
          ? null
          : DateTime.parse(json['last_contribution_date'] as String),
      volunteerAreas: (json['volunteer_areas'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      volunteerHoursThisYear:
          (json['volunteer_hours_this_year'] as num?)?.toInt() ?? 0,
      eventsAttendedThisYear:
          (json['events_attended_this_year'] as num?)?.toInt() ?? 0,
      upcomingEventIds: (json['upcoming_event_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      availableDays: (json['available_days'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      availabilityNotes: json['availability_notes'] as String?,
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      talents: (json['talents'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      completedTrainings: (json['completed_trainings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      currentTrainings: (json['current_trainings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$EngagementInfoImplToJson(
        _$EngagementInfoImpl instance) =>
    <String, dynamic>{
      'roles': instance.roles.map((e) => e.toJson()).toList(),
      'primary_role': _$ChurchRoleTypeEnumMap[instance.primaryRole],
      'ministries': instance.ministries.map((e) => e.toJson()).toList(),
      'cell': instance.cell?.toJson(),
      'attendance_level': _$AttendanceLevelEnumMap[instance.attendanceLevel]!,
      'last_attendance_date': instance.lastAttendanceDate?.toIso8601String(),
      'last_cell_attendance_date':
          instance.lastCellAttendanceDate?.toIso8601String(),
      'attendance_streak_weeks': instance.attendanceStreakWeeks,
      'is_regular_tither': instance.isRegularTither,
      'is_offering_giver': instance.isOfferingGiver,
      'last_contribution_date':
          instance.lastContributionDate?.toIso8601String(),
      'volunteer_areas': instance.volunteerAreas,
      'volunteer_hours_this_year': instance.volunteerHoursThisYear,
      'events_attended_this_year': instance.eventsAttendedThisYear,
      'upcoming_event_ids': instance.upcomingEventIds,
      'available_days': instance.availableDays,
      'availability_notes': instance.availabilityNotes,
      'skills': instance.skills,
      'talents': instance.talents,
      'completed_trainings': instance.completedTrainings,
      'current_trainings': instance.currentTrainings,
    };

const _$AttendanceLevelEnumMap = {
  AttendanceLevel.veryActive: 'veryActive',
  AttendanceLevel.active: 'active',
  AttendanceLevel.regular: 'regular',
  AttendanceLevel.occasional: 'occasional',
  AttendanceLevel.rare: 'rare',
  AttendanceLevel.absent: 'absent',
};

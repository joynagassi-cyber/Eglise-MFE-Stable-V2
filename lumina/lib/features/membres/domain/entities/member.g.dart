// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemberImpl _$$MemberImplFromJson(Map<String, dynamic> json) => _$MemberImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      churchId: json['church_id'] as String,
      memberNumber: json['member_number'] as String?,
      qrCode: json['qr_code'] as String?,
      lastName: json['last_name'] as String,
      firstName: json['first_name'] as String,
      middleName: json['middle_name'] as String?,
      maidenName: json['maiden_name'] as String?,
      nickname: json['nickname'] as String?,
      title: json['title'] as String?,
      suffix: json['suffix'] as String?,
      gender:
          $enumDecodeNullable(_$GenderEnumMap, json['gender']) ?? Gender.male,
      birthDate: json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
      birthCity: json['birth_city'] as String?,
      birthCountry: json['birth_country'] as String?,
      deathDate: json['death_date'] == null
          ? null
          : DateTime.parse(json['death_date'] as String),
      photoUrl: json['photo_url'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      status: $enumDecodeNullable(_$MemberStatusEnumMap, json['status']) ??
          MemberStatus.active,
      membershipType: $enumDecodeNullable(
              _$MembershipTypeEnumMap, json['membership_type']) ??
          MembershipType.visitor,
      joiningDate: json['joining_date'] == null
          ? null
          : DateTime.parse(json['joining_date'] as String),
      membershipDate: json['membership_date'] == null
          ? null
          : DateTime.parse(json['membership_date'] as String),
      lastActiveDate: json['last_active_date'] == null
          ? null
          : DateTime.parse(json['last_active_date'] as String),
      statusNote: json['status_note'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      whatsapp: json['whatsapp'] as String?,
      acceptsWhatsApp: json['accepts_whats_app'] as bool? ?? false,
      acceptsSms: json['accepts_sms'] as bool? ?? false,
      acceptsEmail: json['accepts_email'] as bool? ?? false,
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactPhone: json['emergency_contact_phone'] as String?,
      emergencyContactRelation: json['emergency_contact_relation'] as String?,
      addressLine1: json['address_line1'] as String?,
      neighborhood: json['neighborhood'] as String?,
      city: json['city'] as String?,
      region: json['region'] as String?,
      postalCode: json['postal_code'] as String?,
      country: json['country'] as String? ?? 'Côte d\'Ivoire',
      landmark: json['landmark'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      maritalStatus:
          $enumDecodeNullable(_$MaritalStatusEnumMap, json['marital_status']) ??
              MaritalStatus.single,
      spouseMemberId: json['spouse_member_id'] as String?,
      spouseName: json['spouse_name'] as String?,
      numberOfChildren: (json['number_of_children'] as num?)?.toInt() ?? 0,
      weddingDate: json['wedding_date'] == null
          ? null
          : DateTime.parse(json['wedding_date'] as String),
      isBaptized: json['is_baptized'] as bool? ?? false,
      baptismDate: json['baptism_date'] == null
          ? null
          : DateTime.parse(json['baptism_date'] as String),
      baptismLocation: json['baptism_location'] as String?,
      isConverted: json['is_converted'] as bool? ?? false,
      conversionDate: json['conversion_date'] == null
          ? null
          : DateTime.parse(json['conversion_date'] as String),
      hasCompletedMembershipClass:
          json['has_completed_membership_class'] as bool? ?? false,
      hasCompletedMaturityClass:
          json['has_completed_maturity_class'] as bool? ?? false,
      primaryRoleType: json['primary_role_type'] as String?,
      primaryRoleTitle: json['primary_role_title'] as String?,
      cellId: json['cell_id'] as String?,
      cellName: json['cell_name'] as String?,
      ministryIds: (json['ministry_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      attendanceLevel: $enumDecodeNullable(
              _$AttendanceLevelEnumMap, json['attendance_level']) ??
          AttendanceLevel.regular,
      isLeader: json['is_leader'] as bool? ?? false,
      employmentStatus: $enumDecodeNullable(
              _$EmploymentStatusEnumMap, json['employment_status']) ??
          EmploymentStatus.employed,
      profession: json['profession'] as String?,
      employer: json['employer'] as String?,
      educationLevel: $enumDecodeNullable(
              _$EducationLevelEnumMap, json['education_level']) ??
          EducationLevel.highSchool,
      isRegularTither: json['is_regular_tither'] as bool? ?? false,
      lastContributionDate: json['last_contribution_date'] == null
          ? null
          : DateTime.parse(json['last_contribution_date'] as String),
      totalContributionsThisYear:
          (json['total_contributions_this_year'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      createdBy: json['created_by'] as String?,
      updatedBy: json['updated_by'] as String?,
      isDeleted: json['is_deleted'] as bool? ?? false,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      lastModifiedBy: json['last_modified_by'] as String?,
      lastModifiedAt: json['last_modified_at'] == null
          ? null
          : DateTime.parse(json['last_modified_at'] as String),
      lastModifiedByName: json['last_modified_by_name'] as String?,
      lastModifiedByRole: json['last_modified_by_role'] as String?,
      contactInfoJson: json['contact_info_json'] as String?,
      familyInfoJson: json['family_info_json'] as String?,
      spiritualInfoJson: json['spiritual_info_json'] as String?,
      engagementInfoJson: json['engagement_info_json'] as String?,
      professionalInfoJson: json['professional_info_json'] as String?,
      addressesJson: json['addresses_json'] as String?,
      customFieldsJson: json['custom_fields_json'] as String?,
    );

Map<String, dynamic> _$$MemberImplToJson(_$MemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'church_id': instance.churchId,
      'member_number': instance.memberNumber,
      'qr_code': instance.qrCode,
      'last_name': instance.lastName,
      'first_name': instance.firstName,
      'middle_name': instance.middleName,
      'maiden_name': instance.maidenName,
      'nickname': instance.nickname,
      'title': instance.title,
      'suffix': instance.suffix,
      'gender': _$GenderEnumMap[instance.gender]!,
      'birth_date': instance.birthDate?.toIso8601String(),
      'birth_city': instance.birthCity,
      'birth_country': instance.birthCountry,
      'death_date': instance.deathDate?.toIso8601String(),
      'photo_url': instance.photoUrl,
      'thumbnail_url': instance.thumbnailUrl,
      'status': _$MemberStatusEnumMap[instance.status]!,
      'membership_type': _$MembershipTypeEnumMap[instance.membershipType]!,
      'joining_date': instance.joiningDate?.toIso8601String(),
      'membership_date': instance.membershipDate?.toIso8601String(),
      'last_active_date': instance.lastActiveDate?.toIso8601String(),
      'status_note': instance.statusNote,
      'email': instance.email,
      'phone': instance.phone,
      'whatsapp': instance.whatsapp,
      'accepts_whats_app': instance.acceptsWhatsApp,
      'accepts_sms': instance.acceptsSms,
      'accepts_email': instance.acceptsEmail,
      'emergency_contact_name': instance.emergencyContactName,
      'emergency_contact_phone': instance.emergencyContactPhone,
      'emergency_contact_relation': instance.emergencyContactRelation,
      'address_line1': instance.addressLine1,
      'neighborhood': instance.neighborhood,
      'city': instance.city,
      'region': instance.region,
      'postal_code': instance.postalCode,
      'country': instance.country,
      'landmark': instance.landmark,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'marital_status': _$MaritalStatusEnumMap[instance.maritalStatus]!,
      'spouse_member_id': instance.spouseMemberId,
      'spouse_name': instance.spouseName,
      'number_of_children': instance.numberOfChildren,
      'wedding_date': instance.weddingDate?.toIso8601String(),
      'is_baptized': instance.isBaptized,
      'baptism_date': instance.baptismDate?.toIso8601String(),
      'baptism_location': instance.baptismLocation,
      'is_converted': instance.isConverted,
      'conversion_date': instance.conversionDate?.toIso8601String(),
      'has_completed_membership_class': instance.hasCompletedMembershipClass,
      'has_completed_maturity_class': instance.hasCompletedMaturityClass,
      'primary_role_type': instance.primaryRoleType,
      'primary_role_title': instance.primaryRoleTitle,
      'cell_id': instance.cellId,
      'cell_name': instance.cellName,
      'ministry_ids': instance.ministryIds,
      'attendance_level': _$AttendanceLevelEnumMap[instance.attendanceLevel]!,
      'is_leader': instance.isLeader,
      'employment_status':
          _$EmploymentStatusEnumMap[instance.employmentStatus]!,
      'profession': instance.profession,
      'employer': instance.employer,
      'education_level': _$EducationLevelEnumMap[instance.educationLevel]!,
      'is_regular_tither': instance.isRegularTither,
      'last_contribution_date':
          instance.lastContributionDate?.toIso8601String(),
      'total_contributions_this_year': instance.totalContributionsThisYear,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'created_by': instance.createdBy,
      'updated_by': instance.updatedBy,
      'is_deleted': instance.isDeleted,
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'last_modified_by': instance.lastModifiedBy,
      'last_modified_at': instance.lastModifiedAt?.toIso8601String(),
      'last_modified_by_name': instance.lastModifiedByName,
      'last_modified_by_role': instance.lastModifiedByRole,
      'contact_info_json': instance.contactInfoJson,
      'family_info_json': instance.familyInfoJson,
      'spiritual_info_json': instance.spiritualInfoJson,
      'engagement_info_json': instance.engagementInfoJson,
      'professional_info_json': instance.professionalInfoJson,
      'addresses_json': instance.addressesJson,
      'custom_fields_json': instance.customFieldsJson,
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.other: 'other',
};

const _$MemberStatusEnumMap = {
  MemberStatus.active: 'active',
  MemberStatus.inactive: 'inactive',
  MemberStatus.visitor: 'visitor',
  MemberStatus.prospective: 'prospective',
  MemberStatus.deceased: 'deceased',
  MemberStatus.transferred: 'transferred',
  MemberStatus.suspended: 'suspended',
  MemberStatus.restored: 'restored',
};

const _$MembershipTypeEnumMap = {
  MembershipType.fullMember: 'fullMember',
  MembershipType.associateMember: 'associateMember',
  MembershipType.prospective: 'prospective',
  MembershipType.visitor: 'visitor',
  MembershipType.friend: 'friend',
  MembershipType.child: 'child',
};

const _$MaritalStatusEnumMap = {
  MaritalStatus.single: 'single',
  MaritalStatus.engaged: 'engaged',
  MaritalStatus.married: 'married',
  MaritalStatus.separated: 'separated',
  MaritalStatus.divorced: 'divorced',
  MaritalStatus.widowed: 'widowed',
  MaritalStatus.remarried: 'remarried',
  MaritalStatus.cohabiting: 'cohabiting',
};

const _$AttendanceLevelEnumMap = {
  AttendanceLevel.veryActive: 'veryActive',
  AttendanceLevel.active: 'active',
  AttendanceLevel.regular: 'regular',
  AttendanceLevel.occasional: 'occasional',
  AttendanceLevel.rare: 'rare',
  AttendanceLevel.absent: 'absent',
};

const _$EmploymentStatusEnumMap = {
  EmploymentStatus.employed: 'employed',
  EmploymentStatus.selfEmployed: 'selfEmployed',
  EmploymentStatus.businessOwner: 'businessOwner',
  EmploymentStatus.unemployed: 'unemployed',
  EmploymentStatus.student: 'student',
  EmploymentStatus.retired: 'retired',
  EmploymentStatus.homemaker: 'homemaker',
  EmploymentStatus.disability: 'disability',
  EmploymentStatus.sabbatical: 'sabbatical',
  EmploymentStatus.other: 'other',
};

const _$EducationLevelEnumMap = {
  EducationLevel.none: 'none',
  EducationLevel.primary: 'primary',
  EducationLevel.middleSchool: 'middleSchool',
  EducationLevel.highSchool: 'highSchool',
  EducationLevel.vocational: 'vocational',
  EducationLevel.someCollege: 'someCollege',
  EducationLevel.associate: 'associate',
  EducationLevel.bachelor: 'bachelor',
  EducationLevel.master: 'master',
  EducationLevel.doctorate: 'doctorate',
  EducationLevel.postDoctorate: 'postDoctorate',
};

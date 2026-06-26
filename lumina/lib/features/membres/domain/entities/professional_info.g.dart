// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'professional_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmploymentHistoryImpl _$$EmploymentHistoryImplFromJson(
        Map<String, dynamic> json) =>
    _$EmploymentHistoryImpl(
      jobTitle: json['job_title'] as String,
      company: json['company'] as String,
      industry: json['industry'] as String?,
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      isCurrent: json['is_current'] as bool? ?? true,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$EmploymentHistoryImplToJson(
        _$EmploymentHistoryImpl instance) =>
    <String, dynamic>{
      'job_title': instance.jobTitle,
      'company': instance.company,
      'industry': instance.industry,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'is_current': instance.isCurrent,
      'description': instance.description,
    };

_$ProfessionalInfoImpl _$$ProfessionalInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfessionalInfoImpl(
      status: $enumDecodeNullable(_$EmploymentStatusEnumMap, json['status']) ??
          EmploymentStatus.employed,
      currentJobTitle: json['current_job_title'] as String?,
      currentCompany: json['current_company'] as String?,
      industry: json['industry'] as String?,
      department: json['department'] as String?,
      workAddress: json['work_address'] as String?,
      workPhone: json['work_phone'] as String?,
      workEmail: json['work_email'] as String?,
      employmentHistory: (json['employment_history'] as List<dynamic>?)
              ?.map(
                  (e) => EmploymentHistory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      educationLevel: $enumDecodeNullable(
              _$EducationLevelEnumMap, json['education_level']) ??
          EducationLevel.highSchool,
      highestDegree: json['highest_degree'] as String?,
      university: json['university'] as String?,
      fieldOfStudy: json['field_of_study'] as String?,
      graduationYear: (json['graduation_year'] as num?)?.toInt(),
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      specializations: (json['specializations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      incomeRange: json['income_range'] as String?,
      isFinanciallyStable: json['is_financially_stable'] as bool? ?? false,
      canHelpWith: (json['can_help_with'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      professionalGifts: (json['professional_gifts'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ProfessionalInfoImplToJson(
        _$ProfessionalInfoImpl instance) =>
    <String, dynamic>{
      'status': _$EmploymentStatusEnumMap[instance.status]!,
      'current_job_title': instance.currentJobTitle,
      'current_company': instance.currentCompany,
      'industry': instance.industry,
      'department': instance.department,
      'work_address': instance.workAddress,
      'work_phone': instance.workPhone,
      'work_email': instance.workEmail,
      'employment_history':
          instance.employmentHistory.map((e) => e.toJson()).toList(),
      'education_level': _$EducationLevelEnumMap[instance.educationLevel]!,
      'highest_degree': instance.highestDegree,
      'university': instance.university,
      'field_of_study': instance.fieldOfStudy,
      'graduation_year': instance.graduationYear,
      'certifications': instance.certifications,
      'specializations': instance.specializations,
      'skills': instance.skills,
      'languages': instance.languages,
      'income_range': instance.incomeRange,
      'is_financially_stable': instance.isFinanciallyStable,
      'can_help_with': instance.canHelpWith,
      'professional_gifts': instance.professionalGifts,
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

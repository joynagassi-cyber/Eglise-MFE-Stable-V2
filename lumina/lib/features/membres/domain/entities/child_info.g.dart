// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChildInfoImpl _$$ChildInfoImplFromJson(Map<String, dynamic> json) =>
    _$ChildInfoImpl(
      memberId: json['member_id'] as String?,
      isMember: json['is_member'] as bool? ?? false,
      lastName: json['last_name'] as String,
      firstName: json['first_name'] as String,
      middleName: json['middle_name'] as String?,
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      photoUrl: json['photo_url'] as String?,
      birthDate: json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
      birthPlace: json['birth_place'] as String?,
      status: $enumDecodeNullable(_$ChildStatusEnumMap, json['status']) ??
          ChildStatus.living,
      isDependent: json['is_dependent'] as bool? ?? true,
      isAdopted: json['is_adopted'] as bool? ?? false,
      isStepChild: json['is_step_child'] as bool? ?? false,
      birthOrder: (json['birth_order'] as num?)?.toInt() ?? 1,
      deathDate: json['death_date'] == null
          ? null
          : DateTime.parse(json['death_date'] as String),
      schoolName: json['school_name'] as String?,
      gradeLevel: json['grade_level'] as String?,
      isConverted: json['is_converted'] as bool? ?? false,
      isBaptized: json['is_baptized'] as bool? ?? false,
      baptismDate: json['baptism_date'] == null
          ? null
          : DateTime.parse(json['baptism_date'] as String),
      attendsSundaySchool: json['attends_sunday_school'] as bool? ?? false,
      sundaySchoolClass: json['sunday_school_class'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$$ChildInfoImplToJson(_$ChildInfoImpl instance) =>
    <String, dynamic>{
      'member_id': instance.memberId,
      'is_member': instance.isMember,
      'last_name': instance.lastName,
      'first_name': instance.firstName,
      'middle_name': instance.middleName,
      'gender': _$GenderEnumMap[instance.gender]!,
      'photo_url': instance.photoUrl,
      'birth_date': instance.birthDate?.toIso8601String(),
      'birth_place': instance.birthPlace,
      'status': _$ChildStatusEnumMap[instance.status]!,
      'is_dependent': instance.isDependent,
      'is_adopted': instance.isAdopted,
      'is_step_child': instance.isStepChild,
      'birth_order': instance.birthOrder,
      'death_date': instance.deathDate?.toIso8601String(),
      'school_name': instance.schoolName,
      'grade_level': instance.gradeLevel,
      'is_converted': instance.isConverted,
      'is_baptized': instance.isBaptized,
      'baptism_date': instance.baptismDate?.toIso8601String(),
      'attends_sunday_school': instance.attendsSundaySchool,
      'sunday_school_class': instance.sundaySchoolClass,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.other: 'other',
};

const _$ChildStatusEnumMap = {
  ChildStatus.living: 'living',
  ChildStatus.deceased: 'deceased',
  ChildStatus.adopted: 'adopted',
  ChildStatus.fosterChild: 'fosterChild',
  ChildStatus.stepChild: 'stepChild',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spouse_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpouseInfoImpl _$$SpouseInfoImplFromJson(Map<String, dynamic> json) =>
    _$SpouseInfoImpl(
      memberId: json['member_id'] as String?,
      isMember: json['is_member'] as bool? ?? false,
      lastName: json['last_name'] as String,
      firstName: json['first_name'] as String,
      middleName: json['middle_name'] as String?,
      maidenName: json['maiden_name'] as String?,
      title: json['title'] as String?,
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      photoUrl: json['photo_url'] as String?,
      birthDate: json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
      birthPlace: json['birth_place'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      whatsapp: json['whatsapp'] as String?,
      profession: json['profession'] as String?,
      employer: json['employer'] as String?,
      isChristian: json['is_christian'] as bool? ?? true,
      denomination: json['denomination'] as String?,
      churchName: json['church_name'] as String?,
      isBaptized: json['is_baptized'] as bool? ?? false,
    );

Map<String, dynamic> _$$SpouseInfoImplToJson(_$SpouseInfoImpl instance) =>
    <String, dynamic>{
      'member_id': instance.memberId,
      'is_member': instance.isMember,
      'last_name': instance.lastName,
      'first_name': instance.firstName,
      'middle_name': instance.middleName,
      'maiden_name': instance.maidenName,
      'title': instance.title,
      'gender': _$GenderEnumMap[instance.gender]!,
      'photo_url': instance.photoUrl,
      'birth_date': instance.birthDate?.toIso8601String(),
      'birth_place': instance.birthPlace,
      'phone': instance.phone,
      'email': instance.email,
      'whatsapp': instance.whatsapp,
      'profession': instance.profession,
      'employer': instance.employer,
      'is_christian': instance.isChristian,
      'denomination': instance.denomination,
      'church_name': instance.churchName,
      'is_baptized': instance.isBaptized,
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.other: 'other',
};

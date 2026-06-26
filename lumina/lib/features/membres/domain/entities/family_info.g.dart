// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeddingInfoImpl _$$WeddingInfoImplFromJson(Map<String, dynamic> json) =>
    _$WeddingInfoImpl(
      type: $enumDecodeNullable(_$WeddingTypeEnumMap, json['type']) ??
          WeddingType.churchAndCivil,
      civilWeddingDate: json['civil_wedding_date'] == null
          ? null
          : DateTime.parse(json['civil_wedding_date'] as String),
      civilWeddingLocation: json['civil_wedding_location'] as String?,
      churchWeddingDate: json['church_wedding_date'] == null
          ? null
          : DateTime.parse(json['church_wedding_date'] as String),
      churchWeddingLocation: json['church_wedding_location'] as String?,
      churchWeddingOfficiant: json['church_wedding_officiant'] as String?,
      traditionalWeddingDate: json['traditional_wedding_date'] == null
          ? null
          : DateTime.parse(json['traditional_wedding_date'] as String),
      traditionalWeddingLocation:
          json['traditional_wedding_location'] as String?,
      weddingCertificateNumber: json['wedding_certificate_number'] as String?,
      hasWeddingCertificate: json['has_wedding_certificate'] as bool? ?? false,
      witnesses: (json['witnesses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$WeddingInfoImplToJson(_$WeddingInfoImpl instance) =>
    <String, dynamic>{
      'type': _$WeddingTypeEnumMap[instance.type]!,
      'civil_wedding_date': instance.civilWeddingDate?.toIso8601String(),
      'civil_wedding_location': instance.civilWeddingLocation,
      'church_wedding_date': instance.churchWeddingDate?.toIso8601String(),
      'church_wedding_location': instance.churchWeddingLocation,
      'church_wedding_officiant': instance.churchWeddingOfficiant,
      'traditional_wedding_date':
          instance.traditionalWeddingDate?.toIso8601String(),
      'traditional_wedding_location': instance.traditionalWeddingLocation,
      'wedding_certificate_number': instance.weddingCertificateNumber,
      'has_wedding_certificate': instance.hasWeddingCertificate,
      'witnesses': instance.witnesses,
    };

const _$WeddingTypeEnumMap = {
  WeddingType.churchOnly: 'churchOnly',
  WeddingType.civilOnly: 'civilOnly',
  WeddingType.churchAndCivil: 'churchAndCivil',
  WeddingType.traditional: 'traditional',
  WeddingType.traditionalAndChurch: 'traditionalAndChurch',
  WeddingType.all: 'all',
};

_$FamilyInfoImpl _$$FamilyInfoImplFromJson(Map<String, dynamic> json) =>
    _$FamilyInfoImpl(
      maritalStatus:
          $enumDecodeNullable(_$MaritalStatusEnumMap, json['marital_status']) ??
              MaritalStatus.single,
      spouse: json['spouse'] == null
          ? null
          : SpouseInfo.fromJson(json['spouse'] as Map<String, dynamic>),
      wedding: json['wedding'] == null
          ? null
          : WeddingInfo.fromJson(json['wedding'] as Map<String, dynamic>),
      children: (json['children'] as List<dynamic>?)
              ?.map((e) => ChildInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      numberOfChildren: (json['number_of_children'] as num?)?.toInt() ?? 0,
      numberOfChildrenLiving:
          (json['number_of_children_living'] as num?)?.toInt() ?? 0,
      numberOfDependents: (json['number_of_dependents'] as num?)?.toInt() ?? 0,
      familyMemberIds: (json['family_member_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      fatherMemberId: json['father_member_id'] as String?,
      motherMemberId: json['mother_member_id'] as String?,
      siblingMemberIds: (json['sibling_member_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      ethnicity: json['ethnicity'] as String?,
      tribe: json['tribe'] as String?,
      clan: json['clan'] as String?,
      villageOfOrigin: json['village_of_origin'] as String?,
      regionOfOrigin: json['region_of_origin'] as String?,
      countryOfOrigin: json['country_of_origin'] as String?,
      hometownCity: json['hometown_city'] as String?,
    );

Map<String, dynamic> _$$FamilyInfoImplToJson(_$FamilyInfoImpl instance) =>
    <String, dynamic>{
      'marital_status': _$MaritalStatusEnumMap[instance.maritalStatus]!,
      'spouse': instance.spouse?.toJson(),
      'wedding': instance.wedding?.toJson(),
      'children': instance.children.map((e) => e.toJson()).toList(),
      'number_of_children': instance.numberOfChildren,
      'number_of_children_living': instance.numberOfChildrenLiving,
      'number_of_dependents': instance.numberOfDependents,
      'family_member_ids': instance.familyMemberIds,
      'father_member_id': instance.fatherMemberId,
      'mother_member_id': instance.motherMemberId,
      'sibling_member_ids': instance.siblingMemberIds,
      'ethnicity': instance.ethnicity,
      'tribe': instance.tribe,
      'clan': instance.clan,
      'village_of_origin': instance.villageOfOrigin,
      'region_of_origin': instance.regionOfOrigin,
      'country_of_origin': instance.countryOfOrigin,
      'hometown_city': instance.hometownCity,
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

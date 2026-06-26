// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddressImpl _$$AddressImplFromJson(Map<String, dynamic> json) =>
    _$AddressImpl(
      streetNumber: json['street_number'] as String?,
      streetName: json['street_name'] as String?,
      streetLine1: json['street_line1'] as String?,
      streetLine2: json['street_line2'] as String?,
      building: json['building'] as String?,
      apartment: json['apartment'] as String?,
      floor: json['floor'] as String?,
      neighborhood: json['neighborhood'] as String?,
      district: json['district'] as String?,
      city: json['city'] as String,
      region: json['region'] as String?,
      postalCode: json['postal_code'] as String?,
      poBox: json['po_box'] as String?,
      country: json['country'] as String? ?? 'Côte d\'Ivoire',
      landmark: json['landmark'] as String?,
      nearbyLandmark: json['nearby_landmark'] as String?,
      directions: json['directions'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      type: $enumDecodeNullable(_$AddressTypeEnumMap, json['type']) ??
          AddressType.home,
      isVerified: json['is_verified'] as bool? ?? false,
      verifiedAt: json['verified_at'] == null
          ? null
          : DateTime.parse(json['verified_at'] as String),
    );

Map<String, dynamic> _$$AddressImplToJson(_$AddressImpl instance) =>
    <String, dynamic>{
      'street_number': instance.streetNumber,
      'street_name': instance.streetName,
      'street_line1': instance.streetLine1,
      'street_line2': instance.streetLine2,
      'building': instance.building,
      'apartment': instance.apartment,
      'floor': instance.floor,
      'neighborhood': instance.neighborhood,
      'district': instance.district,
      'city': instance.city,
      'region': instance.region,
      'postal_code': instance.postalCode,
      'po_box': instance.poBox,
      'country': instance.country,
      'landmark': instance.landmark,
      'nearby_landmark': instance.nearbyLandmark,
      'directions': instance.directions,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'type': _$AddressTypeEnumMap[instance.type]!,
      'is_verified': instance.isVerified,
      'verified_at': instance.verifiedAt?.toIso8601String(),
    };

const _$AddressTypeEnumMap = {
  AddressType.home: 'home',
  AddressType.work: 'work',
  AddressType.postal: 'postal',
  AddressType.secondary: 'secondary',
  AddressType.village: 'village',
  AddressType.temporary: 'temporary',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChurchImpl _$$ChurchImplFromJson(Map<String, dynamic> json) => _$ChurchImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$ChurchTypeEnumMap, json['type']),
      description: json['description'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      postalCode: json['postal_code'] as String?,
      country: json['country'] as String? ?? 'RDC',
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      parentChurchId: json['parent_church_id'] as String?,
      federationId: json['federation_id'] as String?,
      memberCount: (json['member_count'] as num?)?.toInt() ?? 0,
      foundedDate: json['founded_date'] == null
          ? null
          : DateTime.parse(json['founded_date'] as String),
      leadPastorId: json['lead_pastor_id'] as String?,
      logoUrl: json['logo_url'] as String?,
      coverImageUrl: json['cover_image_url'] as String?,
      isSynced: json['is_synced'] as bool? ?? false,
      lastSyncedAt: json['last_synced_at'] == null
          ? null
          : DateTime.parse(json['last_synced_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ChurchImplToJson(_$ChurchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$ChurchTypeEnumMap[instance.type]!,
      'description': instance.description,
      'address': instance.address,
      'city': instance.city,
      'postal_code': instance.postalCode,
      'country': instance.country,
      'phone': instance.phone,
      'email': instance.email,
      'website': instance.website,
      'parent_church_id': instance.parentChurchId,
      'federation_id': instance.federationId,
      'member_count': instance.memberCount,
      'founded_date': instance.foundedDate?.toIso8601String(),
      'lead_pastor_id': instance.leadPastorId,
      'logo_url': instance.logoUrl,
      'cover_image_url': instance.coverImageUrl,
      'is_synced': instance.isSynced,
      'last_synced_at': instance.lastSyncedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$ChurchTypeEnumMap = {
  ChurchType.main: 'main',
  ChurchType.branch: 'branch',
  ChurchType.affiliate: 'affiliate',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PhoneNumberImpl _$$PhoneNumberImplFromJson(Map<String, dynamic> json) =>
    _$PhoneNumberImpl(
      number: json['number'] as String,
      countryCode: json['country_code'] as String? ?? '+225',
      type: $enumDecodeNullable(_$PhoneTypeEnumMap, json['type']) ??
          PhoneType.mobile,
      hasWhatsApp: json['has_whats_app'] as bool? ?? false,
      hasTelegram: json['has_telegram'] as bool? ?? false,
      isPrimary: json['is_primary'] as bool? ?? true,
      isVerified: json['is_verified'] as bool? ?? true,
      canReceiveSms: json['can_receive_sms'] as bool? ?? true,
    );

Map<String, dynamic> _$$PhoneNumberImplToJson(_$PhoneNumberImpl instance) =>
    <String, dynamic>{
      'number': instance.number,
      'country_code': instance.countryCode,
      'type': _$PhoneTypeEnumMap[instance.type]!,
      'has_whats_app': instance.hasWhatsApp,
      'has_telegram': instance.hasTelegram,
      'is_primary': instance.isPrimary,
      'is_verified': instance.isVerified,
      'can_receive_sms': instance.canReceiveSms,
    };

const _$PhoneTypeEnumMap = {
  PhoneType.mobile: 'mobile',
  PhoneType.home: 'home',
  PhoneType.work: 'work',
  PhoneType.fax: 'fax',
  PhoneType.other: 'other',
};

_$ContactInfoImpl _$$ContactInfoImplFromJson(Map<String, dynamic> json) =>
    _$ContactInfoImpl(
      phones: (json['phones'] as List<dynamic>?)
              ?.map((e) => PhoneNumber.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      whatsappNumber: json['whatsapp_number'] as String?,
      telegramUsername: json['telegram_username'] as String?,
      primaryEmail: json['primary_email'] as String?,
      secondaryEmail: json['secondary_email'] as String?,
      emailVerified: json['email_verified'] as bool? ?? false,
      facebookUrl: json['facebook_url'] as String?,
      instagramHandle: json['instagram_handle'] as String?,
      twitterHandle: json['twitter_handle'] as String?,
      linkedInUrl: json['linked_in_url'] as String?,
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactPhone: json['emergency_contact_phone'] as String?,
      emergencyContactRelation: json['emergency_contact_relation'] as String?,
      acceptsWhatsApp: json['accepts_whats_app'] as bool? ?? true,
      acceptsSms: json['accepts_sms'] as bool? ?? true,
      acceptsEmail: json['accepts_email'] as bool? ?? true,
      acceptsPhoneCall: json['accepts_phone_call'] as bool? ?? true,
      preferredContactMethod: json['preferred_contact_method'] as String?,
      preferredContactTime: json['preferred_contact_time'] as String?,
    );

Map<String, dynamic> _$$ContactInfoImplToJson(_$ContactInfoImpl instance) =>
    <String, dynamic>{
      'phones': instance.phones.map((e) => e.toJson()).toList(),
      'whatsapp_number': instance.whatsappNumber,
      'telegram_username': instance.telegramUsername,
      'primary_email': instance.primaryEmail,
      'secondary_email': instance.secondaryEmail,
      'email_verified': instance.emailVerified,
      'facebook_url': instance.facebookUrl,
      'instagram_handle': instance.instagramHandle,
      'twitter_handle': instance.twitterHandle,
      'linked_in_url': instance.linkedInUrl,
      'emergency_contact_name': instance.emergencyContactName,
      'emergency_contact_phone': instance.emergencyContactPhone,
      'emergency_contact_relation': instance.emergencyContactRelation,
      'accepts_whats_app': instance.acceptsWhatsApp,
      'accepts_sms': instance.acceptsSms,
      'accepts_email': instance.acceptsEmail,
      'accepts_phone_call': instance.acceptsPhoneCall,
      'preferred_contact_method': instance.preferredContactMethod,
      'preferred_contact_time': instance.preferredContactTime,
    };

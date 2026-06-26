// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSessionImpl _$$UserSessionImplFromJson(Map<String, dynamic> json) =>
    _$UserSessionImpl(
      userId: json['user_id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      activeChurchId: json['active_church_id'] as String,
      accessibleChurchIds: (json['accessible_church_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      role: ChurchRole.fromJson(json['role'] as Map<String, dynamic>),
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenExpiresAt: DateTime.parse(json['token_expires_at'] as String),
      lastLoginAt: DateTime.parse(json['last_login_at'] as String),
      isActive: json['is_active'] as bool? ?? true,
      needsOnboarding: json['needs_onboarding'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UserSessionImplToJson(_$UserSessionImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'email': instance.email,
      'name': instance.name,
      'avatar': instance.avatar,
      'active_church_id': instance.activeChurchId,
      'accessible_church_ids': instance.accessibleChurchIds,
      'role': instance.role.toJson(),
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_expires_at': instance.tokenExpiresAt.toIso8601String(),
      'last_login_at': instance.lastLoginAt.toIso8601String(),
      'is_active': instance.isActive,
      'needs_onboarding': instance.needsOnboarding,
      'metadata': instance.metadata,
    };

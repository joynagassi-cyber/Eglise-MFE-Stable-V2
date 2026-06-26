// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserSession _$UserSessionFromJson(Map<String, dynamic> json) {
  return _UserSession.fromJson(json);
}

/// @nodoc
mixin _$UserSession {
  /// Identifiant unique de l'utilisateur
  String get userId => throw _privateConstructorUsedError;

  /// Email de l'utilisateur
  String get email => throw _privateConstructorUsedError;

  /// Nom complet de l'utilisateur
  String get name => throw _privateConstructorUsedError;

  /// Photo de profil (URL ou base64)
  String? get avatar => throw _privateConstructorUsedError;

  /// Identifiant de l'église active (contexte multi-église)
  String get activeChurchId => throw _privateConstructorUsedError;

  /// Liste des églises auxquelles l'utilisateur a accès
  List<String> get accessibleChurchIds => throw _privateConstructorUsedError;

  /// Rôle de l'utilisateur dans l'église active
  ChurchRole get role => throw _privateConstructorUsedError;

  /// Token JWT d'authentification
  String get accessToken => throw _privateConstructorUsedError;

  /// Token pour rafraîchir le JWT
  String get refreshToken => throw _privateConstructorUsedError;

  /// Date d'expiration du token d'accès
  DateTime get tokenExpiresAt => throw _privateConstructorUsedError;

  /// Date de dernière connexion
  DateTime get lastLoginAt => throw _privateConstructorUsedError;

  /// Indique si la session est active
  bool get isActive => throw _privateConstructorUsedError;

  /// Indique si l'utilisateur doit compléter son onboarding (choix rôle/église)
  bool get needsOnboarding => throw _privateConstructorUsedError;

  /// Métadonnées supplémentaires (device info, etc.)
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserSessionCopyWith<UserSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSessionCopyWith<$Res> {
  factory $UserSessionCopyWith(
          UserSession value, $Res Function(UserSession) then) =
      _$UserSessionCopyWithImpl<$Res, UserSession>;
  @useResult
  $Res call(
      {String userId,
      String email,
      String name,
      String? avatar,
      String activeChurchId,
      List<String> accessibleChurchIds,
      ChurchRole role,
      String accessToken,
      String refreshToken,
      DateTime tokenExpiresAt,
      DateTime lastLoginAt,
      bool isActive,
      bool needsOnboarding,
      Map<String, dynamic>? metadata});

  $ChurchRoleCopyWith<$Res> get role;
}

/// @nodoc
class _$UserSessionCopyWithImpl<$Res, $Val extends UserSession>
    implements $UserSessionCopyWith<$Res> {
  _$UserSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? email = null,
    Object? name = null,
    Object? avatar = freezed,
    Object? activeChurchId = null,
    Object? accessibleChurchIds = null,
    Object? role = null,
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? tokenExpiresAt = null,
    Object? lastLoginAt = null,
    Object? isActive = null,
    Object? needsOnboarding = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      activeChurchId: null == activeChurchId
          ? _value.activeChurchId
          : activeChurchId // ignore: cast_nullable_to_non_nullable
              as String,
      accessibleChurchIds: null == accessibleChurchIds
          ? _value.accessibleChurchIds
          : accessibleChurchIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as ChurchRole,
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenExpiresAt: null == tokenExpiresAt
          ? _value.tokenExpiresAt
          : tokenExpiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastLoginAt: null == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      needsOnboarding: null == needsOnboarding
          ? _value.needsOnboarding
          : needsOnboarding // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ChurchRoleCopyWith<$Res> get role {
    return $ChurchRoleCopyWith<$Res>(_value.role, (value) {
      return _then(_value.copyWith(role: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserSessionImplCopyWith<$Res>
    implements $UserSessionCopyWith<$Res> {
  factory _$$UserSessionImplCopyWith(
          _$UserSessionImpl value, $Res Function(_$UserSessionImpl) then) =
      __$$UserSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String email,
      String name,
      String? avatar,
      String activeChurchId,
      List<String> accessibleChurchIds,
      ChurchRole role,
      String accessToken,
      String refreshToken,
      DateTime tokenExpiresAt,
      DateTime lastLoginAt,
      bool isActive,
      bool needsOnboarding,
      Map<String, dynamic>? metadata});

  @override
  $ChurchRoleCopyWith<$Res> get role;
}

/// @nodoc
class __$$UserSessionImplCopyWithImpl<$Res>
    extends _$UserSessionCopyWithImpl<$Res, _$UserSessionImpl>
    implements _$$UserSessionImplCopyWith<$Res> {
  __$$UserSessionImplCopyWithImpl(
      _$UserSessionImpl _value, $Res Function(_$UserSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? email = null,
    Object? name = null,
    Object? avatar = freezed,
    Object? activeChurchId = null,
    Object? accessibleChurchIds = null,
    Object? role = null,
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? tokenExpiresAt = null,
    Object? lastLoginAt = null,
    Object? isActive = null,
    Object? needsOnboarding = null,
    Object? metadata = freezed,
  }) {
    return _then(_$UserSessionImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      activeChurchId: null == activeChurchId
          ? _value.activeChurchId
          : activeChurchId // ignore: cast_nullable_to_non_nullable
              as String,
      accessibleChurchIds: null == accessibleChurchIds
          ? _value._accessibleChurchIds
          : accessibleChurchIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as ChurchRole,
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenExpiresAt: null == tokenExpiresAt
          ? _value.tokenExpiresAt
          : tokenExpiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastLoginAt: null == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      needsOnboarding: null == needsOnboarding
          ? _value.needsOnboarding
          : needsOnboarding // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSessionImpl extends _UserSession {
  const _$UserSessionImpl(
      {required this.userId,
      required this.email,
      required this.name,
      this.avatar,
      required this.activeChurchId,
      required final List<String> accessibleChurchIds,
      required this.role,
      required this.accessToken,
      required this.refreshToken,
      required this.tokenExpiresAt,
      required this.lastLoginAt,
      this.isActive = true,
      this.needsOnboarding = false,
      final Map<String, dynamic>? metadata})
      : _accessibleChurchIds = accessibleChurchIds,
        _metadata = metadata,
        super._();

  factory _$UserSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSessionImplFromJson(json);

  /// Identifiant unique de l'utilisateur
  @override
  final String userId;

  /// Email de l'utilisateur
  @override
  final String email;

  /// Nom complet de l'utilisateur
  @override
  final String name;

  /// Photo de profil (URL ou base64)
  @override
  final String? avatar;

  /// Identifiant de l'église active (contexte multi-église)
  @override
  final String activeChurchId;

  /// Liste des églises auxquelles l'utilisateur a accès
  final List<String> _accessibleChurchIds;

  /// Liste des églises auxquelles l'utilisateur a accès
  @override
  List<String> get accessibleChurchIds {
    if (_accessibleChurchIds is EqualUnmodifiableListView)
      return _accessibleChurchIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_accessibleChurchIds);
  }

  /// Rôle de l'utilisateur dans l'église active
  @override
  final ChurchRole role;

  /// Token JWT d'authentification
  @override
  final String accessToken;

  /// Token pour rafraîchir le JWT
  @override
  final String refreshToken;

  /// Date d'expiration du token d'accès
  @override
  final DateTime tokenExpiresAt;

  /// Date de dernière connexion
  @override
  final DateTime lastLoginAt;

  /// Indique si la session est active
  @override
  @JsonKey()
  final bool isActive;

  /// Indique si l'utilisateur doit compléter son onboarding (choix rôle/église)
  @override
  @JsonKey()
  final bool needsOnboarding;

  /// Métadonnées supplémentaires (device info, etc.)
  final Map<String, dynamic>? _metadata;

  /// Métadonnées supplémentaires (device info, etc.)
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'UserSession(userId: $userId, email: $email, name: $name, avatar: $avatar, activeChurchId: $activeChurchId, accessibleChurchIds: $accessibleChurchIds, role: $role, accessToken: $accessToken, refreshToken: $refreshToken, tokenExpiresAt: $tokenExpiresAt, lastLoginAt: $lastLoginAt, isActive: $isActive, needsOnboarding: $needsOnboarding, metadata: $metadata)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSessionImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.activeChurchId, activeChurchId) ||
                other.activeChurchId == activeChurchId) &&
            const DeepCollectionEquality()
                .equals(other._accessibleChurchIds, _accessibleChurchIds) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.tokenExpiresAt, tokenExpiresAt) ||
                other.tokenExpiresAt == tokenExpiresAt) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.needsOnboarding, needsOnboarding) ||
                other.needsOnboarding == needsOnboarding) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      email,
      name,
      avatar,
      activeChurchId,
      const DeepCollectionEquality().hash(_accessibleChurchIds),
      role,
      accessToken,
      refreshToken,
      tokenExpiresAt,
      lastLoginAt,
      isActive,
      needsOnboarding,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSessionImplCopyWith<_$UserSessionImpl> get copyWith =>
      __$$UserSessionImplCopyWithImpl<_$UserSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSessionImplToJson(
      this,
    );
  }
}

abstract class _UserSession extends UserSession {
  const factory _UserSession(
      {required final String userId,
      required final String email,
      required final String name,
      final String? avatar,
      required final String activeChurchId,
      required final List<String> accessibleChurchIds,
      required final ChurchRole role,
      required final String accessToken,
      required final String refreshToken,
      required final DateTime tokenExpiresAt,
      required final DateTime lastLoginAt,
      final bool isActive,
      final bool needsOnboarding,
      final Map<String, dynamic>? metadata}) = _$UserSessionImpl;
  const _UserSession._() : super._();

  factory _UserSession.fromJson(Map<String, dynamic> json) =
      _$UserSessionImpl.fromJson;

  @override

  /// Identifiant unique de l'utilisateur
  String get userId;
  @override

  /// Email de l'utilisateur
  String get email;
  @override

  /// Nom complet de l'utilisateur
  String get name;
  @override

  /// Photo de profil (URL ou base64)
  String? get avatar;
  @override

  /// Identifiant de l'église active (contexte multi-église)
  String get activeChurchId;
  @override

  /// Liste des églises auxquelles l'utilisateur a accès
  List<String> get accessibleChurchIds;
  @override

  /// Rôle de l'utilisateur dans l'église active
  ChurchRole get role;
  @override

  /// Token JWT d'authentification
  String get accessToken;
  @override

  /// Token pour rafraîchir le JWT
  String get refreshToken;
  @override

  /// Date d'expiration du token d'accès
  DateTime get tokenExpiresAt;
  @override

  /// Date de dernière connexion
  DateTime get lastLoginAt;
  @override

  /// Indique si la session est active
  bool get isActive;
  @override

  /// Indique si l'utilisateur doit compléter son onboarding (choix rôle/église)
  bool get needsOnboarding;
  @override

  /// Métadonnées supplémentaires (device info, etc.)
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$UserSessionImplCopyWith<_$UserSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

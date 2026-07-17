// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentSessionHash() => r'8c8cf4d3848052542168315a70b93b72e0106765';

/// See also [currentSession].
@ProviderFor(currentSession)
final currentSessionProvider = Provider<UserSession?>.internal(
  currentSession,
  name: r'currentSessionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentSessionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentSessionRef = ProviderRef<UserSession?>;
String _$isAuthenticatedHash() => r'890c03e480c0da083c93fd8b6aa6bb348208e359';

/// See also [isAuthenticated].
@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = Provider<bool>.internal(
  isAuthenticated,
  name: r'isAuthenticatedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isAuthenticatedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsAuthenticatedRef = ProviderRef<bool>;
String _$needsOnboardingHash() => r'aa0e69e57bb42c9a2c55367e37d869452887010e';

/// See also [needsOnboarding].
@ProviderFor(needsOnboarding)
final needsOnboardingProvider = Provider<bool>.internal(
  needsOnboarding,
  name: r'needsOnboardingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$needsOnboardingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NeedsOnboardingRef = ProviderRef<bool>;
String _$currentUserIdHash() => r'3d9532078560fd47d69d600ee4d0fc9bb26ad28c';

/// See also [currentUserId].
@ProviderFor(currentUserId)
final currentUserIdProvider = Provider<String?>.internal(
  currentUserId,
  name: r'currentUserIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentUserIdRef = ProviderRef<String?>;
String _$activeChurchIdHash() => r'615c08c2fc4e94362bbc2c0e9bb50bbb93392645';

/// See also [activeChurchId].
@ProviderFor(activeChurchId)
final activeChurchIdProvider = Provider<String>.internal(
  activeChurchId,
  name: r'activeChurchIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeChurchIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ActiveChurchIdRef = ProviderRef<String>;
String _$currentRoleLevelHash() => r'ff009c57dbe32ef48002f5cea6bca065d0af91c4';

/// Retourne le RoleLevel de l'utilisateur courant
///
/// Copied from [currentRoleLevel].
@ProviderFor(currentRoleLevel)
final currentRoleLevelProvider = Provider<RoleLevel>.internal(
  currentRoleLevel,
  name: r'currentRoleLevelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentRoleLevelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentRoleLevelRef = ProviderRef<RoleLevel>;
String _$currentInitialRouteHash() =>
    r'd577cfe33876b6467408bef4919f177b64a885d1';

/// Retourne la route initiale de l'utilisateur courant.
/// PrioritÃ© au UserContext.role.initialRoute (rafraÃ®chi aprÃ¨s onboarding)
/// puis fallback sur UserSession.role.initialRoute (construit au login).
///
/// Copied from [currentInitialRoute].
@ProviderFor(currentInitialRoute)
final currentInitialRouteProvider = Provider<String>.internal(
  currentInitialRoute,
  name: r'currentInitialRouteProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentInitialRouteHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentInitialRouteRef = ProviderRef<String>;
String _$isFullAdminHash() => r'674f1e506ef8791a9e47a75e465a8dec654fd211';

/// VÃ©rifie si l'utilisateur a un accÃ¨s administratif complet.
/// (Soit SuperAdmin, soit son rÃ´le contient "administrateur").
///
/// Copied from [isFullAdmin].
@ProviderFor(isFullAdmin)
final isFullAdminProvider = Provider<bool>.internal(
  isFullAdmin,
  name: r'isFullAdminProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isFullAdminHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsFullAdminRef = ProviderRef<bool>;
String _$isStaffHash() => r'02fa73c6bf83ecbc9eb2a2c4f534b0e68e7e06c9';

/// VÃ©rifie si l'utilisateur fait partie du Staff (AccÃ¨s opÃ©rationnel complet).
/// Note: Tout le staff (Pasteurs, SecrÃ©taires, TrÃ©soriers) peut s'entraider.
///
/// Copied from [isStaff].
@ProviderFor(isStaff)
final isStaffProvider = Provider<bool>.internal(
  isStaff,
  name: r'isStaffProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isStaffHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsStaffRef = ProviderRef<bool>;
String _$isTreasurerHash() => r'21f77ebbb5540936bb64aa00906a778822c631f7';

/// VÃ©rifie si l'utilisateur a accÃ¨s aux finances.
/// Avec la polyvalence opÃ©rationnelle, isStaff et isTreasurer deviennent Ã©quivalents
/// pour le staff administratif de l'Ã©glise.
///
/// Copied from [isTreasurer].
@ProviderFor(isTreasurer)
final isTreasurerProvider = Provider<bool>.internal(
  isTreasurer,
  name: r'isTreasurerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isTreasurerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsTreasurerRef = ProviderRef<bool>;
String _$isAdminHash() => r'd0f0061f79a14aa01c7b671708685aa527f38b9f';

/// VÃ©rifie si l'utilisateur est admin ou superadmin (Maintenu pour compatibilitÃ© UI)
///
/// Copied from [isAdmin].
@ProviderFor(isAdmin)
final isAdminProvider = Provider<bool>.internal(
  isAdmin,
  name: r'isAdminProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isAdminHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsAdminRef = ProviderRef<bool>;
String _$isSuperAdminHash() => r'e552664cc8df551a8779ced5d7f1030a53949ec7';

/// VÃ©rifie si l'utilisateur est superadmin
///
/// Copied from [isSuperAdmin].
@ProviderFor(isSuperAdmin)
final isSuperAdminProvider = Provider<bool>.internal(
  isSuperAdmin,
  name: r'isSuperAdminProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isSuperAdminHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsSuperAdminRef = ProviderRef<bool>;
String _$isGroupLeaderHash() => r'2e1635d53223e67e4ffde1a2efe3c1dcc6e34db8';

/// VÃ©rifie si l'utilisateur est un leader (responsable de groupe)
///
/// Copied from [isGroupLeader].
@ProviderFor(isGroupLeader)
final isGroupLeaderProvider = Provider<bool>.internal(
  isGroupLeader,
  name: r'isGroupLeaderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isGroupLeaderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsGroupLeaderRef = ProviderRef<bool>;
String _$isConsultantHash() => r'7da341e91e4d0feb0aaee1cdeee463e7cfe49c4f';

/// VÃ©rifie si l'utilisateur est en mode consultation uniquement
///
/// Copied from [isConsultant].
@ProviderFor(isConsultant)
final isConsultantProvider = Provider<bool>.internal(
  isConsultant,
  name: r'isConsultantProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isConsultantHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsConsultantRef = ProviderRef<bool>;
String _$isMemberHash() => r'329abde1eba18a402015390d06aa70f932f97178';

/// VÃ©rifie si l'utilisateur est un membre standard
///
/// Copied from [isMember].
@ProviderFor(isMember)
final isMemberProvider = Provider<bool>.internal(
  isMember,
  name: r'isMemberProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isMemberHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsMemberRef = ProviderRef<bool>;
String _$authHash() => r'a9a79b52bfc1e2303b8cbc55a628601db0297071';

/// See also [Auth].
@ProviderFor(Auth)
final authProvider = AsyncNotifierProvider<Auth, app_auth.AuthState>.internal(
  Auth.new,
  name: r'authProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Auth = AsyncNotifier<app_auth.AuthState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

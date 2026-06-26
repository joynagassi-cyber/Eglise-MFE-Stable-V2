// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allRolesHash() => r'de5bd5e29ee3e066f9c283eb620235306f86811d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider pour récupérer tous les rôles d'une église
///
/// Copied from [allRoles].
@ProviderFor(allRoles)
const allRolesProvider = AllRolesFamily();

/// Provider pour récupérer tous les rôles d'une église
///
/// Copied from [allRoles].
class AllRolesFamily extends Family<AsyncValue<List<ChurchRole>>> {
  /// Provider pour récupérer tous les rôles d'une église
  ///
  /// Copied from [allRoles].
  const AllRolesFamily();

  /// Provider pour récupérer tous les rôles d'une église
  ///
  /// Copied from [allRoles].
  AllRolesProvider call({
    required String churchId,
    bool includeInactive = false,
  }) {
    return AllRolesProvider(
      churchId: churchId,
      includeInactive: includeInactive,
    );
  }

  @override
  AllRolesProvider getProviderOverride(
    covariant AllRolesProvider provider,
  ) {
    return call(
      churchId: provider.churchId,
      includeInactive: provider.includeInactive,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'allRolesProvider';
}

/// Provider pour récupérer tous les rôles d'une église
///
/// Copied from [allRoles].
class AllRolesProvider extends AutoDisposeFutureProvider<List<ChurchRole>> {
  /// Provider pour récupérer tous les rôles d'une église
  ///
  /// Copied from [allRoles].
  AllRolesProvider({
    required String churchId,
    bool includeInactive = false,
  }) : this._internal(
          (ref) => allRoles(
            ref as AllRolesRef,
            churchId: churchId,
            includeInactive: includeInactive,
          ),
          from: allRolesProvider,
          name: r'allRolesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$allRolesHash,
          dependencies: AllRolesFamily._dependencies,
          allTransitiveDependencies: AllRolesFamily._allTransitiveDependencies,
          churchId: churchId,
          includeInactive: includeInactive,
        );

  AllRolesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.churchId,
    required this.includeInactive,
  }) : super.internal();

  final String churchId;
  final bool includeInactive;

  @override
  Override overrideWith(
    FutureOr<List<ChurchRole>> Function(AllRolesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AllRolesProvider._internal(
        (ref) => create(ref as AllRolesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        churchId: churchId,
        includeInactive: includeInactive,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ChurchRole>> createElement() {
    return _AllRolesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AllRolesProvider &&
        other.churchId == churchId &&
        other.includeInactive == includeInactive;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, churchId.hashCode);
    hash = _SystemHash.combine(hash, includeInactive.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AllRolesRef on AutoDisposeFutureProviderRef<List<ChurchRole>> {
  /// The parameter `churchId` of this provider.
  String get churchId;

  /// The parameter `includeInactive` of this provider.
  bool get includeInactive;
}

class _AllRolesProviderElement
    extends AutoDisposeFutureProviderElement<List<ChurchRole>>
    with AllRolesRef {
  _AllRolesProviderElement(super.provider);

  @override
  String get churchId => (origin as AllRolesProvider).churchId;
  @override
  bool get includeInactive => (origin as AllRolesProvider).includeInactive;
}

String _$systemRolesHash() => r'838d1321baea0a18c63a5e712d309aba1dd04ff4';

/// Provider pour récupérer les rôles système
///
/// Copied from [systemRoles].
@ProviderFor(systemRoles)
const systemRolesProvider = SystemRolesFamily();

/// Provider pour récupérer les rôles système
///
/// Copied from [systemRoles].
class SystemRolesFamily extends Family<AsyncValue<List<ChurchRole>>> {
  /// Provider pour récupérer les rôles système
  ///
  /// Copied from [systemRoles].
  const SystemRolesFamily();

  /// Provider pour récupérer les rôles système
  ///
  /// Copied from [systemRoles].
  SystemRolesProvider call({
    required String churchId,
  }) {
    return SystemRolesProvider(
      churchId: churchId,
    );
  }

  @override
  SystemRolesProvider getProviderOverride(
    covariant SystemRolesProvider provider,
  ) {
    return call(
      churchId: provider.churchId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'systemRolesProvider';
}

/// Provider pour récupérer les rôles système
///
/// Copied from [systemRoles].
class SystemRolesProvider extends AutoDisposeFutureProvider<List<ChurchRole>> {
  /// Provider pour récupérer les rôles système
  ///
  /// Copied from [systemRoles].
  SystemRolesProvider({
    required String churchId,
  }) : this._internal(
          (ref) => systemRoles(
            ref as SystemRolesRef,
            churchId: churchId,
          ),
          from: systemRolesProvider,
          name: r'systemRolesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$systemRolesHash,
          dependencies: SystemRolesFamily._dependencies,
          allTransitiveDependencies:
              SystemRolesFamily._allTransitiveDependencies,
          churchId: churchId,
        );

  SystemRolesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.churchId,
  }) : super.internal();

  final String churchId;

  @override
  Override overrideWith(
    FutureOr<List<ChurchRole>> Function(SystemRolesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SystemRolesProvider._internal(
        (ref) => create(ref as SystemRolesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        churchId: churchId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ChurchRole>> createElement() {
    return _SystemRolesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SystemRolesProvider && other.churchId == churchId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, churchId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SystemRolesRef on AutoDisposeFutureProviderRef<List<ChurchRole>> {
  /// The parameter `churchId` of this provider.
  String get churchId;
}

class _SystemRolesProviderElement
    extends AutoDisposeFutureProviderElement<List<ChurchRole>>
    with SystemRolesRef {
  _SystemRolesProviderElement(super.provider);

  @override
  String get churchId => (origin as SystemRolesProvider).churchId;
}

String _$customRolesHash() => r'7e37cf979ea44b91c9a55b49c9379ba71d4e4387';

/// Provider pour récupérer les rôles personnalisés
///
/// Copied from [customRoles].
@ProviderFor(customRoles)
const customRolesProvider = CustomRolesFamily();

/// Provider pour récupérer les rôles personnalisés
///
/// Copied from [customRoles].
class CustomRolesFamily extends Family<AsyncValue<List<ChurchRole>>> {
  /// Provider pour récupérer les rôles personnalisés
  ///
  /// Copied from [customRoles].
  const CustomRolesFamily();

  /// Provider pour récupérer les rôles personnalisés
  ///
  /// Copied from [customRoles].
  CustomRolesProvider call({
    required String churchId,
    bool includeInactive = false,
  }) {
    return CustomRolesProvider(
      churchId: churchId,
      includeInactive: includeInactive,
    );
  }

  @override
  CustomRolesProvider getProviderOverride(
    covariant CustomRolesProvider provider,
  ) {
    return call(
      churchId: provider.churchId,
      includeInactive: provider.includeInactive,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'customRolesProvider';
}

/// Provider pour récupérer les rôles personnalisés
///
/// Copied from [customRoles].
class CustomRolesProvider extends AutoDisposeFutureProvider<List<ChurchRole>> {
  /// Provider pour récupérer les rôles personnalisés
  ///
  /// Copied from [customRoles].
  CustomRolesProvider({
    required String churchId,
    bool includeInactive = false,
  }) : this._internal(
          (ref) => customRoles(
            ref as CustomRolesRef,
            churchId: churchId,
            includeInactive: includeInactive,
          ),
          from: customRolesProvider,
          name: r'customRolesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$customRolesHash,
          dependencies: CustomRolesFamily._dependencies,
          allTransitiveDependencies:
              CustomRolesFamily._allTransitiveDependencies,
          churchId: churchId,
          includeInactive: includeInactive,
        );

  CustomRolesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.churchId,
    required this.includeInactive,
  }) : super.internal();

  final String churchId;
  final bool includeInactive;

  @override
  Override overrideWith(
    FutureOr<List<ChurchRole>> Function(CustomRolesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CustomRolesProvider._internal(
        (ref) => create(ref as CustomRolesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        churchId: churchId,
        includeInactive: includeInactive,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ChurchRole>> createElement() {
    return _CustomRolesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomRolesProvider &&
        other.churchId == churchId &&
        other.includeInactive == includeInactive;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, churchId.hashCode);
    hash = _SystemHash.combine(hash, includeInactive.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CustomRolesRef on AutoDisposeFutureProviderRef<List<ChurchRole>> {
  /// The parameter `churchId` of this provider.
  String get churchId;

  /// The parameter `includeInactive` of this provider.
  bool get includeInactive;
}

class _CustomRolesProviderElement
    extends AutoDisposeFutureProviderElement<List<ChurchRole>>
    with CustomRolesRef {
  _CustomRolesProviderElement(super.provider);

  @override
  String get churchId => (origin as CustomRolesProvider).churchId;
  @override
  bool get includeInactive => (origin as CustomRolesProvider).includeInactive;
}

String _$roleByIdHash() => r'bace9a40a037e5b43523a73c5fe9b66b1942a71e';

/// Provider pour récupérer un rôle par ID
///
/// Copied from [roleById].
@ProviderFor(roleById)
const roleByIdProvider = RoleByIdFamily();

/// Provider pour récupérer un rôle par ID
///
/// Copied from [roleById].
class RoleByIdFamily extends Family<AsyncValue<ChurchRole?>> {
  /// Provider pour récupérer un rôle par ID
  ///
  /// Copied from [roleById].
  const RoleByIdFamily();

  /// Provider pour récupérer un rôle par ID
  ///
  /// Copied from [roleById].
  RoleByIdProvider call(
    String roleId,
  ) {
    return RoleByIdProvider(
      roleId,
    );
  }

  @override
  RoleByIdProvider getProviderOverride(
    covariant RoleByIdProvider provider,
  ) {
    return call(
      provider.roleId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'roleByIdProvider';
}

/// Provider pour récupérer un rôle par ID
///
/// Copied from [roleById].
class RoleByIdProvider extends AutoDisposeFutureProvider<ChurchRole?> {
  /// Provider pour récupérer un rôle par ID
  ///
  /// Copied from [roleById].
  RoleByIdProvider(
    String roleId,
  ) : this._internal(
          (ref) => roleById(
            ref as RoleByIdRef,
            roleId,
          ),
          from: roleByIdProvider,
          name: r'roleByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$roleByIdHash,
          dependencies: RoleByIdFamily._dependencies,
          allTransitiveDependencies: RoleByIdFamily._allTransitiveDependencies,
          roleId: roleId,
        );

  RoleByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.roleId,
  }) : super.internal();

  final String roleId;

  @override
  Override overrideWith(
    FutureOr<ChurchRole?> Function(RoleByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RoleByIdProvider._internal(
        (ref) => create(ref as RoleByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        roleId: roleId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ChurchRole?> createElement() {
    return _RoleByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RoleByIdProvider && other.roleId == roleId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roleId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RoleByIdRef on AutoDisposeFutureProviderRef<ChurchRole?> {
  /// The parameter `roleId` of this provider.
  String get roleId;
}

class _RoleByIdProviderElement
    extends AutoDisposeFutureProviderElement<ChurchRole?> with RoleByIdRef {
  _RoleByIdProviderElement(super.provider);

  @override
  String get roleId => (origin as RoleByIdProvider).roleId;
}

String _$userRoleHash() => r'2969e0c72592ff69834d1458acb3b6c663e8e694';

/// Provider pour récupérer le rôle d'un utilisateur
///
/// Copied from [userRole].
@ProviderFor(userRole)
const userRoleProvider = UserRoleFamily();

/// Provider pour récupérer le rôle d'un utilisateur
///
/// Copied from [userRole].
class UserRoleFamily extends Family<AsyncValue<ChurchRole?>> {
  /// Provider pour récupérer le rôle d'un utilisateur
  ///
  /// Copied from [userRole].
  const UserRoleFamily();

  /// Provider pour récupérer le rôle d'un utilisateur
  ///
  /// Copied from [userRole].
  UserRoleProvider call({
    required String userId,
    required String churchId,
  }) {
    return UserRoleProvider(
      userId: userId,
      churchId: churchId,
    );
  }

  @override
  UserRoleProvider getProviderOverride(
    covariant UserRoleProvider provider,
  ) {
    return call(
      userId: provider.userId,
      churchId: provider.churchId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userRoleProvider';
}

/// Provider pour récupérer le rôle d'un utilisateur
///
/// Copied from [userRole].
class UserRoleProvider extends AutoDisposeFutureProvider<ChurchRole?> {
  /// Provider pour récupérer le rôle d'un utilisateur
  ///
  /// Copied from [userRole].
  UserRoleProvider({
    required String userId,
    required String churchId,
  }) : this._internal(
          (ref) => userRole(
            ref as UserRoleRef,
            userId: userId,
            churchId: churchId,
          ),
          from: userRoleProvider,
          name: r'userRoleProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userRoleHash,
          dependencies: UserRoleFamily._dependencies,
          allTransitiveDependencies: UserRoleFamily._allTransitiveDependencies,
          userId: userId,
          churchId: churchId,
        );

  UserRoleProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.churchId,
  }) : super.internal();

  final String userId;
  final String churchId;

  @override
  Override overrideWith(
    FutureOr<ChurchRole?> Function(UserRoleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserRoleProvider._internal(
        (ref) => create(ref as UserRoleRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
        churchId: churchId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ChurchRole?> createElement() {
    return _UserRoleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserRoleProvider &&
        other.userId == userId &&
        other.churchId == churchId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, churchId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserRoleRef on AutoDisposeFutureProviderRef<ChurchRole?> {
  /// The parameter `userId` of this provider.
  String get userId;

  /// The parameter `churchId` of this provider.
  String get churchId;
}

class _UserRoleProviderElement
    extends AutoDisposeFutureProviderElement<ChurchRole?> with UserRoleRef {
  _UserRoleProviderElement(super.provider);

  @override
  String get userId => (origin as UserRoleProvider).userId;
  @override
  String get churchId => (origin as UserRoleProvider).churchId;
}

String _$allPermissionsHash() => r'6c1b4a343726518c7bd6ca515624424a2cb00b89';

/// Provider pour récupérer toutes les permissions
///
/// Copied from [allPermissions].
@ProviderFor(allPermissions)
final allPermissionsProvider = AutoDisposeProvider<List<Permission>>.internal(
  allPermissions,
  name: r'allPermissionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allPermissionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllPermissionsRef = AutoDisposeProviderRef<List<Permission>>;
String _$permissionsByModuleHash() =>
    r'e63e2e543ef3d8a182142e9d1ae7260e4253d0de';

/// Provider pour récupérer les permissions groupées par module
///
/// Copied from [permissionsByModule].
@ProviderFor(permissionsByModule)
final permissionsByModuleProvider =
    AutoDisposeProvider<Map<String, List<Permission>>>.internal(
  permissionsByModule,
  name: r'permissionsByModuleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$permissionsByModuleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PermissionsByModuleRef
    = AutoDisposeProviderRef<Map<String, List<Permission>>>;
String _$watchRolesHash() => r'd5e284bff22dc6e21ba4db3b4405168913aec1ec';

/// Stream de tous les rôles d'une église
///
/// Copied from [watchRoles].
@ProviderFor(watchRoles)
const watchRolesProvider = WatchRolesFamily();

/// Stream de tous les rôles d'une église
///
/// Copied from [watchRoles].
class WatchRolesFamily extends Family<AsyncValue<List<ChurchRole>>> {
  /// Stream de tous les rôles d'une église
  ///
  /// Copied from [watchRoles].
  const WatchRolesFamily();

  /// Stream de tous les rôles d'une église
  ///
  /// Copied from [watchRoles].
  WatchRolesProvider call({
    required String churchId,
  }) {
    return WatchRolesProvider(
      churchId: churchId,
    );
  }

  @override
  WatchRolesProvider getProviderOverride(
    covariant WatchRolesProvider provider,
  ) {
    return call(
      churchId: provider.churchId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'watchRolesProvider';
}

/// Stream de tous les rôles d'une église
///
/// Copied from [watchRoles].
class WatchRolesProvider extends AutoDisposeStreamProvider<List<ChurchRole>> {
  /// Stream de tous les rôles d'une église
  ///
  /// Copied from [watchRoles].
  WatchRolesProvider({
    required String churchId,
  }) : this._internal(
          (ref) => watchRoles(
            ref as WatchRolesRef,
            churchId: churchId,
          ),
          from: watchRolesProvider,
          name: r'watchRolesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$watchRolesHash,
          dependencies: WatchRolesFamily._dependencies,
          allTransitiveDependencies:
              WatchRolesFamily._allTransitiveDependencies,
          churchId: churchId,
        );

  WatchRolesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.churchId,
  }) : super.internal();

  final String churchId;

  @override
  Override overrideWith(
    Stream<List<ChurchRole>> Function(WatchRolesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WatchRolesProvider._internal(
        (ref) => create(ref as WatchRolesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        churchId: churchId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<ChurchRole>> createElement() {
    return _WatchRolesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchRolesProvider && other.churchId == churchId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, churchId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WatchRolesRef on AutoDisposeStreamProviderRef<List<ChurchRole>> {
  /// The parameter `churchId` of this provider.
  String get churchId;
}

class _WatchRolesProviderElement
    extends AutoDisposeStreamProviderElement<List<ChurchRole>>
    with WatchRolesRef {
  _WatchRolesProviderElement(super.provider);

  @override
  String get churchId => (origin as WatchRolesProvider).churchId;
}

String _$watchRoleHash() => r'd7890e2ce45337b6f814065689f4ea3508bde237';

/// Stream d'un rôle spécifique
///
/// Copied from [watchRole].
@ProviderFor(watchRole)
const watchRoleProvider = WatchRoleFamily();

/// Stream d'un rôle spécifique
///
/// Copied from [watchRole].
class WatchRoleFamily extends Family<AsyncValue<ChurchRole?>> {
  /// Stream d'un rôle spécifique
  ///
  /// Copied from [watchRole].
  const WatchRoleFamily();

  /// Stream d'un rôle spécifique
  ///
  /// Copied from [watchRole].
  WatchRoleProvider call(
    String roleId,
  ) {
    return WatchRoleProvider(
      roleId,
    );
  }

  @override
  WatchRoleProvider getProviderOverride(
    covariant WatchRoleProvider provider,
  ) {
    return call(
      provider.roleId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'watchRoleProvider';
}

/// Stream d'un rôle spécifique
///
/// Copied from [watchRole].
class WatchRoleProvider extends AutoDisposeStreamProvider<ChurchRole?> {
  /// Stream d'un rôle spécifique
  ///
  /// Copied from [watchRole].
  WatchRoleProvider(
    String roleId,
  ) : this._internal(
          (ref) => watchRole(
            ref as WatchRoleRef,
            roleId,
          ),
          from: watchRoleProvider,
          name: r'watchRoleProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$watchRoleHash,
          dependencies: WatchRoleFamily._dependencies,
          allTransitiveDependencies: WatchRoleFamily._allTransitiveDependencies,
          roleId: roleId,
        );

  WatchRoleProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.roleId,
  }) : super.internal();

  final String roleId;

  @override
  Override overrideWith(
    Stream<ChurchRole?> Function(WatchRoleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WatchRoleProvider._internal(
        (ref) => create(ref as WatchRoleRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        roleId: roleId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<ChurchRole?> createElement() {
    return _WatchRoleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchRoleProvider && other.roleId == roleId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roleId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WatchRoleRef on AutoDisposeStreamProviderRef<ChurchRole?> {
  /// The parameter `roleId` of this provider.
  String get roleId;
}

class _WatchRoleProviderElement
    extends AutoDisposeStreamProviderElement<ChurchRole?> with WatchRoleRef {
  _WatchRoleProviderElement(super.provider);

  @override
  String get roleId => (origin as WatchRoleProvider).roleId;
}

String _$roleActionsHash() => r'1dd66aeb61cd7a80c9350f82b457850572d26dc4';

/// Provider pour accéder aux actions sur les rôles
///
/// Copied from [roleActions].
@ProviderFor(roleActions)
final roleActionsProvider = AutoDisposeProvider<RoleActions>.internal(
  roleActions,
  name: r'roleActionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$roleActionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RoleActionsRef = AutoDisposeProviderRef<RoleActions>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

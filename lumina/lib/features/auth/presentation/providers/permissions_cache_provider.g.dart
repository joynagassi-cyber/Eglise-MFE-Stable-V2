// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permissions_cache_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hasPermissionCachedHash() =>
    r'2d88ccc22bfbc8b534e4066e8f516b7030b0d06a';

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

/// Provider simplifié pour vérifier une permission
///
/// Copied from [hasPermissionCached].
@ProviderFor(hasPermissionCached)
const hasPermissionCachedProvider = HasPermissionCachedFamily();

/// Provider simplifié pour vérifier une permission
///
/// Copied from [hasPermissionCached].
class HasPermissionCachedFamily extends Family<bool> {
  /// Provider simplifié pour vérifier une permission
  ///
  /// Copied from [hasPermissionCached].
  const HasPermissionCachedFamily();

  /// Provider simplifié pour vérifier une permission
  ///
  /// Copied from [hasPermissionCached].
  HasPermissionCachedProvider call(
    Permission permission,
  ) {
    return HasPermissionCachedProvider(
      permission,
    );
  }

  @override
  HasPermissionCachedProvider getProviderOverride(
    covariant HasPermissionCachedProvider provider,
  ) {
    return call(
      provider.permission,
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
  String? get name => r'hasPermissionCachedProvider';
}

/// Provider simplifié pour vérifier une permission
///
/// Copied from [hasPermissionCached].
class HasPermissionCachedProvider extends AutoDisposeProvider<bool> {
  /// Provider simplifié pour vérifier une permission
  ///
  /// Copied from [hasPermissionCached].
  HasPermissionCachedProvider(
    Permission permission,
  ) : this._internal(
          (ref) => hasPermissionCached(
            ref as HasPermissionCachedRef,
            permission,
          ),
          from: hasPermissionCachedProvider,
          name: r'hasPermissionCachedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hasPermissionCachedHash,
          dependencies: HasPermissionCachedFamily._dependencies,
          allTransitiveDependencies:
              HasPermissionCachedFamily._allTransitiveDependencies,
          permission: permission,
        );

  HasPermissionCachedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.permission,
  }) : super.internal();

  final Permission permission;

  @override
  Override overrideWith(
    bool Function(HasPermissionCachedRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HasPermissionCachedProvider._internal(
        (ref) => create(ref as HasPermissionCachedRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        permission: permission,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _HasPermissionCachedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HasPermissionCachedProvider &&
        other.permission == permission;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, permission.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin HasPermissionCachedRef on AutoDisposeProviderRef<bool> {
  /// The parameter `permission` of this provider.
  Permission get permission;
}

class _HasPermissionCachedProviderElement
    extends AutoDisposeProviderElement<bool> with HasPermissionCachedRef {
  _HasPermissionCachedProviderElement(super.provider);

  @override
  Permission get permission =>
      (origin as HasPermissionCachedProvider).permission;
}

String _$hasAllPermissionsCachedHash() =>
    r'45ae390986413e8adf965f73c02eef480915f68c';

/// Provider pour vérifier plusieurs permissions (toutes requises)
///
/// Copied from [hasAllPermissionsCached].
@ProviderFor(hasAllPermissionsCached)
const hasAllPermissionsCachedProvider = HasAllPermissionsCachedFamily();

/// Provider pour vérifier plusieurs permissions (toutes requises)
///
/// Copied from [hasAllPermissionsCached].
class HasAllPermissionsCachedFamily extends Family<bool> {
  /// Provider pour vérifier plusieurs permissions (toutes requises)
  ///
  /// Copied from [hasAllPermissionsCached].
  const HasAllPermissionsCachedFamily();

  /// Provider pour vérifier plusieurs permissions (toutes requises)
  ///
  /// Copied from [hasAllPermissionsCached].
  HasAllPermissionsCachedProvider call(
    Set<Permission> permissions,
  ) {
    return HasAllPermissionsCachedProvider(
      permissions,
    );
  }

  @override
  HasAllPermissionsCachedProvider getProviderOverride(
    covariant HasAllPermissionsCachedProvider provider,
  ) {
    return call(
      provider.permissions,
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
  String? get name => r'hasAllPermissionsCachedProvider';
}

/// Provider pour vérifier plusieurs permissions (toutes requises)
///
/// Copied from [hasAllPermissionsCached].
class HasAllPermissionsCachedProvider extends AutoDisposeProvider<bool> {
  /// Provider pour vérifier plusieurs permissions (toutes requises)
  ///
  /// Copied from [hasAllPermissionsCached].
  HasAllPermissionsCachedProvider(
    Set<Permission> permissions,
  ) : this._internal(
          (ref) => hasAllPermissionsCached(
            ref as HasAllPermissionsCachedRef,
            permissions,
          ),
          from: hasAllPermissionsCachedProvider,
          name: r'hasAllPermissionsCachedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hasAllPermissionsCachedHash,
          dependencies: HasAllPermissionsCachedFamily._dependencies,
          allTransitiveDependencies:
              HasAllPermissionsCachedFamily._allTransitiveDependencies,
          permissions: permissions,
        );

  HasAllPermissionsCachedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.permissions,
  }) : super.internal();

  final Set<Permission> permissions;

  @override
  Override overrideWith(
    bool Function(HasAllPermissionsCachedRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HasAllPermissionsCachedProvider._internal(
        (ref) => create(ref as HasAllPermissionsCachedRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        permissions: permissions,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _HasAllPermissionsCachedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HasAllPermissionsCachedProvider &&
        other.permissions == permissions;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, permissions.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin HasAllPermissionsCachedRef on AutoDisposeProviderRef<bool> {
  /// The parameter `permissions` of this provider.
  Set<Permission> get permissions;
}

class _HasAllPermissionsCachedProviderElement
    extends AutoDisposeProviderElement<bool> with HasAllPermissionsCachedRef {
  _HasAllPermissionsCachedProviderElement(super.provider);

  @override
  Set<Permission> get permissions =>
      (origin as HasAllPermissionsCachedProvider).permissions;
}

String _$hasAnyPermissionCachedHash() =>
    r'b489b5f9e26bb90d07d64375ffd787542df7fbdb';

/// Provider pour vérifier plusieurs permissions (au moins une)
///
/// Copied from [hasAnyPermissionCached].
@ProviderFor(hasAnyPermissionCached)
const hasAnyPermissionCachedProvider = HasAnyPermissionCachedFamily();

/// Provider pour vérifier plusieurs permissions (au moins une)
///
/// Copied from [hasAnyPermissionCached].
class HasAnyPermissionCachedFamily extends Family<bool> {
  /// Provider pour vérifier plusieurs permissions (au moins une)
  ///
  /// Copied from [hasAnyPermissionCached].
  const HasAnyPermissionCachedFamily();

  /// Provider pour vérifier plusieurs permissions (au moins une)
  ///
  /// Copied from [hasAnyPermissionCached].
  HasAnyPermissionCachedProvider call(
    Set<Permission> permissions,
  ) {
    return HasAnyPermissionCachedProvider(
      permissions,
    );
  }

  @override
  HasAnyPermissionCachedProvider getProviderOverride(
    covariant HasAnyPermissionCachedProvider provider,
  ) {
    return call(
      provider.permissions,
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
  String? get name => r'hasAnyPermissionCachedProvider';
}

/// Provider pour vérifier plusieurs permissions (au moins une)
///
/// Copied from [hasAnyPermissionCached].
class HasAnyPermissionCachedProvider extends AutoDisposeProvider<bool> {
  /// Provider pour vérifier plusieurs permissions (au moins une)
  ///
  /// Copied from [hasAnyPermissionCached].
  HasAnyPermissionCachedProvider(
    Set<Permission> permissions,
  ) : this._internal(
          (ref) => hasAnyPermissionCached(
            ref as HasAnyPermissionCachedRef,
            permissions,
          ),
          from: hasAnyPermissionCachedProvider,
          name: r'hasAnyPermissionCachedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hasAnyPermissionCachedHash,
          dependencies: HasAnyPermissionCachedFamily._dependencies,
          allTransitiveDependencies:
              HasAnyPermissionCachedFamily._allTransitiveDependencies,
          permissions: permissions,
        );

  HasAnyPermissionCachedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.permissions,
  }) : super.internal();

  final Set<Permission> permissions;

  @override
  Override overrideWith(
    bool Function(HasAnyPermissionCachedRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HasAnyPermissionCachedProvider._internal(
        (ref) => create(ref as HasAnyPermissionCachedRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        permissions: permissions,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _HasAnyPermissionCachedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HasAnyPermissionCachedProvider &&
        other.permissions == permissions;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, permissions.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin HasAnyPermissionCachedRef on AutoDisposeProviderRef<bool> {
  /// The parameter `permissions` of this provider.
  Set<Permission> get permissions;
}

class _HasAnyPermissionCachedProviderElement
    extends AutoDisposeProviderElement<bool> with HasAnyPermissionCachedRef {
  _HasAnyPermissionCachedProviderElement(super.provider);

  @override
  Set<Permission> get permissions =>
      (origin as HasAnyPermissionCachedProvider).permissions;
}

String _$permissionsCacheHash() => r'36569722a41e9e6304b9099cb616ef0b95cc6084';

/// Cache des permissions utilisateur pour éviter recalculs
///
/// Recalculé uniquement quand la session change
///
/// Copied from [PermissionsCache].
@ProviderFor(PermissionsCache)
final permissionsCacheProvider = AutoDisposeNotifierProvider<PermissionsCache,
    Map<Permission, bool>>.internal(
  PermissionsCache.new,
  name: r'permissionsCacheProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$permissionsCacheHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PermissionsCache = AutoDisposeNotifier<Map<Permission, bool>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

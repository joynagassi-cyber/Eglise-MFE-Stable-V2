// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_control_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$canAccessModuleHash() => r'ca5336fe9dea58d789af7abd2277ebe4041feaf7';

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

/// Provider pour vérifier l'accès à un module
///
/// Copied from [canAccessModule].
@ProviderFor(canAccessModule)
const canAccessModuleProvider = CanAccessModuleFamily();

/// Provider pour vérifier l'accès à un module
///
/// Copied from [canAccessModule].
class CanAccessModuleFamily extends Family<bool> {
  /// Provider pour vérifier l'accès à un module
  ///
  /// Copied from [canAccessModule].
  const CanAccessModuleFamily();

  /// Provider pour vérifier l'accès à un module
  ///
  /// Copied from [canAccessModule].
  CanAccessModuleProvider call(
    String moduleId,
  ) {
    return CanAccessModuleProvider(
      moduleId,
    );
  }

  @override
  CanAccessModuleProvider getProviderOverride(
    covariant CanAccessModuleProvider provider,
  ) {
    return call(
      provider.moduleId,
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
  String? get name => r'canAccessModuleProvider';
}

/// Provider pour vérifier l'accès à un module
///
/// Copied from [canAccessModule].
class CanAccessModuleProvider extends AutoDisposeProvider<bool> {
  /// Provider pour vérifier l'accès à un module
  ///
  /// Copied from [canAccessModule].
  CanAccessModuleProvider(
    String moduleId,
  ) : this._internal(
          (ref) => canAccessModule(
            ref as CanAccessModuleRef,
            moduleId,
          ),
          from: canAccessModuleProvider,
          name: r'canAccessModuleProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$canAccessModuleHash,
          dependencies: CanAccessModuleFamily._dependencies,
          allTransitiveDependencies:
              CanAccessModuleFamily._allTransitiveDependencies,
          moduleId: moduleId,
        );

  CanAccessModuleProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.moduleId,
  }) : super.internal();

  final String moduleId;

  @override
  Override overrideWith(
    bool Function(CanAccessModuleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CanAccessModuleProvider._internal(
        (ref) => create(ref as CanAccessModuleRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        moduleId: moduleId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _CanAccessModuleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CanAccessModuleProvider && other.moduleId == moduleId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, moduleId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CanAccessModuleRef on AutoDisposeProviderRef<bool> {
  /// The parameter `moduleId` of this provider.
  String get moduleId;
}

class _CanAccessModuleProviderElement extends AutoDisposeProviderElement<bool>
    with CanAccessModuleRef {
  _CanAccessModuleProviderElement(super.provider);

  @override
  String get moduleId => (origin as CanAccessModuleProvider).moduleId;
}

String _$hasPermissionAccessHash() =>
    r'302507f3e587c4ed81fbde1dfa91b469c21fb114';

/// Provider pour vérifier une permission
///
/// Copied from [hasPermissionAccess].
@ProviderFor(hasPermissionAccess)
const hasPermissionAccessProvider = HasPermissionAccessFamily();

/// Provider pour vérifier une permission
///
/// Copied from [hasPermissionAccess].
class HasPermissionAccessFamily extends Family<bool> {
  /// Provider pour vérifier une permission
  ///
  /// Copied from [hasPermissionAccess].
  const HasPermissionAccessFamily();

  /// Provider pour vérifier une permission
  ///
  /// Copied from [hasPermissionAccess].
  HasPermissionAccessProvider call(
    Permission permission,
  ) {
    return HasPermissionAccessProvider(
      permission,
    );
  }

  @override
  HasPermissionAccessProvider getProviderOverride(
    covariant HasPermissionAccessProvider provider,
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
  String? get name => r'hasPermissionAccessProvider';
}

/// Provider pour vérifier une permission
///
/// Copied from [hasPermissionAccess].
class HasPermissionAccessProvider extends AutoDisposeProvider<bool> {
  /// Provider pour vérifier une permission
  ///
  /// Copied from [hasPermissionAccess].
  HasPermissionAccessProvider(
    Permission permission,
  ) : this._internal(
          (ref) => hasPermissionAccess(
            ref as HasPermissionAccessRef,
            permission,
          ),
          from: hasPermissionAccessProvider,
          name: r'hasPermissionAccessProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hasPermissionAccessHash,
          dependencies: HasPermissionAccessFamily._dependencies,
          allTransitiveDependencies:
              HasPermissionAccessFamily._allTransitiveDependencies,
          permission: permission,
        );

  HasPermissionAccessProvider._internal(
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
    bool Function(HasPermissionAccessRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HasPermissionAccessProvider._internal(
        (ref) => create(ref as HasPermissionAccessRef),
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
    return _HasPermissionAccessProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HasPermissionAccessProvider &&
        other.permission == permission;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, permission.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin HasPermissionAccessRef on AutoDisposeProviderRef<bool> {
  /// The parameter `permission` of this provider.
  Permission get permission;
}

class _HasPermissionAccessProviderElement
    extends AutoDisposeProviderElement<bool> with HasPermissionAccessRef {
  _HasPermissionAccessProviderElement(super.provider);

  @override
  Permission get permission =>
      (origin as HasPermissionAccessProvider).permission;
}

String _$accessControlServiceHash() =>
    r'7b2a01894a01f98ec3c9c0082e248e91bce3663f';

/// Service de contrôle d'accès pour implémenter les 3 règles
///
/// Copied from [AccessControlService].
@ProviderFor(AccessControlService)
final accessControlServiceProvider = AutoDisposeAsyncNotifierProvider<
    AccessControlService, AccessControlState>.internal(
  AccessControlService.new,
  name: r'accessControlServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accessControlServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AccessControlService = AutoDisposeAsyncNotifier<AccessControlState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

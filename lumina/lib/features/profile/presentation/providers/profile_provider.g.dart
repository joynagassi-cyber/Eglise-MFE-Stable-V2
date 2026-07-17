// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileStateHash() => r'ef632e4c23b47a66277a34f8d3b8c7661377cbca';

/// See also [profileState].
@ProviderFor(profileState)
final profileStateProvider = AutoDisposeStreamProvider<Profile?>.internal(
  profileState,
  name: r'profileStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$profileStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProfileStateRef = AutoDisposeStreamProviderRef<Profile?>;
String _$localProfileFutureHash() =>
    r'2e644a28838f4300862d6473deac47ebbf5e4d55';

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

/// Preloads local profile for offline-first behavior.
///
/// Copied from [localProfileFuture].
@ProviderFor(localProfileFuture)
const localProfileFutureProvider = LocalProfileFutureFamily();

/// Preloads local profile for offline-first behavior.
///
/// Copied from [localProfileFuture].
class LocalProfileFutureFamily extends Family<AsyncValue<Profile?>> {
  /// Preloads local profile for offline-first behavior.
  ///
  /// Copied from [localProfileFuture].
  const LocalProfileFutureFamily();

  /// Preloads local profile for offline-first behavior.
  ///
  /// Copied from [localProfileFuture].
  LocalProfileFutureProvider call(
    String userId,
  ) {
    return LocalProfileFutureProvider(
      userId,
    );
  }

  @override
  LocalProfileFutureProvider getProviderOverride(
    covariant LocalProfileFutureProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'localProfileFutureProvider';
}

/// Preloads local profile for offline-first behavior.
///
/// Copied from [localProfileFuture].
class LocalProfileFutureProvider extends AutoDisposeFutureProvider<Profile?> {
  /// Preloads local profile for offline-first behavior.
  ///
  /// Copied from [localProfileFuture].
  LocalProfileFutureProvider(
    String userId,
  ) : this._internal(
          (ref) => localProfileFuture(
            ref as LocalProfileFutureRef,
            userId,
          ),
          from: localProfileFutureProvider,
          name: r'localProfileFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$localProfileFutureHash,
          dependencies: LocalProfileFutureFamily._dependencies,
          allTransitiveDependencies:
              LocalProfileFutureFamily._allTransitiveDependencies,
          userId: userId,
        );

  LocalProfileFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<Profile?> Function(LocalProfileFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LocalProfileFutureProvider._internal(
        (ref) => create(ref as LocalProfileFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Profile?> createElement() {
    return _LocalProfileFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LocalProfileFutureProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LocalProfileFutureRef on AutoDisposeFutureProviderRef<Profile?> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _LocalProfileFutureProviderElement
    extends AutoDisposeFutureProviderElement<Profile?>
    with LocalProfileFutureRef {
  _LocalProfileFutureProviderElement(super.provider);

  @override
  String get userId => (origin as LocalProfileFutureProvider).userId;
}

String _$otherUserProfileHash() => r'd250b12771425cc99251d1e17b93046f55165931';

/// See also [otherUserProfile].
@ProviderFor(otherUserProfile)
const otherUserProfileProvider = OtherUserProfileFamily();

/// See also [otherUserProfile].
class OtherUserProfileFamily extends Family<AsyncValue<Profile?>> {
  /// See also [otherUserProfile].
  const OtherUserProfileFamily();

  /// See also [otherUserProfile].
  OtherUserProfileProvider call(
    String userId,
  ) {
    return OtherUserProfileProvider(
      userId,
    );
  }

  @override
  OtherUserProfileProvider getProviderOverride(
    covariant OtherUserProfileProvider provider,
  ) {
    return call(
      provider.userId,
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
  String? get name => r'otherUserProfileProvider';
}

/// See also [otherUserProfile].
class OtherUserProfileProvider extends AutoDisposeFutureProvider<Profile?> {
  /// See also [otherUserProfile].
  OtherUserProfileProvider(
    String userId,
  ) : this._internal(
          (ref) => otherUserProfile(
            ref as OtherUserProfileRef,
            userId,
          ),
          from: otherUserProfileProvider,
          name: r'otherUserProfileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$otherUserProfileHash,
          dependencies: OtherUserProfileFamily._dependencies,
          allTransitiveDependencies:
              OtherUserProfileFamily._allTransitiveDependencies,
          userId: userId,
        );

  OtherUserProfileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<Profile?> Function(OtherUserProfileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OtherUserProfileProvider._internal(
        (ref) => create(ref as OtherUserProfileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Profile?> createElement() {
    return _OtherUserProfileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OtherUserProfileProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin OtherUserProfileRef on AutoDisposeFutureProviderRef<Profile?> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _OtherUserProfileProviderElement
    extends AutoDisposeFutureProviderElement<Profile?>
    with OtherUserProfileRef {
  _OtherUserProfileProviderElement(super.provider);

  @override
  String get userId => (origin as OtherUserProfileProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

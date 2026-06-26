// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shepherd_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shepherdListHash() => r'08619c8e625a8bc11da23cd26184fca37a9caf36';

/// See also [shepherdList].
@ProviderFor(shepherdList)
final shepherdListProvider = AutoDisposeFutureProvider<List<Shepherd>>.internal(
  shepherdList,
  name: r'shepherdListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$shepherdListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ShepherdListRef = AutoDisposeFutureProviderRef<List<Shepherd>>;
String _$currentShepherdHash() => r'3fa4a76b9ce809ef15108d4386813e4e96518ae6';

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

/// See also [currentShepherd].
@ProviderFor(currentShepherd)
const currentShepherdProvider = CurrentShepherdFamily();

/// See also [currentShepherd].
class CurrentShepherdFamily extends Family<AsyncValue<Shepherd?>> {
  /// See also [currentShepherd].
  const CurrentShepherdFamily();

  /// See also [currentShepherd].
  CurrentShepherdProvider call(
    String id,
  ) {
    return CurrentShepherdProvider(
      id,
    );
  }

  @override
  CurrentShepherdProvider getProviderOverride(
    covariant CurrentShepherdProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'currentShepherdProvider';
}

/// See also [currentShepherd].
class CurrentShepherdProvider extends AutoDisposeFutureProvider<Shepherd?> {
  /// See also [currentShepherd].
  CurrentShepherdProvider(
    String id,
  ) : this._internal(
          (ref) => currentShepherd(
            ref as CurrentShepherdRef,
            id,
          ),
          from: currentShepherdProvider,
          name: r'currentShepherdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$currentShepherdHash,
          dependencies: CurrentShepherdFamily._dependencies,
          allTransitiveDependencies:
              CurrentShepherdFamily._allTransitiveDependencies,
          id: id,
        );

  CurrentShepherdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Shepherd?> Function(CurrentShepherdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CurrentShepherdProvider._internal(
        (ref) => create(ref as CurrentShepherdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Shepherd?> createElement() {
    return _CurrentShepherdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentShepherdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CurrentShepherdRef on AutoDisposeFutureProviderRef<Shepherd?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _CurrentShepherdProviderElement
    extends AutoDisposeFutureProviderElement<Shepherd?>
    with CurrentShepherdRef {
  _CurrentShepherdProviderElement(super.provider);

  @override
  String get id => (origin as CurrentShepherdProvider).id;
}

String _$teamListHash() => r'9804761d70d26fa5ecd5288e4627a0cb75c9da1b';

/// See also [teamList].
@ProviderFor(teamList)
final teamListProvider = AutoDisposeFutureProvider<List<Shepherd>>.internal(
  teamList,
  name: r'teamListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$teamListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TeamListRef = AutoDisposeFutureProviderRef<List<Shepherd>>;
String _$pastoralVisitsHash() => r'3cd996134fa70501154a83d0aff730ed15d13483';

/// See also [pastoralVisits].
@ProviderFor(pastoralVisits)
const pastoralVisitsProvider = PastoralVisitsFamily();

/// See also [pastoralVisits].
class PastoralVisitsFamily extends Family<AsyncValue<List<PastoralVisit>>> {
  /// See also [pastoralVisits].
  const PastoralVisitsFamily();

  /// See also [pastoralVisits].
  PastoralVisitsProvider call({
    String? shepherdId,
  }) {
    return PastoralVisitsProvider(
      shepherdId: shepherdId,
    );
  }

  @override
  PastoralVisitsProvider getProviderOverride(
    covariant PastoralVisitsProvider provider,
  ) {
    return call(
      shepherdId: provider.shepherdId,
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
  String? get name => r'pastoralVisitsProvider';
}

/// See also [pastoralVisits].
class PastoralVisitsProvider
    extends AutoDisposeFutureProvider<List<PastoralVisit>> {
  /// See also [pastoralVisits].
  PastoralVisitsProvider({
    String? shepherdId,
  }) : this._internal(
          (ref) => pastoralVisits(
            ref as PastoralVisitsRef,
            shepherdId: shepherdId,
          ),
          from: pastoralVisitsProvider,
          name: r'pastoralVisitsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pastoralVisitsHash,
          dependencies: PastoralVisitsFamily._dependencies,
          allTransitiveDependencies:
              PastoralVisitsFamily._allTransitiveDependencies,
          shepherdId: shepherdId,
        );

  PastoralVisitsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.shepherdId,
  }) : super.internal();

  final String? shepherdId;

  @override
  Override overrideWith(
    FutureOr<List<PastoralVisit>> Function(PastoralVisitsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PastoralVisitsProvider._internal(
        (ref) => create(ref as PastoralVisitsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        shepherdId: shepherdId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PastoralVisit>> createElement() {
    return _PastoralVisitsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PastoralVisitsProvider && other.shepherdId == shepherdId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, shepherdId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PastoralVisitsRef on AutoDisposeFutureProviderRef<List<PastoralVisit>> {
  /// The parameter `shepherdId` of this provider.
  String? get shepherdId;
}

class _PastoralVisitsProviderElement
    extends AutoDisposeFutureProviderElement<List<PastoralVisit>>
    with PastoralVisitsRef {
  _PastoralVisitsProviderElement(super.provider);

  @override
  String? get shepherdId => (origin as PastoralVisitsProvider).shepherdId;
}

String _$shepherdControllerHash() =>
    r'f12ffcb3f2e30b85fd55ea8222e10254beee5254';

/// See also [ShepherdController].
@ProviderFor(ShepherdController)
final shepherdControllerProvider =
    AutoDisposeAsyncNotifierProvider<ShepherdController, void>.internal(
  ShepherdController.new,
  name: r'shepherdControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shepherdControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ShepherdController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

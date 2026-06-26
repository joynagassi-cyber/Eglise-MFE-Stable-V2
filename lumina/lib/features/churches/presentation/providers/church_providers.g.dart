// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$churchRepositoryHash() => r'02c0f3f76557dab1c59589b5c477d9fa8e5fde32';

/// Provider du repository d'églises
///
/// Copied from [churchRepository].
@ProviderFor(churchRepository)
final churchRepositoryProvider =
    AutoDisposeFutureProvider<ChurchRepository>.internal(
  churchRepository,
  name: r'churchRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$churchRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ChurchRepositoryRef = AutoDisposeFutureProviderRef<ChurchRepository>;
String _$userChurchesHash() => r'3104417d37d3c38c02868c09730db9e0a2d08147';

/// Provider des églises accessibles par l'utilisateur connecté
///
/// Copied from [userChurches].
@ProviderFor(userChurches)
final userChurchesProvider = AutoDisposeFutureProvider<List<Church>>.internal(
  userChurches,
  name: r'userChurchesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userChurchesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserChurchesRef = AutoDisposeFutureProviderRef<List<Church>>;
String _$watchUserChurchesHash() => r'c4e57e2870df6d9973f8b6708e5583b1ab8a87d9';

/// Stream des églises de l'utilisateur (temps réel)
///
/// Copied from [watchUserChurches].
@ProviderFor(watchUserChurches)
final watchUserChurchesProvider =
    AutoDisposeStreamProvider<List<Church>>.internal(
  watchUserChurches,
  name: r'watchUserChurchesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$watchUserChurchesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WatchUserChurchesRef = AutoDisposeStreamProviderRef<List<Church>>;
String _$activeChurchHash() => r'e8cd6db2cee89422eeb37fa761a91654f1360ddb';

/// Provider de l'église active actuelle
///
/// Récupère l'ID depuis la session active et retourne l'entité Church complète
///
/// Copied from [activeChurch].
@ProviderFor(activeChurch)
final activeChurchProvider = AutoDisposeFutureProvider<Church?>.internal(
  activeChurch,
  name: r'activeChurchProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$activeChurchHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ActiveChurchRef = AutoDisposeFutureProviderRef<Church?>;
String _$watchActiveChurchHash() => r'2f9a95031d1e83c92b07a582906323d6281f20a1';

/// Stream de l'église active (temps réel)
///
/// Copied from [watchActiveChurch].
@ProviderFor(watchActiveChurch)
final watchActiveChurchProvider = AutoDisposeStreamProvider<Church?>.internal(
  watchActiveChurch,
  name: r'watchActiveChurchProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$watchActiveChurchHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WatchActiveChurchRef = AutoDisposeStreamProviderRef<Church?>;
String _$allChurchesHash() => r'11a2929327674750368e1f4ab29640d3903c4727';

/// Provider de toutes les églises (admin usage)
///
/// Copied from [allChurches].
@ProviderFor(allChurches)
final allChurchesProvider = AutoDisposeFutureProvider<List<Church>>.internal(
  allChurches,
  name: r'allChurchesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allChurchesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllChurchesRef = AutoDisposeFutureProviderRef<List<Church>>;
String _$watchAllChurchesHash() => r'584e90c2204372302a7859e5082222881b522885';

/// Stream de toutes les églises
///
/// Copied from [watchAllChurches].
@ProviderFor(watchAllChurches)
final watchAllChurchesProvider =
    AutoDisposeStreamProvider<List<Church>>.internal(
  watchAllChurches,
  name: r'watchAllChurchesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$watchAllChurchesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WatchAllChurchesRef = AutoDisposeStreamProviderRef<List<Church>>;
String _$searchChurchesHash() => r'27ebfa464014aec2d81e7badb5dc6c2eb74f2cb8';

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

/// Provider de recherche d'églises
///
/// Copied from [searchChurches].
@ProviderFor(searchChurches)
const searchChurchesProvider = SearchChurchesFamily();

/// Provider de recherche d'églises
///
/// Copied from [searchChurches].
class SearchChurchesFamily extends Family<AsyncValue<List<Church>>> {
  /// Provider de recherche d'églises
  ///
  /// Copied from [searchChurches].
  const SearchChurchesFamily();

  /// Provider de recherche d'églises
  ///
  /// Copied from [searchChurches].
  SearchChurchesProvider call(
    String query,
  ) {
    return SearchChurchesProvider(
      query,
    );
  }

  @override
  SearchChurchesProvider getProviderOverride(
    covariant SearchChurchesProvider provider,
  ) {
    return call(
      provider.query,
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
  String? get name => r'searchChurchesProvider';
}

/// Provider de recherche d'églises
///
/// Copied from [searchChurches].
class SearchChurchesProvider extends AutoDisposeFutureProvider<List<Church>> {
  /// Provider de recherche d'églises
  ///
  /// Copied from [searchChurches].
  SearchChurchesProvider(
    String query,
  ) : this._internal(
          (ref) => searchChurches(
            ref as SearchChurchesRef,
            query,
          ),
          from: searchChurchesProvider,
          name: r'searchChurchesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchChurchesHash,
          dependencies: SearchChurchesFamily._dependencies,
          allTransitiveDependencies:
              SearchChurchesFamily._allTransitiveDependencies,
          query: query,
        );

  SearchChurchesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<Church>> Function(SearchChurchesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchChurchesProvider._internal(
        (ref) => create(ref as SearchChurchesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Church>> createElement() {
    return _SearchChurchesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchChurchesProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchChurchesRef on AutoDisposeFutureProviderRef<List<Church>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchChurchesProviderElement
    extends AutoDisposeFutureProviderElement<List<Church>>
    with SearchChurchesRef {
  _SearchChurchesProviderElement(super.provider);

  @override
  String get query => (origin as SearchChurchesProvider).query;
}

String _$churchesByTypeHash() => r'3accc2bd157e29a0de85ff2dc40bf234717b5eae';

/// Provider de filtrage par type
///
/// Copied from [churchesByType].
@ProviderFor(churchesByType)
const churchesByTypeProvider = ChurchesByTypeFamily();

/// Provider de filtrage par type
///
/// Copied from [churchesByType].
class ChurchesByTypeFamily extends Family<AsyncValue<List<Church>>> {
  /// Provider de filtrage par type
  ///
  /// Copied from [churchesByType].
  const ChurchesByTypeFamily();

  /// Provider de filtrage par type
  ///
  /// Copied from [churchesByType].
  ChurchesByTypeProvider call(
    ChurchType type,
  ) {
    return ChurchesByTypeProvider(
      type,
    );
  }

  @override
  ChurchesByTypeProvider getProviderOverride(
    covariant ChurchesByTypeProvider provider,
  ) {
    return call(
      provider.type,
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
  String? get name => r'churchesByTypeProvider';
}

/// Provider de filtrage par type
///
/// Copied from [churchesByType].
class ChurchesByTypeProvider extends AutoDisposeFutureProvider<List<Church>> {
  /// Provider de filtrage par type
  ///
  /// Copied from [churchesByType].
  ChurchesByTypeProvider(
    ChurchType type,
  ) : this._internal(
          (ref) => churchesByType(
            ref as ChurchesByTypeRef,
            type,
          ),
          from: churchesByTypeProvider,
          name: r'churchesByTypeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$churchesByTypeHash,
          dependencies: ChurchesByTypeFamily._dependencies,
          allTransitiveDependencies:
              ChurchesByTypeFamily._allTransitiveDependencies,
          type: type,
        );

  ChurchesByTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final ChurchType type;

  @override
  Override overrideWith(
    FutureOr<List<Church>> Function(ChurchesByTypeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChurchesByTypeProvider._internal(
        (ref) => create(ref as ChurchesByTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Church>> createElement() {
    return _ChurchesByTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChurchesByTypeProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChurchesByTypeRef on AutoDisposeFutureProviderRef<List<Church>> {
  /// The parameter `type` of this provider.
  ChurchType get type;
}

class _ChurchesByTypeProviderElement
    extends AutoDisposeFutureProviderElement<List<Church>>
    with ChurchesByTypeRef {
  _ChurchesByTypeProviderElement(super.provider);

  @override
  ChurchType get type => (origin as ChurchesByTypeProvider).type;
}

String _$churchesByCityHash() => r'a90bab0607daf02be79c6ef4e71416972004cab8';

/// Provider de filtrage par ville
///
/// Copied from [churchesByCity].
@ProviderFor(churchesByCity)
const churchesByCityProvider = ChurchesByCityFamily();

/// Provider de filtrage par ville
///
/// Copied from [churchesByCity].
class ChurchesByCityFamily extends Family<AsyncValue<List<Church>>> {
  /// Provider de filtrage par ville
  ///
  /// Copied from [churchesByCity].
  const ChurchesByCityFamily();

  /// Provider de filtrage par ville
  ///
  /// Copied from [churchesByCity].
  ChurchesByCityProvider call(
    String city,
  ) {
    return ChurchesByCityProvider(
      city,
    );
  }

  @override
  ChurchesByCityProvider getProviderOverride(
    covariant ChurchesByCityProvider provider,
  ) {
    return call(
      provider.city,
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
  String? get name => r'churchesByCityProvider';
}

/// Provider de filtrage par ville
///
/// Copied from [churchesByCity].
class ChurchesByCityProvider extends AutoDisposeFutureProvider<List<Church>> {
  /// Provider de filtrage par ville
  ///
  /// Copied from [churchesByCity].
  ChurchesByCityProvider(
    String city,
  ) : this._internal(
          (ref) => churchesByCity(
            ref as ChurchesByCityRef,
            city,
          ),
          from: churchesByCityProvider,
          name: r'churchesByCityProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$churchesByCityHash,
          dependencies: ChurchesByCityFamily._dependencies,
          allTransitiveDependencies:
              ChurchesByCityFamily._allTransitiveDependencies,
          city: city,
        );

  ChurchesByCityProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.city,
  }) : super.internal();

  final String city;

  @override
  Override overrideWith(
    FutureOr<List<Church>> Function(ChurchesByCityRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChurchesByCityProvider._internal(
        (ref) => create(ref as ChurchesByCityRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        city: city,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Church>> createElement() {
    return _ChurchesByCityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChurchesByCityProvider && other.city == city;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, city.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChurchesByCityRef on AutoDisposeFutureProviderRef<List<Church>> {
  /// The parameter `city` of this provider.
  String get city;
}

class _ChurchesByCityProviderElement
    extends AutoDisposeFutureProviderElement<List<Church>>
    with ChurchesByCityRef {
  _ChurchesByCityProviderElement(super.provider);

  @override
  String get city => (origin as ChurchesByCityProvider).city;
}

String _$churchStatsHash() => r'9fd0eb93d180c0497c267c881cb5c7c9c967e0c0';

/// Provider des statistiques d'une église
///
/// Copied from [churchStats].
@ProviderFor(churchStats)
const churchStatsProvider = ChurchStatsFamily();

/// Provider des statistiques d'une église
///
/// Copied from [churchStats].
class ChurchStatsFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// Provider des statistiques d'une église
  ///
  /// Copied from [churchStats].
  const ChurchStatsFamily();

  /// Provider des statistiques d'une église
  ///
  /// Copied from [churchStats].
  ChurchStatsProvider call(
    String churchId,
  ) {
    return ChurchStatsProvider(
      churchId,
    );
  }

  @override
  ChurchStatsProvider getProviderOverride(
    covariant ChurchStatsProvider provider,
  ) {
    return call(
      provider.churchId,
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
  String? get name => r'churchStatsProvider';
}

/// Provider des statistiques d'une église
///
/// Copied from [churchStats].
class ChurchStatsProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// Provider des statistiques d'une église
  ///
  /// Copied from [churchStats].
  ChurchStatsProvider(
    String churchId,
  ) : this._internal(
          (ref) => churchStats(
            ref as ChurchStatsRef,
            churchId,
          ),
          from: churchStatsProvider,
          name: r'churchStatsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$churchStatsHash,
          dependencies: ChurchStatsFamily._dependencies,
          allTransitiveDependencies:
              ChurchStatsFamily._allTransitiveDependencies,
          churchId: churchId,
        );

  ChurchStatsProvider._internal(
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
    FutureOr<Map<String, dynamic>> Function(ChurchStatsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChurchStatsProvider._internal(
        (ref) => create(ref as ChurchStatsRef),
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
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _ChurchStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChurchStatsProvider && other.churchId == churchId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, churchId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChurchStatsRef on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `churchId` of this provider.
  String get churchId;
}

class _ChurchStatsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with ChurchStatsRef {
  _ChurchStatsProviderElement(super.provider);

  @override
  String get churchId => (origin as ChurchStatsProvider).churchId;
}

String _$totalMemberCountHash() => r'2f6b386c99194b04cdcdef124524c768ffe9e44d';

/// Provider du nombre total de membres (toutes églises)
///
/// Copied from [totalMemberCount].
@ProviderFor(totalMemberCount)
final totalMemberCountProvider = AutoDisposeFutureProvider<int>.internal(
  totalMemberCount,
  name: r'totalMemberCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalMemberCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TotalMemberCountRef = AutoDisposeFutureProviderRef<int>;
String _$churchSwitcherHash() => r'f6856d7d6d130167aef056a53cf6b23fc54cba3f';

/// Notifier pour changer d'église active
///
/// Utilise le provider Auth pour changer le contexte d'église
///
/// Copied from [ChurchSwitcher].
@ProviderFor(ChurchSwitcher)
final churchSwitcherProvider =
    AutoDisposeAsyncNotifierProvider<ChurchSwitcher, void>.internal(
  ChurchSwitcher.new,
  name: r'churchSwitcherProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$churchSwitcherHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChurchSwitcher = AutoDisposeAsyncNotifier<void>;
String _$churchActionsHash() => r'9689de04cf8aa91dbb915c441a92c8e38415f9e4';

/// Provider des actions CRUD pour les églises
///
/// Copied from [ChurchActions].
@ProviderFor(ChurchActions)
final churchActionsProvider =
    AutoDisposeAsyncNotifierProvider<ChurchActions, void>.internal(
  ChurchActions.new,
  name: r'churchActionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$churchActionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChurchActions = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

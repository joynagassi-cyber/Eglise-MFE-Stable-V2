// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intercession_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$intercessionRepositoryHash() =>
    r'038e5ebb57f1ecac3a5d6c97e5d1c2a19ca4c250';

/// See also [intercessionRepository].
@ProviderFor(intercessionRepository)
final intercessionRepositoryProvider =
    AutoDisposeProvider<IntercessionRepository>.internal(
  intercessionRepository,
  name: r'intercessionRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$intercessionRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IntercessionRepositoryRef
    = AutoDisposeProviderRef<IntercessionRepository>;
String _$prayerVigilsNotifierHash() =>
    r'32daa91972b89bed4352668d78d7a7ae50b739eb';

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

abstract class _$PrayerVigilsNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<PrayerVigil>> {
  late final String groupId;

  FutureOr<List<PrayerVigil>> build(
    String groupId,
  );
}

/// See also [PrayerVigilsNotifier].
@ProviderFor(PrayerVigilsNotifier)
const prayerVigilsNotifierProvider = PrayerVigilsNotifierFamily();

/// See also [PrayerVigilsNotifier].
class PrayerVigilsNotifierFamily extends Family<AsyncValue<List<PrayerVigil>>> {
  /// See also [PrayerVigilsNotifier].
  const PrayerVigilsNotifierFamily();

  /// See also [PrayerVigilsNotifier].
  PrayerVigilsNotifierProvider call(
    String groupId,
  ) {
    return PrayerVigilsNotifierProvider(
      groupId,
    );
  }

  @override
  PrayerVigilsNotifierProvider getProviderOverride(
    covariant PrayerVigilsNotifierProvider provider,
  ) {
    return call(
      provider.groupId,
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
  String? get name => r'prayerVigilsNotifierProvider';
}

/// See also [PrayerVigilsNotifier].
class PrayerVigilsNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    PrayerVigilsNotifier, List<PrayerVigil>> {
  /// See also [PrayerVigilsNotifier].
  PrayerVigilsNotifierProvider(
    String groupId,
  ) : this._internal(
          () => PrayerVigilsNotifier()..groupId = groupId,
          from: prayerVigilsNotifierProvider,
          name: r'prayerVigilsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$prayerVigilsNotifierHash,
          dependencies: PrayerVigilsNotifierFamily._dependencies,
          allTransitiveDependencies:
              PrayerVigilsNotifierFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  PrayerVigilsNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
  }) : super.internal();

  final String groupId;

  @override
  FutureOr<List<PrayerVigil>> runNotifierBuild(
    covariant PrayerVigilsNotifier notifier,
  ) {
    return notifier.build(
      groupId,
    );
  }

  @override
  Override overrideWith(PrayerVigilsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: PrayerVigilsNotifierProvider._internal(
        () => create()..groupId = groupId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PrayerVigilsNotifier,
      List<PrayerVigil>> createElement() {
    return _PrayerVigilsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PrayerVigilsNotifierProvider && other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PrayerVigilsNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<PrayerVigil>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _PrayerVigilsNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PrayerVigilsNotifier,
        List<PrayerVigil>> with PrayerVigilsNotifierRef {
  _PrayerVigilsNotifierProviderElement(super.provider);

  @override
  String get groupId => (origin as PrayerVigilsNotifierProvider).groupId;
}

String _$permanentPrayerSubjectsNotifierHash() =>
    r'f95514799cd12da9089fc2174de3a0598dc70d9d';

abstract class _$PermanentPrayerSubjectsNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<PermanentPrayerSubject>> {
  late final String groupId;

  FutureOr<List<PermanentPrayerSubject>> build(
    String groupId,
  );
}

/// See also [PermanentPrayerSubjectsNotifier].
@ProviderFor(PermanentPrayerSubjectsNotifier)
const permanentPrayerSubjectsNotifierProvider =
    PermanentPrayerSubjectsNotifierFamily();

/// See also [PermanentPrayerSubjectsNotifier].
class PermanentPrayerSubjectsNotifierFamily
    extends Family<AsyncValue<List<PermanentPrayerSubject>>> {
  /// See also [PermanentPrayerSubjectsNotifier].
  const PermanentPrayerSubjectsNotifierFamily();

  /// See also [PermanentPrayerSubjectsNotifier].
  PermanentPrayerSubjectsNotifierProvider call(
    String groupId,
  ) {
    return PermanentPrayerSubjectsNotifierProvider(
      groupId,
    );
  }

  @override
  PermanentPrayerSubjectsNotifierProvider getProviderOverride(
    covariant PermanentPrayerSubjectsNotifierProvider provider,
  ) {
    return call(
      provider.groupId,
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
  String? get name => r'permanentPrayerSubjectsNotifierProvider';
}

/// See also [PermanentPrayerSubjectsNotifier].
class PermanentPrayerSubjectsNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<
        PermanentPrayerSubjectsNotifier, List<PermanentPrayerSubject>> {
  /// See also [PermanentPrayerSubjectsNotifier].
  PermanentPrayerSubjectsNotifierProvider(
    String groupId,
  ) : this._internal(
          () => PermanentPrayerSubjectsNotifier()..groupId = groupId,
          from: permanentPrayerSubjectsNotifierProvider,
          name: r'permanentPrayerSubjectsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$permanentPrayerSubjectsNotifierHash,
          dependencies: PermanentPrayerSubjectsNotifierFamily._dependencies,
          allTransitiveDependencies:
              PermanentPrayerSubjectsNotifierFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  PermanentPrayerSubjectsNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
  }) : super.internal();

  final String groupId;

  @override
  FutureOr<List<PermanentPrayerSubject>> runNotifierBuild(
    covariant PermanentPrayerSubjectsNotifier notifier,
  ) {
    return notifier.build(
      groupId,
    );
  }

  @override
  Override overrideWith(PermanentPrayerSubjectsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: PermanentPrayerSubjectsNotifierProvider._internal(
        () => create()..groupId = groupId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PermanentPrayerSubjectsNotifier,
      List<PermanentPrayerSubject>> createElement() {
    return _PermanentPrayerSubjectsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PermanentPrayerSubjectsNotifierProvider &&
        other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PermanentPrayerSubjectsNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<PermanentPrayerSubject>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _PermanentPrayerSubjectsNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<
        PermanentPrayerSubjectsNotifier,
        List<PermanentPrayerSubject>> with PermanentPrayerSubjectsNotifierRef {
  _PermanentPrayerSubjectsNotifierProviderElement(super.provider);

  @override
  String get groupId =>
      (origin as PermanentPrayerSubjectsNotifierProvider).groupId;
}

String _$intercessionKpisNotifierHash() =>
    r'a484dadad820fc677f4dddbdac0a32a5af35585b';

abstract class _$IntercessionKpisNotifier
    extends BuildlessAutoDisposeAsyncNotifier<Map<String, dynamic>> {
  late final String groupId;

  FutureOr<Map<String, dynamic>> build(
    String groupId,
  );
}

/// See also [IntercessionKpisNotifier].
@ProviderFor(IntercessionKpisNotifier)
const intercessionKpisNotifierProvider = IntercessionKpisNotifierFamily();

/// See also [IntercessionKpisNotifier].
class IntercessionKpisNotifierFamily
    extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [IntercessionKpisNotifier].
  const IntercessionKpisNotifierFamily();

  /// See also [IntercessionKpisNotifier].
  IntercessionKpisNotifierProvider call(
    String groupId,
  ) {
    return IntercessionKpisNotifierProvider(
      groupId,
    );
  }

  @override
  IntercessionKpisNotifierProvider getProviderOverride(
    covariant IntercessionKpisNotifierProvider provider,
  ) {
    return call(
      provider.groupId,
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
  String? get name => r'intercessionKpisNotifierProvider';
}

/// See also [IntercessionKpisNotifier].
class IntercessionKpisNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<IntercessionKpisNotifier,
        Map<String, dynamic>> {
  /// See also [IntercessionKpisNotifier].
  IntercessionKpisNotifierProvider(
    String groupId,
  ) : this._internal(
          () => IntercessionKpisNotifier()..groupId = groupId,
          from: intercessionKpisNotifierProvider,
          name: r'intercessionKpisNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$intercessionKpisNotifierHash,
          dependencies: IntercessionKpisNotifierFamily._dependencies,
          allTransitiveDependencies:
              IntercessionKpisNotifierFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  IntercessionKpisNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
  }) : super.internal();

  final String groupId;

  @override
  FutureOr<Map<String, dynamic>> runNotifierBuild(
    covariant IntercessionKpisNotifier notifier,
  ) {
    return notifier.build(
      groupId,
    );
  }

  @override
  Override overrideWith(IntercessionKpisNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: IntercessionKpisNotifierProvider._internal(
        () => create()..groupId = groupId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<IntercessionKpisNotifier,
      Map<String, dynamic>> createElement() {
    return _IntercessionKpisNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IntercessionKpisNotifierProvider &&
        other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IntercessionKpisNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<Map<String, dynamic>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _IntercessionKpisNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<IntercessionKpisNotifier,
        Map<String, dynamic>> with IntercessionKpisNotifierRef {
  _IntercessionKpisNotifierProviderElement(super.provider);

  @override
  String get groupId => (origin as IntercessionKpisNotifierProvider).groupId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipe_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$equipeControllerHash() => r'04cf533e7035b808701edf137af16eebc1ea4efd';

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

abstract class _$EquipeController
    extends BuildlessAutoDisposeAsyncNotifier<EquipeState> {
  late final String? churchId;

  FutureOr<EquipeState> build({
    String? churchId,
  });
}

/// Controller for the Equipe (Team) module.
/// Aggregates shepherds and pastoral visits into a unified team view.
///
/// Copied from [EquipeController].
@ProviderFor(EquipeController)
const equipeControllerProvider = EquipeControllerFamily();

/// Controller for the Equipe (Team) module.
/// Aggregates shepherds and pastoral visits into a unified team view.
///
/// Copied from [EquipeController].
class EquipeControllerFamily extends Family<AsyncValue<EquipeState>> {
  /// Controller for the Equipe (Team) module.
  /// Aggregates shepherds and pastoral visits into a unified team view.
  ///
  /// Copied from [EquipeController].
  const EquipeControllerFamily();

  /// Controller for the Equipe (Team) module.
  /// Aggregates shepherds and pastoral visits into a unified team view.
  ///
  /// Copied from [EquipeController].
  EquipeControllerProvider call({
    String? churchId,
  }) {
    return EquipeControllerProvider(
      churchId: churchId,
    );
  }

  @override
  EquipeControllerProvider getProviderOverride(
    covariant EquipeControllerProvider provider,
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
  String? get name => r'equipeControllerProvider';
}

/// Controller for the Equipe (Team) module.
/// Aggregates shepherds and pastoral visits into a unified team view.
///
/// Copied from [EquipeController].
class EquipeControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    EquipeController, EquipeState> {
  /// Controller for the Equipe (Team) module.
  /// Aggregates shepherds and pastoral visits into a unified team view.
  ///
  /// Copied from [EquipeController].
  EquipeControllerProvider({
    String? churchId,
  }) : this._internal(
          () => EquipeController()..churchId = churchId,
          from: equipeControllerProvider,
          name: r'equipeControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$equipeControllerHash,
          dependencies: EquipeControllerFamily._dependencies,
          allTransitiveDependencies:
              EquipeControllerFamily._allTransitiveDependencies,
          churchId: churchId,
        );

  EquipeControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.churchId,
  }) : super.internal();

  final String? churchId;

  @override
  FutureOr<EquipeState> runNotifierBuild(
    covariant EquipeController notifier,
  ) {
    return notifier.build(
      churchId: churchId,
    );
  }

  @override
  Override overrideWith(EquipeController Function() create) {
    return ProviderOverride(
      origin: this,
      override: EquipeControllerProvider._internal(
        () => create()..churchId = churchId,
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
  AutoDisposeAsyncNotifierProviderElement<EquipeController, EquipeState>
      createElement() {
    return _EquipeControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EquipeControllerProvider && other.churchId == churchId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, churchId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin EquipeControllerRef on AutoDisposeAsyncNotifierProviderRef<EquipeState> {
  /// The parameter `churchId` of this provider.
  String? get churchId;
}

class _EquipeControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<EquipeController,
        EquipeState> with EquipeControllerRef {
  _EquipeControllerProviderElement(super.provider);

  @override
  String? get churchId => (origin as EquipeControllerProvider).churchId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

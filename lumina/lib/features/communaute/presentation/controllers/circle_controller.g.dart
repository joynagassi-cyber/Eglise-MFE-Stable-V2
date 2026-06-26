// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$circleControllerHash() => r'8cb83a10d41a4712d9efa3c303bd209a9265a39d';

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

abstract class _$CircleController
    extends BuildlessAutoDisposeAsyncNotifier<List<Circle>> {
  late final String churchId;

  FutureOr<List<Circle>> build({
    required String churchId,
  });
}

/// See also [CircleController].
@ProviderFor(CircleController)
const circleControllerProvider = CircleControllerFamily();

/// See also [CircleController].
class CircleControllerFamily extends Family<AsyncValue<List<Circle>>> {
  /// See also [CircleController].
  const CircleControllerFamily();

  /// See also [CircleController].
  CircleControllerProvider call({
    required String churchId,
  }) {
    return CircleControllerProvider(
      churchId: churchId,
    );
  }

  @override
  CircleControllerProvider getProviderOverride(
    covariant CircleControllerProvider provider,
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
  String? get name => r'circleControllerProvider';
}

/// See also [CircleController].
class CircleControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    CircleController, List<Circle>> {
  /// See also [CircleController].
  CircleControllerProvider({
    required String churchId,
  }) : this._internal(
          () => CircleController()..churchId = churchId,
          from: circleControllerProvider,
          name: r'circleControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$circleControllerHash,
          dependencies: CircleControllerFamily._dependencies,
          allTransitiveDependencies:
              CircleControllerFamily._allTransitiveDependencies,
          churchId: churchId,
        );

  CircleControllerProvider._internal(
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
  FutureOr<List<Circle>> runNotifierBuild(
    covariant CircleController notifier,
  ) {
    return notifier.build(
      churchId: churchId,
    );
  }

  @override
  Override overrideWith(CircleController Function() create) {
    return ProviderOverride(
      origin: this,
      override: CircleControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<CircleController, List<Circle>>
      createElement() {
    return _CircleControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CircleControllerProvider && other.churchId == churchId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, churchId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CircleControllerRef on AutoDisposeAsyncNotifierProviderRef<List<Circle>> {
  /// The parameter `churchId` of this provider.
  String get churchId;
}

class _CircleControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CircleController,
        List<Circle>> with CircleControllerRef {
  _CircleControllerProviderElement(super.provider);

  @override
  String get churchId => (origin as CircleControllerProvider).churchId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

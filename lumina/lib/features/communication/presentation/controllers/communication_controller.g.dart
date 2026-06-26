// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'communication_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$communicationControllerHash() =>
    r'9e9ba6a9aced3160411706aa7a0dce79cf47726f';

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

abstract class _$CommunicationController
    extends BuildlessAutoDisposeAsyncNotifier<CommunicationState> {
  late final String? churchId;

  FutureOr<CommunicationState> build({
    String? churchId,
  });
}

/// Controller for the Communication module.
/// Aggregates announcements, social feeds, and messaging stats.
///
/// Copied from [CommunicationController].
@ProviderFor(CommunicationController)
const communicationControllerProvider = CommunicationControllerFamily();

/// Controller for the Communication module.
/// Aggregates announcements, social feeds, and messaging stats.
///
/// Copied from [CommunicationController].
class CommunicationControllerFamily
    extends Family<AsyncValue<CommunicationState>> {
  /// Controller for the Communication module.
  /// Aggregates announcements, social feeds, and messaging stats.
  ///
  /// Copied from [CommunicationController].
  const CommunicationControllerFamily();

  /// Controller for the Communication module.
  /// Aggregates announcements, social feeds, and messaging stats.
  ///
  /// Copied from [CommunicationController].
  CommunicationControllerProvider call({
    String? churchId,
  }) {
    return CommunicationControllerProvider(
      churchId: churchId,
    );
  }

  @override
  CommunicationControllerProvider getProviderOverride(
    covariant CommunicationControllerProvider provider,
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
  String? get name => r'communicationControllerProvider';
}

/// Controller for the Communication module.
/// Aggregates announcements, social feeds, and messaging stats.
///
/// Copied from [CommunicationController].
class CommunicationControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<CommunicationController,
        CommunicationState> {
  /// Controller for the Communication module.
  /// Aggregates announcements, social feeds, and messaging stats.
  ///
  /// Copied from [CommunicationController].
  CommunicationControllerProvider({
    String? churchId,
  }) : this._internal(
          () => CommunicationController()..churchId = churchId,
          from: communicationControllerProvider,
          name: r'communicationControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$communicationControllerHash,
          dependencies: CommunicationControllerFamily._dependencies,
          allTransitiveDependencies:
              CommunicationControllerFamily._allTransitiveDependencies,
          churchId: churchId,
        );

  CommunicationControllerProvider._internal(
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
  FutureOr<CommunicationState> runNotifierBuild(
    covariant CommunicationController notifier,
  ) {
    return notifier.build(
      churchId: churchId,
    );
  }

  @override
  Override overrideWith(CommunicationController Function() create) {
    return ProviderOverride(
      origin: this,
      override: CommunicationControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<CommunicationController,
      CommunicationState> createElement() {
    return _CommunicationControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CommunicationControllerProvider &&
        other.churchId == churchId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, churchId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CommunicationControllerRef
    on AutoDisposeAsyncNotifierProviderRef<CommunicationState> {
  /// The parameter `churchId` of this provider.
  String? get churchId;
}

class _CommunicationControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CommunicationController,
        CommunicationState> with CommunicationControllerRef {
  _CommunicationControllerProviderElement(super.provider);

  @override
  String? get churchId => (origin as CommunicationControllerProvider).churchId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

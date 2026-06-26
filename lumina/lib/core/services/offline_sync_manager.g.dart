// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_sync_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$offlineSyncManagerHash() =>
    r'9d6c86cdc2d6f55ccf080339b449257e621858be';

/// See also [offlineSyncManager].
@ProviderFor(offlineSyncManager)
final offlineSyncManagerProvider = Provider<OfflineSyncManager>.internal(
  offlineSyncManager,
  name: r'offlineSyncManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$offlineSyncManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef OfflineSyncManagerRef = ProviderRef<OfflineSyncManager>;
String _$isRecordPendingHash() => r'7e4cb48d9e0eb81225e668b12278a6f8242a8b75';

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

/// See also [isRecordPending].
@ProviderFor(isRecordPending)
const isRecordPendingProvider = IsRecordPendingFamily();

/// See also [isRecordPending].
class IsRecordPendingFamily extends Family<AsyncValue<bool>> {
  /// See also [isRecordPending].
  const IsRecordPendingFamily();

  /// See also [isRecordPending].
  IsRecordPendingProvider call(
    String recordId,
  ) {
    return IsRecordPendingProvider(
      recordId,
    );
  }

  @override
  IsRecordPendingProvider getProviderOverride(
    covariant IsRecordPendingProvider provider,
  ) {
    return call(
      provider.recordId,
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
  String? get name => r'isRecordPendingProvider';
}

/// See also [isRecordPending].
class IsRecordPendingProvider extends AutoDisposeStreamProvider<bool> {
  /// See also [isRecordPending].
  IsRecordPendingProvider(
    String recordId,
  ) : this._internal(
          (ref) => isRecordPending(
            ref as IsRecordPendingRef,
            recordId,
          ),
          from: isRecordPendingProvider,
          name: r'isRecordPendingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isRecordPendingHash,
          dependencies: IsRecordPendingFamily._dependencies,
          allTransitiveDependencies:
              IsRecordPendingFamily._allTransitiveDependencies,
          recordId: recordId,
        );

  IsRecordPendingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.recordId,
  }) : super.internal();

  final String recordId;

  @override
  Override overrideWith(
    Stream<bool> Function(IsRecordPendingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsRecordPendingProvider._internal(
        (ref) => create(ref as IsRecordPendingRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        recordId: recordId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<bool> createElement() {
    return _IsRecordPendingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsRecordPendingProvider && other.recordId == recordId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, recordId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IsRecordPendingRef on AutoDisposeStreamProviderRef<bool> {
  /// The parameter `recordId` of this provider.
  String get recordId;
}

class _IsRecordPendingProviderElement
    extends AutoDisposeStreamProviderElement<bool> with IsRecordPendingRef {
  _IsRecordPendingProviderElement(super.provider);

  @override
  String get recordId => (origin as IsRecordPendingProvider).recordId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

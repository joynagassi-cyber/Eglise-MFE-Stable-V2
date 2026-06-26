// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_indicator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pendingSyncCountHash() => r'2e8706429fa0970e8d5bc46166037e462aa1522b';

/// Provider pour l'état de synchronisation globale (Queue Isar)
///
/// Copied from [pendingSyncCount].
@ProviderFor(pendingSyncCount)
final pendingSyncCountProvider = AutoDisposeStreamProvider<int>.internal(
  pendingSyncCount,
  name: r'pendingSyncCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingSyncCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PendingSyncCountRef = AutoDisposeStreamProviderRef<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

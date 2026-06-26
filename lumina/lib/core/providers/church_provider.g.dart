// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$effectiveChurchIdHash() => r'f50865f32562218e5f19a108c0d5e25a1c720eb5';

/// Provider dérivé qui retourne le church_id effectif à utiliser pour les requêtes.
/// - Superadmin : utilise selectedChurchIdProvider (peut changer)
/// - Autres rôles : utilise toujours leur propre church_id
///
/// Copied from [effectiveChurchId].
@ProviderFor(effectiveChurchId)
final effectiveChurchIdProvider = AutoDisposeProvider<String>.internal(
  effectiveChurchId,
  name: r'effectiveChurchIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$effectiveChurchIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef EffectiveChurchIdRef = AutoDisposeProviderRef<String>;
String _$currentChurchHash() => r'48f51709ed9c53b49ad0b639748005dd667a0125';

/// See also [CurrentChurch].
@ProviderFor(CurrentChurch)
final currentChurchProvider =
    AutoDisposeAsyncNotifierProvider<CurrentChurch, Church?>.internal(
  CurrentChurch.new,
  name: r'currentChurchProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentChurchHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentChurch = AutoDisposeAsyncNotifier<Church?>;
String _$allChurchesHash() => r'4d7cd7c1f0ee430614b965cf49c389082dfb87e0';

/// See also [AllChurches].
@ProviderFor(AllChurches)
final allChurchesProvider =
    AutoDisposeAsyncNotifierProvider<AllChurches, List<Church>>.internal(
  AllChurches.new,
  name: r'allChurchesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allChurchesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AllChurches = AutoDisposeAsyncNotifier<List<Church>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

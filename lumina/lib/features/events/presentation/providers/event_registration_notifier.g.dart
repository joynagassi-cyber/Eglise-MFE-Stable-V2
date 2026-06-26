// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_registration_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventRegistrationHash() => r'83ec64698936de15ad95d9334ec95b6fc44c85f9';

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

abstract class _$EventRegistration
    extends BuildlessAutoDisposeAsyncNotifier<EventRegistrationState> {
  late final String eventId;

  FutureOr<EventRegistrationState> build(
    String eventId,
  );
}

/// Gère l'inscription d'un utilisateur à un événement spécifique.
///
/// Implémente le pattern optimistic update :
/// 1. L'UI affiche "Inscrit ✓" immédiatement
/// 2. L'insertion en DB est lancée en arrière-plan
/// 3. En cas d'erreur → rollback + notification d'erreur
///
/// Copied from [EventRegistration].
@ProviderFor(EventRegistration)
const eventRegistrationProvider = EventRegistrationFamily();

/// Gère l'inscription d'un utilisateur à un événement spécifique.
///
/// Implémente le pattern optimistic update :
/// 1. L'UI affiche "Inscrit ✓" immédiatement
/// 2. L'insertion en DB est lancée en arrière-plan
/// 3. En cas d'erreur → rollback + notification d'erreur
///
/// Copied from [EventRegistration].
class EventRegistrationFamily
    extends Family<AsyncValue<EventRegistrationState>> {
  /// Gère l'inscription d'un utilisateur à un événement spécifique.
  ///
  /// Implémente le pattern optimistic update :
  /// 1. L'UI affiche "Inscrit ✓" immédiatement
  /// 2. L'insertion en DB est lancée en arrière-plan
  /// 3. En cas d'erreur → rollback + notification d'erreur
  ///
  /// Copied from [EventRegistration].
  const EventRegistrationFamily();

  /// Gère l'inscription d'un utilisateur à un événement spécifique.
  ///
  /// Implémente le pattern optimistic update :
  /// 1. L'UI affiche "Inscrit ✓" immédiatement
  /// 2. L'insertion en DB est lancée en arrière-plan
  /// 3. En cas d'erreur → rollback + notification d'erreur
  ///
  /// Copied from [EventRegistration].
  EventRegistrationProvider call(
    String eventId,
  ) {
    return EventRegistrationProvider(
      eventId,
    );
  }

  @override
  EventRegistrationProvider getProviderOverride(
    covariant EventRegistrationProvider provider,
  ) {
    return call(
      provider.eventId,
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
  String? get name => r'eventRegistrationProvider';
}

/// Gère l'inscription d'un utilisateur à un événement spécifique.
///
/// Implémente le pattern optimistic update :
/// 1. L'UI affiche "Inscrit ✓" immédiatement
/// 2. L'insertion en DB est lancée en arrière-plan
/// 3. En cas d'erreur → rollback + notification d'erreur
///
/// Copied from [EventRegistration].
class EventRegistrationProvider extends AutoDisposeAsyncNotifierProviderImpl<
    EventRegistration, EventRegistrationState> {
  /// Gère l'inscription d'un utilisateur à un événement spécifique.
  ///
  /// Implémente le pattern optimistic update :
  /// 1. L'UI affiche "Inscrit ✓" immédiatement
  /// 2. L'insertion en DB est lancée en arrière-plan
  /// 3. En cas d'erreur → rollback + notification d'erreur
  ///
  /// Copied from [EventRegistration].
  EventRegistrationProvider(
    String eventId,
  ) : this._internal(
          () => EventRegistration()..eventId = eventId,
          from: eventRegistrationProvider,
          name: r'eventRegistrationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$eventRegistrationHash,
          dependencies: EventRegistrationFamily._dependencies,
          allTransitiveDependencies:
              EventRegistrationFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  EventRegistrationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.eventId,
  }) : super.internal();

  final String eventId;

  @override
  FutureOr<EventRegistrationState> runNotifierBuild(
    covariant EventRegistration notifier,
  ) {
    return notifier.build(
      eventId,
    );
  }

  @override
  Override overrideWith(EventRegistration Function() create) {
    return ProviderOverride(
      origin: this,
      override: EventRegistrationProvider._internal(
        () => create()..eventId = eventId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        eventId: eventId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<EventRegistration,
      EventRegistrationState> createElement() {
    return _EventRegistrationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EventRegistrationProvider && other.eventId == eventId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, eventId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin EventRegistrationRef
    on AutoDisposeAsyncNotifierProviderRef<EventRegistrationState> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _EventRegistrationProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<EventRegistration,
        EventRegistrationState> with EventRegistrationRef {
  _EventRegistrationProviderElement(super.provider);

  @override
  String get eventId => (origin as EventRegistrationProvider).eventId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

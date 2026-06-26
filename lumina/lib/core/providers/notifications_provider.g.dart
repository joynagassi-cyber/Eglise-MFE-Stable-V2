// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationsMonitorHash() =>
    r'ea54284e1c3fc9d2a381be84c46825894a6e3965';

/// Provider pour surveiller les changements de notifications
///
/// Copied from [notificationsMonitor].
@ProviderFor(notificationsMonitor)
final notificationsMonitorProvider = AutoDisposeProvider<void>.internal(
  notificationsMonitor,
  name: r'notificationsMonitorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsMonitorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NotificationsMonitorRef = AutoDisposeProviderRef<void>;
String _$realNotificationsServiceHash() =>
    r'7ed26e76ed77014a4180389f76a653ff016360b5';

/// Provider pour le service de notifications réelles
///
/// Copied from [realNotificationsService].
@ProviderFor(realNotificationsService)
final realNotificationsServiceProvider =
    AutoDisposeProvider<RealNotificationsService>.internal(
  realNotificationsService,
  name: r'realNotificationsServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$realNotificationsServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RealNotificationsServiceRef
    = AutoDisposeProviderRef<RealNotificationsService>;
String _$realNavigationBadgesHash() =>
    r'3f8a9fd05fe741c547a4b623f066dddfb23d9d08';

/// Provider qui met à jour les badges avec les données réelles
/// Provider qui expose les badges avec les données réelles
///
/// Copied from [realNavigationBadges].
@ProviderFor(realNavigationBadges)
final realNavigationBadgesProvider =
    AutoDisposeFutureProvider<Map<NavigationBadgeType, int>>.internal(
  realNavigationBadges,
  name: r'realNavigationBadgesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$realNavigationBadgesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RealNavigationBadgesRef
    = AutoDisposeFutureProviderRef<Map<NavigationBadgeType, int>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

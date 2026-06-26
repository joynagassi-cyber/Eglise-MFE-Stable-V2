// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$unreadNotificationCountHash() =>
    r'c0c228b72fda1b569d2ffcf4bd10dcf2b1b6bb2e';

/// See also [unreadNotificationCount].
@ProviderFor(unreadNotificationCount)
final unreadNotificationCountProvider = AutoDisposeFutureProvider<int>.internal(
  unreadNotificationCount,
  name: r'unreadNotificationCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unreadNotificationCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UnreadNotificationCountRef = AutoDisposeFutureProviderRef<int>;
String _$notificationControllerHash() =>
    r'2cf0b199551fdef646bef202d8db50e8678c6864';

/// See also [NotificationController].
@ProviderFor(NotificationController)
final notificationControllerProvider = AutoDisposeAsyncNotifierProvider<
    NotificationController, List<AppNotificationEntity>>.internal(
  NotificationController.new,
  name: r'notificationControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationController
    = AutoDisposeAsyncNotifier<List<AppNotificationEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

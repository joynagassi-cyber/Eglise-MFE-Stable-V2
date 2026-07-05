// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$unreadNotificationCountHash() =>
    r'6ec388b884aeb7ae510af86a8318bd1d958fb6f6';

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
String _$notificationListHash() => r'f37aba1f4a403697da0b8567d1cd3a2adf102faf';

/// Provider qui expose les notifications comme des [NotificationDisplayItem]
/// pour l'UI, en mappant depuis [AppNotificationEntity]
///
/// Copied from [notificationList].
@ProviderFor(notificationList)
final notificationListProvider =
    AutoDisposeFutureProvider<List<NotificationDisplayItem>>.internal(
  notificationList,
  name: r'notificationListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NotificationListRef
    = AutoDisposeFutureProviderRef<List<NotificationDisplayItem>>;
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

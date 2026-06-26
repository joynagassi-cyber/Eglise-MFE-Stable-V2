// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realtime_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$unreadNotificationCountHash() =>
    r'0b20886fdb84eee8acf8d95cb4b0bab9176d40ab';

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
String _$realtimeManagerHash() => r'9e8cb24ca86559b03d17d2658379502d4a26620d';

/// Manages all Supabase Realtime subscriptions.
///
/// Souscrit dynamiquement aux canaux en fonction du rôle de l'utilisateur :
/// - **Tous** : notifications (user), annonces (église)
/// - **Admin/Superadmin** : transactions, budgets, members, audit_logs
/// - **Chef de groupe** : events (église), event_attendances (église)
/// - **Membre** : finance_transactions (personnel via user_id)
///
/// Chaque événement reçu est dispatché au [DashboardCacheManager]
/// qui invalide les providers Riverpod concernés.
///
/// Copied from [RealtimeManager].
@ProviderFor(RealtimeManager)
final realtimeManagerProvider =
    NotifierProvider<RealtimeManager, void>.internal(
  RealtimeManager.new,
  name: r'realtimeManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$realtimeManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RealtimeManager = Notifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

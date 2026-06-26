import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lumina/core/data/local/isar_service.dart';
import 'package:lumina/core/providers/supabase_provider.dart';
import 'package:lumina/core/services/offline_sync_manager.dart';
import 'package:lumina/features/annonces/data/repositories/annonce_repository_impl.dart';
import 'package:lumina/features/annonces/domain/repositories/i_annonce_repository.dart';
import 'package:lumina/features/audit/data/repositories/audit_repository.dart';
import 'package:lumina/features/celebrations/data/repositories/celebration_repository_impl.dart';
import 'package:lumina/features/celebrations/domain/repositories/i_celebration_repository.dart';
import 'package:lumina/features/churches/data/repositories/supabase_church_repository.dart';
import 'package:lumina/features/churches/domain/repositories/church_repository.dart';
import 'package:lumina/features/communaute/data/repositories/circle_repository_impl.dart';
import 'package:lumina/features/communaute/domain/repositories/i_circle_repository.dart';
import 'package:lumina/features/events/data/repositories/event_repository_impl.dart';
import 'package:lumina/features/events/domain/repositories/i_event_repository.dart';
import 'package:lumina/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:lumina/features/notifications/domain/repositories/i_notification_repository.dart';
import 'package:lumina/features/rubriques/data/repositories/supabase_category_repository.dart';
import 'package:lumina/features/rubriques/domain/repositories/category_repository.dart';
import 'package:lumina/features/sacraments/data/repositories/sacrament_repository_impl.dart';
import 'package:lumina/features/sacraments/domain/repositories/i_sacrament_repository.dart';
import 'package:lumina/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:lumina/features/settings/domain/repositories/i_settings_repository.dart';
import 'package:lumina/features/bergers/data/repositories/shepherd_repository_impl.dart';
import 'package:lumina/features/bergers/domain/repositories/i_shepherd_repository.dart';

part 'repository_providers_content.g.dart';

@Riverpod(keepAlive: true)
ChurchRepository churchRepository(ChurchRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final isar = ref.watch(isarServiceProvider);
  return SupabaseChurchRepository(client: supabase, isar: isar);
}

@Riverpod(keepAlive: true)
AuditRepository auditRepository(AuditRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final isar = ref.watch(isarServiceProvider);
  return AuditRepository(supabase, isar, ref);
}

@Riverpod(keepAlive: true)
IAnnonceRepository annonceRepository(AnnonceRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final isar = ref.watch(isarServiceProvider);
  return AnnonceRepositoryImpl(supabase, isar, ref);
}

@Riverpod(keepAlive: true)
IShepherdRepository shepherdRepository(ShepherdRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final isar = ref.watch(isarServiceProvider);
  final syncManager = ref.watch(offlineSyncManagerProvider);
  return ShepherdRepositoryImpl(supabase, isar, syncManager);
}

@Riverpod(keepAlive: true)
ICelebrationRepository celebrationRepository(CelebrationRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final isar = ref.watch(isarServiceProvider);
  final syncManager = ref.watch(offlineSyncManagerProvider);
  return CelebrationRepositoryImpl(supabase, isar, syncManager);
}

@Riverpod(keepAlive: true)
IEventRepository eventRepository(EventRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final isar = ref.watch(isarServiceProvider);
  return EventRepositoryImpl(supabase, isar);
}

@Riverpod(keepAlive: true)
ISacramentRepository sacramentRepository(SacramentRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final isar = ref.watch(isarServiceProvider);
  return SacramentRepositoryImpl(supabase, isar);
}

@Riverpod(keepAlive: true)
CategoryRepository categoryRepository(CategoryRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final isar = ref.watch(isarServiceProvider);
  return SupabaseCategoryRepository(supabase, isar, ref);
}

@Riverpod(keepAlive: true)
INotificationRepository notificationRepository(
  NotificationRepositoryRef ref,
) {
  final supabase = ref.watch(supabaseProvider);
  final isar = ref.watch(isarServiceProvider);
  final syncManager = ref.watch(offlineSyncManagerProvider);
  return NotificationRepositoryImpl(supabase, isar, syncManager, ref);
}

@Riverpod(keepAlive: true)
ICircleRepository circleRepository(CircleRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  return CircleRepositoryImpl(supabase);
}

@Riverpod(keepAlive: true)
ISettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  return SettingsRepositoryImpl();
}

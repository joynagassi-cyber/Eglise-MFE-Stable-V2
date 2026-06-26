import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lumina/core/data/local/isar_service.dart';
import 'package:lumina/core/providers/supabase_provider.dart';
import 'package:lumina/features/messaging/data/repositories/messaging_repository_impl.dart';
import 'package:lumina/features/messaging/data/services/e2ee_service.dart';
import 'package:lumina/features/messaging/data/services/presence_service.dart';
import 'package:lumina/features/messaging/data/services/voice_note_service.dart';
import 'package:lumina/features/messaging/domain/repositories/i_messaging_repository.dart';
import 'package:lumina/features/social/data/repositories/social_repository_impl.dart';
import 'package:lumina/features/social/domain/repositories/i_social_repository.dart';
import 'package:lumina/core/services/offline_sync_manager.dart';

part 'repository_providers_messaging.g.dart';

@Riverpod(keepAlive: true)
IMessagingRepository messagingRepository(MessagingRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final isar = ref.watch(isarServiceProvider);
  final syncManager = ref.watch(offlineSyncManagerProvider);
  
  final repo = MessagingRepositoryImpl(supabase, isar, syncManager, ref);
  
  ref.onDispose(() {
    repo.dispose();
  });
  
  return repo;
}

@Riverpod(keepAlive: true)
E2eeService e2eeService(E2eeServiceRef ref) {
  final supabase = ref.watch(supabaseProvider);
  const secureStorage = FlutterSecureStorage();
  return E2eeService(supabase, secureStorage);
}

@Riverpod(keepAlive: true)
PresenceService presenceService(PresenceServiceRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final service = PresenceService(supabase);
  ref.onDispose(() => service.dispose());
  return service;
}

@Riverpod(keepAlive: true)
VoiceNoteService voiceNoteService(VoiceNoteServiceRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final service = VoiceNoteService(supabase);
  ref.onDispose(() => service.dispose());
  return service;
}

@Riverpod(keepAlive: true)
ISocialRepository socialRepository(SocialRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final isar = ref.watch(isarServiceProvider);
  final syncManager = ref.watch(offlineSyncManagerProvider);
  return SocialRepositoryImpl(supabase, isar, syncManager, ref);
}

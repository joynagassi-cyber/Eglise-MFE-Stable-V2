import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/seal_repository.dart';
import '../../domain/services/sealing_service.dart';

// Provider pour Supabase Client
final _supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Repository Provider
final sealRepositoryProvider = Provider<SealRepository>((ref) {
  final supabase = ref.watch(_supabaseClientProvider);
  return SealRepository(supabase);
});

// Service Provider
final sealingServiceProvider = Provider<SealingService>((ref) {
  return SealingService();
});
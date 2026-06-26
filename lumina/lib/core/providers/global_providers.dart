// lib/core/providers/global_providers.dart
// Providers globaux (Supabase, Isar, SyncQueue)
// NOTE: Repository providers are split by feature to avoid circular dependencies

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider Supabase Client global
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

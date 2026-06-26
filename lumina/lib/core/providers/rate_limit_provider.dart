import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumina/core/providers/supabase_provider.dart';
import 'package:lumina/core/services/rate_limit_service.dart';

part 'rate_limit_provider.g.dart';

@riverpod
RateLimitService rateLimitService(RateLimitServiceRef ref) {
  final supabase = ref.watch(supabaseProvider);
  return RateLimitService(supabase);
}

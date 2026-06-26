import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumina/core/logging/app_logger.dart';

class OnboardingRepository {
  final SupabaseClient _supabase;

  OnboardingRepository(this._supabase);

  Future<void> completeSimpleOnboarding(String userId) async {
    try {
      await _supabase.from('profiles').update({'needs_onboarding': false}).eq('id', userId);
    } catch (e) {
      AppLogger.e('Failed to complete simple onboarding', 'ONBOARDING_REPO', e);
      rethrow;
    }
  }
}

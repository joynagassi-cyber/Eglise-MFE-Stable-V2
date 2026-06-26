import 'package:supabase_flutter/supabase_flutter.dart';

class RateLimitService {
  final SupabaseClient _supabase;

  RateLimitService(this._supabase);

  Future<RateLimitResult> checkLimit({
    required String action,
    required String identifier,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'rate-limit-login',
        body: {
          'action': action,
          'identifier': identifier,
        },
      );

      if (response.status == 429) {
        final data = response.data as Map<String, dynamic>;
        return RateLimitResult(
          allowed: false,
          message: data['message'] as String,
          resetAt: DateTime.fromMillisecondsSinceEpoch(data['resetAt'] as int),
        );
      }

      final data = response.data as Map<String, dynamic>;
      return RateLimitResult(
        allowed: true,
        remaining: data['remaining'] as int,
        resetAt: DateTime.fromMillisecondsSinceEpoch(data['resetAt'] as int),
      );
    } catch (e) {
      return RateLimitResult(allowed: true);
    }
  }
}

class RateLimitResult {
  final bool allowed;
  final String? message;
  final int? remaining;
  final DateTime? resetAt;

  RateLimitResult({
    required this.allowed,
    this.message,
    this.remaining,
    this.resetAt,
  });
}

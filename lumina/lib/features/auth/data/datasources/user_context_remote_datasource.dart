import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/auth/domain/entities/user_context.dart';
import '../../../../core/logging/app_logger.dart';

class UserContextRemoteDataSource {
  final SupabaseClient _client;

  UserContextRemoteDataSource(this._client);

  Future<UserContext> fetchUserContext() async {
    const int maxRetries = 2;
    int currentTry = 0;

    while (currentTry < maxRetries) {
      try {
        final response = await _client.functions
            .invoke('get-user-context')
            .timeout(const Duration(seconds: 5));

        if (response.status == 200 && response.data != null) {
          return UserContext.fromJson(Map<String, dynamic>.from(response.data));
        }

        throw Exception('Status: ${response.status}');
      } catch (e) {
        currentTry++;
        AppLogger.w(
          'fetchUserContext tentative $currentTry/$maxRetries échouée: $e',
          'USER_CONTEXT_DS',
        );
        if (currentTry >= maxRetries) {
          throw Exception(
              'Failed to fetch user context after $maxRetries attempts: $e');
        }
        await Future.delayed(const Duration(milliseconds: 1000));
      }
    }

    throw Exception('Error fetching user context (Unexpected flow)');
  }
}

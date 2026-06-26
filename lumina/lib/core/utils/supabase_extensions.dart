import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Extension pour ajouter timeout automatique aux requêtes Supabase
extension SupabaseQueryTimeout on PostgrestFilterBuilder {
  /// Exécute la requête avec timeout
  ///
  /// Par défaut: 30s
  /// Lance TimeoutException si dépassé
  Future<T> withTimeout<T>({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    return Future.value(this as T).timeout(
      timeout,
      onTimeout: () => throw TimeoutException(
        'Requête trop longue (>${timeout.inSeconds}s)',
        timeout,
      ),
    );
  }
}

/// Extension pour PostgrestBuilder
extension PostgrestBuilderTimeout on PostgrestBuilder {
  Future<T> withTimeout<T>({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    return Future.value(this as T).timeout(
      timeout,
      onTimeout: () => throw TimeoutException(
        'Requête trop longue (>${timeout.inSeconds}s)',
        timeout,
      ),
    );
  }
}

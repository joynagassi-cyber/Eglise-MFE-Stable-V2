// ============================================================
// FICHIER : lib/core/services/supabase_service.dart
// DESCRIPTION : Singleton thread-safe wrappant le client Supabase avec
//               méthodes utilitaires pour requêtes filtrées, upload, realtime.
// DÉPENDANCES : supabase_flutter
// ============================================================

import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

/// Singleton thread-safe pour accéder à Supabase.
///
///  NE PAS MODIFIER SANS REVIEW - Service critique
///
/// Usage:
/// ```dart
/// final data = await SupabaseService.instance.fetchWithRoleFilter('members');
/// await SupabaseService.instance.uploadFile('avatars', bytes, 'photo.jpg');
/// final stream = SupabaseService.instance.watchTable('notifications');
/// ```
class SupabaseService {
  SupabaseService._();
  static final SupabaseService _instance = SupabaseService._();
  static SupabaseService get instance => _instance;

  // ─── Client Access ────────────────────────────────────────────────────

  /// Client Supabase initialisé dans main.dart
  SupabaseClient get client => Supabase.instance.client;

  /// Utilisateur actuellement connecté (null si déconnecté)
  User? get currentUser => client.auth.currentUser;

  /// Vérifie si un utilisateur est authentifié
  bool get isAuthenticated => currentUser != null;

  /// Session active
  Session? get currentSession => client.auth.currentSession;

  /// Stream des changements d'état d'authentification
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // ─── Identity Helpers ─────────────────────────────────────────────────

  /// Retourne l'UUID de l'utilisateur connecté
  String? getCurrentUserId() => currentUser?.id;

  /// Retourne le church_id depuis les user metadata
  String? getCurrentChurchId() {
    return currentUser?.userMetadata?['church_id'] as String? ??
        currentUser?.userMetadata?['active_church_id'] as String?;
  }

  /// Retourne le rôle de l'utilisateur
  String getCurrentRole() {
    return currentUser?.userMetadata?['role'] as String? ?? 'member';
  }

  /// Retourne le group_id (null si superadmin/admin)
  String? getCurrentGroupId() {
    return currentUser?.userMetadata?['group_id'] as String?;
  }

  /// Vérifie si l'utilisateur est superadmin
  bool get isSuperAdmin => getCurrentRole() == 'superadmin';

  // ─── Data Fetching ────────────────────────────────────────────────────

  /// Fetches data from a table with automatic church_id filter applied.
  ///
  /// For superadmins, [churchIdOverride] can be used to query a specific church.
  /// For other roles, the filter is always the user's own church_id.
  ///
  /// Returns the raw List<Map<String, dynamic>> response.
  Future<List<Map<String, dynamic>>> fetchWithRoleFilter(
    String table, {
    String select = '*',
    String? churchIdOverride,
    Map<String, dynamic>? additionalFilters,
    String? orderBy,
    bool ascending = true,
    int? limit,
  }) async {
    final churchId = churchIdOverride ?? getCurrentChurchId();

    var query = client.from(table).select(select);

    // Apply church isolation (superadmin can override or skip)
    if (!isSuperAdmin && churchId != null) {
      query = query.eq('church_id', churchId);
    } else if (isSuperAdmin && churchId != null) {
      query = query.eq('church_id', churchId);
    }

    // Apply additional filters
    if (additionalFilters != null) {
      for (final entry in additionalFilters.entries) {
        query = query.eq(entry.key, entry.value);
      }
    }

    dynamic transformQuery = query;

    // Apply ordering
    if (orderBy != null) {
      transformQuery = transformQuery.order(orderBy, ascending: ascending);
    }

    // Apply limit
    if (limit != null) {
      transformQuery = transformQuery.limit(limit);
    }

    final response = await transformQuery;
    return List<Map<String, dynamic>>.from(response as List);
  }

  // ─── Storage ──────────────────────────────────────────────────────────

  /// Uploads a file to Supabase Storage.
  ///
  /// [bucket] : Storage bucket name (e.g., 'avatars', 'receipts', 'church-logos')
  /// [fileBytes] : Raw file bytes
  /// [fileName] : Name of the file (e.g., 'photo.jpg')
  /// [folder] : Optional subfolder (default: uses church_id/user_id)
  ///
  /// Returns the public URL of the uploaded file.
  Future<String> uploadFile(
    String bucket,
    Uint8List fileBytes,
    String fileName, {
    String? folder,
    FileOptions? fileOptions,
  }) async {
    final userId = getCurrentUserId();
    final churchId = getCurrentChurchId();
    final path = folder ?? '$churchId/$userId';
    final fullPath = '$path/$fileName';

    try {
      await client.storage.from(bucket).uploadBinary(
            fullPath,
            fileBytes,
            fileOptions: fileOptions ??
                FileOptions(
                  upsert: true,
                  contentType: _getMimeType(fileName),
                ),
          );

      final publicUrl = client.storage.from(bucket).getPublicUrl(fullPath);
      debugPrint(' File uploaded: $publicUrl');
      return publicUrl;
    } catch (e) {
      debugPrint('❌ Upload failed: $e');
      rethrow;
    }
  }

  /// Deletes a file from Supabase Storage.
  Future<void> deleteFile(String bucket, String path) async {
    try {
      await client.storage.from(bucket).remove([path]);
      debugPrint(' File deleted: $path');
    } catch (e) {
      debugPrint('❌ Delete failed: $e');
      rethrow;
    }
  }

  // ─── Realtime ─────────────────────────────────────────────────────────

  /// Creates a Realtime stream on a table, filtered by church_id.
  ///
  /// Returns a [Stream] of [PostgresChangePayload] for the specified events.
  Stream<PostgresChangePayload> watchTable(
    String table, {
    PostgresChangeEvent event = PostgresChangeEvent.all,
    String? filterColumn,
    String? filterValue,
  }) {
    final channelName = 'watch:$table:${DateTime.now().millisecondsSinceEpoch}';
    final controller = StreamController<PostgresChangePayload>.broadcast();

    PostgresChangeFilter? filter;
    if (filterColumn != null && filterValue != null) {
      filter = PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: filterColumn,
        value: filterValue,
      );
    }

    final channel = client
        .channel(channelName)
        .onPostgresChanges(
          event: event,
          schema: 'public',
          table: table,
          filter: filter,
          callback: (payload) {
            if (!controller.isClosed) {
              controller.add(payload);
            }
          },
        )
        .subscribe();

    controller.onCancel = () {
      client.removeChannel(channel);
      controller.close();
    };

    return controller.stream;
  }

  // ─── Auth (Legacy — kept for backward compatibility) ──────────────────

  /// Déconnexion
  Future<void> signOut() async {
    try {
      await client.auth.signOut();
      debugPrint(' User signed out successfully');
    } catch (e) {
      debugPrint('❌ Sign out failed: $e');
      rethrow;
    }
  }

  /// Connexion avec email/password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      debugPrint(' User signed in: ${response.user?.email}');
      return response;
    } catch (e) {
      debugPrint('❌ Sign in failed: $e');
      rethrow;
    }
  }

  /// Inscription avec email/password
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: metadata,
      );
      debugPrint(' User registered: ${response.user?.email}');
      return response;
    } catch (e) {
      debugPrint('❌ Registration failed: $e');
      rethrow;
    }
  }

  /// Réinitialisation mot de passe
  Future<void> resetPassword(String email) async {
    try {
      await client.auth.resetPasswordForEmail(email);
      debugPrint(' Password reset email sent to: $email');
    } catch (e) {
      debugPrint('❌ Password reset failed: $e');
      rethrow;
    }
  }

  /// Rafraîchir la session
  Future<AuthResponse> refreshSession() async {
    try {
      final response = await client.auth.refreshSession();
      debugPrint(' Session refreshed');
      return response;
    } catch (e) {
      debugPrint('❌ Session refresh failed: $e');
      rethrow;
    }
  }

  // ─── Private Helpers ──────────────────────────────────────────────────

  String _getMimeType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    return switch (ext) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'gif' => 'image/gif',
      'webp' => 'image/webp',
      'pdf' => 'application/pdf',
      'svg' => 'image/svg+xml',
      _ => 'application/octet-stream',
    };
  }
}

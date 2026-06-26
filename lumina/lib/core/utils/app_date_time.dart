/// Centralized DateTime utility for consistent UTC timestamp handling.
///
/// ALL timestamps destined for Supabase/server storage MUST use these methods
/// instead of raw `DateTime.now()` to ensure UTC consistency.
class AppDateTime {
  AppDateTime._();

  /// Returns the current time in UTC.
  /// Use this instead of `DateTime.now()` for any data persisted to Supabase.
  static DateTime nowUtc() => DateTime.now().toUtc();

  /// Returns the current time in UTC as an ISO 8601 string.
  /// Use this for direct Supabase insertions (e.g., `'created_at': AppDateTime.nowIso()`).
  static String nowIso() => DateTime.now().toUtc().toIso8601String();

  /// Returns the current UTC timestamp in milliseconds since epoch.
  /// Useful for generating unique IDs.
  static int nowMillis() => DateTime.now().toUtc().millisecondsSinceEpoch;

  /// Returns a unique string ID based on the current UTC timestamp.
  static String tempId() =>
      DateTime.now().toUtc().millisecondsSinceEpoch.toString();
}

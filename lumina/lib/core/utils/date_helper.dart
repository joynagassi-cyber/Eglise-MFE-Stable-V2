/// Helper pour migration et parsing flexible des dates
///
/// Gère la transition String → DateTime dans les models
class DateHelper {
  /// Parse une date de manière flexible
  ///
  /// Accepte:
  /// - DateTime (retourné tel quel)
  /// - String ISO 8601
  /// - null
  static DateTime? parseFlexible(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Convertit DateTime en String ISO 8601
  static String? toIso(DateTime? date) {
    return date?.toIso8601String();
  }

  /// Parse une date et retourne en UTC
  static DateTime? parseToUtc(dynamic value) {
    final date = parseFlexible(value);
    return date?.toUtc();
  }

  /// Parse une date et retourne en local
  static DateTime? parseToLocal(dynamic value) {
    final date = parseFlexible(value);
    return date?.toLocal();
  }
}

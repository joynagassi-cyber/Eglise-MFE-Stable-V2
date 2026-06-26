// lib/core/utils/date_formatter.dart
// AMÉLIORATION: Formatage des dates en français et durées relatives (timeago).

import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class DateFormatter {
  static void initialize() {
    // S'assurer que le français est disponible pour timeago
    timeago.setLocaleMessages('fr', timeago.FrMessages());
  }

  /// Retourne un formatage relatif par rapport à maintenant.
  /// Exemple: "il y a 5 minutes"
  static String relative(DateTime date) {
    return timeago.format(date, locale: 'fr');
  }

  /// Retourne un formatage complet.
  /// Exemple: "Lundi 31 Mars 2026"
  static String full(DateTime date) {
    return DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(date);
  }

  /// Retourne un formatage court.
  /// Exemple: "31 Mar 2026"
  static String short(DateTime date) {
    return DateFormat('d MMM yyyy', 'fr_FR').format(date);
  }

  /// Retourne uniquement l'heure.
  /// Exemple: "14:30"
  static String time(DateTime date) {
    return DateFormat('HH:mm', 'fr_FR').format(date);
  }

  /// Retourne la date au format technique pour les logs/db.
  static String technical(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }
}

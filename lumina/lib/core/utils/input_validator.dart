class InputValidator {
  static String sanitizeSearch(String input) =>
      input.replaceAll(RegExp(r'[^\w\s\-àéèêôù]'), '').trim();

  static String sanitizeEmail(String email) => email.trim().toLowerCase();

  static bool isValidEmail(String email) =>
      RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(email);

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName est requis';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!RegExp(r'^\+?[\d\s\-\(\)]+$').hasMatch(value)) {
      return 'Numéro invalide';
    }
    return null;
  }
}


class TraceabilityFormatter {
  /// Format the actor identification as "[Nom] · [Rôle]"
  static String formatActor({
    String? name,
    String? role,
    String? fallbackName = 'Système Automatisé',
  }) {
    final formattedName = (name != null && name.trim().isNotEmpty)
        ? name.trim()
        : fallbackName;
        
    final formattedRole = (role != null && role.trim().isNotEmpty)
        ? role.trim()
        : 'N/A';
        
    if (formattedName == fallbackName) {
      return formattedName!;
    }
    
    return '$formattedName · [$formattedRole]';
  }

  /// Format a complete action sentence like "[Nom] · [Rôle] a effectué [Action]"
  static String formatActionSentence({
    String? name,
    String? role,
    required String actionLabel,
    String? fallbackName = 'Système Automatisé',
  }) {
    final actor = formatActor(name: name, role: role, fallbackName: fallbackName);
    return '$actor a $actionLabel';
  }
}

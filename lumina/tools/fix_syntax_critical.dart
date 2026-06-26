// ignore_for_file: avoid_print
import 'dart:io';

void main() async {
  print('🔧 ANT-WEI - Correction Massive Syntaxe\n');
  
  final fixes = <String, List<Fix>>{
    // member_stats_screen.dart - Erreurs répétées lignes 264, 358, 446, 557, 628
    'lib/features/membres/presentation/screens/member_stats_screen.dart': [
      Fix(pattern: RegExp(r';\s*;\s*\)'), replacement: ');'),
    ],
    
    // password_recovery_screen.dart - userMetadata errors
    'lib/features/auth/presentation/screens/password_recovery_screen.dart': [
      Fix(pattern: RegExp(r'Icons\.userMetadata'), replacement: 'Icons.email'),
      Fix(pattern: RegExp(r'TextInputType\.email\.userMetadata.*?Address'), replacement: 'TextInputType.emailAddress'),
    ],
    
    // register_screen.dart - Same errors
    'lib/features/auth/presentation/screens/register_screen.dart': [
      Fix(pattern: RegExp(r'Icons\.userMetadata'), replacement: 'Icons.email'),
      Fix(pattern: RegExp(r'TextInputType\.email\.userMetadata.*?Address'), replacement: 'TextInputType.emailAddress'),
    ],
    
    // member_form_screen.dart - Same pattern
    'lib/features/membres/presentation/screens/member_form_screen.dart': [
      Fix(pattern: RegExp(r'Icons\.userMetadata'), replacement: 'Icons.email'),
      Fix(pattern: RegExp(r'TextInputType\.email\.userMetadata.*?Address'), replacement: 'TextInputType.emailAddress'),
    ],
    
    // donor_form_screen.dart - Same
    'lib/features/donors/presentation/donor_form_screen.dart': [
      Fix(pattern: RegExp(r'TextInputType\.email\.userMetadata.*?Address'), replacement: 'TextInputType.emailAddress'),
    ],
    
    // donor_list_screen.dart - if without braces
    'lib/features/donors/presentation/donor_list_screen.dart': [
      Fix(pattern: RegExp(r'if \(([^)]+)\)\s+([^{;]+);'), replacement: r'if ($1) { $2; }'),
    ],
    
    // settings_screen.dart - userMetadata error
    'lib/features/settings/presentation/screens/settings_screen.dart': [
      Fix(pattern: RegExp(r'settings\.email\.userMetadata.*?NotificationsEnabled'), replacement: 'settings.notificationsEnabled'),
    ],
  };
  
  int totalFixed = 0;
  
  for (var entry in fixes.entries) {
    final file = File(entry.key);
    if (!file.existsSync()) {
      print('⚠️  ${entry.key} - Fichier introuvable');
      continue;
    }
    
    var content = await file.readAsString();
    var modified = false;
    
    for (var fix in entry.value) {
      if (content.contains(fix.pattern)) {
        content = content.replaceAll(fix.pattern, fix.replacement);
        modified = true;
        totalFixed++;
      }
    }
    
    if (modified) {
      await file.writeAsString(content);
      print('✓ ${entry.key}');
    }
  }
  
  print('\n✅ $totalFixed corrections appliquées');
}

class Fix {
  final Pattern pattern;
  final String replacement;
  
  Fix({required this.pattern, required this.replacement});
}

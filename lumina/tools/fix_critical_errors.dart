// ignore_for_file: avoid_print
import 'dart:io';

void main() async {
  print('🔧 Correction des erreurs critiques...\n');

  final fixes = [
    // Fix 1: password_recovery_screen.dart - ligne 210
    FileFix(
      'lib/features/auth/presentation/screens/password_recovery_screen.dart',
      [
        RegExpFix(
          RegExp(r'prefixIcon:\s*Icons\.email.*?_outlined\),'),
          'prefixIcon: Icons.email_outlined,',
        ),
        RegExpFix(
          RegExp(r'keyboardType:\s*TextInputType\.email.*?Address\),'),
          'keyboardType: TextInputType.emailAddress,',
        ),
      ],
    ),
    
    // Fix 2: register_screen.dart - ligne 305
    FileFix(
      'lib/features/auth/presentation/screens/register_screen.dart',
      [
        RegExpFix(
          RegExp(r'prefixIcon:\s*Icons\.email.*?_outlined\),'),
          'prefixIcon: Icons.email_outlined,',
        ),
        RegExpFix(
          RegExp(r'keyboardType:\s*TextInputType\.email.*?Address\),'),
          'keyboardType: TextInputType.emailAddress,',
        ),
      ],
    ),
    
    // Fix 3: donor_form_screen.dart - ligne 130
    FileFix(
      'lib/features/donors/presentation/donor_form_screen.dart',
      [
        RegExpFix(
          RegExp(r'keyboardType:\s*TextInputType\.email.*?Address\),'),
          'keyboardType: TextInputType.emailAddress,',
        ),
      ],
    ),
    
    // Fix 4: member_form_screen.dart - ligne 322
    FileFix(
      'lib/features/membres/presentation/screens/member_form_screen.dart',
      [
        RegExpFix(
          RegExp(r'prefixIcon:\s*Icons\.email.*?_outlined\),'),
          'prefixIcon: Icons.email_outlined,',
        ),
        RegExpFix(
          RegExp(r'keyboardType:\s*TextInputType\.email.*?Address\),'),
          'keyboardType: TextInputType.emailAddress,',
        ),
      ],
    ),
    
    // Fix 5: settings_screen.dart - ligne 77
    FileFix(
      'lib/features/settings/presentation/screens/settings_screen.dart',
      [
        RegExpFix(
          RegExp(r'\.email.*?NotificationsEnabled\)'),
          '.email ?? \'Non connecté\'',
        ),
      ],
    ),
    
    // Fix 6: donor_list_screen.dart - lignes 86-90
    FileFix(
      'lib/features/donors/presentation/donor_list_screen.dart',
      [
        RegExpFix(
          RegExp(r'if\s*\(donors\.isEmpty\)\s*return\s+EmptyState[^;]*;[\s\n]*;'),
          'if (donors.isEmpty) {\n          return const EmptyState(\n            icon: Icons.person_off,\n            message: \'Aucun donateur trouvé\',\n          );\n        }',
        ),
      ],
    ),
  ];

  for (final fix in fixes) {
    await fix.apply();
  }

  print('\n✅ Corrections terminées!');
}

class FileFix {
  final String path;
  final List<RegExpFix> fixes;

  FileFix(this.path, this.fixes);

  Future<void> apply() async {
    final file = File(path);
    if (!await file.exists()) {
      print('⚠️  Fichier non trouvé: $path');
      return;
    }

    var content = await file.readAsString();
    var modified = false;

    for (final fix in fixes) {
      if (content.contains(fix.pattern)) {
        content = content.replaceAll(fix.pattern, fix.replacement);
        modified = true;
      }
    }

    if (modified) {
      await file.writeAsString(content);
      print('✓ Corrigé: $path');
    }
  }
}

class RegExpFix {
  final RegExp pattern;
  final String replacement;

  RegExpFix(this.pattern, this.replacement);
}

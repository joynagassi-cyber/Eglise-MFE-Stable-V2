// ignore_for_file: avoid_print
import 'dart:io';

void main() async {
  print('🎯 ANT-WEI BATCH FIX - Correction automatique des erreurs');
  
  final fixes = <String, String>{
    // Pattern 1: TextInputType.email invalide
    r'TextInputType\.email \?\? TextInputType\.userMetadata\?\[.*?\] as String\? \?\? .*?Address': 'TextInputType.emailAddress',
    
    // Pattern 2: Icons.userMetadata invalide
    r'Icons\..*? \?\? Icons\.userMetadata\?\[.*?\]': 'Icons.email_outlined',
    
    // Pattern 3: Virgules manquantes avant paramètres nommés
    r'(\w+)\s+(\w+:)': r'$1, $2',
  };
  
  final libDir = Directory('lib');
  int filesFixed = 0;
  int errorsFixed = 0;
  
  await for (final file in libDir.list(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      String content = await file.readAsString();
      final String original = content;
      
      for (final pattern in fixes.entries) {
        final regex = RegExp(pattern.key);
        if (regex.hasMatch(content)) {
          content = content.replaceAll(regex, pattern.value);
          errorsFixed++;
        }
      }
      
      if (content != original) {
        await file.writeAsString(content);
        filesFixed++;
        print('✅ Fixed: ${file.path}');
      }
    }
  }
  
  print('\n📊 RÉSULTATS:');
  print('   Fichiers corrigés: $filesFixed');
  print('   Erreurs corrigées: $errorsFixed');
}

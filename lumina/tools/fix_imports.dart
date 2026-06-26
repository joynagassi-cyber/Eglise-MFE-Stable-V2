#!/usr/bin/env dart
// Fix imports - Ajout automatique des imports manquants

// ignore_for_file: avoid_print
import 'dart:io';

void main() async {
  print('🔧 Ajout imports manquants...\n');
  
  final imports = {
    'context.go': "import 'package:go_router/go_router.dart';",
    'AppRoutes': "import 'package:go_router/go_router.dart';",
    'context.push': "import 'package:go_router/go_router.dart';",
  };
  
  var count = 0;
  final dir = Directory('lib');
  
  await for (final entity in dir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      var content = await entity.readAsString();
      var modified = false;
      
      imports.forEach((pattern, importStatement) {
        if (content.contains(pattern) && !content.contains(importStatement)) {
          final lines = content.split('\n');
          var insertIndex = 0;
          
          // Trouver la position après les imports existants
          for (var i = 0; i < lines.length; i++) {
            if (lines[i].startsWith('import ')) {
              insertIndex = i + 1;
            } else if (insertIndex > 0 && lines[i].trim().isNotEmpty) {
              break;
            }
          }
          
          lines.insert(insertIndex, importStatement);
          content = lines.join('\n');
          modified = true;
        }
      });
      
      if (modified) {
        await entity.writeAsString(content);
        count++;
        print('✓ ${entity.path}');
      }
    }
  }
  
  print('\n✅ $count fichiers corrigés');
}

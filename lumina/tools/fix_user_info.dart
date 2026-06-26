#!/usr/bin/env dart
// Fix UserInfo.email - Correction automatique du breaking change Supabase

// ignore_for_file: avoid_print
import 'dart:io';

void main() async {
  print('🔧 Correction UserInfo.email...\n');
  
  var count = 0;
  final dir = Directory('lib');
  
  await for (final entity in dir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      var content = await entity.readAsString();
      final original = content;
      
      // Pattern 1: user.email direct
      content = content.replaceAllMapped(
        RegExp(r'(\w+)\.email(?!\s*\?\?)'),
        (match) {
          final varName = match.group(1)!;
          return '$varName.email ?? $varName.userMetadata?[\'email\'] as String? ?? \'\'';
        },
      );
      
      if (content != original) {
        await entity.writeAsString(content);
        count++;
        print('✓ ${entity.path}');
      }
    }
  }
  
  print('\n✅ $count fichiers corrigés');
}

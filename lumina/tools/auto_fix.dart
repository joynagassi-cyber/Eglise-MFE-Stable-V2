#!/usr/bin/env dart
// ANT-WEI Auto-Fix Script - Correction automatique des erreurs Flutter
// Usage: dart run tools/auto_fix.dart

// ignore_for_file: avoid_print
import 'dart:io';

void main() async {
  print('🎯 ANT-WEI AUTO-FIX - Démarrage...\n');
  
  final fixer = AutoFixer();
  await fixer.run();
}

class AutoFixer {
  final stats = <String, int>{};
  
  Future<void> run() async {
    print('📊 PHASE 1: Analyse des erreurs...');
    final analysis = await _analyzeProject();
    
    print('\n🔧 PHASE 2: Corrections automatiques...');
    
    await _fixUnusedElements(analysis);
    await _fixUnusedVariables(analysis);
    await _fixUnusedFields(analysis);
    await _fixDeadCode(analysis);
    await _fixEmptyStatements(analysis);
    await _fixCurlyBraces(analysis);
    await _fixUnusedImports(analysis);
    await _fixUndefinedIdentifiers(analysis);
    await _fixUriDoesNotExist(analysis);
    
    print('\n✅ PHASE 3: Formatage...');
    await _formatCode();
    
    print('\n📈 RÉSULTATS:');
    stats.forEach((key, value) {
      print('  ✓ $key: $value corrections');
    });
    
    print('\n🎉 Terminé ! Relancez flutter analyze pour vérifier.');
  }
  
  Future<List<String>> _analyzeProject() async {
    final result = await Process.run(
      'flutter.bat',
      ['analyze', '--no-fatal-infos'],
      workingDirectory: Directory.current.path,
      runInShell: true,
    );
    return result.stdout.toString().split('\n');
  }
  
  Future<void> _fixUnusedElements(List<String> analysis) async {
    final pattern = RegExp(r"warning - The declaration '([^']+)' isn't referenced - ([^:]+):(\d+)");
    var count = 0;
    
    for (final line in analysis) {
      final match = pattern.firstMatch(line);
      if (match != null) {
        final element = match.group(1)!;
        final file = match.group(2)!;
        final lineNum = int.parse(match.group(3)!);
        
        await _commentLines(file, lineNum, '// UNUSED: $element');
        count++;
      }
    }
    
    if (count > 0) stats['unused_element'] = count;
  }
  
  Future<void> _fixUnusedVariables(List<String> analysis) async {
    final pattern = RegExp(r"warning - The value of the local variable '([^']+)' isn't used - ([^:]+):(\d+)");
    var count = 0;
    
    for (final line in analysis) {
      final match = pattern.firstMatch(line);
      if (match != null) {
        final variable = match.group(1)!;
        final file = match.group(2)!;
        final lineNum = int.parse(match.group(3)!);
        
        await _replaceInLine(file, lineNum, variable, '_$variable');
        count++;
      }
    }
    
    if (count > 0) stats['unused_local_variable'] = count;
  }
  
  Future<void> _fixUnusedFields(List<String> analysis) async {
    final pattern = RegExp(r"warning - The value of the field '([^']+)' isn't used - ([^:]+):(\d+)");
    var count = 0;
    
    for (final line in analysis) {
      final match = pattern.firstMatch(line);
      if (match != null) {
        final field = match.group(1)!;
        final file = match.group(2)!;
        final lineNum = int.parse(match.group(3)!);
        
        await _commentLines(file, lineNum, '// UNUSED FIELD: $field');
        count++;
      }
    }
    
    if (count > 0) stats['unused_field'] = count;
  }
  
  Future<void> _fixDeadCode(List<String> analysis) async {
    final pattern = RegExp(r'warning - Dead code - ([^:]+):(\d+)');
    var count = 0;
    
    for (final line in analysis) {
      final match = pattern.firstMatch(line);
      if (match != null) {
        final file = match.group(1)!;
        final lineNum = int.parse(match.group(2)!);
        
        await _deleteLine(file, lineNum);
        count++;
      }
    }
    
    if (count > 0) stats['dead_code'] = count;
  }
  
  Future<void> _fixEmptyStatements(List<String> analysis) async {
    final pattern = RegExp(r'info - Unnecessary empty statement - ([^:]+):(\d+)');
    var count = 0;
    
    for (final line in analysis) {
      final match = pattern.firstMatch(line);
      if (match != null) {
        final file = match.group(1)!;
        final lineNum = int.parse(match.group(2)!);
        
        await _removeEmptyStatement(file, lineNum);
        count++;
      }
    }
    
    if (count > 0) stats['empty_statements'] = count;
  }
  
  Future<void> _fixCurlyBraces(List<String> analysis) async {
    final pattern = RegExp(r'info - Statements in an if should be enclosed in a block - ([^:]+):(\d+)');
    var count = 0;
    
    for (final line in analysis) {
      final match = pattern.firstMatch(line);
      if (match != null) {
        final file = match.group(1)!;
        final lineNum = int.parse(match.group(2)!);
        
        await _addCurlyBraces(file, lineNum);
        count++;
      }
    }
    
    if (count > 0) stats['curly_braces'] = count;
  }
  
  Future<void> _fixUnusedImports(List<String> analysis) async {
    final pattern = RegExp(r"warning - Unused import: '([^']+)' - ([^:]+):(\d+)");
    var count = 0;
    
    for (final line in analysis) {
      final match = pattern.firstMatch(line);
      if (match != null) {
        final file = match.group(2)!;
        final lineNum = int.parse(match.group(3)!);
        
        await _deleteLine(file, lineNum);
        count++;
      }
    }
    
    if (count > 0) stats['unused_import'] = count;
  }
  
  Future<void> _fixUndefinedIdentifiers(List<String> analysis) async {
    final fixes = <String, String>{
      'AppRoutes': "import 'package:go_router/go_router.dart';",
      'AppAnimations': "import '../../../../core/theme/app_animations.dart';",
      'AppSpacing': "import '../../../../core/theme/app_spacing.dart';",
      'AppColors': "import '../../../../core/theme/app_colors.dart';",
      'AppButton': "import '../../../../core/widgets/app_button.dart';",
    };
    
    final pattern = RegExp(r"error - Undefined name '([^']+)' - ([^:]+):(\d+)");
    var count = 0;
    
    for (final line in analysis) {
      final match = pattern.firstMatch(line);
      if (match != null) {
        final identifier = match.group(1)!;
        final file = match.group(2)!;
        
        if (fixes.containsKey(identifier)) {
          await _addImportIfMissing(file, fixes[identifier]!);
          count++;
        }
      }
    }
    
    if (count > 0) stats['undefined_identifier'] = count;
  }
  
  Future<void> _fixUriDoesNotExist(List<String> analysis) async {
    final pattern = RegExp(r"error - Target of URI doesn't exist: '([^']+)' - ([^:]+):(\d+)");
    var count = 0;
    
    for (final line in analysis) {
      final match = pattern.firstMatch(line);
      if (match != null) {
        final uri = match.group(1)!;
        final file = match.group(2)!;
        final lineNum = int.parse(match.group(3)!);
        
        await _commentLines(file, lineNum, '// BROKEN IMPORT: $uri');
        count++;
      }
    }
    
    if (count > 0) stats['uri_does_not_exist'] = count;
  }
  
  Future<void> _commentLines(String filePath, int lineNum, String comment) async {
    final file = File(filePath);
    if (!await file.exists()) return;
    
    final lines = await file.readAsLines();
    if (lineNum > 0 && lineNum <= lines.length) {
      lines[lineNum - 1] = '// ${lines[lineNum - 1]} $comment';
      await file.writeAsString(lines.join('\n'));
    }
  }
  
  Future<void> _deleteLine(String filePath, int lineNum) async {
    final file = File(filePath);
    if (!await file.exists()) return;
    
    final lines = await file.readAsLines();
    if (lineNum > 0 && lineNum <= lines.length) {
      lines.removeAt(lineNum - 1);
      await file.writeAsString(lines.join('\n'));
    }
  }
  
  Future<void> _replaceInLine(String filePath, int lineNum, String oldText, String newText) async {
    final file = File(filePath);
    if (!await file.exists()) return;
    
    final lines = await file.readAsLines();
    if (lineNum > 0 && lineNum <= lines.length) {
      lines[lineNum - 1] = lines[lineNum - 1].replaceAll(oldText, newText);
      await file.writeAsString(lines.join('\n'));
    }
  }
  
  Future<void> _removeEmptyStatement(String filePath, int lineNum) async {
    final file = File(filePath);
    if (!await file.exists()) return;
    
    final lines = await file.readAsLines();
    if (lineNum > 0 && lineNum <= lines.length) {
      lines[lineNum - 1] = lines[lineNum - 1].replaceAll(RegExp(r';\s*;'), ';');
      await file.writeAsString(lines.join('\n'));
    }
  }
  
  Future<void> _addCurlyBraces(String filePath, int lineNum) async {
    final file = File(filePath);
    if (!await file.exists()) return;
    
    final lines = await file.readAsLines();
    if (lineNum > 0 && lineNum <= lines.length) {
      final line = lines[lineNum - 1];
      final indent = line.substring(0, line.length - line.trimLeft().length);
      
      lines[lineNum - 1] = '$line {';
      lines.insert(lineNum, '$indent}');
      await file.writeAsString(lines.join('\n'));
    }
  }
  
  Future<void> _addImportIfMissing(String filePath, String importStatement) async {
    final file = File(filePath);
    if (!await file.exists()) return;
    
    final content = await file.readAsString();
    if (!content.contains(importStatement)) {
      final lines = await file.readAsLines();
      
      var insertIndex = 0;
      for (var i = 0; i < lines.length; i++) {
        if (lines[i].startsWith('import ')) {
          insertIndex = i + 1;
        } else if (insertIndex > 0) {
          break;
        }
      }
      
      lines.insert(insertIndex, importStatement);
      await file.writeAsString(lines.join('\n'));
    }
  }
  
  Future<void> _formatCode() async {
    await Process.run('dart', ['format', 'lib/', 'test/'], runInShell: true);
  }
}

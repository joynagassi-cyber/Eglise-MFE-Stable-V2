// ignore_for_file: avoid_print
import 'dart:io';

void main() async {
  print('🔍 Analyse des erreurs restantes...\n');
  
  final result = await Process.run(
    'flutter.bat',
    ['analyze', '--no-fatal-infos'],
    runInShell: true,
  );
  
  final lines = result.stdout.toString().split('\n');
  final errors = <String, List<String>>{};
  final warnings = <String, List<String>>{};
  final infos = <String, List<String>>{};
  
  for (var line in lines) {
    if (line.contains('error •')) {
      final type = _extractType(line);
      errors.putIfAbsent(type, () => []).add(line);
    } else if (line.contains('warning •')) {
      final type = _extractType(line);
      warnings.putIfAbsent(type, () => []).add(line);
    } else if (line.contains('info •')) {
      final type = _extractType(line);
      infos.putIfAbsent(type, () => []).add(line);
    }
  }
  
  print('═══════════════════════════════════════');
  print('ERREURS (${errors.values.fold(0, (sum, list) => sum + list.length)})');
  print('═══════════════════════════════════════');
  errors.forEach((type, list) {
    print('  $type: ${list.length}');
  });
  
  print('\n═══════════════════════════════════════');
  print('WARNINGS (${warnings.values.fold(0, (sum, list) => sum + list.length)})');
  print('═══════════════════════════════════════');
  warnings.forEach((type, list) {
    print('  $type: ${list.length}');
  });
  
  print('\n═══════════════════════════════════════');
  print('INFOS (${infos.values.fold(0, (sum, list) => sum + list.length)})');
  print('═══════════════════════════════════════');
  infos.forEach((type, list) {
    print('  $type: ${list.length}');
  });
  
  // Top 5 erreurs avec exemples
  print('\n\n🎯 TOP 5 ERREURS À CORRIGER:\n');
  final sortedErrors = errors.entries.toList()
    ..sort((a, b) => b.value.length.compareTo(a.value.length));
  
  for (var i = 0; i < 5 && i < sortedErrors.length; i++) {
    final entry = sortedErrors[i];
    print('${i + 1}. ${entry.key} (${entry.value.length} occurrences)');
    print('   Exemple: ${entry.value.first.trim()}');
    print('');
  }
}

String _extractType(String line) {
  final match = RegExp(r'• ([a-z_]+) •').firstMatch(line);
  return match?.group(1) ?? 'unknown';
}

// ignore_for_file: avoid_print

import 'dart:io';

void main() async {
  final libDir = Directory('lib');
  if (!await libDir.exists()) {
    print('Error: lib directory not found. Run this from the project root.');
    exit(1);
  }

  print('Scanning for .g.dart files in lib/ ...');
  final files = libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.g.dart'));

  int patchedCount = 0;
  final largeIntPattern = RegExp(r'\b(-?\d{16,})\b');

  for (final file in files) {
    final content = await file.readAsString();
    if (largeIntPattern.hasMatch(content)) {
      print('Patching ${file.path}...');
      
      final updatedContent = content.replaceAllMapped(largeIntPattern, (match) {
        final original = match.group(1)!;
        final value = double.parse(original);
        final rounded = value.toStringAsFixed(0);
        
        if (original != rounded) {
          print('  $original -> $rounded');
        }
        return rounded;
      });

      if (content != updatedContent) {
        await file.writeAsString(updatedContent);
        patchedCount++;
      }
    }
  }

  print('\nFinished! Patched $patchedCount files.');
}

// ignore_for_file: avoid_print
//
// check_corruptions.dart
// ======================
// Détecte les corruptions de code (insertions intempestives de "const" ou
// fragmentations d'identifiants) dans les fichiers .dart du projet.
//
// Usage :
//   dart run scripts/check_corruptions.dart                          # scanne lib/ + test/
//   dart run scripts/check_corruptions.dart --path lib/features/bilan # chemin personnalisé
//   dart run scripts/check_corruptions.dart --fix                     # corrige automatiquement
//   dart run scripts/check_corruptions.dart --json                    # sortie JSON
//
// Codes de sortie :
//   0 = aucune corruption
//   1 = au moins une corruption trouvée

import 'dart:convert';
import 'dart:io';

const _defaultPaths = ['lib', 'test', 'integration_test'];
final _excludedPatterns = RegExp(r'\.(g|freezed)\.dart$');

/// Chaque pattern de corruption est défini avec :
///   - `pattern` : expression régulière trouvée sur une ligne
///   - `suggestion` : correctif suggéré ou description
///   - `severity` : error / warning
typedef _CorruptionRule = ({String name, String description, RegExp regex, bool autoFixable});

final List<_CorruptionRule> _rules = [
  // ─── Multi-const ───────────────────────────────────────────
  (
    name: 'triple-const',
    description: 'const const const → const',
    regex: RegExp(r'''const\s+const\s+const\b'''),
    autoFixable: true,
  ),
  (
    name: 'double-const',
    description: 'const const → const (SizedBox, Text, Icon, etc.)',
    regex: RegExp(r'''(?<!\bconst\s+)const\s+const\b(?!\s+const\b)'''),
    autoFixable: true,
  ),

  // ─── Const sur parenthèse/bracket/brace ───────────────────
  (
    name: 'const-paren',
    description: 'const ) → )',
    regex: RegExp(r'''const\s+\)'''),
    autoFixable: true,
  ),
  (
    name: 'const-bracket',
    description: 'const ] → ]',
    regex: RegExp(r'''const\s+\]'''),
    autoFixable: true,
  ),
  (
    name: 'const-brace',
    description: 'const } → }',
    regex: RegExp(r'''const\s+\}'''),
    autoFixable: true,
  ),

  // ─── Const sur paramètre nommé (color:, icon:, child:, shrinkWrap:) ──
  (
    name: 'const-named-param-color',
    description: 'const color: → color: (paramètre nommé)',
    regex: RegExp(r'''^(?!\s*//)(\s*)const\s+(color|icon|child|shrinkWrap|crossAxisCount|mainAxisSpacing|crossAxisSpacing|childAspectRatio|padding|margin|onTap|onPressed|label|title|subtitle|trailing|leading)\s*:''', multiLine: true),
    autoFixable: true,
  ),

  // ─── Identifiants fragmentés (insertion de "const" au milieu) ────
  (
    name: 'conconst-context',
    description: 'conconst → context (fragmentation)',
    regex: RegExp(r'''conconst'''),
    autoFixable: true,
  ),
  (
    name: 'Routconst-routes',
    description: 'Routconst → Routes (fragmentation AppRoutes)',
    regex: RegExp(r'''Routconst'''),
    autoFixable: true,
  ),
  (
    name: 'Iconconst-icon',
    description: 'Iconconst → Icon (fragmentation)',
    regex: RegExp(r'''Iconconst'''),
    autoFixable: true,
  ),
  (
    name: 'Icoconst-icon',
    description: 'Icoconst → Icon (fragmentation)',
    regex: RegExp(r'''Icoconst'''),
    autoFixable: true,
  ),
  (
    name: 'Icconst-icons',
    description: 'Icconst → Icons / Icon (fragmentation ambigüe, correction manuelle)',
    regex: RegExp(r'''Icconst'''),
    autoFixable: false,
  ),
  (
    name: 'chconst-child',
    description: 'chconst → child (fragmentation)',
    regex: RegExp(r'''chconst'''),
    autoFixable: true,
  ),
  (
    name: 'Desconst-design',
    description: 'Desconst → Design (fragmentation LuminaDesign)',
    regex: RegExp(r'''Desconst'''),
    autoFixable: true,
  ),
  (
    name: 'grconst-grey',
    description: 'grconst → grey (fragmentation Colors.grey)',
    regex: RegExp(r'''grconst'''),
    autoFixable: true,
  ),
  (
    name: 'orconst-orange',
    description: 'orconst → orange/an (fragmentation)',
    regex: RegExp(r'''orconst'''),
    autoFixable: true,
  ),
  (
    name: 'reconst-refresh',
    description: 'reconst → refresh/red/an (fragmentation)',
    regex: RegExp(r'''reconst'''),
    autoFixable: true,
  ),
  (
    name: 'blconst-color',
    description: 'blconst → blue/black (fragmentation)',
    regex: RegExp(r'''blconst'''),
    autoFixable: true,
  ),
  (
    name: 'whconst-white',
    description: 'whconst → white (fragmentation)',
    regex: RegExp(r'''whconst'''),
    autoFixable: true,
  ),
  (
    name: 'colorconst-color',
    description: 'colorconst → color: ou context.colors (selon contexte)',
    regex: RegExp(r'''colorconst'''),
    autoFixable: false,
  ),
  (
    name: 'Navigatorconst-navigator',
    description: 'Navigatorconst → Navigator (fragmentation)',
    regex: RegExp(r'''Navigatorconst'''),
    autoFixable: true,
  ),
  (
    name: 'OutlineInputBorconst',
    description: 'OutlineInputBorconst → OutlineInputBorder (fragmentation)',
    regex: RegExp(r'''OutlineInputBorconst'''),
    autoFixable: true,
  ),
  (
    name: 'errorconst-error',
    description: 'errorconst → error: (fragmentation, correction manuelle)',
    regex: RegExp(r'''errorconst\s*:'''),
    autoFixable: false,
  ),
  (
    name: 'donorconst-donor',
    description: 'donorconst → donor (fragmentation)',
    regex: RegExp(r'''donorconst'''),
    autoFixable: true,
  ),
  (
    name: 'AppTypogrconst',
    description: 'AppTypogrconst → AppTypography (fragmentation)',
    regex: RegExp(r'''AppTypogrconst'''),
    autoFixable: true,
  ),
  (
    name: 'branconst-brand',
    description: 'branconst → brand (fragmentation brandPrimary)',
    regex: RegExp(r'''branconst'''),
    autoFixable: true,
  ),
  (
    name: 'scheduleDesconst',
    description: 'scheduleDesconst → scheduleDescription (fragmentation)',
    regex: RegExp(r'''scheduleDesconst'''),
    autoFixable: true,
  ),
  (
    name: 'grouconst-group',
    description: 'grouconst → group (fragmentation)',
    regex: RegExp(r'''grouconst'''),
    autoFixable: true,
  ),
  (
    name: 'colorSchconst',
    description: 'colorSchconst → colorScheme (fragmentation)',
    regex: RegExp(r'''colorSchconst'''),
    autoFixable: true,
  ),
  (
    name: 'AppRoutes-const',
    description: 'AppRoutes. suivie de const → AppRoutes.route',
    regex: RegExp(r'''AppRoutes\.\s*const\b'''),
    autoFixable: true,
  ),
];

/// Résultat pour une corruption trouvée.
class _CorruptionResult {
  final String file;
  final int line;
  final int column;
  final String ruleName;
  final String description;
  final String lineContent;
  final bool autoFixable;

  const _CorruptionResult({
    required this.file,
    required this.line,
    required this.column,
    required this.ruleName,
    required this.description,
    required this.lineContent,
    required this.autoFixable,
  });
}

List<_CorruptionResult> _scanFile(String filePath) {
  final results = <_CorruptionResult>[];
  final lines = File(filePath).readAsLinesSync();

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (line.trim().isEmpty || line.trimLeft().startsWith('//')) continue;

    for (final rule in _rules) {
      for (final match in rule.regex.allMatches(line)) {
        final col = match.start + 1;
        results.add(_CorruptionResult(
          file: filePath,
          line: i + 1,
          column: col,
          ruleName: rule.name,
          description: rule.description,
          lineContent: line.trim(),
          autoFixable: rule.autoFixable,
        ));
      }
    }
  }

  return results;
}

List<String> _collectDartFiles(List<String> paths) {
  final files = <String>[];
  for (final p in paths) {
    final dir = Directory(p);
    if (!dir.existsSync()) {
      print("⚠️  Chemin introuvable : $p");
      continue;
    }
    dir.listSync(recursive: true).forEach((entity) {
      if (entity is File &&
          entity.path.endsWith('.dart') &&
          !_excludedPatterns.hasMatch(entity.path)) {
        files.add(entity.path);
      }
    });
  }
  return files;
}

void _printResults(
  List<_CorruptionResult> results, {
  bool json = false,
  bool showSummary = true,
}) {
  if (json) {
    final output = {
      'total': results.length,
      'corruptions': results
          .map((r) => {
                'file': r.file,
                'line': r.line,
                'column': r.column,
                'rule': r.ruleName,
                'description': r.description,
                'content': r.lineContent,
              })
          .toList(),
    };
    print(const JsonEncoder.withIndent('  ').convert(output));
    return;
  }

  if (results.isEmpty) {
    print("✅ Aucune corruption trouvée !");
    return;
  }

  // Grouper par fichier
  final byFile = <String, List<_CorruptionResult>>{};
  for (final r in results) {
    byFile.putIfAbsent(r.file, () => []).add(r);
  }

  print("═══════════════════════════════════════════════════════");
  print("  🔍 Scan de corruptions — ${results.length} trouvée(s)");
  print("═══════════════════════════════════════════════════════\n");

  for (final entry in byFile.entries) {
    print("  📄 ${entry.key}");
    for (final r in entry.value) {
      final icon = r.autoFixable ? '🛠' : '⚠️';
      print(
          "    $icon L${r.line}:${r.column} [${r.ruleName}] ${r.description}");
      print("       → ${r.lineContent.substring(0, r.lineContent.length.clamp(0, 120))}");
    }
    print("");
  }

  if (showSummary) {
    // Résumé par règle
    final byRule = <String, int>{};
    for (final r in results) {
      byRule.update(r.ruleName, (v) => v + 1, ifAbsent: () => 1);
    }

    print("═══════════════════════════════════════════════════════");
    print("  📊 Résumé par type de corruption");
    print("═══════════════════════════════════════════════════════");
    final sorted = byRule.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    for (final entry in sorted) {
      final desc =
          _rules.firstWhere((r) => r.name == entry.key).description;
      print("  ${entry.value.toString().padLeft(4)} × $desc");
    }
    print("");
  }
}

/// Applique les corrections automatiques pour les corruptions autoFixable.
/// Approche conservative : ne corrige que les patterns sans ambiguïté.
int _applyFixes(List<_CorruptionResult> results) {
  // Grouper par fichier pour ne lire/écrire chaque fichier qu'une fois
  final byFile = <String, List<_CorruptionResult>>{};
  for (final r in results.where((r) => r.autoFixable)) {
    byFile.putIfAbsent(r.file, () => []).add(r);
  }

  int totalFixed = 0;

  for (final entry in byFile.entries) {
    final filePath = entry.key;
    var content = File(filePath).readAsStringSync();
    String? previous;

    int iterations = 0;
    while (content != previous && iterations < 10) {
      previous = content;
      for (final rule in _rules) {
        if (!rule.autoFixable) continue;
        content = _applyRule(content, rule);
      }
      iterations++;
    }

    if (content != File(filePath).readAsStringSync()) {
      File(filePath).writeAsStringSync(content);
      totalFixed++;
      print("  ✅ Corrigé : $filePath");
    }
  }

  return totalFixed;
}

String _applyRule(String content, _CorruptionRule rule) {
  return content.replaceAllMapped(rule.regex, (match) {
    return _replacementFor(rule.name, match);
  });
}

String _replacementFor(String ruleName, [Match? match]) {
  return switch (ruleName) {
    'triple-const' => 'const',
    'double-const' => 'const',
    'const-paren' => ')',
    'const-bracket' => ']',
    'const-brace' => '}',
    // Préserve le paramètre nommé et le ":", supprime uniquement "const"
    'const-named-param-color' => _preserveNamedParam(match),
    'conconst-context' => 'context',
    'Routconst-routes' => 'Routes',
    'Iconconst-icon' => 'Icon',
    'Icoconst-icon' => 'Icon',
    'Icconst-icons' => 'Icons',
    'chconst-child' => 'child',
    'Desconst-design' => 'Design',
    'grconst-grey' => 'grey',
    'orconst-orange' => 'orange',
    'reconst-refresh' => 'refresh',
    'blconst-color' => 'blue',
    'whconst-white' => 'white',
    'Navigatorconst-navigator' => 'Navigator',
    'OutlineInputBorconst' => 'OutlineInputBorder',
    'errorconst-error' => 'error',
    'donorconst-donor' => 'donor',
    'AppTypogrconst' => 'AppTypography',
    'branconst-brand' => 'brand',
    'scheduleDesconst' => 'scheduleDescription',
    'grouconst-group' => 'group',
    'colorSchconst' => 'colorScheme',
    'AppRoutes-const' => 'AppRoutes.',
    _ => throw ArgumentError('Règle inconnue ou non fixable : $ruleName'),
  };
}

/// Pour le pattern `const-named-param-color`, on veut garder
/// l'indentation et le paramètre nommé, en supprimant seulement `const`.
/// Exemple : "        const        color:" → "        color:"
String _preserveNamedParam(Match? match) {
  if (match == null || match.groupCount < 2) return '';
  // Groupe 1 = l'indentation (les espaces avant)
  // Groupe 2 = le nom du paramètre
  // Le regex: ^(?!\s*//)(\s*)const\s+(color|icon|...)\s*:
  final indent = match.group(1) ?? '';
  final paramName = match.group(2) ?? '';
  return '$indent$paramName:';
}

Future<void> main(List<String> args) async {
  final paths = <String>[];
  bool fix = false;
  bool json = false;

  for (var i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--path':
        i++;
        if (i < args.length) paths.add(args[i]);
      case '--fix':
        fix = true;
      case '--json':
        json = true;
      default:
        // Ignorer les flags inconnus
        break;
    }
  }

  if (paths.isEmpty) paths.addAll(_defaultPaths);

  print("🔎 Scan de corruptions dans ${paths.join(', ')}...\n");

  final files = _collectDartFiles(paths);
  print("📁 ${files.length} fichiers .dart trouvés\n");

  final allResults = <_CorruptionResult>[];
  for (final file in files) {
    try {
      allResults.addAll(_scanFile(file));
    } catch (e) {
      print("⚠️  Erreur lors du scan de $file : $e");
    }
  }

  _printResults(allResults, json: json);

  if (fix && allResults.isNotEmpty) {
    print("\n🛠  Application des corrections automatiques...\n");
    final fixed = _applyFixes(allResults);
    print("\n✅ $fixed corruption(s) corrigée(s) automatiquement.\n");
  }

  // Résumé final
  final autoFixable = allResults.where((r) => r.autoFixable).length;
  final nonFixable = allResults.length - autoFixable;
  print(
      "📊 ${allResults.length} corruption(s) trouvée(s) ($autoFixable auto-réparable(s), $nonFixable manuelle(s)).");

  exit(allResults.isEmpty ? 0 : 1);
}

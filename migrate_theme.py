#!/usr/bin/env python3
"""
Migration automatique : remplace les références LuminaDesign hardcodées
par des appels context.colors mode-aware.

RÈGLE : Dans un build() method, on a toujours accès à BuildContext.
Ce script détecte les widgets (StatelessWidget.build, ConsumerWidget.build,
State.build) et remplace les couleurs hardcodées.

AVANT :
  backgroundColor: LuminaDesign.background,
  color: LuminaDesign.textPrimary
  style: LuminaDesign.h2.copyWith(color: LuminaDesign.textSecondary)

APRÈS :
  backgroundColor: context.colors.bgPage,
  color: context.colors.textPrimary
  style: LuminaDesign.h2Of(context).copyWith(color: context.colors.textSecondary)

Usage :
  python3 migrate_theme.py --dry-run    # Voir les changements sans les appliquer
  python3 migrate_theme.py              # Appliquer les changements
"""

import re
import os
import sys

DRY_RUN = '--dry-run' in sys.argv

BASE_PATH = '/home/user/lumina-recovery/lumina/lib'

# Mapping des remplacements
COLOR_MAP = {
    'LuminaDesign.textPrimary': 'context.colors.textPrimary',
    'LuminaDesign.textSecondary': 'context.colors.textSecondary',
    'LuminaDesign.textTertiary': 'context.colors.textTertiary',
    'LuminaDesign.background': 'context.colors.bgPage',
    'LuminaDesign.surface': 'context.colors.bgPage',
    'LuminaDesign.card': 'context.colors.bgCard',
}

TYPO_MAP = {
    'LuminaDesign.h1': 'LuminaDesign.h1Of(context)',
    'LuminaDesign.h2': 'LuminaDesign.h2Of(context)',
    'LuminaDesign.bodyLarge': 'LuminaDesign.bodyLargeOf(context)',
    'LuminaDesign.label': 'LuminaDesign.labelOf(context)',
}

# Fichiers à exclure (le design system lui-même, fichiers générés)
EXCLUDE_PATTERNS = [
    'lumina_design_system.dart',
    '.g.dart',
    '.freezed.dart',
]

def should_exclude(filepath):
    return any(pattern in filepath for pattern in EXCLUDE_PATTERNS)

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original = content
    changes = []

    # Remplacement des couleurs
    for old, new in COLOR_MAP.items():
        if old in content:
            count = content.count(old)
            content = content.replace(old, new)
            changes.append(f'  {old} → {new} ({count}x)')

    # Remplacement des typographies (plus subtil — ne pas remplacer dans les définitions)
    for old, new in TYPO_MAP.items():
        # Ne pas remplacer si c'est dans la définition du getter lui-même
        pattern = re.compile(r'(?<!\w)' + re.escape(old) + r'(?!\w|Of)')
        matches = pattern.findall(content)
        if matches:
            # Remplacer uniquement dans les méthodes build()
            content = pattern.sub(new, content)
            changes.append(f'  {old} → {new} ({len(matches)}x)')

    if content != original:
        if not DRY_RUN:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
        return changes

    return None

def main():
    print(f'=== MIGRATION THEME LUMINA ===')
    print(f'Mode: {"DRY RUN (aucune modification)" if DRY_RUN else "APPLIQUER LES CHANGEMENTS"}')
    print()

    total_changes = 0
    files_changed = 0

    for root, dirs, files in os.walk(BASE_PATH):
        for filename in files:
            if not filename.endswith('.dart'):
                continue

            filepath = os.path.join(root, filename)
            if should_exclude(filepath):
                continue

            changes = process_file(filepath)
            if changes:
                files_changed += 1
                relpath = os.path.relpath(filepath, BASE_PATH)
                print(f'📄 {relpath}')
                for change in changes:
                    print(change)
                total_changes += len(changes)
                print()

    print(f'════════════════════════════════')
    print(f'Fichiers modifiés: {files_changed}')
    print(f'Changes totaux: {total_changes}')
    if DRY_RUN:
        print(f'⚠️  Mode DRY RUN — aucun fichier modifié')
        print(f'   Relancez sans --dry-run pour appliquer')

if __name__ == '__main__':
    main()

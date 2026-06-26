# 🔬 DIAGNOSTIC : Pourquoi le Dark/Light Mode est cassé

## Le Problème Racine

Lumina a **3 systèmes de couleurs concurrents** qui se contredisent :

| Système | Fichier | Mode-aware ? | Utilisé dans |
|---|---|---|---|
| `LuminaDesign` | `lumina_design_system.dart` | ❌ **COULEURS HARDCODÉES** | 98+ écrans/widgets |
| `LuminaColorsExtension` | `lumina_colors_extension.dart` | ✅ Light + Dark | Écrans récents |
| `Color(0x...)` inline | 80+ fichiers | ❌ **MAUVAIS DANS LES DEUX MODES** | Partout |

### Le coupable #1 : `LuminaDesign`

```dart
// ❌ Ces couleurs sont TOUJOURNES les mêmes, peu importe le mode !
static const Color textPrimary = Color(0xFF1A1C1E);    // Noir → invisible en dark !
static const Color background = Color(0xFFF1F3F5);     // Gris clair → éblouissant en dark !
static const Color card = Color(0xFFFFFFFF);            // Blanc → invisible en dark !
```

### Le coupable #2 : 80+ couleurs hex inline

```dart
// ❌ Éparpillées dans 80 fichiers — jamais adaptées au mode
color: Color(0xFF333333)   // Trop sombre en dark mode
color: Color(0xFF757575)   // Disparaît sur fond sombre
```

## La Solution : Principe du "Single Source of Truth"

La bonne architecture (validée par Flutter, React Native/Tailwind, iOS, Android) :

```
┌─────────────────────────────────────────────────────┐
│           TOKENS (lumina_tokens.dart)                │
│   LuminaLight.textPrimary  = #121212                │
│   LuminaDark.textPrimary   = #F0F0F0                │
└──────────────────────┬──────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────┐
│     THEME EXTENSION (LuminaColorsExtension)          │
│   light.textPrimary = LuminaLight.textPrimary        │
│   dark.textPrimary  = LuminaDark.textPrimary         │
└──────────────────────┬──────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────┐
│          CONTEXT ACCESSOR (context.colors)            │
│   Text(style: TextStyle(color: context.colors.text)) │
│   → AUTO-MATIQUEMENT bon en light OU dark            │
└──────────────────────────────────────────────────────┘
```

## Ce que font les autres frameworks

| Framework | Méthode | Équivalent Flutter |
|---|---|---|
| **Tailwind CSS** | `@theme { --color-text: ... }` + `dark: { --color-text: ... }` | `ThemeExtension` light/dark |
| **NativeWind v4** | CSS custom properties + `prefers-color-scheme` | `context.colors` (déjà existant !) |
| **iOS (SwiftUI)** | `Color(.label)` adapte automatiquement | `ColorScheme.onSurface` |
| **Android (M3)** | `?attr/colorOnSurface` | `ColorScheme.onSurface` |
| **Figma** | Design tokens avec modes | `lumina_tokens.dart` (déjà existant !) |

## Règle d'Or (WCAG 2.1 AA)

- Ratio de contraste minimum : **4.5:1** pour le texte normal
- Ratio minimum : **3:1** pour le texte large (18px+)
- **JAMAIS** de couleur hardcodée dans un widget — TOUJOURS via `context.colors`

## Plan d'Exécution

1. **Rendre `LuminaDesign` mode-aware** (getter contextuels au lieu de const)
2. **Créer un script de migration** qui remplace automatiquement les références
3. **Ajouter un lint custom** pour empêcher les couleurs hardcodées à l'avenir

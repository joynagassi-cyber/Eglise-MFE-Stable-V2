# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.
# CLAUDE.md — Lumina Project Reference

> Ce fichier est la référence absolue pour tout agent IA travaillant sur Lumina.
> Lis-le entièrement avant d'écrire la moindre ligne de code.

---

## 1. VUE D'ENSEMBLE DU PROJET

**Lumina** est une application mobile de gestion d'église, multi-tenant, de niveau entreprise.

| Attribut | Valeur |
|---|---|
| Plateforme | Flutter / Dart (mobile iOS + Android) |
| Taille | ~300 000 lignes de code |
| Écrans | 104 écrans |
| Dashboards | 8 (un par rôle utilisateur) |
| Groupes ministériels | 6 |
| Langues | Français + Anglais (bilingue) |
| Devise | FCFA |
| Architecture | Clean Architecture stricte |
| Multi-tenant | Oui — support multi-église |

---

## 2. STACK TECHNIQUE COMPLÈTE

```
UI            → Flutter / Dart
État          → Riverpod + code generation (riverpod_generator)
Backend       → Supabase (PostgreSQL + RLS + Auth + Storage + Realtime)
Navigation    → GoRouter avec guards RBAC
Cache local   → Isar (offline-first, base locale embarquée)
Architecture  → Clean Architecture (domain / data / presentation)
Auth          → Supabase Auth (email/password + Google OAuth)
Graphiques    → fl_chart
Localisation  → flutter_localizations (fr_FR + en_US)
```

---

## 3. ARCHITECTURE — STRUCTURE DES DOSSIERS

```
lib/
├── core/
│   ├── constants/        # AppRoutes, AppColors, AppSizes
│   ├── errors/           # Failures, Exceptions
│   ├── usecases/         # UseCase base class
│   └── utils/            # Helpers, extensions
├── features/
│   ├── auth/
│   │   ├── domain/       # entities, repositories (interfaces), usecases
│   │   ├── data/         # models, repositories (impl), datasources
│   │   └── presentation/ # screens, widgets, providers
│   ├── onboarding/
│   ├── members/
│   ├── groups/
│   ├── finance/
│   ├── bible/
│   ├── songs/
│   ├── dashboard/
│   └── [autres features]/
├── shared/
│   ├── widgets/          # Widgets réutilisables globaux
│   ├── providers/        # Providers globaux (currentUser, church, etc.)
│   └── theme/            # AppTheme, AppColors, LuminaColorsExtension
└── main.dart
```

**Règle** : chaque feature est autonome. Jamais d'import direct entre features.
Passer par `shared/` ou `core/` pour les éléments communs.

---

## 4. RÔLES UTILISATEUR

```dart
enum UserRole {
  superAdmin,   // accès total toutes églises
  admin,        // accès total sur son église
  pastor,       // vision pastorale
  treasurer,    // finances
  secretary,    // administration membres
  groupLeader,  // son groupe ministériel uniquement
  member,       // accès personnel uniquement
}
```

Chaque rôle a son dashboard dédié. La navigation post-login et post-onboarding
est TOUJOURS dynamique selon le rôle. Jamais hardcodée.

```dart
String getHomeRouteForRole(UserRole? role) {
  return switch (role) {
    UserRole.superAdmin  => AppRoutes.superAdminDashboard,
    UserRole.admin       => AppRoutes.adminDashboard,
    UserRole.pastor      => AppRoutes.pastorDashboard,
    UserRole.treasurer   => AppRoutes.treasurerDashboard,
    UserRole.secretary   => AppRoutes.secretaryDashboard,
    UserRole.groupLeader => AppRoutes.groupLeaderDashboard,
    UserRole.member      => AppRoutes.memberDashboard,
    _                    => AppRoutes.memberDashboard,
  };
}
```

---

## 5. NAVIGATION — GOROUTER

### Règles absolues

- **TOUTES** les navigations passent par GoRouter : `context.go()` ou `context.push()`
- **JAMAIS** `Navigator.push(MaterialPageRoute(...))` dans les écrans (sauf dialogs/bottom sheets)
- **TOUTES** les routes utilisent des constantes `AppRoutes.xxx` — jamais de string en dur
- Les guards RBAC sont définis dans le router, pas dans les widgets
- Chaque `GoRoute` doit avoir un `builder` non-vide (jamais `Container()` ou `SizedBox()`)

### Pattern route correcte

```dart
GoRoute(
  path: AppRoutes.memberDashboard,
  name: AppRoutes.memberDashboardNamed,
  redirect: (context, state) => _rbacGuard(context, [UserRole.member]),
  builder: (context, state) => const MemberDashboardScreen(),
),
```

### Route placeholder (si écran pas encore fait)

```dart
GoRoute(
  path: AppRoutes.nomRoute,
  builder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('En construction')),
    body: const Center(child: Text('Cette section arrive bientôt')),
  ),
),
```

---

## 6. RIVERPOD — PATTERNS OBLIGATOIRES

### Providers avec code generation

```dart
// Provider simple (lecture)
@riverpod
Future<List<MemberEntity>> members(MembersRef ref) async {
  final repo = ref.watch(memberRepositoryProvider);
  return repo.getAll();
}

// Provider mutable (AsyncNotifier)
@riverpod
class MemberNotifier extends _$MemberNotifier {
  @override
  Future<MemberEntity?> build() async => null;

  Future<void> update(MemberEntity member) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(memberRepositoryProvider).update(member),
    );
  }
}
```

### Règles Riverpod

- `ref.watch()` → UNIQUEMENT dans `build()`
- `ref.read()` → UNIQUEMENT dans les callbacks (onPressed, etc.)
- `ref.invalidate()` → pour forcer le rechargement
- **Toujours** gérer les 3 états : `data` / `loading` / `error`
- **Jamais** `provider.when(data: ...)` sans `loading:` et `error:`

### Pattern when() obligatoire

```dart
ref.watch(monProvider).when(
  data: (data) => MonWidget(data: data),
  loading: () => const MonSkeletonWidget(), // JAMAIS CircularProgressIndicator
  error: (err, _) => ErrorWidget(
    message: 'Impossible de charger les données.',
    onRetry: () => ref.invalidate(monProvider),
  ),
);
```

---

## 7. RÈGLES UX STRICTES (NON NÉGOCIABLES)

### Règle 1 — Zéro spinner

```
⛔ INTERDIT  : CircularProgressIndicator
⛔ INTERDIT  : LinearProgressIndicator
✅ OBLIGATOIRE : Skeleton shimmer qui reproduit exactement
                 la forme et la disposition du contenu attendu
```

Chaque écran doit avoir son propre `_NomEcranSkeleton` widget qui
simule visuellement le layout final pendant le chargement.

### Règle 2 — Audience principale

Les utilisateurs principaux ont entre 45 et 65 ans, peu d'expérience numérique.
Beaucoup n'utilisent que WhatsApp ou Facebook.

**Conséquences UX obligatoires :**
- Zones tactiles minimum : 48×48 dp
- Textes de boutons explicites (pas d'icône seule sans label)
- Messages d'erreur en français simple, sans jargon technique
- Guidage permanent visible (pas de découvrabilité cachée)
- Jamais de geste complexe (swipe caché, long press obligatoire)
- Confirmation avant toute action destructrice

### Règle 3 — Personas à garder en tête

| Persona | Rôle | Caractéristique clé |
|---|---|---|
| Marie | Membre | 52 ans, utilise WhatsApp uniquement |
| Pasteur Joseph | Pasteur | 60 ans, veut voir les chiffres clés vite |
| Sœur Bernadette | Chorale | 48 ans, cherche les chants facilement |
| Frère Samuel | Leader groupe | 45 ans, suit les présences |
| Directeur Marc | Admin | 55 ans, gère finances et membres |

### Règle 4 — Messages d'erreur

```dart
// ⛔ MAUVAIS
'Error: SocketException: Failed to connect'

// ✅ BON
'Connexion impossible. Vérifiez votre réseau et réessayez.'
```

---

## 8. SUPABASE — ARCHITECTURE DE DONNÉES

### Architecture TYPE A / TYPE B

```
TYPE A — Données personnelles (accès utilisateur uniquement)
  Tables : profiles, personal_notes, bible_highlights, bible_favorites
  RLS    : WHERE auth.uid() = user_id

TYPE B — Données d'église (accès selon rôle dans l'église)
  Tables : members, groups, finances, events, attendance
  RLS    : WHERE church_id = [church_id de l'utilisateur connecté]
           ET role IN [rôles autorisés]
```

### Tables principales

```sql
-- Utilisateurs / profils
profiles (id, user_id, church_id, role, first_name, last_name,
          gender, date_of_birth, phone, created_at)

-- Membres de l'église
members (id, church_id, profile_id, status, joined_at)

-- Groupes ministériels
groups (id, church_id, name, type, leader_id, created_at)

-- Appartenance aux groupes (many-to-many)
member_groups (id, member_id, group_id, role, joined_at)
-- role dans member_groups : 'leader' | 'member'
-- auto-assignment à la création du membre
-- validation : un leader ne peut pas être dans un groupe sans en être leader

-- Transactions financières
transactions (id, church_id, amount, currency, type,
              category, date, recorded_by, notes)
-- currency toujours 'FCFA'
-- type : 'income' | 'expense'

-- Abonnements admin aux groupes
admin_group_subscriptions (id, admin_id, group_id, subscribed_at)
```

### Règles RLS importantes

- Toujours filtrer par `church_id` pour les données TYPE B
- Le `superAdmin` bypass les RLS via service_role (backend uniquement)
- Les mutations Supabase se font TOUJOURS dans la couche `data/`
- Jamais d'appel Supabase direct dans les widgets ou providers

### Realtime activé sur

- `members` (nouvelles inscriptions)
- `transactions` (nouvelles entrées financières)
- `attendance` (présences en temps réel)
- `groups` (changements de membres)

---

## 9. ISAR — OFFLINE FIRST

Lumina fonctionne sans connexion internet. Isar est la base locale.

### Principe de synchronisation

```
Action utilisateur
  → Écriture Isar (immédiate, feedback instantané)
  → Tentative Supabase (en arrière-plan)
  → Si succès : marquer comme synchronisé
  → Si échec  : mettre en file d'attente (sync_queue)
```

### Modèles Isar présents

- `MemberModel` — cache local des membres
- `TransactionModel` — transactions en attente de sync
- `BibleNoteModel` — notes Bible personnelles
- `BibleHighlightModel` — versets surlignés
- `BibleFavoriteModel` — versets favoris
- `OnboardingStateModel` — état de l'onboarding
- `SongModel` — cache du recueil de chants

### Règle offline

Toujours vérifier la connectivité avant un appel Supabase.
Si hors ligne → écrire dans Isar + mettre en sync_queue.

---

## 10. ONBOARDING — FLUX COMPLET

### Flux onboarding selon le rôle

```
Écran accueil
  → Choix du rôle
      ├── Membre → Step1(Genre) → Step2(DateNaiss) → Step3(Église) → Step4(Message) → MemberDashboard
      ├── Leader → Step1(Genre) → Step2(DateNaiss) → Step3(Groupe) → Step4(Message) → GroupLeaderDashboard
      ├── Pasteur → Step1(Infos) → Step2(Église) → Step3(Message) → PastorDashboard
      └── Admin  → Step1(Infos) → Step2(Église) → Step3(Groupes) → Step4(Message) → AdminDashboard
```

### Règles onboarding

- Le bouton "Passer" et "Terminer" sont **TOUJOURS** dynamiques selon le rôle
- Jamais de route hardcodée dans les boutons d'onboarding
- L'onboarding complété est marqué dans Isar + Supabase
- Au relaunch de l'app, si onboarding complété → skip direct vers dashboard

### Date de naissance — implémentation correcte

```dart
// ✅ CORRECT : showDatePicker natif Flutter
Future<void> openDatePicker(BuildContext context) async {
  final picked = await showDatePicker(
    context: context,
    initialDate: DateTime(DateTime.now().year - 25),
    firstDate: DateTime(1900),
    lastDate: DateTime(DateTime.now().year - 5),
    locale: const Locale('fr', 'FR'),
    helpText: 'Date de naissance',
    cancelText: 'Annuler',
    confirmText: 'Confirmer',
  );
  if (picked != null) { /* utiliser la date */ }
}

// ✅ Saisie manuelle : keyboardType + inputFormatters
TextFormField(
  keyboardType: TextInputType.number,
  inputFormatters: [
    LengthLimitingTextInputFormatter(10),
    FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
  ],
  hintText: 'JJ/MM/AAAA',
)

// ⛔ INTERDIT : Navigator.push vers un écran de date
// ⛔ INTERDIT : DatePickerDialog() appelé directement
// ⛔ INTERDIT : onPressed: null sur l'icône calendrier
```

---

## 11. GROUPES MINISTÉRIELS

### 6 groupes présents

1. Chorale / Musique
2. Jeunesse
3. Femmes
4. Hommes
5. Prière / Intercession
6. Enfants / École du dimanche

### Système d'appartenance (many-to-many)

```dart
// Un membre peut appartenir à plusieurs groupes
// Un groupe a un leader (membre avec role='leader' dans member_groups)
// L'admin choisit quels groupes il suit via admin_group_subscriptions
```

### Sélection de groupes pour l'admin

```
⛔ INTERDIT : Champ de recherche texte pour trouver les groupes
✅ OBLIGATOIRE : Liste directe de tous les groupes de l'église
                 avec checkbox pour sélection
                 (CheckboxListTile ou ListTile + trailing Checkbox)
```

---

## 12. MODULES FONCTIONNELS

### Module Bible

Inspiré de YouVersion. Fonctionnalités :
- Lecture par livre / chapitre / verset
- Surlignage de versets (stocké Isar, TYPE A)
- Favoris (stocké Isar, TYPE A)
- Notes personnelles par verset (stocké Isar, TYPE A)
- Plans de lecture
- Verset du jour
- Partage de verset en image

### Module Chants

- Recueil bilingue : 23 chants (FR + EN)
- Répertoire gospel africain : 80 titres, 19 artistes
- Recherche par titre, paroles, artiste
- Mode présentation (plein écran pour projection)

### Module Finance

- Saisie des transactions (offrandes, dîmes, dépenses)
- Devise : FCFA uniquement
- Catégories prédéfinies
- Graphiques mensuels via fl_chart
- Export des rapports
- Accès : treasurer + admin + pastor (lecture) + superAdmin

### Module Membres

- Fiche complète par membre
- Statut : actif / inactif / visiteur
- Historique de présence
- Appartenance aux groupes
- Coordonnées + date de naissance + genre

---

## 13. THÈME & COULEURS

### Système de thème

```dart
// AppColors expose les couleurs via LuminaColorsExtension
// Toujours utiliser les tokens, jamais des hex en dur dans les widgets
context.colors.primary      // couleur primaire
context.colors.surface      // surface des cartes
context.colors.textPrimary  // texte principal
context.colors.textMuted    // texte secondaire
```

### Règle thème

- Light mode + Dark mode supportés
- Jamais de couleur hex hardcodée dans les widgets
- Toutes les couleurs passent par `AppColors` ou `LuminaColorsExtension`
- Ne pas changer l'identité visuelle — seulement la dynamisation

---

## 14. PATTERNS DE CODE — INTERDITS vs OBLIGATOIRES

### ⛔ Patterns INTERDITS (causes de bugs connus)

```dart
// ❌ Navigation hardcodée
context.go('/member-dashboard');
Navigator.push(context, MaterialPageRoute(builder: (_) => Screen()));

// ❌ Scaffold vide (page blanche)
return const Scaffold();
return Scaffold(body: Container());
return Scaffold(body: SizedBox.shrink());

// ❌ Catch vide (erreurs silencieuses)
} catch (e) {}

// ❌ Widget vide retourné en cas d'erreur
} catch (e) { return Container(); }

// ❌ Spinner de chargement
CircularProgressIndicator()
LinearProgressIndicator()

// ❌ AsyncValue incomplet
provider.when(data: (d) => Widget(d)); // manque loading + error

// ❌ FutureBuilder sans tous les états
FutureBuilder(builder: (ctx, snap) {
  if (snap.hasData) return Widget(); // manque loading + error
})

// ❌ Appel Supabase dans un widget
final data = await supabase.from('members').select();

// ❌ Appel Supabase sans try/catch
await supabase.from('members').insert(data);

// ❌ Date picker comme page séparée
Navigator.push(context, MaterialPageRoute(builder: (_) => DatePickerScreen()));

// ❌ GoRoute avec builder vide
GoRoute(path: '/route', builder: (_, __) => const SizedBox());
```

### ✅ Patterns OBLIGATOIRES

```dart
// ✅ Navigation via constantes
context.go(AppRoutes.memberDashboard);
context.push(AppRoutes.memberProfile);

// ✅ États de chargement (skeleton shimmer)
ref.watch(provider).when(
  data: (d) => Widget(d),
  loading: () => const MemberListSkeleton(),
  error: (e, _) => ErrorDisplay(onRetry: () => ref.invalidate(provider)),
);

// ✅ Catch avec log + message utilisateur
} catch (e, st) {
  debugPrint('❌ [FeatureName] $e\n$st');
  throw AppException('Opération impossible. Réessayez.');
}

// ✅ Appels Supabase dans le repository (data layer uniquement)
class MemberRepositoryImpl implements MemberRepository {
  @override
  Future<List<MemberEntity>> getAll() async {
    try {
      final response = await _supabase.from('members').select();
      return response.map(MemberModel.fromJson).toList();
    } catch (e, st) {
      debugPrint('❌ [MemberRepo] $e\n$st');
      throw DataException('Impossible de charger les membres.');
    }
  }
}
```

---

## 15. STRUCTURE CLEAN ARCHITECTURE PAR FEATURE

```
features/[feature]/
├── domain/
│   ├── entities/
│   │   └── member_entity.dart        # Objet métier pur (pas de JSON)
│   ├── repositories/
│   │   └── member_repository.dart    # Interface (abstract class)
│   └── usecases/
│       └── get_members_usecase.dart  # Un usecase = une action métier
├── data/
│   ├── models/
│   │   └── member_model.dart         # Entity + fromJson/toJson + Isar
│   ├── datasources/
│   │   ├── member_remote_datasource.dart  # Appels Supabase
│   │   └── member_local_datasource.dart   # Appels Isar
│   └── repositories/
│       └── member_repository_impl.dart    # Implémentation de l'interface
└── presentation/
    ├── screens/
    │   └── members_screen.dart
    ├── widgets/
    │   ├── member_card.dart
    │   └── member_list_skeleton.dart  # Skeleton obligatoire
    └── providers/
        └── members_provider.dart      # Riverpod providers
```

---

## 16. LOCALISATION

```dart
// Configuration obligatoire dans MaterialApp
localizationsDelegates: const [
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
],
supportedLocales: const [
  Locale('fr', 'FR'),
  Locale('en', 'US'),
],
locale: const Locale('fr', 'FR'), // défaut français
```

- Tous les textes utilisateur en français
- Les messages d'erreur en français simple
- Les dates au format `JJ/MM/AAAA`
- La devise toujours en `FCFA`

---

## 17. COMPORTEMENTS OFFLINE

```dart
// Vérification connexion avant appel réseau
final isOnline = ref.watch(connectivityProvider);

if (isOnline) {
  // Appel Supabase + sync Isar
} else {
  // Lire depuis Isar uniquement
  // Ajouter à sync_queue si action de mutation
}
```

---

## 18. DÉFAUTS CONNUS À ÉVITER (HISTORIQUE DES BUGS)

Ces bugs ont déjà été rencontrés. Ne pas les reproduire.

| Bug | Cause | Solution |
|---|---|---|
| Page blanche calendrier | `Navigator.push` vers écran inexistant | `showDatePicker()` natif |
| Saisie date impossible | Pas de `keyboardType` + pas d'`inputFormatters` | Voir §10 |
| Bouton "Passer" hardcodé | Route en dur vers un seul dashboard | Routing dynamique par rôle |
| Page blanche générale | `Scaffold(body: null)` ou GoRoute vide | Builder non-vide obligatoire |
| Spinner qui tourne indéfiniment | `AsyncValue` sans gestion error | `when()` complet à 3 états |
| Données non rechargées | Pas de `ref.invalidate()` après mutation | Invalider le provider source |
| Groupes non filtrés par église | Pas de filtre `church_id` | Toujours filtrer par `church_id` |
| Erreurs silencieuses | `catch(e) {}` vide | Log + throw `AppException` |
| Champ recherche groupes admin | TextField de recherche | Liste directe avec checkboxes |

---

## 19. PROTOCOLE DE TRAVAIL AVEC L'AGENT

### Avant chaque modification

1. **Lire** le fichier cible avant de le modifier
2. **Identifier** les noms réels des classes/providers/routes dans le code
3. **Ne jamais deviner** un nom — toujours vérifier dans le code source
4. Si incertain → **demander** avant d'écrire

### Format de réponse obligatoire

Après chaque fichier modifié :
```
✅ Modifié : lib/features/[feature]/presentation/screens/[fichier].dart
   Nature  : [description courte du changement]
```

### Portes de validation

Pour toute tâche de plus de 3 fichiers modifiés :
- Présenter un plan avant de commencer
- S'arrêter après chaque phase et attendre confirmation
- Afficher le diff AVANT / APRÈS pour chaque modification

### Ce que l'agent ne doit JAMAIS faire

- Modifier des fichiers non demandés
- Refactoriser du code "au passage"
- Changer le design ou les couleurs sans demande explicite
- Ajouter des dépendances sans le mentionner
- Corriger plusieurs fichiers en même temps sans diff intermédiaire
- Créer de nouveaux patterns différents de ceux établis dans ce fichier

---

## 20. COMMANDES UTILES

```bash
# Génération du code Riverpod/Freezed
dart run build_runner build --delete-conflicting-outputs

# Vérification des erreurs
flutter analyze

# Tests
flutter test

# Lancement debug
flutter run

# Nettoyage
flutter clean && flutter pub get
```

---

## 21. DÉPENDANCES CLÉS (pubspec.yaml)

```yaml
dependencies:
  flutter_riverpod: ^2.x
  riverpod_annotation: ^2.x
  go_router: ^13.x
  supabase_flutter: ^2.x
  isar: ^3.x
  isar_flutter_libs: ^3.x
  fl_chart: ^0.x
  flutter_localizations:
    sdk: flutter
  intl: ^0.x

dev_dependencies:
  riverpod_generator: ^2.x
  build_runner: ^2.x
  isar_generator: ^3.x
```

Si une dépendance est absente et nécessaire → la mentionner et attendre confirmation avant de l'ajouter.

---

## 22. CHECKLIST AVANT TOUT COMMIT

- [ ] Aucun `CircularProgressIndicator` ajouté
- [ ] Chaque état loading a son skeleton shimmer
- [ ] Toutes les routes utilisent `AppRoutes.xxx`
- [ ] Tous les appels Supabase sont dans `data/`
- [ ] Tous les `catch` loguent et propagent l'erreur
- [ ] `AsyncValue.when()` gère les 3 états
- [ ] Les textes utilisateur sont en français simple
- [ ] Aucune couleur hex hardcodée dans les widgets
- [ ] La `church_id` filtre toutes les requêtes TYPE B
- [ ] `dart run build_runner build` exécuté si providers modifiés
- [ ] `flutter analyze` sans erreur

---

*CLAUDE.md — Lumina v1.0 — Référence agent IA*
*À mettre à jour à chaque changement d'architecture majeur.*

## graphify

This project has a graphify knowledge graph at graphify-out/.

Rules:
- Before answering architecture or codebase questions, read graphify-out/GRAPH_REPORT.md for god nodes and community structure
- If graphify-out/wiki/index.md exists, navigate it instead of reading raw files
- After modifying code files in this session, run `graphify update .` to keep the graph current (AST-only, no API cost)

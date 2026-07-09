# CI — Spécification officielle (GitHub Actions uniquement)

**Dernière mise à jour :** 2026-07-09  
**Plateforme CI :** GitHub Actions (`.github/workflows/`)  
**Ancien :** GitLab CI (`.gitlab-ci.yml` supprimé — ne pas restaurer)

---

## 1. Règle d'or

> **Toute modification CI passe par GitHub Actions.**  
> GitLab CI n'existe plus. Si un fichier `.gitlab-ci.yml` réapparaît, c'est une régression.

---

## 2. Secrets GitHub (Repository > Settings > Secrets and variables > Actions)

| Secret | Rôle | Où il est consommé |
|--------|------|--------------------|
| `SUPABASE_URL` | URL projet Supabase (ex: `https://vvcdmqpbwfyhkzalwdli.supabase.co`) | `--dart-define` au build |
| `SUPABASE_ANON_KEY` | Clé anonyme Supabase (publishable) | `--dart-define` au build |
| `GOOGLE_WEB_CLIENT_ID` | Client ID Web Google (OAuth 2.0, type "Web application") | `--dart-define` + `google-services.json` |
| `GOOGLE_SERVICES_JSON_B64` | Contenu complet de `android/app/google-services.json` encodé en base64 | Décodé → `android/app/google-services.json` |
| `UPLOAD_KEYSTORE_B64` | Keystore Android de signature (`.jks`) encodé en base64 | Décodé → `android/app/upload-keystore.jks` |
| `KEYSTORE_PASSWORD` | Mot de passe du keystore | `signing.properties` |
| `KEY_ALIAS` | Alias de la clé de signature | `signing.properties` + `keytool -list` |
| `KEY_PASSWORD` | Mot de passe de la clé | `signing.properties` |
| `SENTRY_DSN` | DSN Sentry pour crash reporting | `--dart-define` au build |
| `ENVIRONMENT` | Environnement cible (`production`, `staging`, etc.) | `--dart-define` au build |

### Règles sur les secrets

- **JAMAIS** écrire un secret en clair dans un log (`echo $SECRET` interdit)
- Les secrets sont passés au build Flutter via `--dart-define`, **pas** via un fichier `.env`
- Le `GH_TOKEN` est fourni automatiquement par GitHub (`github.token`) — aucun secret supplémentaire requis

---

## 3. Structure du workflow

**Chemin :** `.github/workflows/ci.yml`

### 3.1 Déclencheurs

```yaml
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
```

**Règle :** Le workflow ne se déclenche **que** sur `main` (push + PR).  
Les releases se font **uniquement** via des **tags Git** (format `vX.Y.Z`).

### 3.2 Jobs

| Job | Rôle | dépend de |
|-----|------|-----------|
| `analyze` | `build_runner build` + `flutter analyze` | — |
| `build-apk` | Build APK release signé + upload release | `analyze` |

### 3.3 Étapes du job `build-apk`

```
1. Checkout                    actions/checkout@v4
2. Setup Java                  actions/setup-java@v4 (temurin 17)
3. Setup Flutter               subosito/flutter-action@v2 (channel: beta)
4. flutter pub get
5. Injection google-services.json  (base64 → fichier)
6. Validation package name         (vérifie com.lumina.mfejc)
7. Injection keystore              (base64 → .jks)
8. Vérification keystore           (keytool -list)
9. Création signing.properties
10. Lecture version depuis pubspec.yaml
11. Build APK release               (flutter build apk --release)
12. Upload APK → GitHub Release     (gh release upload)
13. Upload APK artifact (CI)
14. Upload debug symbols artifact
15. Nettoyage des secrets           (rm des fichiers sensibles)
```

### 3.4 Commande de build (paramètres critiques)

```bash
flutter build apk --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols \
  --dart-define=SUPABASE_URL="$SUPABASE_URL" \
  --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY" \
  --dart-define=SENTRY_DSN="$SENTRY_DSN" \
  --dart-define=ENVIRONMENT="$ENVIRONMENT" \
  --dart-define=GOOGLE_WEB_CLIENT_ID="$GOOGLE_WEB_CLIENT_ID"
```

---

## 4. Supabase — éléments clés pour un agent de codage

### 4.1 Projet

- **Référence projet :** `vvcdmqpbwfyhkzalwdli`
- **URL API :** `https://vvcdmqpbwfyhkzalwdli.supabase.co`
- **SDK Flutter :** `supabase_flutter` v2.x

### 4.2 Authentification

- **Provider Google natif** (pas OAuth web) via `google_sign_in` v7.2.0
- Flux : `GoogleSignIn.authenticate()` → `idToken` → `supabase.auth.signInWithIdToken(provider: google, idToken, accessToken)`
- `accessToken` peut être vide (optionnel pour Supabase)

### 4.3 RPCs SECURITY DEFINER (bypass RLS)

| RPC | Usage | Paramètres |
|-----|-------|-----------|
| `assign_user_role` | Assigner un rôle à un utilisateur | `p_user_id`, `p_role_code`, `p_church_id` |
| `redeem_secret_code` | Valider un code secret (marque comme utilisé) | `p_code` |
| `verify_secret_code` | Vérifier un code sans le consommer | `p_code` |

### 4.4 Edge Functions

| Fonction | Usage |
|----------|-------|
| `get-user-context` | Récupère le contexte RBAC (rôle, groupe, permissions) après authentification |

### 4.5 Tables critiques

| Table | Rôle |
|-------|------|
| `user_roles` | Assignment rôle ↔ utilisateur |
| `user_sessions` | Session active + `active_group_id` |
| `role_secret_codes` | 47 codes secrets pour les rôles staff |
| `profiles` | Profil utilisateur + `needs_onboarding` |
| `admin_group_subscriptions` | Abonnements admin aux groupes |

### 4.6 RLS Policies

- `user_roles` : écriture uniquement via RPC `assign_user_role` (SECURITY DEFINER)
- `profiles` : lecture publique, écriture via service_role
- `user_sessions` : lecture par owner, écriture via service_role
- `role_secret_codes` : lecture par authenticated, écriture via service_role

---

## 5. Règles de sécurité à respecter

1. **JAMAIS** committer de secrets (`.env`, keystore, `google-services.json`)
2. **JAMAIS** logger les secrets dans la CI
3. Les secrets passent par `--dart-define` (compile-time), pas runtime
4. Nettoyage systématique des fichiers sensibles à la fin du job (`after_script` / step `Cleanup secrets`)
5. Le `GH_TOKEN` utilisé pour `gh release upload` est auto-fourni par GitHub

---

## 6. Pipeline CI — flux complet

```
push main / PR → analyze (build_runner + flutter analyze)
                        ↓
                   build-apk (signing + build + release)
```

```
push tag v1.0.0 → analyze → build-apk → release GitHub auto-créée
```

---

## 7. Chemins et fichiers clés

```
.github/workflows/ci.yml          ← Workflow GitHub Actions (UNIQUE source de vérité)
lumina/android/app/build.gradle   ← Signing config (lit signing.properties)
lumina/android/app/google-services.json ← Injecté par CI (jamais commité)
lumina/pubspec.yaml               ← Version de l'app
lumina/.env.example               ← Template des variables d'environnement
```

---

## 8. Ce qu'un agent de codage DOIT savoir

### Checklist avant de toucher la CI

- [ ] Le workflow est dans `.github/workflows/ci.yml` (pas `.gitlab-ci.yml`)
- [ ] Les secrets sont passés en `--dart-define`, pas en fichier `.env` sur disque
- [ ] Le package Android est `com.lumina.mfejc` (vérifié dans `build.gradle`)
- [ ] Le channel Flutter est `beta` (pas `stable`)
- [ ] Java 17 (Temurin) est requis
- [ ] `build_runner build --delete-conflicting-outputs` tourne avant `flutter analyze`
- [ ] Le keystore est injecté en base64 puis décodé, jamais commité
- [ ] `google-services.json` est injecté en base64 puis décodé, jamais commité
- [ ] L'APK est uploadé sur GitHub Release via `gh release upload` (avec `GH_TOKEN`)
- [ ] Les debug symbols sont uploadés en artifact CI
- [ ] Le nettoyage des secrets (`rm`) tourne dans tous les cas (`if: always()`)

### Erreurs fréquentes à éviter

| Erreur | Conséquence |
|--------|-------------|
| Oublier `--dart-define` pour Supabase | App crash au démarrage (config manquante) |
| Passer les secrets en `echo` dans les logs | Fuite de credentials |
| Utiliser `.env` fichier au lieu de `--dart-define` | `.env` apparaît dans les artifacts CI |
| Mauvais chemin APK dans `gh release upload` | Upload échoue silencieusement |
| Oublier `base64 -d` avant d'écrire le keystore | Keystore corrompu → signature échoue |
| Channel Flutter `stable` au lieu de `beta` | Incompatibilité avec certaines dépendances |

---

## 9. Comment vérifier que la CI fonctionne

1. **Localement :**
   ```bash
   cd lumina
   dart run build_runner build --delete-conflicting-outputs
   flutter analyze --no-fatal-infos
   flutter build apk --release \
     --dart-define=SUPABASE_URL="https://vvcdmqpbwfyhkzalwdli.supabase.co" \
     --dart-define=SUPABASE_ANON_KEY="ton-anon-key" \
     --dart-define=GOOGLE_WEB_CLIENT_ID="ton-client-id"
   ```

2. **Sur GitHub :**
   - Aller dans l'onglet **Actions** du repo
   - Le workflow `CI` doit apparaître après un push sur `main`
   - Vérifier que les jobs `analyze` et `build-apk` passent au vert
   - Pour un tag `v1.0.0`, vérifier qu'une release est créée avec l'APK attaché

---

## 10. Points d'attention spécifiques à Lumina

### Supabase Project
- **Ref :** `vvcdmqpbwfyhkzalwdli`
- 47 rôles avec codes secrets dans `role_secret_codes`
- RPCs : `assign_user_role`, `redeem_secret_code`, `verify_secret_code`
- Edge Function : `get-user-context`
- RLS stricte sur `user_roles`, `profiles`, `user_sessions`

### Google Sign-In
- Package : `google_sign_in` v7.2.0
- Méthode correcte : `GoogleSignIn.authenticate()` (v7) — pas `signIn()`
- Client ID Web requis pour l'initialisation `serverClientId`
- Package Android : `com.lumina.mfejc`

### Keystore
- Le keystore de signature est géré par la CI (jamais dans le code)
- `signing.properties` est créé dynamiquement par le workflow
- Le `build.gradle` lit `signing.properties` si présent

---

*Ce document est la source de vérité pour toute modification CI. En cas de doute, consultez `.github/workflows/ci.yml`.*

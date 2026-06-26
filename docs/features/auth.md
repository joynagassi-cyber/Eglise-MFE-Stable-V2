# Feature : Auth

## Vue d’ensemble
Gestion de l’authentification via Supabase (email / mot de passe, Google OAuth). Le module crée la session, récupère le contexte utilisateur (église, rôle) et expose les informations via le provider `authProvider`.

## Rôles concernés
- **SuperAdmin / Admin / Pastor** – accès complet à toutes les fonctions d’authentification, gestion des comptes.
- **Member** – authentification standard, aucune permission d’administration.

## Architecture

### Domain
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/auth/domain/models/auth_user.dart | AppAuthUser | Représente les données utilisateur stockées dans Supabase. |
| lib/features/auth/domain/repositories/auth_repository.dart | AuthRepository (interface) | Méthodes `login`, `register`, `logout`, etc. |
| lib/features/auth/domain/repositories/role_repository.dart | RoleRepository | Gestion des rôles (lecture, assignation). |
| lib/features/auth/domain/repositories/user_context_repository.dart | UserContextRepository | Récupère le contexte RBAC (église, rôle, onboarding). |
| lib/features/auth/domain/usecases/login_usecase.dart | LoginUseCase | Implémente le flux de connexion en appelant `AuthRepository.login`. |
| lib/features/auth/domain/usecases/register_usecase.dart | RegisterUseCase | Implémente l’enregistrement, crée session légère si le contexte RBAC n’existe pas. |

### Data
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/auth/data/repositories/supabase_auth_repository.dart | SupabaseAuthRepository | Implémentation AuthRepository – dialogues avec Supabase, gestion des erreurs, création de `UserSession`. |
| lib/features/auth/data/datasources/secure_token_storage.dart | SecureTokenStorage | Stockage sécurisé (flutter_secure_storage) du refresh/access token. |
| lib/features/auth/data/datasources/supabase_auth_datasource.dart | SupabaseAuthDatasource | Wrapper SDK Supabase pour `signInWithPassword`, `signUp`, `signOut`. |
| lib/features/auth/data/datasources/user_context_remote_datasource.dart | UserContextRemoteDatasource | Appel à l’Edge Function `get-user-context` (RBAC v3). |

### Presentation
| Fichier | Type | Description |
|---|---|---|
| lib/features/auth/presentation/providers/auth_controller.dart | AuthController (AsyncNotifier) | Expose le `UserSession`, actions `login`, `register`, `logout`, `completeOnboarding`. |
| lib/features/auth/presentation/providers/role_provider.dart | RoleProvider | Fournit le rôle actuel (`UserRole`) à partir du `UserSession`. |
| lib/features/auth/presentation/widgets/permission_guard.dart | PermissionGuard (widget) | Garde les routes UI, redirige vers onboarding ou login selon le statut. |

## Flux de données
UI → AuthController → SupabaseAuthRepository ↔ Supabase (auth, Edge Function) + SecureTokenStorage → UI. En cas de succès, le `UserSession` est stocké dans le Provider `authProvider` et partagé via `currentUserIdProvider`, `activeChurchIdProvider`.

## Écrans
| Nom | Fichier | Route | Accès | Provider(s) |
|---|---|---|---|---|
| LoginScreen | auth/presentation/screens/login_screen.dart | `/login` (AppRoutes.login) | Tous | auth_controller |
| RegisterScreen | auth/presentation/screens/register_screen.dart | `/register` (AppRoutes.register) | Tous | auth_controller |
| OnboardingScreen | onboarding/presentation/screens/onboarding_screen.dart | `/onboarding` (AppRoutes.onboarding) | Tous (post‑login) | auth_controller, roleActionsProvider |

## Providers
| Provider | Type | Retour | Dépendances | Usage |
|---|---|---|---|---|
| authProvider | StateNotifierProvider<AuthController> | `UserSession?` | SupabaseAuthRepository, SecureTokenStorage | État d’authentification global. |
| roleProvider | Provider<UserRole> | Rôle courant (`superAdmin`, `admin`, `pastor`, `member`) | authProvider | Décision UI (menus, RBAC). |
| currentUserIdProvider | Provider<String?> | ID utilisateur actuel | authProvider | Utilisé dans tous les modules dépendants de l’utilisateur. |
| activeChurchIdProvider | Provider<String?> | ID de l’église active | authProvider | Filtrage RLS sur les tables. |
| roleActionsProvider | Provider<RoleActions> | Actions d’assignation de rôle (assignDefaultRole) | roleRepository | Utilisé pendant l’onboarding. |

## Appels Supabase / Isar
| Méthode | Table | Opération | Filtre |
|---|---|---|---|
| SupabaseAuthRepository.login | `auth.users` (SDK) | signInWithPassword | email/password + captcha optionnel |
| SupabaseAuthRepository.register | `auth.users` | signUp + création de session légère | – |
| SupabaseAuthRepository.logout | – | signOut | – |
| UserContextRemoteDatasource.getUserContext | `user_context` (Edge Function) | SELECT (RBAC) | `user_id = ?` |
| SecureTokenStorage.saveTokens | – | store `access_token`, `refresh_token` | – |

## Règles métier importantes
- **RLS** : chaque requête Supabase filtrée par `church_id` provenant du `UserSession`. 
- **Onboarding** : si `needsOnboarding = true` (via Edge Function), le router redirige vers `/onboarding`. 
- **Session légère** : lors de l’inscription Google OAuth, le contexte RBAC peut être absent → création d’une session “light” avec rôle `member` et flag `needsOnboarding = true`. 
- **Audit** : chaque login, register, logout déclenche `logAuditAction` (`entityType = 'auth'`).

## Cas limites documentés
- **Timeout** → `SupabaseAuthRepository._handleError` renvoie `ServerFailure` avec message « Délai d’attente dépassé ». 
- **Erreur Auth** → `AuthFailure` traduit via `AuthErrorTranslator` (ex : mot de passe faible, email déjà utilisé). 
- **Contexte manquant** → fallback vers `_buildLightSession`, l’onboarding force la création du profil. 
- **Déconnexion alors que la session est déjà expirée** → Supabase renvoie une erreur silencieuse, le repo gère en rafraîchissant le token ou en forçant la déconnexion.

## TODO / Incomplétudes détectées
- Aucun test unitaire pour `SupabaseAuthRepository` (login, register, fallback). 
- UI `login_screen.dart` ne montre pas le skeleton (`CircularProgressIndicator` interdit ; doit utiliser un skeleton). 
- Widget `three_d_cross_visual.dart` reste vide (non utilisé). 
- Ajouter tests d’intégration pour le flux onboarding (assignation rôle par défaut).

---
*Document basé sur le code source, aucune supposition.*

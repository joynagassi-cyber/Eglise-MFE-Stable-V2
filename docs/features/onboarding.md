# Feature : Onboarding

## Vue d’ensemble
Flux d’onboarding guidé après première connexion ou lorsqu’une nouvelle fonction nécessite une configuration. Le processus collecte les informations de base (rôle, église, données de profil) puis crée le profil utilisateur, assigne le rôle par défaut et marque le statut `needsOnboarding = false`.

## Rôles concernés
- **Tous les rôles** – chaque utilisateur passe par l’onboarding la première fois (Member, Pastor, Admin, etc.).
- **Pastor / Admin** – écran supplémentaire de sélection d’église et de configuration des autorisations.

## Architecture

### Domain
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/onboarding/domain/usecases/complete_onboarding_usecase.dart | CompleteOnboardingUseCase | Orchestration du persistance Isar puis appel Supabase (`profileRepository.completeOnboarding`). |
| lib/features/onboarding/domain/repositories/profile_repository.dart | ProfileRepository (interface) | Méthodes CRUD sur la table `profiles`. |

### Data
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/onboarding/data/repositories/profile_repository_impl.dart | ProfileRepositoryImpl | Implémentation Supabase + Isar, met à jour le champ `needs_onboarding`. |

### Presentation
| Fichier | Type | Description |
|---|---|---|
| lib/features/onboarding/presentation/screens/onboarding_screen.dart | Screen | UI dynamique du wizard (étapes : rôle → église → infos personnelles). |
| lib/features/onboarding/presentation/screens/onboarding_step_role.dart | Widget | Sélection du rôle avec icônes et texte. |
| lib/features/onboarding/presentation/screens/onboarding_step_church.dart | Widget | Sélection de l’église (liste des églises accessibles). |
| lib/features/onboarding/presentation/screens/onboarding_step_details.dart | Widget | Formulaire des informations basiques (nom, email, téléphone). |
| lib/features/onboarding/presentation/providers/onboarding_controller.dart | AsyncNotifier | Gère l’avancement du wizard, persistance temporaire via Isar, appel `completeOnboarding`. |

## Flux de données
UI → OnboardingController → ProfileRepositoryImpl ↔ Supabase (`profiles`) + Isar cache → UI. À la fin, `authProvider` met à jour `needsOnboarding = false` et le router redirige vers le tableau de bord correspondant au rôle.

## Écrans
| Nom | Fichier | Route | Accès | Provider(s) |
|---|---|---|---|---|
| OnboardingScreen | onboarding/presentation/screens/onboarding_screen.dart | `/onboarding` (AppRoutes.onboarding) | Tous (post‑login) | onboarding_controller |

## Providers
| Provider | Type | Retour | Dépendances | Usage |
|---|---|---|---|---|
| onboarding_controller | AsyncNotifierProvider<OnboardingController> | State contenant `currentStep`, `isComplete` | profileRepositoryProvider, authProvider | Gestion du wizard, persistance des données temporaires. |
| profileRepositoryProvider | Provider<ProfileRepository> | Implémentation Supabase/Isar | - | Accès aux opérations `completeOnboarding`. |

## Appels Supabase / Isar
| Méthode | Table | Opération | Filtre |
|---|---|---|---|
| ProfileRepositoryImpl.completeOnboarding | `profiles` | UPDATE `needs_onboarding = false` | `id = userId` |
| ProfileRepositoryImpl.getProfile | `profiles` | SELECT | `id = userId` |

## Règles métier importantes
- **RLS** : les lectures/écritures de `profiles` filtrées par `church_id`.
- **Statut onboarding** : champ `needs_onboarding` booléen détermine si le router doit forcer `/onboarding`.
- **Rôle par défaut** : si aucune sélection, le rôle `member` est assigné via `roleActionsProvider.assignDefaultRole`. 
- **Audit** : chaque mise à jour du profil déclenche `logAuditAction` (`entityType = 'profiles'`).

## Cas limites documentés
- **Pas de réseau** → mise à jour uniquement dans Isar, `sync_queue` marque la modification pour synchronisation ultérieure.
- **Annulation** → l’utilisateur peut quitter le wizard ; l’état reste en `needsOnboarding = true` et sera rappelé à la prochaine connexion.
- **Rôle inconnu** → fallback au rôle `member` et affichage d’un message d’avertissement.

## TODO / Incomplétudes détectées
- Aucun test unitaire pour `OnboardingController`. 
- UI `onboarding_screen.dart` ne montre pas de skeleton pendant les appels réseau. 
- Widget `three_d_cross_visual.dart` reste vide (non utilisé). 
- Ajouter tests d’intégration couvrant le scénario hors‑ligne et la synchronisation différée.

---
*Document basé sur le code source, aucune supposition.*

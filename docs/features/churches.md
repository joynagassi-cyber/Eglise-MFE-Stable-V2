# Feature : Churches

## Vue d’ensemble
Gestion des églises et fédérations. Permet aux utilisateurs d’accéder aux églises auxquelles ils sont rattachés, de créer/mettre à jour/supprimer des églises et de consulter des statistiques.

## Rôles concernés
- **SuperAdmin** – gestion complète de toutes les églises et fédérations.
- **Admin** – gestion des églises de son église principale.
- **Pastor** – visualisation et changement de l’église active.
- **Member** – lecture limitée aux églises auxquelles il est affilié.

## Architecture

### Domain
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/churches/domain/entities/church.dart | Church | Entité représentant une église, champs détaillés (id, name, type, etc.). |
| lib/features/churches/domain/entities/federation.dart | Federation | Entité fédération, groupe d’églises. |
| lib/features/churches/domain/repositories/church_repository.dart | ChurchRepository (interface) | CRUD, lectures, requêtes filtrées, statistiques. |

### Data
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/churches/data/repositories/supabase_church_repository.dart | SupabaseChurchRepository | Implémentation Supabase + Isar, stratégie offline‑first, synchronisation. |
| lib/features/churches/data/models/church_model.dart | ChurchModel | Mapper Isar ↔ Domain, conversion Supabase. |
| lib/features/churches/data/models/federation_model.dart | FederationModel | Mapper Isar ↔ Domain, conversion Supabase. |

### Presentation
| Fichier | Type | Description |
|---|---|---|
| lib/features/churches/presentation/providers/church_providers.dart | Provider | Riverpod providers pour accès, streams, actions CRUD, statistiques. |
| lib/features/churches/presentation/screens/church_list_screen.dart | Screen | Liste des églises accessibles (admin, superadmin). |
| lib/features/churches/presentation/screens/church_detail_screen.dart | Screen | Détails d’une église, édition, statistiques. |

## Flux de données
UI → ChurchProviders → SupabaseChurchRepository ↔ Supabase & Isar → UI. Lectures prioritaires depuis Isar, écritures synchronisées vers Supabase, retour en cache Isar.

## Écrans
| Nom | Fichier | Route | Accès | Provider(s) |
|---|---|---|---|---|
| ChurchListScreen | presentation/screens/church_list_screen.dart | `/churches` (AppRoutes.churches) | Admin, SuperAdmin | church_providers (allChurches, watchAllChurches) |
| ChurchDetailScreen | presentation/screens/church_detail_screen.dart | `/churches/:id` (AppRoutes.churchDetail) | Admin, SuperAdmin | church_providers (activeChurch, watchActiveChurch) |

## Providers
| Provider | Type | Retour | Dépendances | Usage |
|---|---|---|---|---|
| churchRepository | Future<ChurchRepository> | Repository instance | - | Accès aux appels Supabase/Isar. |
| userChurches | Future<List<Church>> | Liste des églises de l’utilisateur | currentUserIdProvider | UI affichage églises utilisateur. |
| watchUserChurches | Stream<List<Church>> | Stream temps réel | currentUserIdProvider | UI mise à jour live. |
| activeChurch | Future<Church?> | Église active du contexte | activeChurchIdProvider | Dashboard, navigation. |
| watchActiveChurch | Stream<Church?> | Stream temps réel de l’église active | activeChurchIdProvider | UI réactive. |
| ChurchSwitcher (class) | AsyncNotifier | Actions CRUD (switch) | authProvider | Changement d’église active. |
| ChurchActions (class) | AsyncNotifier | CRUD complet + audit | - | Création, mise à jour, suppression, logs audit. |
| allChurches | Future<List<Church>> | Toutes les églises (admin) | - | Liste admin globale. |
| watchAllChurches | Stream<List<Church>> | Stream toutes églises | - | UI admin temps réel. |
| searchChurches | Future<List<Church>> | Recherche texte | - | Barre recherche admin. |
| churchesByType | Future<List<Church>> | Filtre par type | - | Filtrage UI. |
| churchesByCity | Future<List<Church>> | Filtre par ville | - | Filtrage UI. |
| churchStats | Future<Map<String,dynamic>> | Statistiques (membres, activités) | - | Tableau de bord. |
| totalMemberCount | Future<int> | Nombre total de membres toutes églises | - | KPI admin. |

## Appels Supabase / Isar
| Méthode | Table | Opération | Filtre |
|---|---|---|---|
| SupabaseChurchRepository.getChurchById | `churches` | SELECT (fallback Isar) | `id = ?` |
| SupabaseChurchRepository.getAllChurches | `churches` | SELECT all | – |
| SupabaseChurchRepository.getUserChurches | `user_churches` → `churches` | SELECT ids puis batch fetch | `user_id = ?` |
| SupabaseChurchRepository.getChildChurches | `churches` | SELECT | `parent_church_id = ?` |
| SupabaseChurchRepository.getFederationChurches | `churches` | SELECT | `federation_id = ?` |
| SupabaseChurchRepository.createChurch | `churches` | INSERT + cache Isar | – |
| SupabaseChurchRepository.updateChurch | `churches` | UPDATE + cache Isar | `id = ?` |
| SupabaseChurchRepository.deleteChurch | `churches` | DELETE + cache Isar | `id = ?` |
| SupabaseChurchRepository.getFederationById | `federations` | SELECT | `id = ?` |
| SupabaseChurchRepository.getAllFederations | `federations` | SELECT all | – |
| SupabaseChurchRepository.createFederation | `federations` | INSERT + cache Isar | – |
| SupabaseChurchRepository.updateFederation | `federations` | UPDATE + cache Isar | `id = ?` |

## Règles métier importantes
- **RLS** : toutes les requêtes Supabase filtrées par `church_id` ou `federation_id` selon le rôle.
- **Validation** : aucune création d’église avec `parentChurchId` invalide ; le `type` doit être parmi `ChurchType`.
- **Accès** : `ChurchSwitcher.switchToChurch` vérifie que l’église appartient à `userChurches` avant changement de contexte.
- **Audit** : chaque création, mise à jour, suppression déclenche `logAuditAction` avec entité `churches`.

## Cas limites documentés
- **Connexion hors‑ligne** → écriture uniquement dans Isar, `isSynced = false` pour synchronisation ultérieure.
- **Conflit d’ID** → Si création d’ID déjà existant, Supabase renvoie erreur, la logique marche via génération timestamp.
- **Accès non autorisé** → `ChurchSwitcher.switchToChurch` lève exception si l’utilisateur n’a pas accès.

## TODO / Incomplétudes détectées
- Aucun test unitaire pour `SupabaseChurchRepository`.
- UI `church_detail_screen.dart` manque de prise en compte du champ `isSynced` pour indiquer l’état de synchronisation.
- Widget `three_d_cross_visual.dart` reste vide (non utilisé).
- Ajouter tests pour `ChurchActions` (CRUD + audit).

---
*Document généré à partir du code source, aucune spéculation.*
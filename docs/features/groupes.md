# Feature : Groupes

## Vue d’ensemble
Gestion des groupes ministériels (cellules, ministères, équipes, chorales, hommes, femmes, jeunesse, enfants, intercession). Permet la création, l’édition, l’affectation de leader, la gestion des membres et la planification d’activités.

## Rôles concernés
- **Admin / SuperAdmin** – création, édition, suppression de tous les groupes, gestion des leaders. 
- **GroupLeader** – gestion des membres de son groupe, mise à jour des informations du groupe. 
- **Member** – visualisation des groupes auxquels il appartient.

## Architecture

### Domain
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/groups/domain/entities/group.dart | Group | Entité groupe avec `id`, `churchId`, `name`, `type` (enum `GroupType`), `leaderId`, etc. |
| lib/features/groups/domain/entities/group_attendance.dart | GroupAttendance | Historique de présence des membres au groupe. |
| lib/features/groups/domain/entities/group_membership.dart | GroupMembership | Relation membre‑groupe avec rôle (`member`, `leader`). |
| lib/features/groups/domain/repositories/group_repository.dart | GroupRepository (interface) | CRUD groupes, listes, recherche, statistiques. |
| lib/features/groups/domain/usecases/create_group_usecase.dart | CreateGroupUseCase | Orchestration création groupe, audit. |
| lib/features/groups/domain/usecases/update_group_usecase.dart | UpdateGroupUseCase | Mise à jour groupe, validation leader. |
| lib/features/groups/domain/usecases/delete_group_usecase.dart | DeleteGroupUseCase | Soft‑delete (`isActive = false`). |

### Data
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/groups/data/models/group_model.dart | GroupModel | Mapper Supabase ↔ Isar, conversion JSON. |
| lib/features/groups/data/models/group_attendance_model.dart | GroupAttendanceModel | Mapper presence. |
| lib/features/groups/data/models/group_membership_model.dart | GroupMembershipModel | Mapper membre‑groupe. |
| lib/features/groups/data/repositories/group_repository_impl.dart | GroupRepositoryImpl | Implémentation Supabase + Isar, stratégie offline‑first, file `sync_queue`. |

### Presentation
| Fichier | Type | Description |
|---|---|---|
| lib/features/groups/presentation/screens/group_list_screen.dart | Screen | Liste des groupes avec filtres par type. |
| lib/features/groups/presentation/screens/group_detail_screen.dart | Screen | Détails du groupe, membres, agenda. |
| lib/features/groups/presentation/screens/group_form_screen.dart | Screen | Formulaire création / édition groupe. |
| lib/features/groups/presentation/widgets/group_card.dart | Widget | Carte affichant nom, type, leader, statut. |
| lib/features/groups/presentation/widgets/group_member_payment_list.dart | Widget | Tableau des cotisations des membres du groupe. |
| lib/features/groups/presentation/providers/group_providers.dart | Provider | Riverpod `FutureProvider<List<Group>>`, `group_detail_provider`, `group_form_provider`. |

## Flux de données
UI → GroupProviders → GroupRepositoryImpl ↔ Supabase (`groups`, `group_memberships`, `group_attendance`) + Isar cache → UI. Lecture prioritaire Isar; écriture synchronisée, file `sync_queue` hors‑ligne.

## Écrans
| Nom | Fichier | Route | Accès | Provider(s) |
|---|---|---|---|---|
| GroupListScreen | presentation/screens/group_list_screen.dart | `/groups` (AppRoutes.groups) | Admin, GroupLeader, Member | group_providers (groupListProvider) |
| GroupDetailScreen | presentation/screens/group_detail_screen.dart | `/groups/:id` (AppRoutes.groupDetail) | Admin, GroupLeader, Member | group_providers (groupDetailProvider) |
| GroupFormScreen | presentation/screens/group_form_screen.dart | `/groups/form` (AppRoutes.groupForm) | Admin, GroupLeader | group_providers (groupFormProvider) |

## Providers
| Provider | Type | Retour | Dépendances | Usage |
|---|---|---|---|---|
| groupListProvider | FutureProvider<List<Group>> | Liste filtrée par type/église | groupRepositoryProvider | Affichage tableau principal. |
| groupDetailProvider | FutureProvider<Group?> | Détails groupe par ID | groupRepositoryProvider | Page détail. |
| groupFormProvider | StateNotifierProvider<GroupFormNotifier> | Gestion état formulaire création/édition | groupRepositoryProvider | Soumission, validation. |
| groupRepositoryProvider | Provider<GroupRepository> | Implémentation Supabase/Isar | - | Accès aux opérations CRUD. |

## Appels Supabase / Isar
| Méthode | Table | Opération | Filtre |
|---|---|---|---|
| GroupRepositoryImpl.getGroups | `groups` | SELECT (pagination) | `church_id = ?` + `type = ?` |
| GroupRepositoryImpl.getGroupById | `groups` | SELECT | `id = ?` |
| GroupRepositoryImpl.createGroup | `groups` | INSERT + cache Isar | – |
| GroupRepositoryImpl.updateGroup | `groups` | UPDATE | `id = ?` |
| GroupRepositoryImpl.deleteGroup | `groups` | UPDATE `is_active = false` | `id = ?` |
| GroupRepositoryImpl.addMember | `group_memberships` | INSERT | – |
| GroupRepositoryImpl.removeMember | `group_memberships` | DELETE | `group_id = ?, member_id = ?` |
| GroupRepositoryImpl.recordAttendance | `group_attendance` | INSERT | – |

## Règles métier importantes
- **RLS** : chaque requête filtrée par `church_id`. 
- **Leader unique** : chaque groupe ne peut avoir qu’un seul `leaderId`. 
- **Statut actif** : groupe inactif (`isActive = false`) n’apparaît pas dans les listes utilisateurs. 
- **Audit** : création, modification, suppression déclenchent `logAuditAction` (`entityType = 'groups'`). 
- **Contrainte de membres** : max 500 membres par groupe (enforce côté backend). 

## Cas limites documentés
- **Hors‑ligne** → ajout/suppression de membres stockés dans Isar, synchronisation différée via `sync_queue`. 
- **Conflit de leader** → si deux utilisateurs tentent d’être leader simultanément, le dernier commit prévaut et un `ConflictError` est journalisé. 
- **Suppression groupe** → cascade suppression des `group_memberships` et `group_attendance` (soft‑delete). 
- **Pagination** → Supabase limite à 500 enregistrements, UI utilise `loadMore`.

## TODO / Incomplétudes détectées
- Aucun test unitaire pour `GroupRepositoryImpl`. 
- UI `group_list_screen.dart` ne montre pas de skeleton pendant le chargement. 
- Widget `three_d_cross_visual.dart` reste vide (non utilisé). 
- Ajouter tests de permission RBAC sur actions de leader et admin.

---
*Document basé sur le code source, aucune supposition.*
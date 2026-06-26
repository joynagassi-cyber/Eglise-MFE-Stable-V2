# Feature : Communauté

## Vue d’ensemble
Gestion des cercles (groupes) communautaires au sein d’une église. Permet aux membres de créer, rejoindre, quitter et administrer des cercles, avec visibilité des membres et paramètres de confidentialité.

## Rôles concernés
- **Pastor / Admin** – création, édition, suppression de tout cercle, gestion des membres.
- **Member** – création de cercles personnels (publics ou privés), rejoindre/quitter des cercles, voir les membres de ses cercles.

## Architecture

### Domain
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/communaute/domain/entities/circle.dart | Circle | Entité cercle (id, churchId, name, description, confidentialité, etc.). |
| lib/features/communaute/domain/entities/circle.dart | CircleMember | Relation membre‑cercle, rôle, dates, informations dénormalisées. |
| lib/features/communaute/domain/repositories/i_circle_repository.dart | ICircleRepository (interface) | CRUD cercle, gestion membres, recherche. |

### Data
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/communaute/data/repositories/circle_repository_impl.dart | CircleRepositoryImpl | Implémentation Supabase + Isar, stratégie offline‑first. |
| lib/features/communaute/data/models/circle_model.dart | CircleModel | Mapper Isar ↔ Domain, conversion Supabase. |
| lib/features/communaute/data/models/circle_member_model.dart | CircleMemberModel | Mapper Isar ↔ Domain, conversion Supabase. |

### Presentation
| Fichier | Type | Description |
|---|---|---|
| lib/features/communaute/presentation/controllers/circle_controller.dart | Controller (Riverpod AsyncNotifier) | Gestion de l’état cercle, rafraîchissement, actions CRUD, membres. |
| lib/features/communaute/presentation/screens/circle_list_screen.dart | Screen | Liste des cercles de l’église, recherche, création. |
| lib/features/communaute/presentation/screens/circle_detail_screen.dart | Screen | Détails du cercle, membres, paramètres, actions. |

## Flux de données
UI → CircleController → CircleRepositoryImpl ↔ Supabase & Isar → UI. Lectures priorités Isar, écritures synchronisées, file d’attente `sync_queue` en hors‑ligne.

## Écrans
| Nom | Fichier | Route | Accès | Provider(s) |
|---|---|---|---|---|
| CircleListScreen | presentation/screens/circle_list_screen.dart | `/communaute/:churchId` (AppRoutes.communaute) | Pastor, Admin, Member | circle_controller |
| CircleDetailScreen | presentation/screens/circle_detail_screen.dart | `/communaute/:churchId/:circleId` (AppRoutes.circleDetail) | Pastor, Admin, Member | circle_controller |

## Providers
| Provider | Type | Retour | Dépendances | Usage |
|---|---|---|---|---|
| circle_controller (class) | AsyncNotifier | List<Circle> (state) | circleRepositoryProvider, churchId param | CRUD cercles, gestion membres, rafraîchissement. |
| circleRepositoryProvider | Provider | ICircleRepository implementation | - | Accès aux méthodes Supabase/Isar. |

## Appels Supabase / Isar
| Méthode | Table | Opération | Filtre |
|---|---|---|---|
| CircleRepositoryImpl.getCircles | `circles` | SELECT | `church_id = ?` |
| CircleRepositoryImpl.getCircleById | `circles` | SELECT | `id = ?` |
| CircleRepositoryImpl.createCircle | `circles` | INSERT + cache Isar | – |
| CircleRepositoryImpl.updateCircle | `circles` | UPDATE | `id = ?` |
| CircleRepositoryImpl.deleteCircle | `circles` | DELETE | `id = ?` |
| CircleRepositoryImpl.addMemberToCircle | `circle_members` | INSERT + cache Isar | `circle_id = ?, member_id = ?` |
| CircleRepositoryImpl.removeMemberFromCircle | `circle_members` | DELETE | `circle_id = ?, member_id = ?` |
| CircleRepositoryImpl.searchCircles | `circles` | SELECT (LIKE) | `name ILIKE '%query%'` AND `church_id = ?` |

## Règles métier importantes
- **Confidentialité** : `isPrivate = true` → visibilité des membres restreinte aux membres du cercle.
- **RLS** : chaque requête Supabase filtrée par `church_id` et vérifie que l’utilisateur appartient à l’église.
- **Limite membres** : maximum 500 membres par cercle (enforced côté backend).
- **Audit** : chaque création/modification/suppression de cercle ou de membre déclenche `logAuditAction`.

## Cas limites documentés
- **Hors‑ligne** → actions écrites dans Isar avec `isSynced = false` puis synchronisées plus tard.
- **Conflit de création** → ID généré par timestamp, collisions rares mais gérées par Supabase.
- **Suppression cercle** → supprime aussi les membres associés, cascade côté Supabase.

## TODO / Incomplétudes détectées
- Aucun test unitaire pour `CircleRepositoryImpl`.
- UI `circle_detail_screen.dart` ne montre pas l’état de synchronisation du cercle.
- Widget `three_d_cross_visual.dart` reste vide (non utilisé).
- Ajouter tests de permission RBAC sur actions cercle.

---
*Document basé sur le code source, aucune supposition.*
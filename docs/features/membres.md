# Feature : Membres

## Vue d’ensemble
Gestion complète du répertoire des membres de chaque église (création, édition, recherche, export, QR code). Les informations sont stockées dans la table Supabase `members` et synchronisées localement via Isar.

## Rôles concernés
- **Admin / SuperAdmin** – création, modification, suppression de tout membre, export CSV/PDF.
- **Pastor** – accès en lecture à tous les membres, édition limitée (ex : statut, groupe).
- **Member** – visualisation de son profil et de ses propres informations (via QR code).

## Architecture

### Domain
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/membres/domain/entities/member.dart | Member | Entité principale ~180 champs (identité, statut, contact, adresse, spiritualité, engagement). |
| lib/features/membres/domain/entities/enums/enums.dart | Enums | Types d’`Gender`, `MemberStatus`, `MembershipType`, etc. |
| lib/features/membres/domain/repositories/member_repository.dart | MemberRepository (interface) | Méthodes CRUD, recherche, export. |
| lib/features/membres/domain/usecases/create_member_usecase.dart | CreateMemberUseCase | Orchestration création : validation, appel repository, audit. |
| lib/features/membres/domain/usecases/update_member_usecase.dart | UpdateMemberUseCase | Orchestration mise à jour avec logique de synchronisation. |
| lib/features/membres/domain/usecases/delete_member_usecase.dart | DeleteMemberUseCase | Suppression logique (`isDeleted`) et purge Isar. |
| lib/features/membres/domain/usecases/get_members_usecase.dart | GetMembersUseCase | Chargement paginé des membres, filtres par statut/type. |

### Data
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/membres/data/models/member_model.dart | MemberModel | Mapper Supabase ↔ Isar, conversion JSON. |
| lib/features/membres/data/repositories/supabase_member_repository.dart | SupabaseMemberRepository | Implémentation : lectures prioritaires depuis Isar, écritures synchronisées Supabase + Isar, file `sync_queue`. |

### Presentation
| Fichier | Type | Description |
|---|---|---|
| lib/features/membres/presentation/screens/member_list_screen.dart | Screen | Liste paginée avec filtres (statut, type, groupe). |
| lib/features/membres/presentation/screens/member_detail_screen.dart | Screen | Détails complet, actions (éditer, supprimer, QR). |
| lib/features/membres/presentation/screens/member_form_screen.dart | Screen | Formulaire création/édition, validation champs. |
| lib/features/membres/presentation/widgets/member_card.dart | Widget | Carte affichant photo, nom, statut, rôle. |
| lib/features/membres/presentation/widgets/member_info_section.dart | Widget | Section d’informations détaillées (adresse, contacts, spiritualité). |
| lib/features/membres/presentation/providers/member_list_provider.dart | Provider | Riverpod `FutureProvider<List<Member>>` avec filtres. |
| lib/features/membres/presentation/providers/member_detail_provider.dart | Provider | `FutureProvider<Member?>` par ID. |
| lib/features/membres/presentation/providers/member_form_provider.dart | Provider | `StateNotifier` gérant le formulaire (validation, submit). |

## Flux de données
UI → MemberProviders → SupabaseMemberRepository ↔ Supabase (`members`) + Isar cache → UI. Lecture prioritaire Isar, écriture + mise en file `sync_queue` si hors‑ligne.

## Écrans
| Nom | Fichier | Route | Accès | Provider(s) |
|---|---|---|---|---|
| MemberListScreen | presentation/screens/member_list_screen.dart | `/members` (AppRoutes.members) | Admin, Pastor, SuperAdmin | member_list_provider |
| MemberDetailScreen | presentation/screens/member_detail_screen.dart | `/members/:id` (AppRoutes.memberDetail) | Admin, Pastor, SuperAdmin, Member (own) | member_detail_provider |
| MemberFormScreen | presentation/screens/member_form_screen.dart | `/members/form` (AppRoutes.memberForm) | Admin, Pastor | member_form_provider |

## Providers
| Provider | Type | Retour | Dépendances | Usage |
|---|---|---|---|---|
| member_list_provider | FutureProvider<List<Member>> | Liste paginée filtrée | memberRepositoryProvider | Affichage tableau principal. |
| member_detail_provider | FutureProvider<Member?> | Détails par ID | memberRepositoryProvider | Page détail. |
| member_form_provider | StateNotifierProvider<MemberFormNotifier> | Gestion état formulaire (creation/edit) | memberRepositoryProvider | Soumission, validation. |
| memberRepositoryProvider | Provider<MemberRepository> | Implémentation Supabase/Isar | - | Accès aux opérations CRUD. |

## Appels Supabase / Isar
| Méthode | Table | Opération | Filtre |
|---|---|---|---|
| SupabaseMemberRepository.getMembers | `members` | SELECT (pagination) | `church_id = ?` + filtres statut/type |
| SupabaseMemberRepository.getMemberById | `members` | SELECT | `id = ?` |
| SupabaseMemberRepository.createMember | `members` | INSERT + cache Isar | – |
| SupabaseMemberRepository.updateMember | `members` | UPDATE | `id = ?` |
| SupabaseMemberRepository.deleteMember | `members` | UPDATE `isDeleted = true` (soft delete) | `id = ?` |
| SupabaseMemberRepository.exportCsv | `members` | SELECT + transformation CSV | – |

## Règles métier importantes
- **RLS** : toutes les requêtes filtrées par `church_id`. 
- **Statut** : `MemberStatus.active`, `inactive`, `visitor`. Les membres inactifs sont masqués par défaut. 
- **QR Code** : chaque membre possède un `qrCode` unique généré à la création, utilisé pour le scan rapide. 
- **Audit** : chaque création/modif/suppression déclenche `logAuditAction` (`entityType = 'members'`). 
- **Contrainte de rôle** : seuls les Admin/SuperAdmin peuvent changer le champ `membershipType` et le statut `isDeleted`.

## Cas limites documentés
- **Hors‑ligne** → création/modif stockées dans Isar avec `isSynced = false`; synchronisation différée via `sync_queue`. 
- **Conflit de QR** → génération assure l’unicité via timestamp + random; en cas de collision, nouvelle génération.
- **Import/export volumineux** → pagination serveur (limite 500) ; UI utilise lazy loading.
- **Suppression** → soft‑delete uniquement ; les données restent dans Isar pour historique.

## TODO / Incomplétudes détectées
- Aucun test unitaire pour `SupabaseMemberRepository`. 
- UI `member_list_screen.dart` ne montre pas de skeleton pendant le chargement (utiliser `MemberListSkeleton`). 
- Widget `three_d_cross_visual.dart` reste vide (non utilisé). 
- Ajouter tests d’intégration pour le scénario de synchronisation offline/online.

---
*Document basé sur le code source, aucune supposition.*
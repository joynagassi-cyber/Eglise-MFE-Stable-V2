# Feature : Annonces

## Vue d’ensemble
Gestion des annonces de l’église (actualités, événements, communications). Les annonces sont créées, publiées, épinglées puis affichées dans le tableau de bord et le fil d’actualité.

## Rôles concernés
- **Pastor / Admin / SuperAdmin** – création, édition, publication, épinglage, suppression.
- **Member** – lecture des annonces publiées.

## Architecture

### Domain
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/annonces/domain/entities/annonce.dart | Annonce | Entité annonce avec champs (id, churchId, title, content, isPublished, isPinned, etc.). |
| lib/features/annonces/domain/entities/annonce_type.dart | AnnonceType | Enumération types d’annonce (INFO, EVENT, ALERT). |
| lib/features/annonces/domain/entities/commentaire.dart | Commentaire | Entité commentaire lié à une annonce. |
| lib/features/annonces/domain/repositories/i_annonce_repository.dart | IAnnonceRepository (interface) | CRUD annonces, recherche, filtres publication/épingle. |

### Data
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/annonces/data/repositories/announcement_repository_impl.dart | AnnouncementRepositoryImpl | Implémentation Supabase + Isar, stratégie offline‑first. |
| lib/features/annonces/data/models/annonce_model.dart | AnnonceModel | Mapper Isar ↔ Domain, conversion Supabase. |

### Presentation
| Fichier | Type | Description |
|---|---|---|
| lib/features/annonces/presentation/screens/annonce_list_screen.dart | Screen | Liste des annonces (filtrage par état). |
| lib/features/annonces/presentation/screens/annonce_detail_screen.dart | Screen | Détails d’une annonce, commentaires, actions (publier, épingler). |
| lib/features/annonces/presentation/providers/annonce_providers.dart | Provider | Riverpod providers (liste, épinglées, publiées, CRUD). |

## Flux de données
UI → AnnonceProviders → AnnouncementRepositoryImpl ↔ Supabase (`annonces`) + Isar cache → UI.

## Écrans
| Nom | Fichier | Route | Accès | Provider(s) |
|---|---|---|---|---|
| AnnonceListScreen | presentation/screens/annonce_list_screen.dart | `/annonces` (AppRoutes.annonces) | Pastor, Admin, Member | annonce_providers (allAnnoncesProvider) |
| AnnonceDetailScreen | presentation/screens/annonce_detail_screen.dart | `/annonces/:id` (AppRoutes.annonceDetail) | Pastor, Admin | annonce_providers (annonceDetailProvider) |

## Providers
| Provider | Type | Retour | Dépendances | Usage |
|---|---|---|---|---|
| allAnnoncesProvider | FutureProvider<List<Annonce>> | Toutes les annonces (incl. brouillons) | annonceRepositoryProvider | UI liste complète. |
| publishedAnnoncesProvider | FutureProvider<List<Annonce>> | Annonces publiées (`isPublished = true`) | annonceRepositoryProvider | Tableau de bord. |
| pinnedAnnoncesProvider | FutureProvider<List<Annonce>> | Annonces épinglées (`isPinned = true`) | annonceRepositoryProvider | Affichage priorité. |
| annonceDetailProvider | FutureProvider<Annonce?> | Détail d’une annonce par ID | annonceRepositoryProvider | Détails écran. |
| createAnnonceProvider | Provider (AsyncNotifier) | Action création | annonceRepositoryProvider | Création nouvelle annonce. |
| updateAnnonceProvider | Provider (AsyncNotifier) | Action mise à jour | annonceRepositoryProvider | Modification annonce. |
| deleteAnnonceProvider | Provider (AsyncNotifier) | Action suppression | annonceRepositoryProvider | Suppression annonce. |

## Appels Supabase / Isar
| Méthode | Table | Opération | Filtre |
|---|---|---|---|
| IAnnonceRepository.getAnnonces | `annonces` | SELECT | `church_id = ?` |
| IAnnonceRepository.getPublishedAnnonces | `annonces` | SELECT | `is_published = true` |
| IAnnonceRepository.getPinnedAnnonces | `annonces` | SELECT | `is_pinned = true` |
| IAnnonceRepository.createAnnonce | `annonces` | INSERT + cache Isar | – |
| IAnnonceRepository.updateAnnonce | `annonces` | UPDATE | `id = ?` |
| IAnnonceRepository.deleteAnnonce | `annonces` | DELETE | `id = ?` |
| IAnnonceRepository.searchAnnonces | `annonces` | SELECT (LIKE) | `title ILIKE '%query%'` |

## Règles métier importantes
- **RLS** : chaque requête filtrée par `church_id` selon le rôle.
- **Statut** : `status` (`BROUILLON`, `PUBLISHED`, `ARCHIVED`). Publication uniquement si `isPublished = true`.
- **Épinglage** : maximum 3 annonces épinglées simultanément (contrôlé côté logique).
- **Audit** : chaque création/modification/suppression déclenche `logAuditAction` (`entityType = 'annonces'`).

## Cas limites documentés
- **Hors‑ligne** → lecture depuis Isar, nouvelles créations en file `sync_queue`.
- **Conflit de mise à jour** → versionnage via `updatedAt`; rejet si version plus ancienne.
- **Pagination** → Supabase limite à 500 résultats, UI utilise `loadMore`.

## TODO / Incomplétudes détectées
- Aucun test unitaire pour `AnnouncementRepositoryImpl`.
- UI `annonce_detail_screen.dart` ne gère pas correctement les erreurs de chargement.
- Widget `three_d_cross_visual.dart` reste vide (non utilisé).
- Ajouter tests de permission RBAC sur création/modification/suppression.

---
*Document basé sur le code source, aucune supposition.*
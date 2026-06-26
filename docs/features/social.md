# Feature : Social

## Vue d’ensemble
Fil d’actualité social interne à l’église. Les membres peuvent publier des posts, commenter, aimer et partager. Les données sont stockées dans la table Supabase `social_posts` (et `social_comments`) et synchronisées en temps réel via les streams Supabase.

## Rôles concernés
- **Pastor / Admin / SuperAdmin** – création, édition, suppression de tout post, modération des commentaires.
- **Member** – création, édition et suppression de ses propres posts et commentaires, interaction (like, partage).

## Architecture

### Domain
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/social/domain/entities/social_post.dart | SocialPost | Entité post (id, authorId, content, mediaUrls, likesCount, createdAt, tags). |
| lib/features/social/domain/entities/social_comment.dart | SocialComment | Entité commentaire (id, postId, authorId, content, createdAt). |
| lib/features/social/domain/repositories/social_repository.dart | SocialRepository (interface) | CRUD posts, commentaires, flux temps réel, filtres. |

### Data
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/social/data/models/social_post_model.dart | SocialPostModel | Mapper Supabase ↔ Isar, conversion JSON. |
| lib/features/social/data/models/social_comment_model.dart | SocialCommentModel | Mapper Supabase ↔ Isar, conversion JSON. |
| lib/features/social/data/repositories/social_repository_impl.dart | SocialRepositoryImpl | Implémentation Supabase + Isar, stratégie offline‑first, streams via `supabase.from('social_posts').on(...)`.
| lib/features/social/data/repositories/social_realtime_repository.dart | SocialRealtimeRepository | Gestion du stream temps réel pour posts et commentaires.

### Presentation
| Fichier | Type | Description |
|---|---|---|
| lib/features/social/presentation/screens/social_feed_screen.dart | Screen | Fil d’actualité complet, pagination, filtres (tags, date). |
| lib/features/social/presentation/widgets/social_post_card.dart | Widget | Carte affichant texte, médias, compteurs likes/commentaires. |
| lib/features/social/presentation/widgets/social_horizontal_feed.dart | Widget | Feed horizontal pour stories ou posts mis en avant. |
| lib/features/social/presentation/providers/social_providers.dart | Provider | `FutureProvider<List<SocialPost>>` (posts), `socialRealtimeProvider` (stream). |
| lib/features/social/presentation/providers/social_realtime_provider.dart | StreamProvider<List<SocialPost>> | Flux temps réel des nouveaux posts et commentaires. |

## Flux de données
UI → SocialProviders → SocialRepositoryImpl ↔ Supabase (`social_posts`, `social_comments`) + Isar cache → UI. Les posts sont d’abord lus depuis Isar, puis le stream Supabase pousse les nouvelles entrées en temps réel.

## Écrans
| Nom | Fichier | Route | Accès | Provider(s) |
|---|---|---|---|---|
| SocialFeedScreen | presentation/screens/social_feed_screen.dart | `/social` (AppRoutes.social) | Member, Pastor, Admin | social_providers, socialRealtimeProvider |

## Providers
| Provider | Type | Retour | Dépendances | Usage |
|---|---|---|---|---|
| socialPostsProvider | FutureProvider<List<SocialPost>> | Liste initiale de posts (pagination) | socialRepositoryProvider | Chargement initial feed. |
| socialRealtimeProvider | StreamProvider<List<SocialPost>> | Stream temps réel de nouveaux posts et mises à jour | socialRealtimeRepositoryProvider | Mise à jour UI en direct. |
| socialRepositoryProvider | Provider<SocialRepository> | Implémentation Supabase/Isar | - | Accès CRUD et streams. |
| socialRealtimeRepositoryProvider | Provider<SocialRealtimeRepository> | Gestion du canal Supabase realtime | - | Sous‑cription aux changements. |

## Appels Supabase / Isar
| Méthode | Table | Opération | Filtre |
|---|---|---|---|
| SocialRepositoryImpl.getPosts | `social_posts` | SELECT (pagination) | `church_id = ?` + `created_at DESC` |
| SocialRepositoryImpl.createPost | `social_posts` | INSERT + cache Isar | – |
| SocialRepositoryImpl.updatePost | `social_posts` | UPDATE | `id = ?` |
| SocialRepositoryImpl.deletePost | `social_posts` | DELETE | `id = ?` |
| SocialRepositoryImpl.createComment | `social_comments` | INSERT + cache Isar | – |
| SocialRepositoryImpl.getComments | `social_comments` | SELECT | `post_id = ?` |
| SocialRealtimeRepository.subscribePosts | `social_posts` | REaltime stream (INSERT/UPDATE/DELETE) | – |
| SocialRealtimeRepository.subscribeComments | `social_comments` | REaltime stream | – |

## Règles métier importantes
- **RLS** : chaque requête filtrée par `church_id`. 
- **Modération** : seuls les rôles `admin`/`superadmin` peuvent supprimer les posts ou commentaires d’autres membres. 
- **Limite de taille** : contenu texte limité à 1000 caractères, médias via URL stockées dans `mediaUrls`. 
- **Audit** : création, modification, suppression de posts/commentaires déclenchent `logAuditAction` (`entityType = 'social_posts'` / `social_comments`).

## Cas limites documentés
- **Hors‑ligne** → les posts créés localement sont stockés dans Isar avec `isSynced = false`; le stream realtime les enverra dès la reconnexion. 
- **Conflit de mise à jour** → versionnage par `updatedAt`; si le serveur a une version plus récente, le client reçoit l’événement realtime et met à jour l’UI. 
- **Flux massif** → le stream realtime est limité à 200 événements simultanés ; au-delà, le client rafraîchit via pagination.

## TODO / Incomplétudes détectées
- Aucun test unitaire pour `SocialRepositoryImpl` ni pour le realtime. 
- UI `social_feed_screen.dart` ne montre pas de skeleton pendant le chargement initial. 
- Widget `three_d_cross_visual.dart` reste vide (non utilisé). 
- Ajouter tests de permission RBAC (suppression par admin vs membre).

---
*Document basé sur le code source, aucune supposition.*
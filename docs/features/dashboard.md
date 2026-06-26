# Feature : Dashboard

## Vue d’ensemble
Regroupe les indicateurs clés pour chaque rôle (SuperAdmin, Admin, Pastor, Member, GroupLeader). Fournit des vues agrégées : statistiques d’église, activité personnelle, supervision des groupes.

## Rôles concernés
- **SuperAdmin** – vue d’ensemble de toutes les églises, suivi global.
- **Admin** – tableau de bord de son église.
- **Pastor** – statistiques de fréquentation, annonces, posts.
- **Member** – aperçu de sa participation, annonces récentes.
- **GroupLeader** – suivi de son groupe, activités.

## Architecture

### Domain
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/dashboard/presentation/providers/dashboard_providers.dart | Providers (Riverpod) | Agrégation métriques, comptages, perspectives. |
| lib/features/dashboard/presentation/providers/dashboard_providers.dart | DashboardPerspective (enum) | Perspective globale du tableau de bord. |
| lib/features/dashboard/presentation/providers/dashboard_providers.dart | GroupPerspective (enum) | Perspective groupe. |

### Data
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/annonces/domain/repositories/i_annonce_repository.dart | IAnnonceRepository | Accès annonces (publiées, épinglées). |
| lib/features/social/domain/repositories/i_social_repository.dart | ISocialRepository | Accès posts sociaux (témoignages). |
| lib/features/messaging/domain/repositories/i_messaging_repository.dart | IMessagingRepository | Conversations et comptage non‑lus. |

### Presentation
| Fichier | Type | Description |
|---|---|---|
| lib/features/dashboard/presentation/screens/dashboard_screen.dart | Screen | Vue principale selon `DashboardPerspective`. |
| lib/features/dashboard/presentation/screens/group_dashboard_screen.dart | Screen | Vue groupe pour leaders. |
| lib/features/dashboard/presentation/screens/superadmin_dashboard_screen.dart | Screen | Vue SuperAdmin avec monitoring. |

## Flux de données
UI → DashboardProviders → plusieurs repositories (annonces, social, messaging) → Supabase ↔ Isar → UI.

## Écrans
| Nom | Fichier | Route | Accès | Provider(s) |
|---|---|---|---|---|
| DashboardScreen | presentation/screens/dashboard_screen.dart | `/dashboard` (AppRoutes.dashboard) | Pastors, Admin, Member | recentAnnoncesProvider, totalUnreadMessagesProvider, recentTestimoniesCountProvider |
| SuperAdminDashboardScreen | presentation/screens/superadmin_dashboard_screen.dart | `/superadmin/dashboard` (AppRoutes.superadminDashboard) | SuperAdmin | superadminTargetGroupProvider, dashboardPerspectiveProvider |
| GroupDashboardScreen | presentation/screens/group_dashboard_screen.dart | `/group/dashboard` (AppRoutes.groupDashboard) | GroupLeader | groupPerspectiveProvider |

## Providers
| Provider | Type | Retour | Dépendances | Usage |
|---|---|---|---|---|
| totalUnreadMessagesProvider | Provider<int> | Total messages non lus | conversationsProvider (messaging) | Affichage badge notifications. |
| pinnedAnnoncesCountProvider | Provider<int> | Nombre d’annonces épinglées | pinnedAnnoncesProvider (annonces) | Badge tableau de bord. |
| recentAnnoncesProvider | FutureProvider<List<Annonce>> | Dernières annonces publiées (limit 10) | annonceRepositoryProvider | Affichage annonces récentes. |
| recentTestimoniesCountProvider | Provider<int> | Comptage témoignages récents (7 jours) | allPostsProvider (social) | Statistiques pastorales. |
| dashboardPerspectiveProvider | StateProvider<DashboardPerspective> | Perspective courante (overview/personal/monitoring) | - | Contrôle UI. |
| groupPerspectiveProvider | StateProvider<GroupPerspective> | Perspective groupe (group/personal) | - | Contrôle UI groupe. |
| superadminTargetGroupProvider | StateProvider<String?> | Groupe ciblé pour monitoring | - | Filtre données groupe. |

## Appels Supabase / Isar
| Méthode | Table | Opération | Filtre |
|---|---|---|---|
| IAnnonceRepository.getPublishedAnnonces | `annonces` | SELECT (limit) | `is_published = true` |
| IMessageRepository.getConversations | `conversations` | SELECT | `user_id = currentUserId` |
| ISocialRepository.getPosts | `social_posts` | SELECT (limit 10) | – |
| ISocialRepository.getPosts (témoignages) | `social_posts` | SELECT | `content ILIKE '%témoignage%'` AND `created_at > now() - interval '7 days'` |

## Règles métier importantes
- **RLS** : chaque requête filtrée par `church_id` ou `user_id` selon contexte.
- **Statistiques** : compteurs (`totalUnreadMessages`, `recentTestimoniesCount`) calculés côté client à partir de flux déjà mis en cache.
- **Perspectives** : changement de perspective invalide automatiquement les fournisseurs dépendants via `ref.invalidateSelf()`.
- **Audit** : lecture seule, aucune modification directe.

## Cas limites documentés
- **Pas de connexion** → providers utilisent états `loading` et affichent données locales disponibles.
- **Aucun message non lu** → `totalUnreadMessagesProvider` retourne 0, UI masque badge.
- **Aucun témoignage récent** → compteur 0, UI affiche “Aucun témoignage récent”.

## TODO / Incomplétudes détectées
- Aucun test unitaire pour les providers de tableau de bord.
- Widget `three_d_cross_visual.dart` reste vide (non utilisé).
- Ajouter tests de performance pour `recentTestimoniesCountProvider` (filtrage lourd).

---
*Document basé sur le code source, aucune supposition.*
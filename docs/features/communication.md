# Feature : Communication

## Vue d’ensemble
Regroupe les annonces de l’église, le fil d’actualité social et les statistiques de messagerie. Fournit un tableau de bord agrégé pour les utilisateurs afin de visualiser les dernières annonces publiées, les posts récents et le nombre total d’annonces.

## Rôles concernés
- **Pastor / Admin / SuperAdmin** – visualisation de toutes les annonces et posts, possibilité de publier (via modules Annonces et Social séparés).
- **Member** – accès en lecture aux annonces publiées et aux posts récents.

## Architecture

### Domain
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/communication/presentation/controllers/communication_controller.dart | CommunicationController (Riverpod AsyncNotifier) | Agrège données des dépôts Announce et Social, construit `CommunicationState`. |
| lib/features/communication/presentation/controllers/communication_controller.dart | CommunicationState | DTO contenant listes d’annonces, posts récents, totaux. |

### Data
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/annonces/domain/repositories/i_annonce_repository.dart | IAnnonceRepository | Fournit `getAnnonces` (CRUD annonces). |
| lib/features/social/domain/repositories/i_social_repository.dart | ISocialRepository | Fournit `getPosts` (fil social). |

### Presentation
| Fichier | Type | Description |
|---|---|---|
| lib/features/communication/presentation/screens/communication_home_screen.dart | Screen | Vue principale affichant annonces, posts épinglés et récents. |
| lib/features/communication/presentation/controllers/communication_controller.dart | Controller | Gestion état, rafraîchissement. |

## Flux de données
UI → CommunicationController → AnnounceRepository + SocialRepository → Supabase (annonces, posts) ↔ Isar (cache) → UI.

## Écrans
| Nom | Fichier | Route | Accès | Provider(s) |
|---|---|---|---|---|
| CommunicationHomeScreen | presentation/screens/communication_home_screen.dart | `/communication` (AppRoutes.communication) | Pastor, Admin, Member | communication_controller |

## Providers
| Provider | Type | Retour | Dépendances | Usage |
|---|---|---|---|---|
| communication_controller (class) | AsyncNotifier | CommunicationState | annonceRepositoryProvider, socialRepositoryProvider, optional churchId | Charge données tableau de bord, rafraîchit. |

## Appels Supabase / Isar
| Méthode | Table | Opération | Filtre |
|---|---|---|---|
| IAnnonceRepository.getAnnonces | `annonces` | SELECT | `church_id = ?` |
| ISocialRepository.getPosts | `social_posts` | SELECT (limit 10) | – |

## Règles métier importantes
- **Visibilité** : seules les annonces `isPublished = true` sont affichées aux membres.
- **Épinglage** : `isPinned = true` place l’annonce en haut du tableau.
- **Statistiques** : `unreadAnnouncementCount` calcule les annonces non vues (viewsCount = 0).
- **RLS** : filtrage par `church_id` pour chaque requête.

## Cas limites documentés
- **Pas de connexion** → les appels tombent sur le cache Isar; le tableau de bord montre les dernières données locales.
- **Aucun post** → `recentPosts` retourne liste vide, UI affiche message vide.

## TODO / Incomplétudes détectées
- Aucun test unitaire pour `CommunicationController`.
- UI `communication_home_screen.dart` ne montre pas indicateur de synchronisation Isar.
- Widget `three_d_cross_visual.dart` reste vide (non utilisé).
- Ajouter tests de permission pour affichage annonces selon rôle.

---
*Document basé sur le code source, aucune supposition.*
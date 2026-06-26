# Feature : Bergers

## Vue d’ensemble
Gestion des bergers (pastors) : planification des visites pastorales, création de rapports de visite, suivi des actions. Les données sont stockées dans les tables `pastors`, `visites_pastorales`.

## Rôles concernés
- **Pastor** – création et édition de ses propres visites.
- **Admin / SuperAdmin** – gestion de tous les bergers et visualisation de tous les rapports.

## Architecture

### Domain
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/bergers/domain/entities/pastor.dart | Pastor | Représente un berger. |
| lib/features/bergers/domain/entities/visite_pastorale.dart | VisitePastorale | Rapport de visite. |
| lib/features/bergers/domain/repositories/i_berger_repository.dart | IBergerRepository (interface) | CRUD sur bergers et visites. |

### Data
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/bergers/data/models/pastor_model.dart | PastorModel | Mapper Supabase ↔ Pastor. |
| lib/features/bergers/data/models/visite_model.dart | VisiteModel | Mapper Supabase ↔ VisitePastorale. |
| lib/features/bergers/data/repositories/shepherd_repository_impl.dart | ShepherdRepositoryImpl | Implémentation des appels Supabase sur `pastors` et `visites_pastorales`. |

### Presentation
| Fichier | Type | Description |
|---|---|---|
| lib/features/bergers/presentation/screens/shepherd_list_screen.dart | Screen | Liste des bergers. |
| lib/features/bergers/presentation/screens/visite_form_screen.dart | Screen | Formulaire de création / édition d’une visite. |
| lib/features/bergers/presentation/widgets/shepherd_card.dart | Widget | Carte d’un berger. |
| lib/features/bergers/presentation/providers/shepherd_providers.dart | Provider | StateNotifier pour charger les bergers et leurs visites. |

## Flux de données
UI → ShepherdProvider → ShepherdRepositoryImpl → Supabase (`pastors`, `visites_pastorales`) + Isar cache → UI.

## Écrans
| Nom | Fichier | Route | Accès | Provider(s) |
|---|---|---|---|---|
| ShepherdListScreen | presentation/screens/shepherd_list_screen.dart | `/bergers` (AppRoutes.bergers) | Admin, SuperAdmin | shepherd_providers |
| VisiteFormScreen | presentation/screens/visite_form_screen.dart | `/bergers/:id/visite` | Pastor (own) | shepherd_providers |

## Providers
| Provider | Type | Retour | Dépendances | Usage |
|---|---|---|---|---|
| shepherd_providers | StateNotifierProvider<ShepherdState> | Liste de bergers et visites | ShepherdRepositoryImpl | Utilisé par les écrans list et form.

## Appels Supabase / Isar
| Méthode | Table | Opération | Filtre |
|---|---|---|---|
| ShepherdRepositoryImpl.getAllPastors | `pastors` | SELECT | `church_id = currentChurchId` |
| ShepherdRepositoryImpl.createVisite | `visites_pastorales` | INSERT | `pastor_id = currentUserId` |
| ShepherdRepositoryImpl.updateVisite | `visites_pastorales` | UPDATE | `id = <visiteId>` |

## Règles métier importantes
- **RBAC** : seuls les bergers peuvent modifier leurs propres visites ; les admins peuvent tout modifier.
- **Validation de date** : le formulaire de visite empêche les dates futures.

## Cas limites documentés
- **Création hors‑ligne** → visite mise en `sync_queue`.
- **Erreur de sauvegarde** → `AsyncError` affiché avec le texte « Impossible d’enregistrer la visite. ».

## TODO / Incomplétudes détectées
- Aucun test unitaire pour `ShepherdRepositoryImpl`.
- Widget `three_d_cross_visual.dart` reste vide.

# Feature : Events

## Vue d’ensemble
Gestion du calendrier ecclésial : création, édition, consultation et suppression d’événements (messes, mariages, baptêmes, réunions, conférences, retraites, etc.). Les événements sont stockés dans la table Supabase `events` et synchronisés avec le cache local Isar. Support offline‑first, filtres par type, statut, date et église (`church_id`).

## Rôles concernés
- **Admin / SuperAdmin** – création, modification, suppression de tout événement, gestion des campagnes de suivi, accès aux statistiques globales. 
- **Pastor** – création et édition d’événements religieux (messe, baptême, mariage), accès complet aux événements de son église. 
- **GroupLeader** – création d’événements de groupe (réunions, retraites) liés à son groupe via `church_id`. 
- **Treasurer** – lecture des événements pour la planification budgétaire, gestion du champ `budgetAccountId`. 
- **Member** – visualisation des événements (liste, calendrier) et inscription éventuelle via UI (hors scope du backend).

## Architecture

### Domain
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/events/domain/entities/event.dart | Event | Entité événement (id, type, dates, lieu, statut, budget, participants, métadonnées). |
| lib/features/events/domain/entities/event_type.dart | EventType | Enumération typologique avec label et icône. |
| lib/features/events/domain/repositories/i_event_repository.dart | IEventRepository (interface) | CRUD événements, recherche, filtres, flux realtime. |

### Data
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/events/data/models/event_model.dart | EventModel | Mapper Supabase ↔ Isar, conversion JSON. |
| lib/features/events/data/repositories/event_repository_impl.dart | EventRepositoryImpl | Implémentation du repository : appels Supabase, synchronisation Isar, gestion du `OfflineSyncManager` pour les actions en mode hors‑ligne. |
| lib/features/events/data/models/event_model.g.dart | – | Généré par Isar (persist). |

### Presentation
| Fichier | Type | Description |
|---|---|---|
| lib/features/events/presentation/screens/events_screen.dart | Screen | Vue liste d’événements avec filtres (type, statut, période). |
| lib/features/events/presentation/screens/event_detail_screen.dart | Screen | Détails d’un événement, actions édition/suppression (selon rôle). |
| lib/features/events/presentation/screens/event_form_screen.dart | Screen | Formulaire création/édition : validation champs, sélection date/heure, type d’événement. |
| lib/features/events/presentation/screens/calendar_screen.dart | Screen | Calendrier mensuel affichant les événements sous forme de points colorés selon `EventType`. |
| lib/features/events/presentation/widgets/event_card.dart | Widget | Carte affichant titre, date, icône type, statut, couleur. |
| lib/features/events/presentation/widgets/add_event_dialog.dart | Widget | Dialog modal pour création rapide d’un événement depuis la liste. |
| lib/features/events/presentation/providers/event_providers.dart | Provider | Riverpod : `eventsProvider` (stream), `eventByIdProvider`, `upcomingEventsProvider`, `pastEventsProvider`, `eventSearchProvider`, `eventNotifierProvider` (AsyncNotifier) et actions CRUD. |

## Flux de données
UI → Providers (Riverpod) → `EventRepositoryImpl` → Supabase (`events`) + Isar cache. Lecture prioritaire depuis Isar ; écriture locale immédiate, puis tentative de synchronisation Supabase. En cas d’échec (ex. hors‑ligne) l’action est placée dans la file `sync_queue` via `OfflineSyncManager` pour synchronisation ultérieure.

## Écrans
| Nom | Fichier | Route | Accès | Provider(s) |
|---|---|---|---|---|
| EventsScreen | presentation/screens/events_screen.dart | `AppRoutes.events` | Tous rôles autorisés | `eventsProvider`, `eventFilterProvider`, `filteredEventsProvider`. |
| EventDetailScreen | presentation/screens/event_detail_screen.dart | `AppRoutes.eventDetail` (id) | Admin, Pastor, GroupLeader | `eventByIdProvider`, `eventActionsProvider`. |
| EventFormScreen | presentation/screens/event_form_screen.dart | `AppRoutes.eventForm` (id?) | Admin, Pastor, GroupLeader | `eventActionsProvider`. |
| CalendarScreen | presentation/screens/calendar_screen.dart | `AppRoutes.calendar` | Tous rôles | `eventsProvider` (tri par date). |

## Providers
| Provider | Type | Retour | Dépendances | Usage |
|---|---|---|---|---|
| eventsProvider | StreamProvider<List<Event>> | Flux temps réel d’événements (option `churchId`). | `eventRepositoryProvider` | Affichage liste principale. |
| allEventsProvider | StreamProvider<List<Event>> | Alias du flux complet. | `eventsProvider` | Widgets qui ne filtrent pas. |
| upcomingEventsProvider | FutureProvider<List<Event>> | 10 prochains événements. | `eventRepositoryProvider` | Dashboard / notifications. |
| pastEventsProvider | FutureProvider<List<Event>> | 10 derniers événements. | idem | Historique. |
| eventSearchProvider | FutureProvider.family<List<Event>, String> | Recherche texte libre. | `eventRepositoryProvider` | Barre de recherche. |
| eventByIdProvider | FutureProvider.family<Event?, String> | Détails par id. | idem | Détail écran. |
| eventNotifierProvider | AsyncNotifierProvider<EventNotifier, List<Event>> | Gestion d’état mutable (CRUD) avec audit. | `eventRepositoryProvider` | Actions créées dans UI. |
| eventActionsProvider | Provider<EventNotifier> | Accès aux méthodes `addEvent`, `updateEvent`, `deleteEvent`, `refresh`. |
| selectedDateProvider | StateProvider<DateTime> | Date sélectionnée dans le calendrier. |
| eventFilterProvider | StateProvider<EventFilter> | Filtre global (all/upcoming/past). |
| filteredEventsProvider | Provider<AsyncValue<List<Event>>> | Liste filtrée en fonction du filtre choisi. |

## Appels Supabase / Isar
| Méthode | Table | Opération | Filtre |
|---|---|---|---|
| EventRepositoryImpl.getEvents | `events` | SELECT (order `date` DESC) | `church_id = ?`, `type = ?`, `status = ?`, période (`date` between ...) |
| EventRepositoryImpl.getEventById | `events` | SELECT | `id = ?`. |
| EventRepositoryImpl.createEvent | `events` | INSERT (sans id, Supabase génère) | – |
| EventRepositoryImpl.updateEvent | `events` | UPDATE | `id = ?`. |
| EventRepositoryImpl.deleteEvent | `events` | DELETE | `id = ?`. |
| EventRepositoryImpl.searchEvents | – | Filtrage en mémoire sur le flux complet | query sur `title`, `description`, `location`, `type.label`. |
| EventRepositoryImpl.getUpcomingEvents | – | Filtrage en mémoire sur `date > now` | – |
| EventRepositoryImpl.getPastEvents | – | Filtrage `date < now` | – |
| EventRepositoryImpl.watchEvents | `events` (Realtime) | Stream en temps réel via Supabase Realtime (fallback à Isar si disponible). |
| IsarService.saveEvent / getEvents / deleteEvent | Isar local | Persistance locale, indices sur `churchId`, `type`, `date`. |
| OfflineSyncManager.registerAction | – | File d’attente (`sync_queue`) pour INSERT / UPDATE / DELETE en cas de perte de connexion. |

## Règles métier importantes
- **RLS** : chaque requête filtrée par `church_id` et, le cas échéant, par `type`. 
- **Statut** : champ `status` (ex. `planned`, `confirmed`, `canceled`). Seules les actions d’édition/suppression sont autorisées si le statut n’est pas `canceled`. 
- **Budget** : `estimatedBudget` et `actualBudget` sont obligatoires pour les événements financiers ; `budgetAccountId` doit référencer un compte valide (vérifié côté UI). 
- **Capacité** : `maxSeats` impose une contrainte d’inscription ; l’UI désactive le bouton d’inscription lorsque le nombre d’inscrits atteint la capacité. 
- **Dates** : `date` obligatoire, `endDate` optionnel ; validation : `endDate` ≥ `date`. 
- **Audit** : chaque création, mise à jour et suppression déclenche `logAuditAction` (`entityType = 'events'`). 
- **Permission RBAC** : seules les personnes avec rôle `admin`, `pastor` ou `groupLeader` appartenant à la même église peuvent modifier ou supprimer un événement. 
- **Soft‑delete** : suppression physique via `DELETE`; aucune logique de soft‑delete actuelle (peut être ajoutée si besoin futur). 

## Cas limites documentés
- **Hors‑ligne** : création/modification sauvegardée en Isar avec `isSynced = false`; le `OfflineSyncManager` reclenche la synchronisation lors du retour en ligne. 
- **Conflit de création** : deux utilisateurs créent simultanément un même événement (même titre, même date) ; Supabase renvoie un conflit, le repository journalise l’erreur et garde la version locale en attente. 
- **Événement récurrent** : non supporté ; chaque occurrence doit être créée séparément. 
- **Filtre par type inconnu** : `EventType.fromString` lève `ArgumentError`; le repository capture l’erreur et renvoie une liste vide. 
- **Mise à jour partielle** : le backend accepte seulement les champs fournis ; les champs non fournis restent inchangés. 
- **Supabase realtime désactivé** : si la connexion Realtime échoue, le provider bascule sur le cache Isar et rafraîchit périodiquement via requête `getEvents`. 

## TODO / Incomplétudes détectées
- Aucun test unitaire pour `EventRepositoryImpl` ni pour les Riverpod providers. 
- UI `events_screen.dart` ne montre pas de skeleton pendant le chargement (remplacer par `ShimmerLoading`). 
- Widget `event_card.dart` ne gère pas encore l’affichage du statut `canceled` (affichage gris). 
- Ajouter tests d’intégration pour le scénario offline → sync. 
- Implémenter la fonction d’inscription des membres à un événement (gestion `participantsIds`). 
- Ajouter export CSV/PDF de la liste d’événements (utile pour planning). 
- Implémenter les notifications push lorsqu’un événement est créé ou mis à jour (via service de notifications). 
- Gestion des rappels de paiement budgétaire liée aux événements financiers. 

---
*Document basé sur le code source, aucune supposition.*
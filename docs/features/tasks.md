# Feature : Tasks

## Vue d’ensemble
Gestion des tâches internes (actions, suivis, assignations) utilisées dans le tableau de bord et les sections de groupe. Les tâches sont persistées dans la table Supabase `tasks` et synchronisées localement via Isar.

## Rôles concernés
- **Admin / SuperAdmin** – création, assignation, modification, suppression de toutes les tâches.
- **GroupLeader** – création et gestion des tâches rattachées à son groupe.
- **Member** – visualisation des tâches qui lui sont assignées, mise à jour du statut (`in_progress`, `completed`).

## Architecture

### Domain
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/tasks/domain/entities/task.dart | Task | Entité tâche avec champs `id`, `title`, `description`, `type`, `status`, `assignedToId`, `groupId`, `dueDate`, `createdAt`, `updatedAt`. |
| lib/features/tasks/domain/repositories/i_task_repository.dart | ITaskRepository (interface) | CRUD, flux d’observation (`watchTasks`). |
| lib/features/tasks/domain/usecases/create_task_usecase.dart | CreateTaskUseCase | Validation, appel repository, audit. |
| lib/features/tasks/domain/usecases/update_task_usecase.dart | UpdateTaskUseCase | Mise à jour statut, assignation. |
| lib/features/tasks/domain/usecases/delete_task_usecase.dart | DeleteTaskUseCase | Soft‑delete (`isDeleted`). |

### Data
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/tasks/data/models/task_model.dart | TaskModel | Mapper Supabase ↔ Isar, conversion JSON. |
| lib/features/tasks/data/repositories/task_repository_impl.dart | TaskRepositoryImpl | Implémentation Supabase + Isar, offline‑first, file `sync_queue`. |

### Presentation
| Fichier | Type | Description |
|---|---|---|
| lib/features/tasks/presentation/screens/tasks_screen.dart | Screen | Vue liste des tâches filtrées par groupe, type, statut. |
| lib/features/tasks/presentation/widgets/task_card.dart | Widget | Carte affichant titre, statut, deadline, assigné. |
| lib/features/tasks/presentation/providers/tasks_provider.dart | Provider | `FutureProvider<Task?>` (par ID), `StreamProvider<List<Task>>` (watch), `TasksController` (actions). |

## Flux de données
UI → TasksProvider → TaskRepositoryImpl ↔ Supabase (`tasks`) + Isar cache → UI. Lecture prioritaire Isar; écritures synchronisées, file `sync_queue` hors‑ligne.

## Écrans
| Nom | Fichier | Route | Accès | Provider(s) |
|---|---|---|---|---|
| TasksScreen | presentation/screens/tasks_screen.dart | `/tasks` (AppRoutes.tasks) | Admin, GroupLeader, Member | tasks_provider (watchTasks), taskProvider (task). |

## Providers
| Provider | Type | Retour | Dépendances | Usage |
|---|---|---|---|---|
| taskProvider | FutureProvider<Task?> | Détails tâche par ID | taskRepositoryProvider | Page détail. |
| watchTasksProvider | StreamProvider<List<Task>> | Flux temps réel (filtré) | taskRepositoryProvider | Liste principale. |
| tasksController | AsyncNotifierProvider<TasksController> | Actions CRUD (create, update, delete, markCompleted) | taskRepositoryProvider | Gestion UI. |
| taskRepositoryProvider | Provider<ITaskRepository> | Implémentation Supabase/Isar | - | Accès CRUD. |

## Appels Supabase / Isar
| Méthode | Table | Opération | Filtre |
|---|---|---|---|
| TaskRepositoryImpl.getTaskById | `tasks` | SELECT | `id = ?` |
| TaskRepositoryImpl.watchTasks | `tasks` | SELECT (stream) | `church_id = ?` + filtres `type`, `groupId`, `assignedToId` |
| TaskRepositoryImpl.createTask | `tasks` | INSERT + cache Isar | – |
| TaskRepositoryImpl.updateTask | `tasks` | UPDATE | `id = ?` |
| TaskRepositoryImpl.deleteTask | `tasks` | UPDATE `isDeleted = true` (soft‑delete) | `id = ?` |

## Règles métier importantes
- **RLS** : chaque requête filtrée par `church_id`. 
- **Assignation** : un membre ne peut être assigné qu’à des tâches appartenant à son groupe ou à l’église globale. 
- **Statuts** : `pending`, `in_progress`, `completed`, `archived`. Seuls les rôles `admin`/`groupLeader` peuvent passer à `archived`. 
- **Audit** : chaque création/modif/suppression déclenche `logAuditAction` (`entityType = 'tasks'`). 
- **Soft‑delete** : les tâches supprimées restent dans Isar pour l’historique.

## Cas limites documentés
- **Hors‑ligne** → création/modif stockées localement avec `isSynced = false`; synchronisation via `sync_queue`. 
- **Conflit de mise à jour** → versionnage via `updatedAt`; si le timestamp est antérieur, l’appel échoue et retourne `ConflictError`. 
- **Charge élevée** → le flux `watchTasks` utilise pagination serveur (500 max) et lazy‑loading côté UI.

## TODO / Incomplétudes détectées
- Aucun test unitaire pour `TaskRepositoryImpl`. 
- UI `tasks_screen.dart` ne montre pas de skeleton pendant le chargement. 
- Widget `three_d_cross_visual.dart` reste vide (non utilisé). 
- Ajouter tests d’intégration pour le scénario offline → sync.

---
*Document basé sur le code source, aucune supposition.*
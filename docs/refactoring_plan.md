# Plan de Refonte Stratégique : Lumina V2 (Stable)

Ce plan divise la refonte en 5 phases pour assurer une transition en douceur sans casser les fonctionnalités critiques actuelles.

---

## Phase 1 : Les Fondations (Core Engine)
**Objectif** : Stabiliser le moteur de synchronisation et la sécurité.
- [ ] Créer `lib/core/architecture/` : `Result`, `Failure`, `BaseRepository`.
- [ ] Créer `lib/core/sync/` : Nouveau `SyncEngine` avec verrouillage persistant (Database-level lock).
- [ ] Unifier le `SecurityInterceptor` pour le multi-tenant.

## Phase 2 : Modèles de Données & Isar
**Objectif** : Aligner Isar et Supabase pour le Local-First.
- [ ] Ajouter `version` et `is_deleted` à tous les schémas Isar.
- [ ] Refactoriser `IsarService` pour supprimer les transactions imbriquées (Deadlocks).

## Phase 3 : Migration "Finance Elite"
**Objectif** : Prouver la performance sur le module le plus lent.
- [ ] Implémenter le déchiffrement en Isolate (compute).
- [ ] Migrer les totaux (bilans) vers des requêtes Isar natives (SQL).
- [ ] Intégrer les transactions financières dans la nouvelle SyncEngine.

## Phase 4 : Migration "Messaging & Social"
**Objectif** : Fiabiliser le temps réel.
- [ ] Implémenter les "Self-Cleaning Streams".
- [ ] Passer la création de messages/posts en mode "Offline-First" via la file de synchro.

## Phase 5 : UI/UX Premium & Finalisation
**Objectif** : Sensation de fluidité absolue.
- [ ] Remplacer les `FutureBuilder` restants par des `StreamProvider`.
- [ ] Implémenter les `Skeleton Shimmers` personnalisés pour chaque écran.
- [ ] Audit final `flutter analyze` et test de charge.

---

### Protocole d'exécution
À la fin de chaque tâche :
1. Analyse manuelle du code.
2. `dart run build_runner build` (si applicable).
3. Commit & Push avec tag de version.

# Plan de Refonte Stratégique Lumina V2.1 : Simplification de la Logique

Ce document cartographie la suppression de la logique héritée de sélection de groupe et d'approbation au sein de l'onboarding, tout en consolidant l'architecture résiliente mise en place dans cette session.

---

## 1. Synthèse du Contexte (Récupération des Tâches Effectuées)

| Domaine | Actions Réalisées | Impact sur la Stabilité |
| :--- | :--- | :--- |
| **Persistance** | Refonte `IsarService` (Raw/Atomic), Suppression Deadlocks. | ✅ Critique : Plus de crashs synchro. |
| **Sync Engine** | Implémentation `SyncLock` (DB-level lock) et `SyncOperationV2`. | ✅ Haute : Synchro fiable background/foreground. |
| **Sécurité** | `ChurchFilterMixin` strict (Multi-tenant enforced). | ✅ Haute : Étanchéité totale entre églises. |
| **Performance** | Finances en Multi-threading (Isolates) + Isar Aggregates. | ✅ Haute : 60 FPS constants. |
| **UI/UX 2.0** | Création `LuminaDesign` & `LuminaPage`. Onboarding à 2 étapes. | ✅ Haute : Cohérence et fluidité. |
| **Qualité** | Correction de 50+ issues `flutter analyze` + CI/CD active. | ✅ Critique : Code "Zero Warning". |

---

## 2. Cartographie de la Logique à Supprimer (Legacy Group Flow)

L'ancienne logique de sélection de groupe et d'approbation par le leader crée une complexité inutile. Voici les composants identifiés pour suppression :

### A. Écrans & UI
- [ ] `lib/features/onboarding/presentation/screens/group_selection_screen.dart` (Suppression totale)
- [ ] `lib/features/groups/presentation/screens/group_join_requests_screen.dart` (Suppression totale)
- [ ] `lib/features/onboarding/presentation/screens/onboarding_group_screens.dart` (Anciennes vues par rôle)

### B. Entités & Modèles
- [ ] `lib/features/onboarding/domain/entities/onboarding_progress.dart` : Retrait de `groupSelectionSkipped` et `selectedGroupId`.
- [ ] `lib/features/onboarding/presentation/providers/onboarding_progress_provider.dart` : Retrait de `selectGroup()` et `clearSelectedGroup()`.

### C. Routage
- [ ] `lib/core/router/routes/auth_routes.dart` : Retrait de la route `/onboarding/select-group`.
- [ ] `lib/core/router/routes/dashboard_routes.dart` : Nettoyage des routes liées aux requêtes de rejointe.

---

## 3. Taskboard d'Implémentation (Lumina V2.1)

| ID | Tâche | Fichier(s) Cible(s) | Risque | État |
| :-- | :--- | :--- | :--- | :--- |
| **T.1** | Suppression physique des écrans legacy. | `group_selection_screen.dart`, `group_join_requests_screen.dart`. | Faible | ⏳ Attente |
| **T.2** | Nettoyage de l'entité `OnboardingProgress`. | `onboarding_progress.dart`. | Moyen (Parsing JSON) | ⏳ Attente |
| **T.3** | Simplification du provider de progression. | `onboarding_progress_provider.dart`. | Faible | ⏳ Attente |
| **T.4** | Nettoyage des routes et imports orphelins. | `auth_routes.dart`, `dashboard_routes.dart`. | Moyen (Navigation) | ⏳ Attente |
| **T.5** | Validation finale `flutter analyze` + `CI`. | — | N/A | ⏳ Attente |

---

## ⚠️ Règle de Consentement
**Aucune modification ne sera effectuée avant votre validation de ce plan.**

*Saga (Analyste) : "Ce plan garantit que nous ne laissons aucune 'code zombie' derrière nous."*
*Winston (Architecte) : "La suppression de ces champs dans l'entité Onboarding nécessite une mise à jour de la factory JSON pour rester compatible avec Isar."*

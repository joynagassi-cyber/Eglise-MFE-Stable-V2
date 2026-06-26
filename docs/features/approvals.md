# Feature : Approvals

## Vue d'ensemble
Système de workflow d'approbation utilisé par plusieurs modules (finance, demandes d'accès, modifications de paramètres). Chaque demande crée un enregistrement dans la table `approvals` et progresse à travers les étapes *pending → approved → rejected*.

## Rôles concernés
- **Admin / SuperAdmin** – peut approuver ou rejeter.
- **Staff** – peut créer des demandes d'approbation.

## Architecture

### Domain
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/approvals/domain/entities/approval.dart | Approval | Entité métier représentant une demande d'approbation. |
| lib/features/approvals/domain/repositories/i_approval_repository.dart | IApprovalRepository (interface) | CRUD des approbations. |
| lib/features/approvals/domain/usecases/approve_request_usecase.dart | ApproveRequestUseCase | Logique d'approbation. |
| lib/features/approvals/domain/usecases/reject_request_usecase.dart | RejectRequestUseCase | Logique de rejet. |

### Data
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/approvals/data/models/approval_model.dart | ApprovalModel | Mapper Supabase ↔ Approval. |
| lib/features/approvals/data/repositories/approval_repository_impl.dart | ApprovalRepositoryImpl | Implémentation des appels Supabase sur `approvals`. |

### Presentation
| Fichier | Type | Description |
|---|---|---|
| lib/features/approvals/presentation/screens/approval_taskboard_screen.dart | Screen | Tableau de bord des demandes en attente. |
| lib/features/approvals/presentation/widgets/approval_card.dart | Widget | Carte affichant le statut et les actions. |
| lib/features/approvals/presentation/providers/approval_providers.dart | Provider | StateNotifier qui charge les demandes. |

## Flux de données
UI → ApprovalProvider → ApprovalRepositoryImpl → Supabase `approvals` + Isar cache → UI.

## Écrans
| Nom | Fichier | Route | Accès | Provider(s) |
|---|---|---|---|---|
| ApprovalTaskboardScreen | presentation/screens/approval_taskboard_screen.dart | `/approvals` (AppRoutes.approvals) | Admin, SuperAdmin | approval_providers |

## Providers
| Provider | Type | Retour | Dépendances | Usage |
|---|---|---|---|---|
| approval_providers | StateNotifierProvider<ApprovalState> | Liste des demandes | ApprovalRepositoryImpl | Utilisé par le tableau de bord. |

## Appels Supabase / Isar
| Méthode | Table | Opération | Filtre |
|---|---|---|---|
| ApprovalRepositoryImpl.getPending | `approvals` | SELECT | `status = 'pending'` |
| ApprovalRepositoryImpl.approve | `approvals` | UPDATE | `id = <requestId>, status = 'approved'` |
| ApprovalRepositoryImpl.reject | `approvals` | UPDATE | `id = <requestId>, status = 'rejected'` |

## Règles métier importantes
- **RBAC** : seules les personnes avec le rôle `admin` ou `superAdmin` peuvent appeler les use‑cases d’approbation/rejet.
- **Audit** : chaque changement de statut crée une entrée dans la table `audit_logs`.

## Cas limites documentés
- **Création hors‑ligne** : la demande est mise en file `sync_queue`.
- **Timeout d'approbation** : si aucune action après 30 jours, la demande passe automatiquement en `expired` (non implémenté). 

## TODO / Incomplétudes détectées
- Pas de tests unitaires pour `ApprovalRepositoryImpl`.
- Le widget `three_d_cross_visual.dart` reste vide et non‑utilisé.

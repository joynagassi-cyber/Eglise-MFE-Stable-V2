# Feature : Audit

## Vue d’ensemble
Enregistrement immuable des actions critiques (login, création/modification de données sensibles, changements de configuration). Les logs sont stockés dans la table Supabase `audit_logs` et consultables via le tableau de bord d’audit.

## Rôles concernés
- **SuperAdmin** – accès complet à tous les logs.
- **Admin** – accès en lecture aux logs de son église.

## Architecture

### Domain
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/audit/domain/models/audit_log.dart | AuditLog | Représente une entrée de log. |
| lib/features/audit/domain/models/audit_anomaly.dart | AuditAnomaly | Anomalie détectée (ex : accès non autorisé). |
| lib/features/audit/domain/services/audit_service.dart | AuditService | Méthodes de création de logs. |

### Data
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/audit/data/repositories/audit_repository_impl.dart | AuditRepositoryImpl | CRUD sur `audit_logs`. |

### Presentation
| Fichier | Type | Description |
|---|---|---|
| lib/features/audit/presentation/audit_dashboard_screen.dart | Screen | Vue principale du tableau d’audit. |
| lib/features/audit/presentation/widgets/audit_filters_bar.dart | Widget | Barres de filtres (date, type, utilisateur). |
| lib/features/audit/presentation/widgets/audit_anomaly_list.dart | Widget | Liste des anomalies détectées. |
| lib/features/audit/presentation/providers/audit_providers.dart | Provider | StateNotifier pour charger les logs. |

## Flux de données
UI → AuditProvider → AuditRepositoryImpl → Supabase `audit_logs` + Isar cache → UI.

## Écrans
| Nom | Fichier | Route | Accès | Provider(s) |
|---|---|---|---|---|
| AuditDashboardScreen | presentation/audit_dashboard_screen.dart | `/audit` (AppRoutes.audit) | SuperAdmin, Admin | audit_providers |

## Providers
| Provider | Type | Retour | Dépendances | Usage |
|---|---|---|---|---|
| audit_providers | StateNotifierProvider<AuditState> | Liste des logs filtrés | AuditRepositoryImpl | Utilisé par le tableau d’audit. |

## Appels Supabase / Isar
| Méthode | Table | Opération | Filtre |
|---|---|---|---|
| AuditRepositoryImpl.getLogs | `audit_logs` | SELECT | `church_id = currentChurchId` + filtres date/type |
| AuditRepositoryImpl.createLog | `audit_logs` | INSERT | — |

## Règles métier importantes
- **RLS** : chaque log est filtré par `church_id`. 
- **Intégrité** : les logs sont en lecture‑seule une fois créés.

## Cas limites documentés
- **Volume élevé** : les logs sont paginés côté serveur (limite 500 entrées par requête). 
- **Erreur d’insertion** → `AsyncError` affiché dans le UI.

## TODO / Incomplétudes détectées
- Pas de tests unitaires sur `AuditRepositoryImpl`.
- Le widget `three_d_cross_visual.dart` reste vide.

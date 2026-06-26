# Feature : Bilan

## Vue d’ensemble
Génération de bilans comptables (CSV, PDF) pour les comptes de l’église. Le module agrège les données financières (transactions, budgets) et applique les règles de conformité fiscale.

## Rôles concernés
- **Trésorier** – création et export des bilans.
- **Admin / SuperAdmin** – accès à tous les bilans.

## Architecture

### Domain
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/bilan/domain/entities/bilan_entities.dart | BilanEntity | Représente un bilan (période, totaux). |
| lib/features/bilan/domain/services/bilan_service.dart | BilanService | Logique de génération (agrégation, formatage). |
| lib/features/bilan/domain/services/fec_export_service.dart | FECExportService | Export au format français standard FEC. |

### Data
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/bilan/data/models/bilan_summary.dart | BilanSummaryModel | Mapper des totaux agrégés. |
| lib/features/bilan/data/repositories/bilan_repository.dart | BilanRepository | Accès aux tables `finance_transactions`, `budgets`. |

### Presentation
| Fichier | Type | Description |
|---|---|---|
| lib/features/bilan/presentation/screens/bilan_pdf_customizer.dart | Screen | Interface de paramétrage du PDF (période, filtres). |
| lib/features/bilan/presentation/widgets/bilan_seal_dialog.dart | Widget | Dialogue de validation (signature). |
| lib/features/bilan/presentation/providers/bilan_providers.dart | Provider | StateNotifier qui lance la génération. |

## Flux de données
UI → BilanProvider → BilanService → Lecture de `finance_transactions` & `budgets` (Supabase) → génération PDF/CSV → téléchargement.

## Écrans
| Nom | Fichier | Route | Accès | Provider(s) |
|---|---|---|---|---|
| BilanPdfCustomizer | presentation/screens/bilan_pdf_customizer.dart | `/bilan/pdf` (AppRoutes.bilan) | Trésorier, Admin | bilan_providers |

## Providers
| Provider | Type | Retour | Dépendances | Usage |
|---|---|---|---|---|
| bilan_providers | StateNotifierProvider<BilanState> | Statut de génération (idle, generating, completed) | BilanService, BilanRepository | UI de génération.

## Appels Supabase / Isar
| Méthode | Table | Opération | Filtre |
|---|---|---|---|
| BilanRepository.getTransactions | `finance_transactions` | SELECT | `church_id = currentChurchId` + période |
| BilanRepository.getBudgets | `budgets` | SELECT | `church_id = currentChurchId` |

## Règles métier importantes
- **Conformité FEC** : le service `FECExportService` applique le format requis par l’administration fiscale française. 
- **Permissions** : seul le rôle `treasurer` ou supérieur peut déclencher la génération.

## Cas limites documentés
- **Volume important** : génération asynchrone, UI montre un loader (`ShimmerLoading`).
- **Erreur d’export** → `AsyncError` affiché, possibilité de retry.

## TODO / Incomplétudes détectées
- Pas de tests unitaires pour `BilanService`.
- Widget `three_d_cross_visual.dart` reste vide.

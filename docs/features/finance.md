# Feature : Finance

## Vue d’ensemble
Gestion des transactions financières de l’église (dîmes, offrandes, dépenses, revenus). Les données sont stockées dans la table Supabase `finance_transactions` et agrégées pour les tableaux de bord, graphiques mensuels et export CSV/PDF.

## Rôles concernés
- **Treasurer / Admin / SuperAdmin** – création, édition, validation, export de transactions. 
- **Pastor** – lecture des rapports financiers, visualisation des KPI. 
- **Member** – aucun accès direct aux transactions.

## Architecture

### Domain
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/finance/domain/entities/finance_transaction.dart | FinanceTransaction | Entité transaction (~30 champs : montant, devise, type, statut, conformité, audit). |
| lib/features/finance/domain/entities/enums/transaction_type.dart | TransactionType (enum) | `income`, `expense`, `transfer`, etc. |
| lib/features/finance/domain/entities/enums/payment_method.dart | PaymentMethod (enum) | `cash`, `bank_transfer`, `mobile_money`, etc. |
| lib/features/finance/domain/entities/enums/transaction_status.dart | TransactionStatus (enum) | `draft`, `pending`, `validated`, `approved`, `reconciled`. |
| lib/features/finance/domain/repositories/finance_repository.dart | FinanceRepository (interface) | CRUD, recherche, agrégations, export. |
| lib/features/finance/domain/usecases/create_transaction_usecase.dart | CreateTransactionUseCase | Validation métier, appel repository, audit. |
| lib/features/finance/domain/usecases/validate_transaction_usecase.dart | ValidateTransactionUseCase | Changement de statut, vérification conformité. |
| lib/features/finance/domain/usecases/export_transactions_usecase.dart | ExportTransactionsUseCase | Génération CSV/PDF via `FinanceExportService`.

### Data
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/finance/data/models/finance_transaction_model.dart | FinanceTransactionModel | Mapper Supabase ↔ Isar, conversion JSON. |
| lib/features/finance/data/repositories/finance_repository_impl.dart | FinanceRepositoryImpl | Implémentation Supabase + Isar, stratégie offline‑first, file `sync_queue`. |
| lib/features/finance/data/services/finance_export_service.dart | FinanceExportService | Génère CSV ou PDF à partir d’une liste de transactions, applique le format FEC français.

### Presentation
| Fichier | Type | Description |
|---|---|---|
| lib/features/finance/presentation/screens/finance_dashboard_screen.dart | Screen | Tableau de bord avec graphiques (`fl_chart`), KPI, filtres date/catégorie. |
| lib/features/finance/presentation/widgets/v2/finance_glass_hero_header.dart | Widget | Header stylisé avec résumé financier. |
| lib/features/finance/presentation/providers/finance_providers.dart | Provider | `FutureProvider<List<FinanceTransaction>>` (transactions), `financeKpiProvider` (totaux, solde), `financeFiltersProvider`.

## Flux de données
UI → FinanceProviders → FinanceRepositoryImpl ↔ Supabase (`finance_transactions`) + Isar cache → UI. Lectures prioritaire Isar; écritures synchronisées, conformité IMAGIR via champs `status`, `complianceTags`.

## Écrans
| Nom | Fichier | Route | Accès | Provider(s) |
|---|---|---|---|---|
| FinanceDashboardScreen | presentation/screens/finance_dashboard_screen.dart | `/finance` (AppRoutes.finance) | Treasurer, Admin, SuperAdmin, Pastor | finance_providers (financeKpiProvider, transactionListProvider) |

## Providers
| Provider | Type | Retour | Dépendances | Usage |
|---|---|---|---|---|
| transactionListProvider | FutureProvider<List<FinanceTransaction>> | Liste filtrée (date, catégorie) | financeRepositoryProvider | Affichage tableau. |
| financeKpiProvider | Provider<Map<String, dynamic>> | Totaux mensuels, solde, revenus/dépenses | financeRepositoryProvider | KPI tableau de bord. |
| financeExportProvider | Provider<FinanceExportService> | Service génération CSV/PDF | - | Export bouton. |
| financeRepositoryProvider | Provider<FinanceRepository> | Implémentation Supabase/Isar | - | Accès CRUD. |

## Appels Supabase / Isar
| Méthode | Table | Opération | Filtre |
|---|---|---|---|
| FinanceRepositoryImpl.getTransactions | `finance_transactions` | SELECT (pagination) | `church_id = ?` + filtres date/type |
| FinanceRepositoryImpl.createTransaction | `finance_transactions` | INSERT + cache Isar | – |
| FinanceRepositoryImpl.updateTransaction | `finance_transactions` | UPDATE | `id = ?` |
| FinanceRepositoryImpl.validateTransaction | `finance_transactions` | UPDATE `status = 'validated'` | `id = ?` |
| FinanceRepositoryImpl.exportCsv | `finance_transactions` | SELECT + transformation CSV | – |
| FinanceRepositoryImpl.exportPdf | `finance_transactions` | SELECT + PDF generation (via `FinanceExportService`) | – |

## Règles métier importantes
- **RLS** : chaque requête filtrée par `church_id`. 
- **Conformité FEC** : champs `status`, `complianceTags`, `complianceChecked` obligatoires pour les exports fiscaux. 
- **Validation** : seules les personnes avec rôle `treasurer` ou `admin` peuvent passer le statut `validated`/`approved`. 
- **Audit** : chaque création/modif/validation déclenche `logAuditAction` (`entityType = 'finance_transactions'`). 
- **Limite de modification** : une transaction ne peut être modifiée que dans les 30 jours suivant la date (`canBeModified`). 

## Cas limites documentés
- **Hors‑ligne** → transaction créée en local Isar avec `isSynced = false`, synchronisée plus tard. 
- **Conflit de double entrée** → `id` généré via timestamp + UUID, collisions rares, gérées par rollback. 
- **Export volumineux** → pagination serveur, export par lots de 500; UI indique progression. 
- **Transaction expirée** → après 30 jours, le champ `canBeModified` retourne false, UI désactive les actions d’édition.

## TODO / Incomplétudes détectées
- Aucun test unitaire pour `FinanceRepositoryImpl`. 
- UI `finance_dashboard_screen.dart` ne montre pas de skeleton pendant le chargement. 
- Widget `three_d_cross_visual.dart` reste vide (non utilisé). 
- Ajouter tests de conformité FEC (validation des champs obligatoires).

---
*Document basé sur le code source, aucune supposition.*

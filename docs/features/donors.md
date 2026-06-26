# Feature : Donors

## Vue d’ensemble
Gestion des donateurs et des campagnes de dons. Permet la création, la consultation, la mise à jour et la suppression logique de dons, ainsi que le suivi statistique. Les données sont stockées dans les tables Supabase `donors`, `donations` et `donation_campaigns` et synchronisées localement via Isar.

## Rôles concernés
- **Admin / SuperAdmin** – création/modification/suppression de tout donateur, de toutes les campagnes, accès aux statistiques globales. 
- **Treasurer** – création/modification de dons, consultation des campagnes, export des rapports. 
- **Secretary** – visualisation et recherche de donateurs, ajout de notes. 
- **Member** – aucune action directe (lecture uniquement de son propre historique via profil).

## Architecture

### Domain
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/donors/domain/entities/donor_entities.dart | Donor | Entité donateur (identité, type, total_donné, statut). |
| lib/features/donors/domain/entities/donor_entities.dart | Donation | Entité don (montant, date, méthode, type). |
| lib/features/donors/domain/entities/donor_entities.dart | DonationCampaign | Campagne de dons (objectif, montant actuel, dates). |
| lib/features/donors/domain/repositories/i_donor_repository.dart | IDonorRepository (interface) | CRUD donateurs, dons, campagnes, agrégats de stats. |

### Data
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/donors/data/models/donor_model.dart | DonorModel | Mapper Supabase ↔ Isar, conversion JSON. |
| lib/features/donors/data/models/donation_model.dart | DonationModel | Mapper Supabase ↔ Isar, conversion JSON. |
| lib/features/donors/data/models/donation_campaign_model.dart | DonationCampaignModel | Mapper Supabase ↔ Isar, conversion JSON. |
| lib/features/donors/data/repositories/donor_repository.dart | DonorRepository | Implémentation du repository : appels Supabase, filtres `church_id`, audit (`logAuditAction`). |
| lib/features/donors/domain/donor_analytics_service.dart | DonorAnalyticsService | Calcul des indicateurs agrégés (total donateurs, montant total, donation moyenne, taux de rétention). |

### Presentation
| Fichier | Type | Description |
|---|---|---|
| lib/features/donors/presentation/screens/donor_list_screen.dart | Screen | Liste paginée de donateurs, filtres, recherche, indicateur actif. |
| lib/features/donors/presentation/screens/donor_detail_screen.dart | Screen | Détails donateur, historique de dons, actions (éditer, désactiver). |
| lib/features/donors/presentation/screens/donor_form_screen.dart | Screen | Formulaire création/édition donateur, validation champs. |
| lib/features/donors/presentation/screens/donation_form_screen.dart | Screen | Formulaire saisie don (montant, méthode, type). |
| lib/features/donors/presentation/screens/donor_dashboard_screen.dart | Screen | Tableau de bord statistique (total, moyenne, rétention, graphique). |
| lib/features/donors/presentation/widgets/monthly_donations_chart.dart | Widget | Chart `fl_chart` affichant les dons mensuels. |
| lib/features/donors/presentation/providers/donor_providers.dart | Provider | Riverpod : `donorsProvider`, `donorProvider`, `donorStatsProvider`, `donorDonationsProvider`, `donationCampaignsProvider`. |

## Flux de données
UI → Providers → `DonorRepository` → Supabase (`donors`, `donations`, `donation_campaigns`) + Isar cache. Lecture prioritaire Isar, écriture via `sync_queue` si hors‑ligne. Les stats sont calculées localement à partir des champs pré‑agrégés (`total_donated`, `donation_count`).

## Écrans
| Nom | Fichier | Route | Accès | Provider(s) |
|---|---|---|---|---|
| DonorListScreen | presentation/screens/donor_list_screen.dart | `AppRoutes.donors` | Admin, Treasurer, Secretary | `donorsProvider`, `donorStatsProvider`. |
| DonorDetailScreen | presentation/screens/donor_detail_screen.dart | `AppRoutes.donorDetail` (id) | Admin, Treasurer | `donorProvider`, `donorDonationsProvider`. |
| DonorFormScreen | presentation/screens/donor_form_screen.dart | `AppRoutes.donorEdit` (id?) | Admin, Treasurer | `donorProvider`. |
| DonationFormScreen | presentation/screens/donation_form_screen.dart | `AppRoutes.donationNew` (donorId) | Treasurer | – |
| DonorDashboardScreen | presentation/screens/donor_dashboard_screen.dart | `AppRoutes.donorsDashboard` | Admin, Treasurer | `donorStatsProvider`, `donationCampaignsProvider`. |

## Providers
| Provider | Type | Retour | Dépendances | Usage |
|---|---|---|---|---|
| donorsProvider | FutureProvider.autoDispose<List<Donor>> | Liste donateurs filtrée par `church_id` | `donorRepositoryProvider`, `activeChurchIdProvider` | Affichage liste. |
| donorProvider | FutureProvider.autoDispose.family<Donor?, String> | Donateur par id | idem | Détails. |
| donorStatsProvider | FutureProvider.autoDispose<Map<String, dynamic>> | Stats agrégées (total, moyen, rétention) | idem | Dashboard. |
| donorDonationsProvider | FutureProvider.autoDispose.family<List<Donation>, String> | Dons d’un donateur | idem | Historique. |
| donationCampaignsProvider | FutureProvider.autoDispose<List<DonationCampaign>> | Campagnes actives | idem | Sélection campagne. |

## Appels Supabase / Isar
| Méthode | Table | Opération | Filtre |
|---|---|---|---|
| DonorRepository.getDonors | `donors` | SELECT (order by `display_name`) | `church_id = ?`, `is_active = true`. |
| DonorRepository.getDonorById | `donors` | SELECT | `id = ?`. |
| DonorRepository.saveDonor | `donors` | INSERT (new) / UPDATE (exist) | `church_id` ajouté si fourni. |
| DonorRepository.getDonationsByDonor | `donations` | SELECT (order by `donation_date` DESC) | `donor_id = ?`. |
| DonorRepository.saveDonation | `donations` | INSERT / UPDATE | `church_id` ajouté si fourni. |
| DonorRepository.getDonationCampaigns | `donation_campaigns` | SELECT (order by `created_at` DESC) | `church_id = ?`. |
| DonorRepository.saveDonationCampaign | `donation_campaigns` | INSERT / UPDATE | `church_id` ajouté si fourni. |
| DonorAnalyticsService.getDonorStats | – | Agrège `total_donated`, `donation_count` depuis `donors` | `church_id = ?`, `is_active = true`. |

## Règles métier importantes
- **RLS** : chaque requête filtrée par `church_id`. 
- **Accès** : seul un participant du `church_id` peut créer/modifier des donateurs. 
- **Donateur actif** : `is_active = true`. Suppression logique via champ `is_active`. 
- **Statistiques** : calculées à la volée dans `DonorAnalyticsService` à partir des colonnes pré‑agrégées (`total_donated`, `donation_count`). 
- **Campagnes** : `goal_amount` et `current_amount` mis à jour par triggers SQL côté Supabase (non exposé dans le code). 
- **Audit** : chaque insertion ou mise à jour déclenche `logAuditAction` (entité: `donors`, `donations`, `donation_campaigns`). 
- **Limite montant** : validation côté formulaire – montant > 0, devise fixe `XAF`. 
- **Type donateur** : `individual` ou `organization`; le champ `display_name` obligatoire. 
- **Conformité** : champ `wants_receipt` indique si le donateur souhaite un reçu fiscal.

## Cas limites documentés
- **Hors‑ligne** : création/modif stockée en Isar avec `isSynced = false`; synchronisation via `sync_queue` à la reconnexion. 
- **Conflit id** : si deux utilisateurs créent simultanément le même donateur (même email), Supabase renvoie un conflit; le repository loggue l’erreur et renvoie le doute. 
- **Campagne expirée** : si `end_date` passé, l’UI désactive le bouton de don. 
- **Taux de rétention** : calcul basé sur nombre de donateurs avec au moins un don au cours des 12 mois précédents (déterminé via `donation_count`). 
- **Taille tableau** : pagination serveur (limit 500) ; UI utilise lazy‑loading (`loadMore`). 
- **Upload de pièces justificatives** : non implémenté dans le module (réservé aux reçus fiscaux via autre service). 

## TODO / Incomplétudes détectées
- Aucun test unitaire pour `DonorRepository` ni pour les providers. 
- UI `donor_list_screen.dart` ne montre pas de skeleton pendant le chargement (à remplacer par `ShimmerLoading`). 
- Widget `monthly_donations_chart.dart` manque de légende et de gestion des valeurs nulles. 
- Implémenter le chiffrement des données sensibles (email, adresse) en base via `E2EE` si besoin de conformité. 
- Ajouter tests d’intégration pour scénario offline → sync. 
- Export CSV/PDF des dons et campagnes (module Finance peut être réutilisé). 
- Gestion des permissions granularisées via `rbac_admin` pour les campagnes. 

---
*Document basé sur le code source, aucune supposition.*
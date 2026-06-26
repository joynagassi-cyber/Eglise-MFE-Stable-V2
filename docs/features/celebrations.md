# Feature : Celebrations

## Vue d’ensemble
Gestion des célébrations liturgiques (masses, veillées, événements spéciaux). Le module permet de créer, planifier, suivre les présences et générer des rapports d’assiduité.

## Rôles concernés
- **Pastor** – création et gestion des célébrations.
- **Staff** – visualisation et inscription des membres.
- **Membre** – inscription aux célébrations.

## Architecture

### Domain
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/celebrations/domain/entities/church_service.dart | ChurchService | Entité représentant une célébration.
| lib/features/celebrations/domain/entities/service_attendance.dart | ServiceAttendance | Enregistrement de la présence d’un membre.
| lib/features/celebrations/domain/repositories/i_celebration_repository.dart | ICelebrationRepository (interface) | CRUD des services.
| lib/features/celebrations/domain/usecases/create_service_usecase.dart | CreateServiceUseCase | Crée une nouvelle célébration.
| lib/features/celebrations/domain/usecases/update_service_usecase.dart | UpdateServiceUseCase | Met à jour une célébration.
| lib/features/celebrations/domain/usecases/delete_service_usecase.dart | DeleteServiceUseCase | Supprime (soft) une célébration.

### Data
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/celebrations/data/models/church_service_model.dart | ChurchServiceModel | Mapper Supabase ↔ ChurchService.
| lib/features/celebrations/data/models/service_attendance_model.dart | ServiceAttendanceModel | Mapper Supabase ↔ ServiceAttendance.
| lib/features/celebrations/data/repositories/celebration_repository_impl.dart | CelebrationRepositoryImpl | Implémentation des appels Supabase (`church_services`, `service_attendance`).

### Presentation
| Fichier | Type | Description |
|---|---|---|
| lib/features/celebrations/presentation/screens/global_attendance_screen.dart | Screen | Vue globale des présences.
| lib/features/celebrations/presentation/screens/celebration_detail_screen.dart | Screen | Détails d’une célébration et inscription.
| lib/features/celebrations/presentation/widgets/celebration_card.dart | Widget | Carte affichant la célébration.
| lib/features/celebrations/presentation/widgets/attendance_list.dart | Widget | Liste des participants.
| lib/features/celebrations/presentation/providers/celebration_providers.dart | Provider | StateNotifier chargé des services et présences.

## Flux de données
UI → CelebrationProvider → CelebrationRepositoryImpl → Supabase (`church_services`, `service_attendance`) + Isar cache → UI.

## Écrans
| Nom | Fichier | Route | Accès | Provider(s) |
|---|---|---|---|---|
| GlobalAttendanceScreen | presentation/screens/global_attendance_screen.dart | `/celebrations` (AppRoutes.celebrations) | Pastor, Staff | celebration_providers |
| CelebrationDetailScreen | presentation/screens/celebration_detail_screen.dart | `/celebrations/:id` | Pastor, Staff, Membre | celebration_providers |

## Providers
| Provider | Type | Retour | Dépendances | Usage |
|---|---|---|---|---|
| celebration_providers | StateNotifierProvider<CelebrationState> | Listes de services & présences | CelebrationRepositoryImpl | UI des célébrations.

## Appels Supabase / Isar
| Méthode | Table | Opération | Filtre |
|---|---|---|---|
| CelebrationRepositoryImpl.getAll | `church_services` | SELECT | `church_id = currentChurchId` |
| CelebrationRepositoryImpl.createService | `church_services` | INSERT | — |
| CelebrationRepositoryImpl.recordAttendance | `service_attendance` | INSERT | `service_id = X, member_id = Y` |

## Règles métier importantes
- **RLS** : les enregistrements de `service_attendance` sont filtrés par `church_id`.
- **Validation de date** : aucune célébration ne peut être créée dans le passé.

## Cas limites documentés
- **Inscription hors‑ligne** → mise en file `sync_queue` puis synchronisation.
- **Conflit de double inscription** → le repository renvoie une erreur et le UI montre `ErrorDisplay`.

## TODO / Incomplétudes détectées
- Aucun test unitaire pour `CelebrationRepositoryImpl`.
- Widget `three_d_cross_visual.dart` reste vide.

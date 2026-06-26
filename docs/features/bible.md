# Feature : Bible

## Vue d’ensemble
Lecture, recherche, surlignage, prise de notes et partage de versets. Les données sont stockées dans les tables `bible_verses`, `bible_highlights`, `bible_notes` et mises en cache localement avec Isar.

## Rôles concernés
- **Tous les utilisateurs** – lecture, surlignage, prise de notes.
- **Pastor / Admin** – création/modification de plans de lecture (future).

## Architecture

### Domain
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/bible/domain/bible_domain.dart | BibleDomain | Regroupe les entités (Verse, Book, Highlight, Note). |
| lib/features/bible/core/models/bible_entities.dart | BibleVerse, BibleBook, ... | Modèles immuables (Freezed). |

### Data
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/bible/data/services/bible_service.dart | BibleService | Accès aux versets via Supabase et Isar. |
| lib/features/bible/data/services/bible_annotation_service.dart | BibleAnnotationService | CRUD sur surlignages et notes. |
| lib/features/bible/data/services/bible_download_service.dart | BibleDownloadService | Téléchargement complet d’une traduction pour usage offline. |
| lib/features/bible/data/models/bible_verse_model.dart | BibleVerseModel | Mapper Supabase ↔ Verse. |

### Presentation
| Fichier | Type | Description |
|---|---|---|
| lib/features/bible/reader/screens/bible_reader_screen.dart | Screen | Lecteur principal, navigation livre/chapitre. |
| lib/features/bible/reader/widgets/verse_list.dart | Widget | Liste virtuelle des versets. |
| lib/features/bible/reader/widgets/verse_action_sheet.dart | Widget | Actions sur un verset (surligner, note, partager). |
| lib/features/bible/reader/widgets/tts_control_bar.dart | Widget | Contrôle du Text‑to‑Speech. |
| lib/features/bible/search/screens/bible_search_screen.dart | Screen | Recherche texte complet. |
| lib/features/bible/library/screens/bible_library_screen.dart | Screen | Gestion du téléchargement des traductions. |
| lib/features/bible/plans/screens/bible_plans_screen.dart | Screen | Liste des plans de lecture. |
| lib/features/bible/plans/screens/bible_plan_detail_screen.dart | Screen | Détail d’un plan. |
| lib/features/bible/reader/providers/bible_notifier.dart | Provider | StateNotifier – verset courant, surlignages. |
| lib/features/bible/reader/providers/bible_stats_notifier.dart | Provider | Statistiques d’usage. |
| lib/features/bible/search/providers/bible_search_notifier.dart | Provider | Recherche asynchrone. |
| lib/features/bible/reader/providers/bible_settings_provider.dart | Provider | Préférences (traduction, taille police, thème). |

## Flux de données
UI → BibleNotifier → BibleService (Supabase/Isar) → UI.
Pour surlignage : VerseActionSheet → BibleAnnotationService → Supabase `bible_highlights` + Isar → BibleNotifier.

## Écrans
| Nom | Fichier | Route | Accès | Provider(s) |
|---|---|---|---|---|
| BibleReaderScreen | reader/screens/bible_reader_screen.dart | `/bible/:book/:chapter` (AppRoutes.bibleReader) | Tous | bible_notifier, bible_settings_provider |
| BibleSearchScreen | search/screens/bible_search_screen.dart | `/bible/search` (AppRoutes.bibleSearch) | Tous | bible_search_notifier |
| BibleLibraryScreen | library/screens/bible_library_screen.dart | `/bible/offline` (AppRoutes.bibleOffline) | Tous | bible_settings_provider |
| BiblePlansScreen | plans/screens/bible_plans_screen.dart | `/bible/plans` (AppRoutes.biblePlans) | Tous | bible_plan_service |

## Providers
| Provider | Type | Retour | Dépendances | Usage |
|---|---|---|---|---|
| bible_notifier | StateNotifierProvider<BibleState> | Verset actuel, surlignages | BibleService, BibleAnnotationService | Lecteur et actions. |
| bible_search_notifier | FutureProvider<List<Verse>> | Résultats recherche | BibleService | Search screen. |
| bible_settings_provider | StateNotifierProvider<BibleSettings> | Préférences utilisateur | – | UI configuration. |

## Appels Supabase / Isar
| Méthode | Table | Opération | Filtre |
|---|---|---|---|
| BibleService.getVerses | `bible_verses` | SELECT | `book = X AND chapter = Y` |
| BibleAnnotationService.addHighlight | `bible_highlights` | INSERT | `user_id = auth.uid()` |
| BibleAnnotationService.addNote | `bible_notes` | INSERT | `user_id = auth.uid()` |
| BibleDownloadService.downloadTranslation | (fichier externe) | FETCH + write Isar `bible_offline` | — |

## Règles métier importantes
- **RLS** : `bible_highlights` et `bible_notes` filtrés par `user_id`. 
- **Mode offline** : si le cache Isar est présent, `BibleService` lit localement.
- **TTS** : disponible uniquement si le dispositif possède le moteur TTS français.

## Cas limites documentés
- **Création de note hors‑ligne** → stockée dans `sync_queue` puis synchronisée.
- **Recherche texte** : limitée à 500 résultats (limite Supabase).

## TODO / Incomplétudes détectées
- Aucun test unitaire pour `BibleAnnotationService`.
- Widget `three_d_cross_visual.dart` reste vide (non‑utilisé).

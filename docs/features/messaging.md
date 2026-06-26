# Feature : Messaging

## Vue d’ensemble
Service de messagerie instantanée sécurisé au sein de l’application. Permet les conversations **privées (1‑to‑1)** et **de groupe** (associées aux groupes ministériels). Les échanges sont stockés dans la table Supabase `conversations` et `chat_messages` et synchronisés en temps réel via Supabase Realtime. Un cache local Isar assure l’accès offline‑first.

## Rôles concernés
- **Admin / SuperAdmin** – visibilité sur toutes les conversations, gestion des paramètres globaux (blocage d’utilisateurs, purge). 
- **GroupLeader** – création de conversations de groupe liées à son groupe, modération (pin, mute, suppression). 
- **Pastor, Treasurer, Secretary** – participation aux conversations privées et de groupe, aucune permission supplémentaire. 
- **Member** – peut initier une conversation privée avec un autre membre et participer aux conversations de groupe auxquelles il appartient.

## Architecture

### Domain
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/messaging/domain/entities/conversation.dart | Conversation | Entité conversation (id, type, participants, titre, timestamps, flags). |
| lib/features/messaging/domain/entities/chat_message.dart | ChatMessage | Entité message (id, conversationId, sender, contenu, type, readBy, timestamps). |
| lib/features/messaging/domain/repositories/i_messaging_repository.dart | IMessagingRepository (interface) | CRUD conversations & messages, flux realtime, upload de fichiers, actions RBAC (pin, mute, blocage, nettoyage). |

### Data
| Fichier | Classe | Responsabilité |
|---|---|---|
| lib/features/messaging/data/models/conversation_model.dart | ConversationModel | Mapper Supabase ↔ Isar, conversion JSON. |
| lib/features/messaging/data/models/chat_message_model.dart | ChatMessageModel | Mapper Supabase ↔ Isar, conversion JSON. |
| lib/features/messaging/data/repositories/messaging_repository_impl.dart | MessagingRepositoryImpl | Implémentation du repository : appels Supabase, synchronisation Isar, gestion du realtime (RealtimeChannel). |
| lib/features/messaging/data/services/e2ee_service.dart | E2eeService | Génération et échange de clés, chiffrement/déchiffrement des messages texte. |
| lib/features/messaging/data/services/presence_service.dart | PresenceService | Suivi en temps réel des utilisateurs en ligne via Supabase Presence. |

### Presentation
| Fichier | Type | Description |
|---|---|---|
| lib/features/messaging/presentation/screens/inbox_screen.dart | Screen | Liste des conversations (filtrage épinglés, recherche, indicateur non‑lu). |
| lib/features/messaging/presentation/screens/chat_screen.dart | Screen | Vue de dialogue, saisie texte, attachement image, enregistrement note vocale, bannière E2EE. |
| lib/features/messaging/presentation/widgets/voice_note_recorder.dart | Widget | Enregistrement audio, upload via `voiceNoteService`. |
| lib/features/messaging/presentation/widgets/voice_note_player.dart | Widget | Lecture d’une note vocale. |
| lib/features/messaging/presentation/providers/messaging_providers.dart | Provider | Riverpod : `conversationsProvider` (Stream), `conversationProvider` (Family), `chatMessagesProvider` (StreamFamily), `onlineUsersProvider`, `isUserOnlineProvider`, `groupChatControllerProvider` (controller pour créer/obtenir conversation groupe). |

## Flux de données
UI → Providers (Riverpod) → `MessagingRepositoryImpl` → Supabase (`conversations`, `chat_messages`, `presence`, `user_encryption_keys`) + Isar cache. Lecture prioritaire depuis Isar, synchronisation en arrière‑plan. Les changements sont poussés aux canaux Realtime (`public:conversations`, `public:chat_messages:<conversationId>`).

## Écrans
| Nom | Fichier | Route | Accès | Provider(s) |
|---|---|---|---|---|
| InboxScreen | presentation/screens/inbox_screen.dart | `AppRoutes.communicationMessaging` | Tous rôles autorisés | `conversationsProvider`, `onlineUsersProvider`. |
| ChatScreen | presentation/screens/chat_screen.dart | `AppRoutes.messagingConversationWithId(id)` | Participants de la conversation | `chatMessagesProvider`, `isUserOnlineProvider`, `groupChatControllerProvider`. |

## Providers
| Provider | Type | Retour | Dépendances | Usage |
|---|---|---|---|---|
| conversationsProvider | StreamProvider<List<Conversation>> | Flux temps réel de toutes les conversations de l'utilisateur | `messagingRepositoryProvider` | Affichage boîte de réception. |
| conversationProvider | Provider.family<Conversation?, String> | Recherche d’une conversation par id dans le stream | `conversationsProvider` | Détails conversation dans `ChatScreen`. |
| chatMessagesProvider | StreamProvider.family<List<ChatMessage>, String> | Flux messages d’une conversation | `messagingRepositoryProvider` | Affichage du fil de discussion. |
| onlineUsersProvider | StreamProvider<Set<String>> | Ensemble des ids en ligne | `presenceServiceProvider` | Indicateur d’état en ligne dans UI. |
| isUserOnlineProvider | Provider.family<bool, String> | Booléen d’état en ligne | `onlineUsersProvider` | Affichage badge vert. |
| groupChatControllerProvider | Provider<Future<String?> Function(String, String)> | Méthode `getOrCreateGroupChat` | `messagingRepositoryProvider` | Crée ou récupère une conversation de groupe depuis l'ID du groupe. |

## Appels Supabase / Isar
| Méthode | Table | Opération | Filtre |
|---|---|---|---|
| MessagingRepositoryImpl.getConversations | `conversations` | SELECT (order by `last_message_at` DESC) | `church_id = ?` + `participants_ids @> [current_user_id]` |
| MessagingRepositoryImpl.watchConversations | `conversations` | Realtime stream | idem |
| MessagingRepositoryImpl.getMessages | `chat_messages` | SELECT (order by `created_at` DESC, limit) | `conversation_id = ?` |
| MessagingRepositoryImpl.watchMessages | `chat_messages` | Realtime stream | idem |
| MessagingRepositoryImpl.createConversation | `conversations` | INSERT + cache Isar | participantsIds, type, title, timestamps |
| MessagingRepositoryImpl.sendMessage | `chat_messages` | INSERT (optionnel E2EE payload) | conversation_id = ?, sender_id = ? |
| MessagingRepositoryImpl.uploadFile | storage `chat_attachments` | UPLOAD → public URL | folder = conversationId |
| MessagingRepositoryImpl.togglePinConversation | `conversations` (local) | Met à jour `isPinned` en Isar | remote sync éventuel |
| MessagingRepositoryImpl.toggleMuteConversation | `conversations` (local) | Met à jour `isMuted` en Isar |
| MessagingRepositoryImpl.blockUser / unblockUser | `blocked_users` (Supabase) | INSERT / DELETE | `blocked_user_id` |
| MessagingRepositoryImpl.clearHistory | `chat_messages` (Isar) | DELETE ALL where `conversation_id` = ? | Optionnel soft‑delete côté serveur |
| MessagingRepositoryImpl.searchMessages | `chat_messages` (Isar) | FILTER `content` contains query | conversation_id = ? |
| MessagingRepositoryImpl.getSharedMediaUrls | `chat_messages` (Isar) | FILTER `type = 'image'` | conversation_id = ? |
| PresenceService.connect / disconnect | Realtime Presence channel | Track / untrack user online status | – |

## Règles métier importantes
- **RLS** : chaque requête filtrée par `church_id` et `participants_ids` contenant l’utilisateur courant. 
- **Accès** : seul un participant peut lire ou écrire dans une conversation. 
- **Conversations de groupe** : créées via `getOrCreateGroupConversation(groupId, title)`, les membres du groupe sont les seuls participants. 
- **Pin / Mute** : états locaux persistes en Isar, synchronisés (optionnel) vers le serveur. 
- **Blocage utilisateur** : `blocked_users` empêche l’envoi de messages vers l’utilisateur bloqué. 
- **E2EE** : optionnel – les messages texte peuvent être chiffrés avant l’insertion (via `E2eeService`). 
- **Limite d’attachement** : taille maximale 5 Mo, rejet avec snackbar. 
- **Présence** : les indicateurs en ligne proviennent du service `PresenceService`. 
- **Synchronisation offline** : écriture immédiate en Isar, puis tentative d’insertion Supabase. En cas d’échec, le message reste en file `sync_queue` (implémentation interne du `IsarService`).

## Cas limites documentés
- **Conversation déjà existante** : création d’une conversation privée vérifie d’abord l’existence (`participantsIds` length 2, `type = private`). 
- **Conflit de création** : si deux utilisateurs créent simultanément la même conversation de groupe, le dernier commit prévaut; le `ConflictError` est journalisé. 
- **Message hors‑ligne** : le message est mis en cache Isar avec `isSynced = false` (dans le modèle) puis envoyé lors de la reconnexion. 
- **Échec d’upload** : le UI montre un snackbar d’erreur, le message n’est pas envoyé. 
- **Presence loss** : si le heartbeat (60 s) échoue, l’utilisateur est marqué hors‑ligne. 
- **Blocage** : les messages provenant d’un utilisateur bloqué sont filtrés côté UI mais restent dans la table serveur. 

## TODO / Incomplétudes détectées
- Aucun test unitaire pour `MessagingRepositoryImpl` ni pour les providers. 
- UI `InboxScreen` ne montre pas de skeleton pendant le chargement (utiliser `ShimmerLoading`). 
- Widget `voice_note_player.dart` reste vide (non implémenté). 
- Ajouter tests d’intégration pour le scénario offline ↔ sync. 
- Implémenter le chiffrement E2EE complet (décryptage côté récepteur). 
- Ajouter audit (`logAuditAction`) sur création/suppression de conversations et envoi de messages. 
- Gestion des réactions (like, reply) non prise en charge. 

---
*Document basé sur le code source, aucune supposition.*
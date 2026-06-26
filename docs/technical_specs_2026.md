# Spécifications Techniques : Patterns d'Architecture Lumina 2026

Ce document fournit des exemples de code exhaustifs pour l'implémentation des patterns de robustesse et de résilience.

---

## 1. Local-First DDD (Source de Vérité Unique)
**But** : Supprimer la latence et garantir le fonctionnement hors-ligne.

### Repository Pattern (Abstraction Local-First)
```dart
abstract class MemberRepository {
  // Les Queries retournent des Streams observés sur Isar
  Stream<List<Member>> watchMembers();
  
  // Les Commands retournent un Result (Succès/Échec)
  Future<Result<void, AppFailure>> addMember(Member member);
}

class MemberRepositoryImpl extends ResilientRepository implements MemberRepository {
  MemberRepositoryImpl(super.ref);

  @override
  Stream<List<Member>> watchMembers() {
    // 1. On renvoie le flux local (Isar) immédiatement
    // 2. Le moteur de synchro mettra à jour Isar en tâche de fond
    return isar.memberModels.where().filter()
        .isDeletedEqualTo(false)
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toDomain()).toList());
  }

  @override
  Future<Result<void, AppFailure>> addMember(Member member) async {
    try {
      final model = MemberModel.fromDomain(member)..isSynced = false;
      
      // Écriture locale immédiate (Optimistic UI)
      await isar.db.writeTxn(() async {
        await isar.putMemberRaw(model);
        
        // Enregistrement de la commande pour le SyncManager
        await isar.syncOperationModels.put(SyncOperationModel.fromEntity(
          entity: member,
          operation: 'INSERT',
        ));
      });
      
      return const Result.success(null);
    } catch (e) {
      return Result.failure(CacheFailure(message: e.toString()));
    }
  }
}
```

---

## 2. Multi-threaded Isolate Pooling
**But** : Garder l'UI à 60 FPS lors du déchiffrement finance ou de l'OCR.

### Worker Service
```dart
class HeavyComputeService {
  /// Déchiffre une liste massive de transactions sans bloquer l'UI
  static Future<List<Transaction>> decryptBatch(List<EncryptedData> items, Key key) async {
    return await compute(_decryptJob, _DecryptParams(items, key));
  }

  static List<Transaction> _decryptJob(_DecryptParams params) {
    final encrypter = Encrypter(AES(params.key, mode: AESMode.gcm));
    return params.items.map((item) {
      // Logique de déchiffrement synchrone ici
      return Transaction.decrypted(item, encrypter);
    }).toList();
  }
}
```

---

## 3. Atomic Command Bus (CQRS)
**But** : Prévenir les Deadlocks et garantir l'ordre des opérations.

```dart
class CommandBus {
  final SyncEngine _engine;
  
  // File d'attente séquentielle
  final _queue = Queue<Command>();
  bool _isProcessing = false;

  Future<void> execute(Command cmd) async {
    _queue.add(cmd);
    if (!_isProcessing) await _processNext();
  }

  Future<void> _processNext() async {
    if (_queue.isEmpty) {
      _isProcessing = false;
      return;
    }
    _isProcessing = true;
    final cmd = _queue.removeFirst();
    await _engine.sync(cmd);
    await _processNext();
  }
}
```

---

## 4. Multi-tenant Security Proxy
**But** : Automatiser l'isolation des données par église.

```dart
extension SupabaseQueryX on PostgrestFilterBuilder {
  /// Force l'ajout du filtre church_id si l'utilisateur n'est pas superadmin
  PostgrestFilterBuilder scoped(Ref ref) {
    final churchId = ref.read(activeChurchIdProvider);
    if (churchId == '*') return this; // SuperAdmin
    return this.eq('church_id', churchId);
  }
}

// Usage :
// supabase.from('members').select().scoped(ref);
```

---

## 5. UI Pattern Matching (Resilient UX)
**But** : Éliminer les crashs visuels et gérer proprement les états.

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final membersState = ref.watch(membersProvider);

  return membersState.when(
    data: (list) => ListView.builder(
      itemCount: list.length,
      itemBuilder: (ctx, i) => MemberCard(member: list[i]),
    ),
    loading: () => const MemberListSkeleton(),
    error: (err, stack) => ErrorRecoveryWidget(
      message: "Impossible de charger les membres",
      onRetry: () => ref.invalidate(membersProvider),
    ),
  );
}
```

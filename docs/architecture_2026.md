# Lumina 2026 : Manifeste d'Architecture Ultra-Résiliente

Ce document définit les standards techniques pour la refonte de l'écosystème Lumina. L'objectif est d'atteindre 100% de disponibilité offline, une performance de 60 FPS constante et une sécurité multi-tenant absolue.

---

## 1. Pattern Local-First (Source de Vérité Unique)
**Concept** : L'UI ne communique jamais avec le réseau. Elle n'observe que la base de données locale (Isar).

### Structure de donnée
Toutes les tables doivent posséder :
- `id` (UUID généré localement)
- `updated_at` (Timestamp UTC)
- `version` (Incrémenté à chaque modification)
- `is_deleted` (Soft delete pour synchro offline)
- `is_synced` (Status local)

### Flux de données
```dart
// 1. Lecture Réactive
@riverpod
Stream<List<Member>> members(MembersRef ref) {
  return ref.watch(isarServiceProvider).memberModels
            .where()
            .filter()
            .isDeletedEqualTo(false)
            .watch(fireImmediately: true)
            .map((models) => models.toDomain());
}

// 2. Écriture Atomique
Future<void> updateMember(Member member) async {
  await isar.writeTxn(() async {
    await isar.memberModels.put(MemberModel.fromDomain(member..isSynced = false));
  });
  // Le moteur de synchro détectera le isSynced = false en tâche de fond
}
```

---

## 2. Pattern Isolate-Worker Pooling (Multi-threading)
**Concept** : Déporter les calculs lourds (Chiffrement, Rapports) hors de l'UI.

```dart
// Utilisation du pool de workers pour le déchiffrement finance
Future<List<Transaction>> decryptTransactions(List<RawData> raw) async {
  return await Isolate.run(() {
    final service = EncryptionService();
    return raw.map((r) => service.decryptSync(r)).toList();
  });
}
```

---

## 3. Pattern CQRS (Command Query Responsibility Segregation)
**Concept** : Séparation totale entre la récupération de données et les actions de modification.

- **Query** : `memberProvider` (Stream sur Isar).
- **Command** : `CreateMemberAction` (Objet de commande envoyé au SyncManager).

---

## 4. Pattern Secure-Interceptor (Multi-tenancy)
**Concept** : Mixin de sécurité obligatoire pour tous les repositories.

```dart
mixin SecureRepository {
  String getActiveChurchId(Ref ref) {
    final id = ref.read(activeChurchIdProvider);
    if (id == null) throw SecurityException("Accès refusé : Église non identifiée");
    return id;
  }

  // Injecte automatiquement le filtre dans chaque requête Supabase
  PostgrestFilterBuilder<T> secure<T>(PostgrestFilterBuilder<T> query, String churchId) {
    if (churchId == '*') return query; // Superadmin
    return query.eq('church_id', churchId);
  }
}
```

---

## 5. Pattern Functional Result (Dartz 2.0)
**Concept** : Pas d'exceptions non gérées. Tout retour est un succès ou un échec explicite.

```dart
Future<Result<void, Failure>> deleteMember(String id) async {
  try {
    await repository.delete(id);
    return const Result.success(null);
  } catch (e) {
    return Result.failure(ServerFailure(message: e.toString()));
  }
}
```

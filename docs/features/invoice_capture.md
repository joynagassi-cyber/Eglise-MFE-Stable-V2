# Feature : Invoice Capture

## Vue d’ensemble
Service de numérisation et de capture des factures de dons et dépenses. Permet d’uploader un PDF ou une image, d’extraire les métadonnées (montant, date, bénéficiaire) via OCR, de les stocker dans Supabase `invoices` et `invoice_items`. Cache local Isar assure l’accès offline‑first. Synchronisation bidirectionnelle, mise à jour temps réel.

## Rôles concernés
- **Admin / SuperAdmin** – visibilité sur toutes les factures, validation, suppression définitive.
- **Treasurer** – création, édition, validation, export CSV, génération rapports financiers.
- **Secretary** – consultation, ajout de notes, recherche.
- **Member** – lecture de ses propres reçus de don via profil.

## Tables Supabase
```sql
invoices (
  id uuid primary key,
  church_id uuid not null,
  uploader_id uuid not null,
  amount numeric not null,
  currency text default 'FCFA',
  date date not null,
  status text check (status in ('pending','validated','rejected')),
  file_url text not null,
  created_at timestamp default now(),
  updated_at timestamp default now()
);

invoice_items (
  id uuid primary key,
  invoice_id uuid references invoices(id),
  description text,
  quantity integer,
  unit_price numeric,
  total numeric generated always as (quantity * unit_price) stored,
  created_at timestamp default now()
);
```
RLS : `church_id = auth.jwt() -> church_id` et `role IN ('admin','superAdmin','treasurer')` pour modification.

## Isar modèle
```dart
@Collection()
class InvoiceModel {
  Id id = Isar.autoIncrement;
  late String supabaseId;
  late String churchId;
  late String uploaderId;
  late double amount;
  late String currency;
  late DateTime date;
  late String status;
  late String fileUrl;
  late DateTime createdAt;
  late DateTime updatedAt;
  final items = IsarLinks<InvoiceItemModel>();
}

@Embedded()
class InvoiceItemModel {
  late String description;
  late int quantity;
  late double unitPrice;
  double get total => quantity * unitPrice;
}
```

## Flux de données
1. Utilisateur appuie “Capture facture”.
2. UI ouvre picker image/PDF → envoie à `InvoiceCaptureProvider`.
3. Provider appelle `invoiceRemoteDatasource.upload(file)` → Supabase Storage.
4. OCR (service externe) renvoie métadonnées, crée `InvoiceModel` + `InvoiceItemModel`.
5. Écrit dans Isar, marque `syncPending`.
6. `syncQueue` tente d’insérer en base via `invoiceRepository.create`.
7. En cas d’échec, persiste dans file d’attente, réessaie à chaque reconnexion.
8. Realtime notifie les dashboards finance.

## Providers Riverpod
```dart
@riverpod
class InvoiceCaptureNotifier extends _$InvoiceCaptureNotifier {
  @override
  FutureOr<void> build() async {}

  Future<void> capture(File file) async {
    state = const AsyncLoading();
    final result = await ref.read(invoiceRepositoryProvider).uploadInvoice(file);
    state = AsyncData(result);
  }
}
```

## UI obligatoire
- Skeleton `InvoiceCaptureSkeleton` pendant upload.
- Affichage liste `InvoiceListSkeleton` pendant chargement.
- Messages d’erreur en français simple.
- Bouton “Confirmer” désactivé tant que `state is AsyncLoading`.

## Règles UX
- Zone tactile >48×48 dp sur bouton capture.
- Aucun spinner : skeleton shimmer.
- Confirmation avant suppression facture.
- Export CSV uniquement pour Treasurer/Admin.

## Tests requis
- Unit tests repository `create`, `update`, `delete`.
- Integration test offline/online sync.
- Widget test skeleton affiché pendant upload.

## Checklist avant commit
- [ ] Aucun `CircularProgressIndicator`.
- [ ] Skeletons implémentés.
- [ ] Routes utilisent `AppRoutes.invoiceCapture`.
- [ ] Calls Supabase uniquement dans `data/`.
- [ ] `catch` log + `AppException`.
- [ ] `AsyncValue.when` complet.
- [ ] Textes FR simple.
- [ ] Pas de couleur hex.
- [ ] Filtrage `church_id`.
- [ ] `dart run build_runner` si provider modifié.
- [ ] `flutter analyze` clean.

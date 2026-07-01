# Workers Cloudflare — Stockage R2 & OCR

Ce dossier contient deux Workers Cloudflare pour l'application Lumina :

| Worker | Fichier config | Rôle |
|--------|----------------|------|
| **Storage** (`feu-evangile-storage-worker`) | `wrangler.toml` | Upload/download/delete de fichiers sur R2 |
| **OCR** (`feu-evangile-ocr-worker`) | `wrangler-ocr.toml` | Extraction de données de factures via Workers AI |

> **Note sur les noms d'URL** : les fichiers `wrangler*.toml` utilisent le préfixe `feu-evangile-*`, tandis que les fallbacks Flutter pointent vers `lumina-*-worker.joynagassi.workers.dev`. Assurez-vous que les variables `.env` de l'app Flutter correspondent aux URLs réellement déployées.

## Prérequis

- Compte Cloudflare avec Workers et R2 activés
- Bucket R2 `feu-evangile-storage` (voir `wrangler.toml`)
- Node.js ≥ 18

```bash
cd backend/cloudflare
npm install
```

## Secrets requis

Configurer via `wrangler secret put <NOM>` pour chaque worker :

### Storage worker (`wrangler.toml`)

| Secret | Description |
|--------|-------------|
| `SUPABASE_URL` | URL du projet Supabase |
| `SUPABASE_SERVICE_ROLE_KEY` | Clé service role (côté worker uniquement) |
| `SUPABASE_ANON_KEY` | Clé anon Supabase |
| `ALLOWED_ORIGINS` | Origines CORS autorisées, séparées par des virgules |

### OCR worker (`wrangler-ocr.toml`)

| Secret | Description |
|--------|-------------|
| `SUPABASE_URL` | URL du projet Supabase |
| `SUPABASE_SERVICE_ROLE_KEY` | Clé service role |
| `ALLOWED_ORIGINS` | Origines CORS autorisées |

Exemple :

```bash
wrangler secret put SUPABASE_URL
wrangler secret put SUPABASE_SERVICE_ROLE_KEY
wrangler secret put SUPABASE_ANON_KEY
wrangler secret put ALLOWED_ORIGINS

wrangler secret put SUPABASE_URL --config wrangler-ocr.toml
wrangler secret put SUPABASE_SERVICE_ROLE_KEY --config wrangler-ocr.toml
wrangler secret put ALLOWED_ORIGINS --config wrangler-ocr.toml
```

## Déploiement

```bash
# Worker de stockage R2
npm run deploy

# Worker OCR
npm run deploy:ocr
```

Développement local :

```bash
npm run dev
```

## Variables Flutter (`.env`)

Copier `lumina/.env.example` vers `lumina/.env` et renseigner :

```env
STORAGE_WORKER_URL=https://your-storage-worker.workers.dev
OCR_WORKER_URL=https://your-ocr-worker.workers.dev
```

`STORAGE_WORKER_URL` doit être l'URL **de base** (sans `/upload`). L'app ajoute automatiquement les suffixes `/upload` et `/download`.

## Tests manuels (curl)

Remplacer `YOUR_TOKEN` par un JWT Supabase valide et `YOUR_WORKER_URL` par l'URL déployée.

### Upload fichier (storage)

```bash
curl -X POST "YOUR_WORKER_URL/upload" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -F "file=@/chemin/vers/facture.pdf" \
  -F "entity_type=invoice" \
  -F "entity_id=tx-123" \
  -F "church_id=church-abc"
```

Réponse attendue (201) :

```json
{ "r2_key": "...", "file_url": "..." }
```

### OCR facture

```bash
curl -X POST "YOUR_OCR_WORKER_URL" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -F "file=@/chemin/vers/facture.jpg"
```

Réponse attendue (200) :

```json
{ "success": true, "data": { "response": "{ ... JSON facture ... }" } }
```

### Téléchargement

```bash
curl -X GET "YOUR_WORKER_URL/download/church-abc/invoice/tx-123/..." \
  -H "Authorization: Bearer YOUR_TOKEN" \
  --output facture.pdf
```

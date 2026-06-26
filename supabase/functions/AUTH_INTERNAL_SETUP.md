# Authentification — Configuration interne (sans domaine email)

Ce projet est destine a un **groupe restreint d'utilisateurs internes** et
n'utilise **pas de nom de domaine**. Le flux OTP par email a donc ete retire
car l'envoi fiable d'emails necessite un domaine verifie (SPF/DKIM).

## Modele d'authentification retenu : Email + Mot de passe

Supabase Auth gere nativement l'authentification email/mot de passe sans
aucun service de messagerie ni domaine.

### 1. Configuration Supabase Dashboard

**Authentication -> Providers -> Email :**

- Activer **Email** comme provider
- **Desactiver** "Confirm email" (Confirm email = OFF)
  > Sans domaine, aucun email de confirmation ne peut etre envoye.
  > Les comptes sont donc actifs immediatement apres creation.

**Authentication -> Settings :**

- Optionnel : desactiver "Allow new users to sign up" si tu veux creer
  les comptes toi-meme (recommande pour un groupe restreint).

### 2. Creation des comptes

Deux options pour un groupe restreint :

1. **Manuelle (recommandee)** : creer les comptes depuis le Dashboard
   Supabase (Authentication -> Users -> Add user) ou via l'Admin API.
2. **Auto-inscription** : laisser "Allow new users to sign up" active et
   distribuer un code secret de groupe (voir section 3).

### 3. Seconde couche optionnelle : code secret de groupe

Le schema contient deja `group_secret_codes` et `role_secret_codes`.
Tu peux exiger la saisie d'un code secret a la premiere connexion pour
renforcer la securite, sans email. Voir les RPC :

- `verify_group_secret_code`
- `verify_role_secret_code`

### 4. Activation Superadmin

L'Edge Function `auth-activate-admin` reste en place : elle eleve un
utilisateur connecte au role `superadmin` via un code secret (hash SHA-256),
sans aucun email. C'est le mecanisme d'escalade de privileges du projet.

## Cote application Flutter

Utiliser les methodes standard du SDK :

```dart
// Inscription
await supabase.auth.signUp(email: email, password: password);

// Connexion
await supabase.auth.signInWithPassword(email: email, password: password);

// Deconnexion
await supabase.auth.signOut();
```

## Fonctions Edge supprimees

- `auth-request-otp`  (envoi du code OTP par email via Resend)
- `auth-verify-otp`   (verification du code OTP)
- `auth-confirm-link` (confirmation via deep link email)

Ces fonctions dependaient toutes d'un domaine email et sont devenues inutiles.

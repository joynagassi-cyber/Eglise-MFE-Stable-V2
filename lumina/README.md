# Lumina - Church Management System

## 🎯 Vue d'ensemble

Système de gestion d'église moderne avec Flutter, Supabase et architecture offline-first.

## 🚀 Quick Start

### Prérequis

- Flutter SDK >=3.3.0
- Dart SDK
- Supabase account
- Google Drive API credentials

### Installation

```bash
# Setup automatique
make setup  # ou ./setup.sh ou setup.bat

# Ou manuel
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Configuration

Créer `.env`:

```
SUPABASE_URL_DEV=your_dev_url
SUPABASE_ANON_KEY_DEV=your_dev_key
SUPABASE_URL_PROD=your_prod_url
SUPABASE_ANON_KEY_PROD=your_prod_key
```

### Lancement

```bash
make run  # ou flutter run --dart-define-from-file=.env
```

## 📁 Architecture

### Structure

```
lib/
├── core/           # Infrastructure partagée
│   ├── theme/     # Design system
│   ├── validation/ # Validateurs
│   ├── config/    # Configuration
│   └── performance/ # Optimisations
└── features/      # Modules métier
```

### Patterns

- **Clean Architecture**: Data/Domain/Presentation
- **Offline-First**: Isar + Sync Queue
- **State Management**: Riverpod avec code generation

## 🔧 Commandes

### Make (Recommandé)

```bash
make setup          # Install + generate
make run            # Launch app
make test           # Run tests
make build-android  # Build APK
make build-ios      # Build IPA
make analyze        # Lint + format
make clean          # Clean build
make gen            # Generate code
make watch          # Watch mode
```

### Développement

```bash
flutter analyze              # Analyse statique
dart format lib/            # Formatage
flutter test --coverage     # Tests avec couverture
```

### Build

```bash
flutter build apk --release           # Android
flutter build ios --release           # iOS
flutter build web --release           # Web
```

### Code Generation

```bash
flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run build_runner watch  # Mode watch
```

## 📊 Features

### Core

- ✅ Authentification multi-facteurs
- ✅ Gestion membres avec photos
- ✅ Finance avec graphiques
- ✅ Events et célébrations
- ✅ Multi-église
- ✅ Offline-first

### Technique

- ✅ Input validation centralisée
- ✅ Migrations Isar
- ✅ Environment management
- ✅ Performance optimizations
- ✅ CI/CD pipeline
- ✅ Error tracking (Sentry)

## 🧪 Tests

```bash
flutter test                          # Tous les tests
flutter test test/unit/              # Tests unitaires
flutter test test/widget/            # Tests widgets
flutter test --coverage              # Avec couverture
```

## 🚢 Déploiement

### Android

```bash
flutter build appbundle --release
# Upload sur Google Play Console
```

### iOS

```bash
flutter build ipa --release
# Upload sur App Store Connect
```

### Web

```bash
flutter build web --release
# Deploy sur Firebase Hosting ou Cloudflare Pages
```

## 📝 Conventions

### Code Style

- Dart: `snake_case.dart`
- Classes: `PascalCase`
- Variables: `camelCase`
- Constants: `UPPER_CASE`

### Git

- Branches: `feature/`, `fix/`, `hotfix/`
- Commits: Conventional Commits
- PR: Obligatoire pour main

## 🔐 Sécurité

- Row Level Security (RLS) sur toutes les tables
- Validation côté serveur
- Chiffrement des données sensibles
- Tokens sécurisés (flutter_secure_storage)

## 📈 Performance

- Image cache: 50 MB
- RepaintBoundary sur widgets lourds
- Lazy loading des listes
- Code splitting

## 🐛 Debugging

```bash
flutter run --debug
# DevTools: flutter pub global run devtools
```

## 📚 Documentation

- [Architecture](docs/architecture.md)
- [API Reference](docs/api.md)
- [Contributing](CONTRIBUTING.md)

## 📄 License

Proprietary - Lumina Church

## 👥 Team

- Lead Developer: [Your Name]
- Backend: Supabase
- Infrastructure: Cloudflare

## 🆘 Support

- Issues: GitHub Issues
- Email: <support@mfejc.org>

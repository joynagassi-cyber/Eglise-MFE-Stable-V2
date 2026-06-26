.PHONY: setup run test clean build format analyze release-android release-ios cf-deploy cf-dev version-up

setup:
	@echo "📦 Installation des dépendances..."
	cd feu_evangile_flutter && flutter pub get
	@echo "🔨 Génération du code..."
	cd feu_evangile_flutter && flutter pub run build_runner build --delete-conflicting-outputs
	@echo "✅ Setup terminé!"

run:
	@echo "🚀 Lancement de l'application..."
	cd feu_evangile_flutter && flutter run --dart-define-from-file=.env

test:
	@echo "🧪 Exécution des tests..."
	cd feu_evangile_flutter && flutter test

clean:
	@echo "🧹 Nettoyage..."
	cd feu_evangile_flutter && flutter clean
	@echo "✅ Nettoyage terminé!"

build:
	@echo "📱 Build APK (Standard)..."
	cd feu_evangile_flutter && flutter build apk --release

release-android:
	@echo "🚀 Build Production APK..."
	cd feu_evangile_flutter && flutter clean
	cd feu_evangile_flutter && flutter pub get
	cd feu_evangile_flutter && flutter pub run build_runner build --delete-conflicting-outputs
	cd feu_evangile_flutter && flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols
	@echo "✅ APK disponible dans feu_evangile_flutter/build/app/outputs/flutter-apk/"

format:
	@echo "✨ Formatage du code..."
	cd feu_evangile_flutter && dart format lib/

analyze:
	@echo "🔍 Analyse du code..."
	cd feu_evangile_flutter && flutter analyze

# Cloudflare Workers
cf-dev:
	@echo "☁️ Lancement du worker en local..."
	cd backend/cloudflare && npm run dev

cf-deploy:
	@echo "☁️ Déploiement des workers..."
	cd backend/cloudflare && npm run deploy
	cd backend/cloudflare && npx wrangler deploy -c wrangler-ocr.toml

# Versioning
version-up:
	@echo "📈 Incrémentation du build number..."
	cd feu_evangile_flutter && perl -i -pe 's/^(version:\s+\d+\.\d+\.\d+\+)(\d+)$/$$1.($$2+1)/e' pubspec.yaml
	@echo "✅ Version mise à jour dans pubspec.yaml"

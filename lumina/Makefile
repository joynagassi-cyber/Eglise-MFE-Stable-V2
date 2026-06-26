.PHONY: setup run build test clean

setup:
	flutter pub get
	flutter pub run build_runner build --delete-conflicting-outputs
	@if [ ! -f .env ]; then cp .env.example .env; echo "⚠️  Configure .env"; fi

run:
	flutter run --dart-define-from-file=.env

build-android:
	flutter build apk --release --dart-define=APP_ENV=prod

build-android-staging:
	flutter build apk --release --dart-define=APP_ENV=staging

build-ios:
	flutter build ios --release --dart-define=APP_ENV=prod

build-ios-staging:
	flutter build ios --release --dart-define=APP_ENV=staging

test:
	flutter test --coverage

analyze:
	flutter analyze
	dart format --set-exit-if-changed .

clean:
	flutter clean
	flutter pub get

gen:
	flutter pub run build_runner build --delete-conflicting-outputs

watch:
	flutter pub run build_runner watch

# Web Compatibility Fix
fix-web:
	dart scripts/fix_isar_web.dart

run-web: fix-web
	flutter run -d chrome

# Ado Assistant

Ado Assistent für Blinde – Cross‑Platform (Flutter) Voice‑First Assistenz mit Offline‑First Navigation, Hinderniserkennung und optionalen Online‑Boosts.

## Features

- **Offline-First**: Funktioniert auch ohne Internetverbindung
- **Spracherkennung**: Offline-Spracherkennung (deviceabhängig) mit German defaults
- **Text-zu-Sprache**: Sprachausgabe für Antworten und Navigation
- **Navigation**: MapLibre-basierte Offline-Navigation (Platzhalter implementiert)
- **Intent Router**: Einfacher regelbasierter Router für deutsche Sprachbefehle
- **Barrierefreiheit**: Optimiert für blinde und sehbehinderte Nutzer

## Local Setup

### Voraussetzungen

- Flutter 3.24.5 oder höher
- Dart 3.1.0 oder höher
- Android Studio / VS Code mit Flutter Plugins
- Für Android: Android SDK 21+
- Für iOS: Xcode 12+ und iOS 12+

### Installation

1. Repository klonen:
```bash
git clone https://github.com/asaliov/ado-assistant.git
cd ado-assistant
```

2. In das App-Verzeichnis wechseln:
```bash
cd app
```

3. Dependencies installieren:
```bash
flutter pub get
```

4. App auf Gerät/Emulator starten:
```bash
# Android
flutter run

# iOS
flutter run -d ios
```

### Build Commands

```bash
# Android APK erstellen
flutter build apk --release

# iOS App erstellen (ohne Code-Signierung)
flutter build ios --release --no-codesign

# Tests ausführen
flutter test

# Code analysieren
flutter analyze

# Code formatieren
flutter format .
```

### Permissions

Die App benötigt folgende Berechtigungen:

**Android:**
- `RECORD_AUDIO` - Für Spracherkennung
- `ACCESS_FINE_LOCATION` / `ACCESS_COARSE_LOCATION` - Für Navigation
- `CAMERA` - Für zukünftige Hinderniserkennung
- `VIBRATE` - Für haptisches Feedback

**iOS:**
- `NSMicrophoneUsageDescription` - Für Spracherkennung
- `NSLocationWhenInUseUsageDescription` - Für Navigation
- `NSCameraUsageDescription` - Für zukünftige Hinderniserkennung
- `NSSpeechRecognitionUsageDescription` - Für Spracherkennung

## Projektstruktur

```
app/
├── lib/
│   ├── main.dart                    # App-Hauptdatei mit Provider-Setup
│   ├── core/
│   │   └── intent_router.dart       # Regel-basierter Intent-Router
│   ├── services/
│   │   ├── asr_stub.dart           # Speech-to-Text Service
│   │   └── tts_stub.dart           # Text-to-Speech Service
│   └── features/
│       ├── navigation/
│       │   └── navigation_stub.dart # Navigation Service & UI
│       └── settings/
│           └── settings_page.dart   # Einstellungsseite
├── android/                        # Android-spezifische Konfiguration
├── ios/                            # iOS-spezifische Konfiguration
└── test/                           # Test-Dateien
```

## Geplante Features

- **Offline-Karten**: MapLibre-Integration mit herunterladbaren Karten
- **Hinderniserkennung**: Kamera-basierte Objekterkennung
- **Online-Boosts**: Optional verfügbare Online-Services für erweiterte Features
- **Erweiterte Navigation**: Turn-by-turn Navigation mit Sprachansagen
- **Personalisierung**: Anpassbare Sprachbefehle und Einstellungen

## Development

### Code Style

Das Projekt verwendet `flutter_lints` für Code-Qualität. Vor dem Commit:

```bash
flutter analyze
flutter format .
flutter test
```

### CI/CD

GitHub Actions führt automatisch folgende Checks aus:
- Code-Analyse und Formatierung
- Unit Tests
- Android APK Build
- iOS IPA Build (ohne Code-Signierung)

## Lizenz

MIT License - siehe [LICENSE](LICENSE) für Details.

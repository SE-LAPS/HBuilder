# HBuilder - Command Reference

Quick reference for common Flutter and Firebase commands.

## 📱 Flutter Commands

### Project Setup
```bash
# Get dependencies
flutter pub get

# Clean project
flutter clean

# Check Flutter setup
flutter doctor

# Check for updates
flutter upgrade
```

### Running the App
```bash
# Run in debug mode
flutter run

# Run in release mode
flutter run --release

# Run on specific device
flutter run -d <device_id>

# Run with hot reload (default)
flutter run --hot

# List devices
flutter devices
```

### Building the App
```bash
# Build APK (Android)
flutter build apk

# Build split APKs per ABI
flutter build apk --split-per-abi

# Build App Bundle (Google Play)
flutter build appbundle

# Build for release
flutter build apk --release
```

### Debugging
```bash
# Run with verbose logging
flutter run -v

# Analyze code
flutter analyze

# Format code
flutter format lib/

# Check outdated packages
flutter pub outdated

# Update packages
flutter pub upgrade
```

## 🔥 Firebase Commands

### FlutterFire CLI Setup
```bash
# Install FlutterFire CLI globally
dart pub global activate flutterfire_cli

# Login to Firebase
firebase login

# Configure Firebase for project
flutterfire configure

# Reconfigure (if you change Firebase project)
flutterfire configure --force
```

### Firebase CLI (Optional)
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize project
firebase init

# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy Firestore indexes
firebase deploy --only firestore:indexes
```

## 🛠️ Troubleshooting Commands

### Clean & Rebuild
```bash
# Full clean and rebuild
flutter clean
flutter pub get
flutter run
```

### Reset Flutter
```bash
# Reset Flutter
flutter pub cache repair
flutter doctor
```

### Android Issues
```bash
# Clean Android build
cd android
./gradlew clean
cd ..
flutter run
```

### Permission Issues (Windows)
```powershell
# Run PowerShell as Administrator if needed
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 📦 Package Management

### Add Package
```bash
# Add to pubspec.yaml, then:
flutter pub get

# Or add directly
flutter pub add package_name
```

### Remove Package
```bash
flutter pub remove package_name
```

### Update Single Package
```bash
flutter pub upgrade package_name
```

## 🔍 Diagnostics

### Check App Size
```bash
flutter build apk --analyze-size
```

### Profile Performance
```bash
flutter run --profile
```

### Check Dependencies
```bash
flutter pub deps
```

## 🎯 Useful Development Commands

### Generate Icons (if using flutter_launcher_icons)
```bash
flutter pub run flutter_launcher_icons:main
```

### Generate Splash Screen (if using flutter_native_splash)
```bash
flutter pub run flutter_native_splash:create
```

### Run Tests
```bash
flutter test
flutter test test/widget_test.dart
```

## 📱 Device Commands

### Install APK Manually
```bash
# Build APK first
flutter build apk

# Install using ADB
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Check Device Logs
```bash
flutter logs
```

### Screenshot
```bash
flutter screenshot
```

## 🔧 Android Specific

### Update Android Dependencies
```bash
cd android
./gradlew dependencies
cd ..
```

### Android Signing (Release)
```bash
# Generate keystore
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
```

## 🚀 Deployment Checklist

### Before Release:
```bash
# 1. Update version in pubspec.yaml
# 2. Clean build
flutter clean

# 3. Get dependencies
flutter pub get

# 4. Analyze code
flutter analyze

# 5. Build release APK
flutter build apk --release

# 6. Test on real device
adb install build/app/outputs/flutter-apk/app-release.apk

# 7. Build app bundle for Play Store
flutter build appbundle
```

## 📊 Performance

### Profile Build
```bash
flutter build apk --profile
```

### Trace Performance
```bash
flutter run --profile --trace-startup
```

## 🔑 Environment Variables (Optional)

Create `.env` file:
```bash
# .env
FIREBASE_API_KEY=your_api_key
FIREBASE_PROJECT_ID=your_project_id
```

## 📝 Git Commands (Recommended)

```bash
# Initialize git
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit"

# Add remote
git remote add origin <your-repo-url>

# Push
git push -u origin main
```

## 🎯 Quick Start (New Setup)

```bash
# 1. Navigate to project
cd H:\HBuilder

# 2. Get dependencies
flutter pub get

# 3. Configure Firebase
flutterfire configure

# 4. Run app
flutter run
```

## 🆘 Emergency Reset

If everything breaks:
```bash
# Nuclear option - reset everything
flutter clean
rm -rf .dart_tool
rm -rf build
rm pubspec.lock
flutter pub get
flutter run
```

On Windows:
```powershell
flutter clean
Remove-Item -Recurse -Force .dart_tool
Remove-Item -Recurse -Force build
Remove-Item pubspec.lock
flutter pub get
flutter run
```

## 📱 Emulator Commands

### List Emulators
```bash
flutter emulators
```

### Launch Emulator
```bash
flutter emulators --launch <emulator_id>
```

## ✅ Daily Development Workflow

```bash
# Morning
flutter pub get
flutter run

# During development
# (Hot reload: press 'r' in terminal)
# (Hot restart: press 'R' in terminal)

# Before commit
flutter analyze
flutter format lib/
git add .
git commit -m "Description"
git push
```

## 🎉 That's It!

Save this file for quick reference during development.

---

**Pro Tip**: Create aliases in your terminal for common commands:
```bash
alias fr="flutter run"
alias fp="flutter pub get"
alias fc="flutter clean"
alias fa="flutter analyze"
```




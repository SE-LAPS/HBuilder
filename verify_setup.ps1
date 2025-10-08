# HBuilder Firebase Setup Verification Script
Write-Host "`n==================================" -ForegroundColor Cyan
Write-Host "HBuilder Setup Verification" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

$allGood = $true

# Check 1: Flutter
Write-Host "`n[1/6] Checking Flutter..." -ForegroundColor Yellow
if (Get-Command flutter -ErrorAction SilentlyContinue) {
    $flutterVersion = flutter --version 2>&1 | Select-String "Flutter" | Select-Object -First 1
    Write-Host "  ✓ Flutter is installed: $flutterVersion" -ForegroundColor Green
} else {
    Write-Host "  ✗ Flutter not found!" -ForegroundColor Red
    $allGood = $false
}

# Check 2: Firebase Options
Write-Host "`n[2/6] Checking Firebase configuration..." -ForegroundColor Yellow
if (Test-Path "lib\firebase_options.dart") {
    Write-Host "  ✓ firebase_options.dart exists" -ForegroundColor Green
    $content = Get-Content "lib\firebase_options.dart" -Raw
    if ($content -match "hbuilder") {
        Write-Host "  ✓ Firebase project configured" -ForegroundColor Green
    } else {
        Write-Host "  ! Run: flutterfire configure" -ForegroundColor Yellow
    }
} else {
    Write-Host "  ✗ firebase_options.dart not found!" -ForegroundColor Red
    Write-Host "  → Run: flutterfire configure" -ForegroundColor Yellow
    $allGood = $false
}

# Check 3: google-services.json
Write-Host "`n[3/6] Checking google-services.json..." -ForegroundColor Yellow
if (Test-Path "android\app\google-services.json") {
    Write-Host "  ✓ google-services.json exists" -ForegroundColor Green
} else {
    Write-Host "  ✗ google-services.json not found!" -ForegroundColor Red
    Write-Host "  → Run: flutterfire configure" -ForegroundColor Yellow
    $allGood = $false
}

# Check 4: Dependencies
Write-Host "`n[4/6] Checking Flutter dependencies..." -ForegroundColor Yellow
if (Test-Path "pubspec.lock") {
    Write-Host "  ✓ Dependencies installed" -ForegroundColor Green
} else {
    Write-Host "  ! Run: flutter pub get" -ForegroundColor Yellow
}

# Check 5: Android Configuration
Write-Host "`n[5/6] Checking Android configuration..." -ForegroundColor Yellow
if (Test-Path "android\app\src\main\AndroidManifest.xml") {
    $manifest = Get-Content "android\app\src\main\AndroidManifest.xml" -Raw
    if ($manifest -match "INTERNET") {
        Write-Host "  ✓ Internet permission configured" -ForegroundColor Green
    }
    if ($manifest -match "CAMERA") {
        Write-Host "  ✓ Camera permission configured" -ForegroundColor Green
    }
    if ($manifest -match "ACCESS_FINE_LOCATION") {
        Write-Host "  ✓ Location permissions configured" -ForegroundColor Green
    }
}

# Check 6: Project Structure
Write-Host "`n[6/6] Checking project structure..." -ForegroundColor Yellow
$requiredFiles = @(
    "lib\main.dart",
    "lib\config\theme.dart",
    "lib\providers\auth_provider.dart",
    "lib\screens\home\home_screen.dart"
)

$allFilesExist = $true
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "  ✓ $file" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $file missing" -ForegroundColor Red
        $allFilesExist = $false
    }
}

# Summary
Write-Host "`n==================================" -ForegroundColor Cyan
if ($allGood -and $allFilesExist) {
    Write-Host "✓ Setup Complete! Ready to run!" -ForegroundColor Green
    Write-Host "`nNext steps:" -ForegroundColor Cyan
    Write-Host "1. Make sure you've added service centers to Firestore" -ForegroundColor White
    Write-Host "2. Run: flutter run" -ForegroundColor Yellow
} else {
    Write-Host "⚠ Setup incomplete" -ForegroundColor Yellow
    Write-Host "`nComplete these steps:" -ForegroundColor Cyan
    Write-Host "1. Run: flutterfire configure" -ForegroundColor White
    Write-Host "2. Run: flutter pub get" -ForegroundColor White
    Write-Host "3. Add data to Firestore (see FIREBASE_SETUP_COMPLETE.md)" -ForegroundColor White
    Write-Host "4. Run: flutter run" -ForegroundColor White
}
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""




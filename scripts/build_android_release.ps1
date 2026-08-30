$ErrorActionPreference = 'Stop'

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Error 'Flutter SDK not found. Install Flutter stable and add it to PATH first.'
    exit 1
}

if (-not (Test-Path 'android/app/src/main/AndroidManifest.xml')) {
    & powershell -NoProfile -ExecutionPolicy Bypass -File 'scripts/bootstrap_android.ps1'
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

flutter pub get
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
flutter analyze
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
flutter test
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
flutter build apk --release
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
flutter build appbundle --release
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host ''
Write-Host 'APK: build/app/outputs/flutter-apk/app-release.apk' -ForegroundColor Green
Write-Host 'AAB: build/app/outputs/bundle/release/app-release.aab' -ForegroundColor Green

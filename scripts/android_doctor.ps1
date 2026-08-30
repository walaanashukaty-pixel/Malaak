param(
    [switch]$AllowDifferentFlutter
)
$ErrorActionPreference = 'Stop'
$ExpectedFlutter = '3.47.1'

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Error 'Flutter SDK not found in PATH.'
    exit 1
}
if (-not (Get-Command java -ErrorAction SilentlyContinue)) {
    Write-Error 'Java not found in PATH. Android builds require a JDK.'
    exit 2
}

Write-Host '== Flutter ==' -ForegroundColor Cyan
$FlutterOutput = (& flutter --version 2>&1 | Out-String)
Write-Host $FlutterOutput.TrimEnd()
if ($FlutterOutput -notmatch "Flutter\s+$([regex]::Escape($ExpectedFlutter))") {
    $Message = "Project CI is pinned to Flutter $ExpectedFlutter; local SDK differs."
    if ($AllowDifferentFlutter) { Write-Warning $Message } else { Write-Warning $Message }
}

Write-Host "`n== Java ==" -ForegroundColor Cyan
& java -version 2>&1 | Select-Object -First 3 | ForEach-Object { Write-Host $_ }

Write-Host "`n== Flutter doctor ==" -ForegroundColor Cyan
$Doctor = (& flutter doctor -v 2>&1 | Out-String)
Write-Host $Doctor.TrimEnd()
if ($Doctor -match '\[✗\]\s+Android toolchain') {
    Write-Error 'Flutter reports an invalid Android toolchain.'
    exit 3
}

Write-Host "`n== Devices (optional for APK/AAB build) ==" -ForegroundColor Cyan
& flutter devices

if (-not (Test-Path 'android/app/src/main/AndroidManifest.xml')) {
    Write-Host "`nAndroid scaffold is not generated yet." -ForegroundColor Yellow
    Write-Host 'Run: powershell -ExecutionPolicy Bypass -File scripts\bootstrap_android.ps1'
} else {
    Write-Host "`nAndroid scaffold: present" -ForegroundColor Green
}

Write-Host "`nDoctor complete. CI toolchain target: Flutter $ExpectedFlutter" -ForegroundColor Green

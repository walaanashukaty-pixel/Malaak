$ErrorActionPreference = 'Stop'

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Error 'Flutter SDK not found. Install Flutter stable and add it to PATH first.'
    exit 1
}

$tempProject = Join-Path $env:TEMP ("malaak_flutter_bootstrap_" + [guid]::NewGuid().ToString('N'))
try {
    flutter create --platforms=android --org com.malaak --project-name malaak_balance --no-pub $tempProject

    if (Test-Path 'android') {
        Remove-Item -Recurse -Force 'android'
    }
    Copy-Item -Recurse -Force (Join-Path $tempProject 'android') 'android'

    $manifest = 'android/app/src/main/AndroidManifest.xml'
    $content = Get-Content $manifest -Raw
    $content = $content -replace 'android:label="malaak_balance"', 'android:label="ملاك"'
    if (-not $content.Contains('android.permission.INTERNET')) {
        $content = [regex]::Replace(
            $content,
            '(<manifest[^>]*>)',
            '$1' + [Environment]::NewLine + '    <uses-permission android:name="android.permission.INTERNET" />',
            1
        )
    }
    Set-Content -Path $manifest -Value $content -Encoding UTF8

    $packageId = 'com.malaak.malaak_balance'
    $packageFound = Get-ChildItem 'android/app' -Recurse -File | Select-String -SimpleMatch $packageId -Quiet
    if (-not $packageFound) {
        throw "Generated Android scaffold does not contain expected package id: $packageId"
    }
    if (-not ((Get-Content $manifest -Raw).Contains('android:label="ملاك"'))) {
        throw 'Android app label patch failed.'
    }
    if (-not ((Get-Content $manifest -Raw).Contains('android.permission.INTERNET'))) {
        throw 'Android release INTERNET permission patch failed.'
    }

    Write-Host ''
    Write-Host "Android scaffold ready: $packageId" -ForegroundColor Green
    Write-Host 'Next: powershell -ExecutionPolicy Bypass -File scripts/build_android_release.ps1'
}
finally {
    if (Test-Path $tempProject) {
        Remove-Item -Recurse -Force $tempProject
    }
}

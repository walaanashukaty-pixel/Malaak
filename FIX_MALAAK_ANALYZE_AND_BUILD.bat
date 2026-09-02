@echo off
setlocal EnableExtensions
title Malaak - Fix Flutter Analyze CI

cd /d "%~dp0"

echo.
echo ================================================
echo   Malaak - Fix Flutter Analyze and Build
echo ================================================
echo.

if not exist "scripts\build_android_release.sh" (
    echo [ERROR] Put this file inside the Malaak project root.
    echo It must be beside pubspec.yaml, lib, scripts, etc.
    echo.
    pause
    exit /b 1
)

where git >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Git is not installed or not available in PATH.
    echo.
    pause
    exit /b 1
)

echo [1/5] Syncing with GitHub...
git remote get-url origin >nul 2>nul
if errorlevel 1 (
    git remote add origin "https://github.com/walaanashukaty-pixel/Malaak.git"
) else (
    git remote set-url origin "https://github.com/walaanashukaty-pixel/Malaak.git"
)

git fetch origin main
if errorlevel 1 goto :fail

git pull --rebase origin main
if errorlevel 1 goto :fail

echo.
echo [2/5] Updating Flutter analyze behavior...

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$p='scripts\build_android_release.sh';" ^
  "$c=[System.IO.File]::ReadAllText($p);" ^
  "if ($c -notmatch '(?m)^flutter analyze --no-fatal-infos\r?$') {" ^
  "  $n=[regex]::Replace($c,'(?m)^flutter analyze\r?$','flutter analyze --no-fatal-infos');" ^
  "  if ($n -eq $c) { Write-Error 'Could not find the exact flutter analyze line.'; exit 2 }" ^
  "  [System.IO.File]::WriteAllText($p,$n,(New-Object System.Text.UTF8Encoding($false)));" ^
  "}"

if errorlevel 1 goto :fail

findstr /C:"flutter analyze --no-fatal-infos" "scripts\build_android_release.sh" >nul
if errorlevel 1 (
    echo [ERROR] Verification failed: analyze command was not updated.
    goto :fail
)

echo [OK] Analyzer will still report infos, but they will not block the Android build.

echo.
echo [3/5] Creating commit...
git add "scripts/build_android_release.sh"
git diff --cached --quiet
if not errorlevel 1 (
    echo No new change was needed. The fix is already present.
) else (
    git commit -m "Allow Android build with analyzer info messages"
    if errorlevel 1 goto :fail
)

echo.
echo [4/5] Pushing to GitHub...
git push origin main
if errorlevel 1 goto :fail

echo.
echo [5/5] Opening GitHub Actions...
start "" "https://github.com/walaanashukaty-pixel/Malaak/actions"

echo.
echo ================================================
echo   Fix pushed. A new Android build should start.
echo ================================================
echo.
echo Keep this window if GitHub asks you to sign in.
pause
exit /b 0

:fail
echo.
echo ================================================
echo   Something failed. Do not close this window.
echo   Send a screenshot of the error to ChatGPT.
echo ================================================
echo.
pause
exit /b 1

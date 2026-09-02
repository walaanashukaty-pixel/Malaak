@echo off
setlocal EnableExtensions
title Malaak - Fix Flutter Analyze Error

cd /d "%~dp0"

set "REPO_URL=https://github.com/walaanashukaty-pixel/Malaak.git"
set "TARGET=lib\screens\profile\hypotheses_screen.dart"

echo.
echo ================================================
echo   Malaak - Fix Flutter Analyze Error
echo ================================================
echo.

where git >nul 2>&1
if errorlevel 1 (
  echo ERROR: Git is not installed or not available in PATH.
  echo.
  pause
  exit /b 1
)

if not exist "%TARGET%" (
  echo ERROR: Could not find:
  echo   %TARGET%
  echo.
  echo Put this BAT file in the MAIN Malaak project folder,
  echo next to pubspec.yaml, lib, scripts, and supabase.
  echo.
  pause
  exit /b 2
)

if not exist ".git" (
  echo Initializing Git repository...
  git init
  if errorlevel 1 goto :fail
)

git remote get-url origin >nul 2>&1
if errorlevel 1 (
  git remote add origin "%REPO_URL%"
) else (
  git remote set-url origin "%REPO_URL%"
)
if errorlevel 1 goto :fail

git branch -M main >nul 2>&1

echo Syncing with GitHub...
git pull --ff-only origin main
if errorlevel 1 (
  echo.
  echo ERROR: Could not sync safely with GitHub.
  echo No files were overwritten.
  echo Send a screenshot of this window to ChatGPT.
  echo.
  pause
  exit /b 3
)

echo.
echo Applying the Flutter analyzer fix...

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$p='%TARGET%';" ^
  "$old='return const ListView(children: [SizedBox(height: 260), Center(child: CircularProgressIndicator())]);';" ^
  "$new='return ListView(children: const [SizedBox(height: 260), Center(child: CircularProgressIndicator())]);';" ^
  "$s=[System.IO.File]::ReadAllText($p);" ^
  "if($s.Contains($new)){ Write-Host 'Fix already present.'; exit 0 }" ^
  "elseif(-not $s.Contains($old)){ Write-Error 'Expected source line was not found. No change was made.'; exit 10 }" ^
  "else { $s=$s.Replace($old,$new); [System.IO.File]::WriteAllText($p,$s,(New-Object System.Text.UTF8Encoding($false))); Write-Host 'Source fixed successfully.' }"

if errorlevel 1 goto :fail

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$s=[System.IO.File]::ReadAllText('%TARGET%');" ^
  "if($s.Contains('return const ListView(children: [SizedBox(height: 260), Center(child: CircularProgressIndicator())]);')){ exit 11 }" ^
  "if(-not $s.Contains('return ListView(children: const [SizedBox(height: 260), Center(child: CircularProgressIndicator())]);')){ exit 12 }"

if errorlevel 1 (
  echo.
  echo ERROR: Verification failed. The source was not changed as expected.
  echo.
  pause
  exit /b 4
)

echo Local verification passed.

git add "%TARGET%"
if errorlevel 1 goto :fail

git diff --cached --quiet
if not errorlevel 1 (
  echo.
  echo No new source change to commit. It may already be fixed on GitHub.
  goto :open_actions
)

git config user.name >nul 2>&1
if errorlevel 1 git config user.name "walaanashukaty-pixel"

git config user.email >nul 2>&1
if errorlevel 1 git config user.email "walaanashukaty-pixel@users.noreply.github.com"

echo.
echo Creating commit...
git commit -m "Fix non-const ListView analyzer error"
if errorlevel 1 goto :fail

echo.
echo Pushing fix to GitHub...
git push -u origin main
if errorlevel 1 goto :fail

echo.
echo ================================================
echo   FIX PUSHED TO GITHUB
echo   GitHub Actions should start automatically.
echo ================================================
echo.

:open_actions
start "" "https://github.com/walaanashukaty-pixel/Malaak/actions"
echo Opening GitHub Actions...
echo.
pause
exit /b 0

:fail
echo.
echo ERROR: The operation stopped.
echo Nothing was force-pushed.
echo Send a screenshot of this window to ChatGPT.
echo.
pause
exit /b 9

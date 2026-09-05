@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"
title Malaak V6.8.2 - Journey Build Fix

set "REPO_URL=https://github.com/walaanashukaty-pixel/Malaak.git"
set "REPO_NAME=walaanashukaty-pixel/Malaak"
set "SOURCE_DIR=%CD%"
set "TEMP_ROOT=%TEMP%\MalaakV682Upload_%RANDOM%_%RANDOM%"
set "CLONE_DIR=%TEMP_ROOT%\repo"

echo.
echo =====================================================
echo   Malaak V6.8.2 - VERIFIED JOURNEY BUILD FIX
echo =====================================================
echo.
echo This upload fixes the two Flutter analyzer errors in journey_screen.dart.
echo It will STOP before push unless the fixed domain-aware navigation is present.
echo.

where git >nul 2>nul
if errorlevel 1 goto :git_missing

REM ---- SOURCE GUARD ----
if not exist "%SOURCE_DIR%\lib\screens\journey\journey_screen.dart" goto :wrong_source
if not exist "%SOURCE_DIR%\lib\features\feminine_intelligence\logic\fi_progression.dart" goto :wrong_source
findstr /C:"FeminineIntelligenceScreen(domain: domain)" "%SOURCE_DIR%\lib\screens\journey\journey_screen.dart" >nul || goto :wrong_source
findstr /C:"const FeminineIntelligenceScreen()" "%SOURCE_DIR%\lib\screens\journey\journey_screen.dart" >nul && goto :wrong_source
findstr /C:"version: 0.6.8+14" "%SOURCE_DIR%\pubspec.yaml" >nul || goto :wrong_source
findstr /C:"FiNodeStatus.locked" "%SOURCE_DIR%\lib\features\feminine_intelligence\screens\fi_route_screen.dart" >nul || goto :wrong_source

echo [OK] V6.8.2 build-fix source markers found.

if exist "%TEMP_ROOT%" rmdir /s /q "%TEMP_ROOT%" >nul 2>&1
mkdir "%TEMP_ROOT%" >nul 2>&1
if errorlevel 1 goto :temp_error

echo.
echo [1/6] Cloning latest main...
git clone --branch main --single-branch "%REPO_URL%" "%CLONE_DIR%"
if errorlevel 1 goto :clone_error

echo.
echo [2/6] Copying the FULL V6.8.2 project...
robocopy "%SOURCE_DIR%" "%CLONE_DIR%" /E /COPY:DAT /DCOPY:DAT /R:2 /W:1 /NFL /NDL /NP /NJH /NJS ^
  /XD ".git" "build" ".dart_tool" ".idea" ".vscode" ^
  /XF "local.properties" ".env" ".env.*" "*.jks" "*.keystore" "key.properties" "android\key.properties"
set "ROBOCODE=%ERRORLEVEL%"
if %ROBOCODE% GEQ 8 goto :copy_error

REM ---- COPY GUARD ----
findstr /C:"FeminineIntelligenceScreen(domain: domain)" "%CLONE_DIR%\lib\screens\journey\journey_screen.dart" >nul || goto :copy_verification_error
findstr /C:"const FeminineIntelligenceScreen()" "%CLONE_DIR%\lib\screens\journey\journey_screen.dart" >nul && goto :copy_verification_error
findstr /C:"version: 0.6.8+14" "%CLONE_DIR%\pubspec.yaml" >nul || goto :copy_verification_error
findstr /C:"FiNodeStatus.locked" "%CLONE_DIR%\lib\features\feminine_intelligence\screens\fi_route_screen.dart" >nul || goto :copy_verification_error

echo [OK] Verified V6.8.2 fix inside Git workspace.

cd /d "%CLONE_DIR%"
if errorlevel 1 goto :git_error

git config user.name "walaanashukaty-pixel"
git config user.email "walaanashukaty-pixel@users.noreply.github.com"

echo.
echo [3/6] Staging project changes...
git add -A
if errorlevel 1 goto :git_error

echo.
echo ===== Files that WILL be uploaded =====
git diff --cached --name-only
echo =======================================

REM ---- DIFF GUARD: the actual broken file must be part of this push ----
git diff --cached --name-only | findstr /C:"lib/screens/journey/journey_screen.dart" >nul
if errorlevel 1 goto :no_fix_diff

git diff --cached --name-only | findstr /C:"pubspec.yaml" >nul
if errorlevel 1 goto :no_fix_diff

echo [OK] Journey build fix and version bump are staged.

echo.
echo [4/6] Creating V6.8.2 commit...
git commit -m "Malaak V6.8.2 - fix required domain navigation build errors"
if errorlevel 1 goto :git_error

echo.
echo [5/6] Rebase on latest main...
git pull --rebase origin main
if errorlevel 1 goto :rebase_error

REM Re-verify after rebase before push.
findstr /C:"FeminineIntelligenceScreen(domain: domain)" "lib\screens\journey\journey_screen.dart" >nul || goto :copy_verification_error
findstr /C:"const FeminineIntelligenceScreen()" "lib\screens\journey\journey_screen.dart" >nul && goto :copy_verification_error
findstr /C:"version: 0.6.8+14" "pubspec.yaml" >nul || goto :copy_verification_error

echo.
echo [6/6] Pushing V6.8.2 to GitHub...
git push origin main
if errorlevel 1 goto :push_error

echo.
echo =====================================================
echo SUCCESS: Malaak V6.8.2 build fix was pushed.
echo GitHub Actions should now build version 0.6.8+14.
echo =====================================================
echo.
cd /d "%SOURCE_DIR%"
rmdir /s /q "%TEMP_ROOT%" >nul 2>&1
start "" "https://github.com/%REPO_NAME%/actions"
pause
exit /b 0

:wrong_source
echo.
echo ERROR: This folder does NOT contain the corrected V6.8.2 source.
echo Extract the ENTIRE V6.8.2 ZIP into a NEW empty folder, then run this BAT there.
goto :failed

:no_fix_diff
echo.
echo ERROR: Upload stopped because journey_screen.dart and pubspec.yaml are not both staged.
echo This prevents a fake build-fix upload.
goto :failed

:copy_verification_error
echo.
echo ERROR: V6.8.2 verification failed after copying. Nothing was pushed.
goto :failed

:git_missing
echo.
echo ERROR: Git for Windows is not installed or not available in PATH.
goto :failed

:clone_error
echo.
echo ERROR: Could not clone the latest GitHub main branch.
goto :failed

:copy_error
echo.
echo ERROR: Robocopy failed. Exit code: %ROBOCODE%
goto :failed

:rebase_error
echo.
echo ERROR: Rebase failed. Nothing was force-pushed.
goto :failed

:push_error
echo.
echo ERROR: GitHub rejected the push. Complete GitHub sign-in if prompted.
goto :failed

:temp_error
echo.
echo ERROR: Could not create temporary folder.
goto :failed

:git_error
echo.
echo ERROR: Git failed while preparing the verified upload.
goto :failed

:failed
echo.
echo Diagnostic folder: %TEMP_ROOT%
echo.
pause
exit /b 30

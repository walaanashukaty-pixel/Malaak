@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"
title Malaak V6.8.1 - REAL Skill Tree Upload

set "REPO_URL=https://github.com/walaanashukaty-pixel/Malaak.git"
set "REPO_NAME=walaanashukaty-pixel/Malaak"
set "SOURCE_DIR=%CD%"
set "TEMP_ROOT=%TEMP%\MalaakV681Upload_%RANDOM%_%RANDOM%"
set "CLONE_DIR=%TEMP_ROOT%\repo"

echo.
echo =====================================================
echo   Malaak V6.8.1 - VERIFIED Skill Tree Upload
echo =====================================================
echo.
echo This uploader will STOP before push unless the real V6.8 files
 echo are present and copied into the GitHub workspace.
echo.

where git >nul 2>nul
if errorlevel 1 goto :git_missing

REM ---- SOURCE GUARD: prevents running only a copied BAT from an old folder ----
if not exist "%SOURCE_DIR%\lib\features\feminine_intelligence\logic\fi_progression.dart" goto :wrong_source
if not exist "%SOURCE_DIR%\lib\features\feminine_intelligence\screens\fi_route_screen.dart" goto :wrong_source
if not exist "%SOURCE_DIR%\lib\features\feminine_intelligence\screens\fi_lesson_screen.dart" goto :wrong_source
findstr /C:"enum FiNodeStatus" "%SOURCE_DIR%\lib\features\feminine_intelligence\logic\fi_progression.dart" >nul || goto :wrong_source
findstr /C:"Duration(hours: 18)" "%SOURCE_DIR%\lib\features\feminine_intelligence\logic\fi_progression.dart" >nul || goto :wrong_source
findstr /C:"FiNodeStatus.locked" "%SOURCE_DIR%\lib\features\feminine_intelligence\screens\fi_route_screen.dart" >nul || goto :wrong_source
findstr /C:"version: 0.6.8+13" "%SOURCE_DIR%\pubspec.yaml" >nul || goto :wrong_source

echo [OK] Real V6.8.1 source markers found.

if exist "%TEMP_ROOT%" rmdir /s /q "%TEMP_ROOT%" >nul 2>&1
mkdir "%TEMP_ROOT%" >nul 2>&1
if errorlevel 1 goto :temp_error

echo.
echo [1/6] Cloning latest main...
git clone --branch main --single-branch "%REPO_URL%" "%CLONE_DIR%"
if errorlevel 1 goto :clone_error

echo.
echo [2/6] Copying the FULL V6.8.1 project...
robocopy "%SOURCE_DIR%" "%CLONE_DIR%" /E /COPY:DAT /DCOPY:DAT /R:2 /W:1 /NFL /NDL /NP /NJH /NJS ^
  /XD ".git" "build" ".dart_tool" ".idea" ".vscode" ^
  /XF "local.properties" ".env" ".env.*" "*.jks" "*.keystore" "key.properties" "android\key.properties"
set "ROBOCODE=%ERRORLEVEL%"
if %ROBOCODE% GEQ 8 goto :copy_error

REM ---- COPY GUARD: proves the cloned workspace now contains the real V6.8 source ----
findstr /C:"enum FiNodeStatus" "%CLONE_DIR%\lib\features\feminine_intelligence\logic\fi_progression.dart" >nul || goto :copy_verification_error
findstr /C:"FiNodeStatus.locked" "%CLONE_DIR%\lib\features\feminine_intelligence\screens\fi_route_screen.dart" >nul || goto :copy_verification_error
findstr /C:"followUpAvailableAt" "%CLONE_DIR%\lib\features\feminine_intelligence\screens\fi_lesson_screen.dart" >nul || goto :copy_verification_error
findstr /C:"version: 0.6.8+13" "%CLONE_DIR%\pubspec.yaml" >nul || goto :copy_verification_error

echo [OK] Verified V6.8.1 files inside Git workspace.

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

REM ---- DIFF GUARD: at least one core Skill Tree file MUST be in this push ----
git diff --cached --name-only | findstr /C:"lib/features/feminine_intelligence/logic/fi_progression.dart" /C:"lib/features/feminine_intelligence/screens/fi_route_screen.dart" /C:"lib/features/feminine_intelligence/screens/fi_lesson_screen.dart" >nul
if errorlevel 1 goto :no_real_diff

echo [OK] Core Skill Tree files are staged for upload.

echo.
echo [4/6] Creating verified V6.8.1 commit...
git commit -m "Malaak V6.8.1 - upload real skill tree UI and progression"
if errorlevel 1 goto :git_error

echo.
echo [5/6] Rebase on latest main...
git pull --rebase origin main
if errorlevel 1 goto :rebase_error

REM Re-verify after rebase before push.
findstr /C:"FiNodeStatus.locked" "lib\features\feminine_intelligence\screens\fi_route_screen.dart" >nul || goto :copy_verification_error
findstr /C:"version: 0.6.8+13" "pubspec.yaml" >nul || goto :copy_verification_error

echo.
echo [6/6] Pushing REAL V6.8.1 to GitHub...
git push origin main
if errorlevel 1 goto :push_error

echo.
echo =====================================================
echo SUCCESS: REAL Malaak V6.8.1 source was pushed.
echo The push included verified Skill Tree source files.
echo GitHub Actions should now build version 0.6.8+13.
echo =====================================================
echo.
cd /d "%SOURCE_DIR%"
rmdir /s /q "%TEMP_ROOT%" >nul 2>&1
start "" "https://github.com/%REPO_NAME%/actions"
pause
exit /b 0

:wrong_source
echo.
echo ERROR: This folder does NOT contain the real V6.8.1 project files.
echo DO NOT copy this BAT into an older Malaak folder.
echo Extract the ENTIRE V6.8.1 ZIP into a NEW empty folder, then run this BAT there.
goto :failed

:no_real_diff
echo.
echo ERROR: Upload stopped because no core Skill Tree source file is staged.
echo This protects you from another fake V6.8 upload that changes only the BAT file.
goto :failed

:copy_verification_error
echo.
echo ERROR: V6.8.1 verification failed after copying. Nothing was pushed.
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

@echo off
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"
title Malaak V6.8 - Safe GitHub Upload

set "REPO_URL=https://github.com/walaanashukaty-pixel/Malaak.git"
set "REPO_NAME=walaanashukaty-pixel/Malaak"
set "SOURCE_DIR=%CD%"
set "TEMP_ROOT=%TEMP%\MalaakGitHubUpload_%RANDOM%_%RANDOM%"
set "CLONE_DIR=%TEMP_ROOT%\repo"

echo.
echo =====================================================
echo   Malaak V6.8 - Safe One Click GitHub Upload
echo =====================================================
echo.
echo This uploader NEVER creates a new Git history.
echo It clones the latest main branch first, copies V6.8 over it,
echo then commits and pushes on top of GitHub's current history.
echo.
echo Target: %REPO_URL%
echo.

where git >nul 2>nul
if errorlevel 1 (
  echo ERROR: Git is not installed or is not available in PATH.
  echo Install Git for Windows, then double-click this file again.
  echo https://git-scm.com/download/win
  echo.
  pause
  exit /b 10
)

if exist "%TEMP_ROOT%" rmdir /s /q "%TEMP_ROOT%" >nul 2>&1
mkdir "%TEMP_ROOT%" >nul 2>&1
if errorlevel 1 goto :temp_error

echo [1/5] Downloading the latest main branch from GitHub...
git clone --branch main --single-branch "%REPO_URL%" "%CLONE_DIR%"
if errorlevel 1 goto :clone_error

echo.
echo [2/5] Copying Malaak V6.8 files over the latest GitHub version...
robocopy "%SOURCE_DIR%" "%CLONE_DIR%" /E /COPY:DAT /DCOPY:DAT /R:2 /W:1 /NFL /NDL /NP /NJH /NJS ^
  /XD ".git" "build" ".dart_tool" ".idea" ".vscode" ^
  /XF "local.properties" ".env" ".env.*" "*.jks" "*.keystore" "key.properties" "android\key.properties"
set "ROBOCODE=%ERRORLEVEL%"
if %ROBOCODE% GEQ 8 goto :copy_error

cd /d "%CLONE_DIR%"
if errorlevel 1 goto :git_error

git config user.name "walaanashukaty-pixel"
git config user.email "walaanashukaty-pixel@users.noreply.github.com"

echo.
echo [3/5] Preparing the V6.8 commit...
git add -A
if errorlevel 1 goto :git_error

git diff --cached --quiet
if errorlevel 1 (
  git commit -m "Malaak V6.8 - Skill tree retention and timed follow-up"
  if errorlevel 1 goto :git_error
) else (
  echo No new file changes were detected. GitHub is already up to date.
)

echo.
echo [4/5] Synchronizing once more before push...
git pull --rebase origin main
if errorlevel 1 goto :rebase_error

echo.
echo [5/5] Uploading to GitHub...
echo If GitHub asks you to sign in, complete the browser sign-in window.
git push origin main
if errorlevel 1 goto :push_error

echo.
echo =====================================================
echo SUCCESS: Malaak V6.8 was uploaded safely to GitHub.
echo No force push was used and GitHub history was preserved.
echo GitHub Actions should now start the Android build.
echo =====================================================
echo.
cd /d "%SOURCE_DIR%"
rmdir /s /q "%TEMP_ROOT%" >nul 2>&1
start "" "https://github.com/%REPO_NAME%/actions"
pause
exit /b 0

:clone_error
echo.
echo ERROR: Could not download the latest repository from GitHub.
echo Check your internet connection and GitHub access, then try again.
goto :failed

:copy_error
echo.
echo ERROR: Windows could not copy the project into the safe Git workspace.
echo Robocopy exit code: %ROBOCODE%
goto :failed

:rebase_error
echo.
echo ERROR: GitHub changed while this upload was running, or a real merge conflict exists.
echo Nothing was force-pushed. Your GitHub files are safe.
echo Keep this window open and send a screenshot of this message.
goto :failed

:push_error
echo.
echo ERROR: GitHub rejected the final push.
echo Your GitHub history was NOT overwritten and no force push was attempted.
echo If a browser sign-in appeared, make sure it was completed.
echo Keep this window open and send a screenshot of this message.
goto :failed

:temp_error
echo.
echo ERROR: Windows could not create the temporary upload folder.
goto :failed

:git_error
echo.
echo ERROR: A Git command failed while preparing the safe upload.
goto :failed

:failed
echo.
echo Temporary working folder (for diagnostics):
echo %TEMP_ROOT%
echo.
pause
exit /b 30

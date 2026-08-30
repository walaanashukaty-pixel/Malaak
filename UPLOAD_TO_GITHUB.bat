@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title Malaak - Upload to GitHub

set "REPO_URL=https://github.com/walaanashukaty-pixel/Malaak.git"
set "REPO_NAME=walaanashukaty-pixel/Malaak"

echo.
echo ================================================
echo   Malaak V6.1 - One Click GitHub Upload
echo ================================================
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

if not exist ".git\" (
  git init -b main >nul 2>&1
  if errorlevel 1 (
    git init
    if errorlevel 1 goto :git_error
    git branch -M main
    if errorlevel 1 goto :git_error
  )
) else (
  git branch -M main >nul 2>&1
)

git config user.name "walaanashukaty-pixel"
git config user.email "walaanashukaty-pixel@users.noreply.github.com"

git remote get-url origin >nul 2>&1
if errorlevel 1 (
  git remote add origin "%REPO_URL%"
  if errorlevel 1 goto :git_error
) else (
  git remote set-url origin "%REPO_URL%"
  if errorlevel 1 goto :git_error
)

git add -A
if errorlevel 1 goto :git_error

git diff --cached --quiet
if errorlevel 1 (
  git commit -m "Malaak Android V6.1 - GitHub ready"
  if errorlevel 1 goto :git_error
) else (
  git rev-parse --verify HEAD >nul 2>&1
  if errorlevel 1 (
    echo ERROR: No files were staged for the first commit.
    goto :failed
  )
  echo No new local changes to commit.
)

echo.
echo Uploading to GitHub...
echo If GitHub asks you to sign in, complete the browser sign-in window.
echo.
git push -u origin main
if errorlevel 1 goto :push_error

echo.
echo ================================================
echo SUCCESS: Malaak was uploaded to GitHub.
echo GitHub Actions should now start the Android build automatically.
echo ================================================
echo.
start "" "https://github.com/%REPO_NAME%/actions"
pause
exit /b 0

:push_error
echo.
echo ERROR: GitHub rejected the upload.
echo Most often this means GitHub sign-in was not completed.
echo Keep this window open and send a screenshot of this message.
echo.
pause
exit /b 20

:git_error
echo.
echo ERROR: A local Git command failed.
echo Keep this window open and send a screenshot.
echo.
:failed
pause
exit /b 30

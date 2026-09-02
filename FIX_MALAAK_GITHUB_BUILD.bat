@echo off
setlocal EnableExtensions
chcp 65001 >nul
cd /d "%~dp0"
title Malaak - Fix GitHub Android Build

echo.
echo ==========================================================
echo   MALAAK - FIX GITHUB ANDROID BUILD
echo ==========================================================
echo.

if not exist "pubspec.yaml" (
  echo [ERROR] Put this file inside the Malaak project main folder.
  echo         It must be beside pubspec.yaml, lib, scripts, etc.
  echo.
  pause
  exit /b 1
)

where git >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Git is not installed or not available in PATH.
  echo.
  pause
  exit /b 1
)

if not exist ".git" (
  echo [INFO] Initializing Git repository...
  git init
  if errorlevel 1 goto :failed
)

git branch -M main >nul 2>&1

git remote get-url origin >nul 2>&1
if errorlevel 1 (
  git remote add origin "https://github.com/walaanashukaty-pixel/Malaak.git"
) else (
  git remote set-url origin "https://github.com/walaanashukaty-pixel/Malaak.git"
)

if not exist ".github\workflows" mkdir ".github\workflows"

echo [1/4] Writing corrected Android workflow...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$b='bmFtZTogQW5kcm9pZCBSZWxlYXNlIEJ1aWxkCgpvbjoKICB3b3JrZmxvd19kaXNwYXRjaDoKICBwdXNoOgogICAgYnJhbmNoZXM6CiAgICAgIC0gbWFpbgogICAgdGFnczoKICAgICAgLSAndionCgpwZXJtaXNzaW9uczoKICBjb250ZW50czogcmVhZAoKam9iczoKICBidWlsZC1hbmRyb2lkOgogICAgcnVucy1vbjogdWJ1bnR1LWxhdGVzdAogICAgdGltZW91dC1taW51dGVzOiAzNQogICAgc3RlcHM6CiAgICAgIC0gbmFtZTogQ2hlY2tvdXQKICAgICAgICB1c2VzOiBhY3Rpb25zL2NoZWNrb3V0QHY0CgogICAgICAtIG5hbWU6IFNldCB1cCBKYXZhCiAgICAgICAgdXNlczogYWN0aW9ucy9zZXR1cC1qYXZhQHY0CiAgICAgICAgd2l0aDoKICAgICAgICAgIGRpc3RyaWJ1dGlvbjogdGVtdXJpbgogICAgICAgICAgamF2YS12ZXJzaW9uOiAnMTcnCgogICAgICAtIG5hbWU6IFNldCB1cCBGbHV0dGVyIDMuNDcuMQogICAgICAgIHVzZXM6IHN1Ym9zaXRvL2ZsdXR0ZXItYWN0aW9uQHYyCiAgICAgICAgd2l0aDoKICAgICAgICAgIGZsdXR0ZXItdmVyc2lvbjogJzMuNDcuMScKICAgICAgICAgIGNoYW5uZWw6IHN0YWJsZQogICAgICAgICAgY2FjaGU6IHRydWUKCiAgICAgIC0gbmFtZTogRmx1dHRlciBkb2N0b3IKICAgICAgICBydW46IGZsdXR0ZXIgZG9jdG9yIC12CgogICAgICAtIG5hbWU6IEJ1aWxkIHZlcmlmaWVkIEFuZHJvaWQgQVBLIGFuZCBBQUIKICAgICAgICBydW46IGJhc2ggc2NyaXB0cy9idWlsZF9hbmRyb2lkX3JlbGVhc2Uuc2gKCiAgICAgIC0gbmFtZTogVXBsb2FkIEFQSwogICAgICAgIHVzZXM6IGFjdGlvbnMvdXBsb2FkLWFydGlmYWN0QHY0CiAgICAgICAgd2l0aDoKICAgICAgICAgIG5hbWU6IG1hbGFhay1hbmRyb2lkLWFwawogICAgICAgICAgcGF0aDogYnVpbGQvYXBwL291dHB1dHMvZmx1dHRlci1hcGsvYXBwLXJlbGVhc2UuYXBrCiAgICAgICAgICBpZi1uby1maWxlcy1mb3VuZDogZXJyb3IKCiAgICAgIC0gbmFtZTogVXBsb2FkIEFBQgogICAgICAgIHVzZXM6IGFjdGlvbnMvdXBsb2FkLWFydGlmYWN0QHY0CiAgICAgICAgd2l0aDoKICAgICAgICAgIG5hbWU6IG1hbGFhay1hbmRyb2lkLWFhYgogICAgICAgICAgcGF0aDogYnVpbGQvYXBwL291dHB1dHMvYnVuZGxlL3JlbGVhc2UvYXBwLXJlbGVhc2UuYWFiCiAgICAgICAgICBpZi1uby1maWxlcy1mb3VuZDogZXJyb3IK'; $text=[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($b)); [IO.File]::WriteAllText((Join-Path (Get-Location) '.github/workflows/android-release.yml'), $text, (New-Object Text.UTF8Encoding($false)))"
if errorlevel 1 goto :failed

echo [2/4] Staging fix...
git add ".github/workflows/android-release.yml"
if errorlevel 1 goto :failed

git diff --cached --quiet
if errorlevel 1 (
  echo [3/4] Creating commit...
  git commit -m "Fix Android CI Java setup before Gradle scaffold"
  if errorlevel 1 goto :failed
) else (
  echo [3/4] Workflow is already corrected. No new commit needed.
)

echo [4/4] Pushing to GitHub...
git push -u origin main
if errorlevel 1 goto :failed

echo.
echo ==========================================================
echo   SUCCESS - Fix pushed to GitHub.
echo   GitHub Actions should start automatically.
echo ==========================================================
echo.
start "" "https://github.com/walaanashukaty-pixel/Malaak/actions"
pause
exit /b 0

:failed
echo.
echo ==========================================================
echo   FAILED - Nothing else was changed automatically.
echo   Take a screenshot of this window and send it to ChatGPT.
echo ==========================================================
echo.
pause
exit /b 1

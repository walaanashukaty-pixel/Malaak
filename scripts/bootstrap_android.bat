@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0bootstrap_android.ps1"
exit /b %ERRORLEVEL%

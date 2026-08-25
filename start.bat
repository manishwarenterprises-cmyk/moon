@echo off
cd /d "%~dp0"
start /min "" powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0serve.ps1"
timeout /t 1 /nobreak >nul
start "" "http://localhost:8765/"

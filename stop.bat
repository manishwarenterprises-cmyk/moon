@echo off
powershell -NoProfile -Command "Get-CimInstance Win32_Process -Filter \"Name='powershell.exe'\" | Where-Object { $_.CommandLine -like '*serve.ps1*' } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force }"
echo Server band kora hoe geche.
pause

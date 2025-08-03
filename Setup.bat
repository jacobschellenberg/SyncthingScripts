@echo off
SETLOCAL

REM === Configuration ===
set SCRIPT_DIR=%~dp0
set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%
set SCHTASKS="C:\Windows\System32\schtasks.exe"

REM === AddSpeedLimit Task ===
echo Importing AddSpeedLimit task...
%SCHTASKS% /Create /TN "Syncthing\SyncthingScripts_AddSpeedLimit" /XML "%SCRIPT_DIR%AddSpeedLimit.xml" /F

REM === RemoveSpeedLimit Task ===
echo Importing RemoveSpeedLimit task...
%SCHTASKS% /Create /TN "Syncthing\SyncthingScripts_RemoveSpeedLimit" /XML "%SCRIPT_DIR%RemoveSpeedLimit.xml" /F

echo.
echo Syncthing bandwidth automation tasks installed successfully.
pause

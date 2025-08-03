@echo off
SETLOCAL

REM === Configuration ===
set SCRIPT_DIR=%~dp0
echo SCRIPT_DIR is: %SCRIPT_DIR%
set SCHTASKS="C:\Windows\System32\schtasks.exe"

REM === AddSpeedLimit Task ===
echo Importing AddSpeedLimit task...
echo Running: %SCHTASKS% /Create /TN "AddSpeedLimit" /XML "%SCRIPT_DIR%SyncthingScripts_AddSpeedLimit.xml" /F
%SCHTASKS% /Create /TN "AddSpeedLimit" /XML "%SCRIPT_DIR%SyncthingScripts_AddSpeedLimit.xml" /F

REM === RemoveSpeedLimit Task ===
echo Importing RemoveSpeedLimit task...
echo Running: %SCHTASKS% /Create /TN "RemoveSpeedLimit" /XML "%SCRIPT_DIR%SyncthingScripts_RemoveSpeedLimit.xml" /F
%SCHTASKS% /Create /TN "RemoveSpeedLimit" /XML "%SCRIPT_DIR%SyncthingScripts_RemoveSpeedLimit.xml" /F

echo.
echo Syncthing bandwidth automation tasks installed successfully.
pause

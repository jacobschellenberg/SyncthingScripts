@echo off
SETLOCAL

REM === Configuration ===
set SCRIPT_DIR=%~dp0
echo SCRIPT_DIR is: %SCRIPT_DIR%
set SCHTASKS="C:\Windows\System32\schtasks.exe"

REM === AddSpeedLimit Task ===
echo Importing AddSpeedLimit task...
echo Running: %SCHTASKS% /Create /TN "SyncthingScripts_AddSpeedLimit" /XML "%SCRIPT_DIR%AddSpeedLimit.xml" /F
%SCHTASKS% /Create /TN "SyncthingScripts_AddSpeedLimit" /XML "%SCRIPT_DIR%\AddSpeedLimit.xml" /F

REM === RemoveSpeedLimit Task ===
echo Importing RemoveSpeedLimit task...
echo Running: %SCHTASKS% /Create /TN "SyncthingScripts_RemoveSpeedLimit" /XML "%SCRIPT_DIR%RemoveSpeedLimit.xml" /F
%SCHTASKS% /Create /TN "SyncthingScripts_RemoveSpeedLimit" /XML "%SCRIPT_DIR%\RemoveSpeedLimit.xml" /F

echo.
echo Syncthing bandwidth automation tasks installed successfully.
pause

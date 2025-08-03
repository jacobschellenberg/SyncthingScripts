@echo off
REM =====================================
REM AddSpeedLimit.bat - Syncthing
REM =====================================

REM === Configuration ===
set API_KEY=REPLACE_WITH_YOUR_API_KEY
set HOST=http://127.0.0.1:8384
set RATE_IN=500
set RATE_OUT=500

REM === Temporary working file paths ===
set CONFIG_JSON=_temp_syncthing_config.json
set MODIFIED_JSON=_temp_modified_config.json

echo Fetching current Syncthing config...
curl -s -H "X-API-Key: %API_KEY%" %HOST%/rest/config > %CONFIG_JSON%

echo Modifying config to apply rate limits...
powershell -Command ^
  "$cfg = Get-Content '%CONFIG_JSON%' | ConvertFrom-Json; $cfg.options.globalReceiveLimitKiB = %RATE_IN%; $cfg.options.globalSendLimitKiB = %RATE_OUT%; $cfg | ConvertTo-Json -Depth 10 | Set-Content '%MODIFIED_JSON%'"

echo Sending updated config back to Syncthing...
curl -s -X POST ^
  -H "X-API-Key: %API_KEY%" ^
  -H "Content-Type: application/json" ^
  --data-binary "@%MODIFIED_JSON%" ^
  %HOST%/rest/config

echo Done.

REM === Clean up temp files ===
del %CONFIG_JSON%
del %MODIFIED_JSON%
@echo off
REM =====================================
REM AddSpeedLimit.bat - Syncthing
REM =====================================

REM === Configuration ===
set API_KEY=REPLACE_WITH_YOUR_API_KEY
set HOST=http://127.0.0.1:8384
set RATE_IN=500000
set RATE_OUT=500000

REM === Temporary working file paths ===
set CONFIG_JSON=_temp_syncthing_config.json
set MODIFIED_JSON=_temp_modified_config.json

echo Fetching current Syncthing system config...
curl -s -H "X-API-Key: %API_KEY%" %HOST%/rest/system/config > %CONFIG_JSON%

echo Modifying system config to apply global rate limits...
powershell -Command ^
  "$xml = [xml](Get-Content '%CONFIG_JSON%'); $xml.configuration.maxRecvKbps = %RATE_IN%; $xml.configuration.maxSendKbps = %RATE_OUT%; $xml.Save('%MODIFIED_JSON%')"

echo Sending updated system config back to Syncthing...
curl -s -X POST ^
  -H "X-API-Key: %API_KEY%" ^
  -H "Content-Type: application/json" ^
  --data-binary "@%MODIFIED_JSON%" ^
  %HOST%/rest/system/config

echo Done.

REM === Clean up temp files ===
del %CONFIG_JSON%
del %MODIFIED_JSON%
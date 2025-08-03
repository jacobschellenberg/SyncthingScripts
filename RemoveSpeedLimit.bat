@echo off
REM =====================================
REM RemoveSpeedLimit.bat - Syncthing
REM =====================================

REM === Configuration ===
set API_KEY=REPLACE_WITH_YOUR_API_KEY
set HOST=http://127.0.0.1:8384

echo Removing global rate limits...

curl -X POST -H "X-API-Key: %API_KEY%" ^
  -H "Content-Type: application/json" ^
  -d "{\"options\": {\"globalSendLimitKiB\": 0, \"globalReceiveLimitKiB\": 0}}" ^
  %HOST%/rest/config

echo Done.
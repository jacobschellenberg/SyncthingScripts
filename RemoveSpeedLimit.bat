@echo off
REM === Configuration ===
set API_KEY=REPLACE_WITH_YOUR_API_KEY
set HOST=http://127.0.0.1:8384

REM === Remove rate limits ===
curl -X PATCH ^
  -H "X-API-Key: %API_KEY%" ^
  -H "Content-Type: application/json" ^
  -d "{\"rateLimitIn\":0,\"rateLimitOut\":0}" ^
  %HOST%/rest/system/config
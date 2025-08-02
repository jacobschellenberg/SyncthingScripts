@echo off
REM === Configuration ===
set API_KEY=REPLACE_WITH_YOUR_API_KEY
set HOST=http://127.0.0.1:8384
set RATE_IN=500
set RATE_OUT=500

REM === Apply rate limits ===
curl -X PATCH ^
  -H "X-API-Key: %API_KEY%" ^
  -H "Content-Type: application/json" ^
  -d "{\"rateLimitIn\":%RATE_IN%,\"rateLimitOut\":%RATE_OUT%}" ^
  %HOST%/rest/system/config
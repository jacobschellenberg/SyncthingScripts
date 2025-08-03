#!/bin/bash

apiKey="YOUR_API_KEY_HERE"
baseUrl="http://127.0.0.1:8384"

# Custom speed limits (0 = unlimited)
maxSend=1000
maxRecv=1000

curl -skL -H "X-API-Key: $apiKey" "$baseUrl/rest/system/config" | \
jq --argjson send "$maxSend" --argjson recv "$maxRecv" \
  '.options.maxSendKbps = $send | .options.maxRecvKbps = $recv' | \
curl -skL -X POST \
  -H "X-API-Key: $apiKey" \
  -H "Content-Type: application/json" \
  --data-binary @- \
  "$baseUrl/rest/system/config"
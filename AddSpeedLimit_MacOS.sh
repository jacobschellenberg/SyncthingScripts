#!/bin/bash

configPath="$(dirname "$0")/Config.json"
apiKey=$(jq -r '.apiKey' "$configPath")
baseUrl=$(jq -r '.host' "$configPath")
maxSend=$(jq -r '.rateOut' "$configPath")
maxRecv=$(jq -r '.rateIn' "$configPath")

curl -skL -H "X-API-Key: $apiKey" "$baseUrl/rest/system/config" | \
jq --argjson send "$maxSend" --argjson recv "$maxRecv" \
  '.options.maxSendKbps = $send | .options.maxRecvKbps = $recv' | \
curl -skL -X POST \
  -H "X-API-Key: $apiKey" \
  -H "Content-Type: application/json" \
  --data-binary @- \
  "$baseUrl/rest/system/config"
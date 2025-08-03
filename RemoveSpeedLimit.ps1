$apiKey = "YOUR_API_KEY_HERE"
$baseUrl = "http://127.0.0.1:8384"

# Custom speed limits (0 = unlimited)
$maxSend = 0
$maxRecv = 0

# Fetch config
$response = Invoke-RestMethod -Uri "$baseUrl/rest/system/config" -Headers @{ "X-API-Key" = $apiKey }

# Modify send/receive rates
$response.options.maxSendKbps = $maxSend
$response.options.maxRecvKbps = $maxRecv

# Convert object to JSON string (no indentation for compactness)
$json = $response | ConvertTo-Json -Depth 100 -Compress

# Send updated config
Invoke-RestMethod -Method Post -Uri "$baseUrl/rest/system/config" `
  -Headers @{ "X-API-Key" = $apiKey; "Content-Type" = "application/json" } `
  -Body $json
# AddSpeedLimit.ps1

$apiKey = 'REPLACE_WITH_YOUR_API_KEY'
$host = 'http://127.0.0.1:8384'
$rateIn = 500000
$rateOut = 500000

$configJson = '_temp_syncthing_config.json'
$modifiedJson = '_temp_modified_config.json'

Write-Host "Fetching current Syncthing system config..."
Invoke-RestMethod -Uri "$host/rest/system/config" -Headers @{ "X-API-Key" = $apiKey } -OutFile $configJson

Write-Host "Modifying system config to apply global rate limits..."
$json = Get-Content $configJson -Raw | ConvertFrom-Json
$json.options.maxRecvKbps = $rateIn
$json.options.maxSendKbps = $rateOut
$json | ConvertTo-Json -Depth 10 | Set-Content -Encoding UTF8 $modifiedJson

Write-Host "Sending updated system config back to Syncthing..."
Invoke-RestMethod -Uri "$host/rest/system/config" -Method Put -Headers @{ "X-API-Key" = $apiKey; "Content-Type" = "application/json" } -InFile $modifiedJson

Write-Host "Done."

Remove-Item $configJson, $modifiedJson -Force
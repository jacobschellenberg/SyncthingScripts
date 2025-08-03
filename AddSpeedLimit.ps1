# AddSpeedLimit.ps1

$config = Get-Content "$PSScriptRoot\Config.json" -Raw | ConvertFrom-Json
$apiKey = $config.apiKey
$host = $config.host
$rateIn = $config.rateIn
$rateOut = $config.rateOut

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
# AddSpeedLimit.ps1

$config = Get-Content "$PSScriptRoot\Config.json" -Raw | ConvertFrom-Json
$apiKey = $config.apiKey
$baseUrl = $config.host
$rateIn = $config.rateIn
$rateOut = $config.rateOut

$headers = @{ "X-API-Key" = $apiKey }
try {
    $csrf = Invoke-RestMethod -Uri "$baseUrl/rest/system/csrf" -Headers $headers -ErrorAction Stop
    $headers["X-CSRF-Token"] = $csrf.csrf
} catch {
    Write-Host "No CSRF token required or failed to retrieve. Continuing with API key only."
}

$configJson = '_temp_syncthing_config.json'
$modifiedJson = '_temp_modified_config.json'

Write-Host "Fetching current Syncthing system config..."
Invoke-RestMethod -Uri "$baseUrl/rest/system/config" -Headers $headers -OutFile $configJson

Write-Host "Modifying system config to apply global rate limits..."
$json = Get-Content $configJson -Raw | ConvertFrom-Json
$json.options.maxRecvKbps = $rateIn
$json.options.maxSendKbps = $rateOut
$json | ConvertTo-Json -Depth 10 | Set-Content -Encoding UTF8 $modifiedJson

Write-Host "Sending updated system config back to Syncthing..."
Invoke-RestMethod -Uri "$baseUrl/rest/system/config" -Method Put -Headers $headers -ContentType 'application/json' -InFile $modifiedJson

Write-Host "Done."

Remove-Item $configJson, $modifiedJson -Force
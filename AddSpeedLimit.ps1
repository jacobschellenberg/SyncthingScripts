# AddSpeedLimit.ps1

$config = Get-Content "$PSScriptRoot\Config.json" -Raw | ConvertFrom-Json
$apiKey = $config.apiKey
$baseUrl = $config.host
$rateIn = $config.rateIn
$rateOut = $config.rateOut

$headers = @{
    "X-API-Key" = $apiKey
    "Accept" = "application/json"
}

$configJson = '_temp_syncthing_config.json'
$modifiedJson = '_temp_modified_config.json'

Write-Host "Fetching current Syncthing system config..."
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/rest/system/config" -Headers $headers -UseBasicParsing
    $response | ConvertTo-Json -Depth 10 | Set-Content -Encoding UTF8 $configJson
} catch {
    Write-Error "Failed to fetch config: $_"
    return
}

Write-Host "Modifying system config to apply global rate limits..."
try {
    $json = Get-Content $configJson -Raw | ConvertFrom-Json
    $json.options.maxRecvKbps = $rateIn
    $json.options.maxSendKbps = $rateOut
    $json | ConvertTo-Json -Depth 10 | Set-Content -Encoding UTF8 $modifiedJson
} catch {
    Write-Error "Failed to modify config: $_"
    return
}

Write-Host "Sending updated system config back to Syncthing..."
try {
    Invoke-RestMethod -Uri "$baseUrl/rest/system/config" -Method Put -Headers $headers -ContentType 'application/json' -InFile $modifiedJson -UseBasicParsing
    Write-Host "Done."
} catch {
    Write-Error "Failed to send config: $_"
}

Remove-Item $configJson -Force -ErrorAction SilentlyContinue
Remove-Item $modifiedJson -Force -ErrorAction SilentlyContinue
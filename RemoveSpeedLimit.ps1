# RemoveSpeedLimit.ps1


$config = Get-Content "$PSScriptRoot\Config.json" -Raw | ConvertFrom-Json
$apiKey = $config.apiKey
$baseUrl = $config.host
$configJson = '_temp_syncthing_config.json'
$modifiedJson = '_temp_modified_config.json'

$headers = @{ "X-API-Key" = $apiKey }
try {
    $csrf = Invoke-RestMethod -Uri "$baseUrl/rest/system/csrf" -Headers $headers -ErrorAction Stop
    $headers["X-CSRF-Token"] = $csrf.csrf
} catch {
    Write-Host "No CSRF token required or failed to retrieve. Continuing with API key only."
}

Write-Host "Fetching current Syncthing config..."
Invoke-RestMethod -Uri "$baseUrl/rest/system/config" -Headers $headers -OutFile $configJson

Write-Host "Modifying config to remove rate limits..."
$json = Get-Content $configJson -Raw | ConvertFrom-Json
$json.options.maxSendKbps = 0
$json.options.maxRecvKbps = 0
$json | ConvertTo-Json -Depth 10 | Set-Content -Encoding UTF8 $modifiedJson

Write-Host "Sending updated config back to Syncthing..."
Invoke-RestMethod -Uri "$baseUrl/rest/system/config" -Method Put -Headers $headers -ContentType 'application/json' -InFile $modifiedJson

Write-Host "Done."

Remove-Item $configJson, $modifiedJson -Force
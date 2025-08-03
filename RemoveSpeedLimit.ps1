<file name=AddSpeedLimit.ps1 path=/Users/jacobschellenberg/Offline Storage/Development/SyncthingScripts/AddSpeedLimit.ps1># AddSpeedLimit.ps1

$config = Get-Content "$PSScriptRoot\Config.json" -Raw | ConvertFrom-Json
$apiKey = $config.apiKey
$baseUrl = $config.host
$configJson = '_temp_syncthing_config.json'
$modifiedJson = '_temp_modified_config.json'

$headers = @{
    "X-API-Key" = $apiKey
    "Accept" = "application/json"
}

Write-Host "Fetching current Syncthing config..."
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/rest/system/config" -Headers $headers -UseBasicParsing
    $response | ConvertTo-Json -Depth 10 | Set-Content -Encoding UTF8 $configJson
} catch {
    if ($_.Exception.Response -and $_.Exception.Response.StatusCode -eq 403) {
        Write-Host "CSRF error encountered. Trying with CSRF token..."
        $csrf = Invoke-RestMethod -Uri "$baseUrl/rest/system/csrf" -Headers @{ "X-API-Key" = $apiKey } -UseBasicParsing
        $headers["X-CSRF-Token"] = $csrf.csrf
        $response = Invoke-RestMethod -Uri "$baseUrl/rest/system/config" -Headers $headers -UseBasicParsing
        $response | ConvertTo-Json -Depth 10 | Set-Content -Encoding UTF8 $configJson
    } else {
        Write-Error "Failed to fetch config: $_"
        return
    }
}

Write-Host "Modifying config to add rate limits..."
try {
    $json = Get-Content $configJson -Raw | ConvertFrom-Json
    if (-not $json.options) {
        throw "Config JSON does not contain an 'options' object."
    }
    $json.options.maxSendKbps = 500
    $json.options.maxRecvKbps = 500
    $json | ConvertTo-Json -Depth 10 | Set-Content -Encoding UTF8 $modifiedJson
} catch {
    Write-Error "Failed to modify config: $_"
    return
}

Write-Host "Sending updated config back to Syncthing..."
try {
    Invoke-RestMethod -Uri "$baseUrl/rest/system/config" -Method Put -Headers $headers -ContentType 'application/json' -InFile $modifiedJson -UseBasicParsing
    Write-Host "Done."
} catch {
    Write-Error "Failed to send config: $_"
}

# Safe deletion
Remove-Item $configJson -Force -ErrorAction SilentlyContinue
Remove-Item $modifiedJson -Force -ErrorAction SilentlyContinue</file>
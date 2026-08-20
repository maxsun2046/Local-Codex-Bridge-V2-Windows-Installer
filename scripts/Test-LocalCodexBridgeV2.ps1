[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [int]$BridgePort = 4115,

    [Parameter(Mandatory = $false)]
    [int]$TimeoutSeconds = 5
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Test-Endpoint {
    param(
        [string]$Name,
        [string]$Url
    )

    try {
        $response = Invoke-WebRequest -UseBasicParsing -Uri $Url -TimeoutSec $TimeoutSeconds
    } catch {
        throw "${Name} failed at ${Url}: $($_.Exception.Message)"
    }

    if ($response.StatusCode -ne 200) {
        throw "$Name returned HTTP $($response.StatusCode) at $Url"
    }

    Write-Host "$Name OK: $Url"
}

Test-Endpoint -Name "health" -Url "http://127.0.0.1:$BridgePort/health"
Test-Endpoint -Name "readyz" -Url "http://127.0.0.1:$BridgePort/readyz"

Write-Host "Local HTTP checks passed. Now validate from ChatGPT by calling codex_threads and confirming codex_git exposure."

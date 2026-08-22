[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [int]$BridgePort = 4115,

    [Parameter(Mandatory = $false)]
    [int]$TimeoutSeconds = 5,

    [Parameter(Mandatory = $false)]
    [string]$BrokerStateDir = "",

    [Parameter(Mandatory = $false)]
    [switch]$RunTurnProbe
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

function Test-BrokerHealth {
    param(
        [string]$StateDir
    )

    if ([string]::IsNullOrWhiteSpace($StateDir) -or -not (Test-Path -LiteralPath $StateDir)) {
        Write-Host "Broker health check SKIPPED: no broker state directory configured (-BrokerStateDir)."
        return
    }

    $tokenFile = Join-Path $StateDir "token.txt"
    $portFile = Join-Path $StateDir "port.json"

    if (-not (Test-Path -LiteralPath $tokenFile) -or -not (Test-Path -LiteralPath $portFile)) {
        Write-Host "Broker health check SKIPPED: broker credential state incomplete."
        return
    }

    $token = [IO.File]::ReadAllText($tokenFile, [Text.Encoding]::UTF8).Trim()
    if ([string]::IsNullOrWhiteSpace($token)) {
        throw "Broker token file is empty."
    }

    $port = (Get-Content -Raw -LiteralPath $portFile | ConvertFrom-Json).port
    $headers = @{ Authorization = "Bearer $token" }
    $result = Invoke-RestMethod -Method Get -Uri ("http://127.0.0.1:{0}/health" -f $port) -Headers $headers -TimeoutSec $TimeoutSeconds
    if ($result.ok -ne $true) {
        throw "Broker health check returned ok=false."
    }
    Write-Host "Broker health OK: pid=$($result.pid)"
}

Test-Endpoint -Name "health" -Url "http://127.0.0.1:$BridgePort/health"
Test-Endpoint -Name "readyz" -Url "http://127.0.0.1:$BridgePort/readyz"

Test-BrokerHealth -StateDir $BrokerStateDir

if ($RunTurnProbe) {
    Write-Host "Turn probe not executed: requires a tunnel/MCP client context. Run a read-only turn from ChatGPT or codex CLI manually."
}

Write-Host "Local HTTP checks passed. Now validate from ChatGPT by calling codex_threads and confirming codex_git exposure."

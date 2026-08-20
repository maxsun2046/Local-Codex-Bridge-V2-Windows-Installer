[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $false)]
    [string]$BridgeRoot = "C:\Tools\LocalCodexBridgeV2",

    [Parameter(Mandatory = $false)]
    [string]$ConfigDirectoryName = "config-local"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$sourceConfig = Join-Path $repoRoot "config"
$targetConfig = Join-Path $BridgeRoot $ConfigDirectoryName

if ($PSCmdlet.ShouldProcess($targetConfig, "Create local config directory and copy templates")) {
    New-Item -ItemType Directory -Path $targetConfig -Force | Out-Null
    Get-ChildItem -Path $sourceConfig -Filter "*.template.json" -File | ForEach-Object {
        $targetName = $_.Name -replace "\.template\.json$", ".local.json"
        $targetPath = Join-Path $targetConfig $targetName
        if (-not (Test-Path -LiteralPath $targetPath)) {
            Copy-Item -LiteralPath $_.FullName -Destination $targetPath
        }
    }
}

Write-Host "Local templates are in: $targetConfig"
Write-Host "Edit local copies only. Do not commit filled config files."

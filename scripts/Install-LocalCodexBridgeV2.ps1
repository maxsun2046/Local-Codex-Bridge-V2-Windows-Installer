[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$BridgeRoot,

    [switch]$RunValidation,

    [int]$BridgePort = 4115
)

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot
$RepoRootFull = [System.IO.Path]::GetFullPath($RepoRoot).TrimEnd('\')
$BridgeRootFull = [System.IO.Path]::GetFullPath($BridgeRoot).TrimEnd('\')

if ($BridgeRootFull -eq $RepoRootFull) {
    throw "Refusing to install config into the public source repository itself."
}

$SourceConfig = Join-Path $RepoRootFull "config"
$TargetConfig = Join-Path $BridgeRootFull "config-local"
$BackupRoot = Join-Path $BridgeRootFull "backup"

if (-not (Test-Path -LiteralPath $SourceConfig)) {
    throw "Source config directory not found: $SourceConfig"
}

if (-not (Test-Path -LiteralPath $BridgeRootFull)) {
    New-Item -ItemType Directory -Force -Path $BridgeRootFull | Out-Null
}

if (Test-Path -LiteralPath $TargetConfig) {
    $Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $BackupPath = Join-Path $BackupRoot "config-local-$Timestamp"

    New-Item -ItemType Directory -Force -Path $BackupRoot | Out-Null
    Copy-Item -LiteralPath $TargetConfig -Destination $BackupPath -Recurse -Force

    Write-Host "Existing config backed up to:"
    Write-Host "  $BackupPath"
}

New-Item -ItemType Directory -Force -Path $TargetConfig | Out-Null

$Templates = @(
    "bridge.config.template.json",
    "git-allowlist.template.json",
    "mcp-profile.template.json",
    "tunnel-profile.template.json"
)

foreach ($Template in $Templates) {
    $Source = Join-Path $SourceConfig $Template

    if (-not (Test-Path -LiteralPath $Source)) {
        throw "Missing template: $Source"
    }

    $Destination = Join-Path $TargetConfig $Template
    Copy-Item -LiteralPath $Source -Destination $Destination -Force

    Write-Host "Installed template: $Destination"
}

Write-Host ""
Write-Host "Template installation completed."
Write-Host "This script does not install Bridge, Tunnel, or Codex binaries."

if ($RunValidation) {
    $ValidationScript = Join-Path $PSScriptRoot "Test-LocalCodexBridgeV2.ps1"

    if (-not (Test-Path -LiteralPath $ValidationScript)) {
        throw "Validation requested but script missing: $ValidationScript"
    }

    Write-Host ""
    Write-Host "Running post-install local validation..."

    & powershell.exe `
        -NoProfile `
        -ExecutionPolicy Bypass `
        -File $ValidationScript `
        -BridgePort $BridgePort

    if ($LASTEXITCODE -ne 0) {
        throw "Post-install validation failed."
    }

    Write-Host "Post-install validation: PASS"
}
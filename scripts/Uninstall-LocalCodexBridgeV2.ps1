[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $false)]
    [string]$TaskName = "LocalCodexBridgeV2Launcher",

    [Parameter(Mandatory = $false)]
    [string]$BridgeRoot = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$task = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($null -ne $task) {
    if ($PSCmdlet.ShouldProcess($TaskName, "Unregister scheduled task")) {
        Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
    }
    Write-Host "Removed scheduled task: $TaskName"
} else {
    Write-Host "Scheduled task not found: $TaskName"
}

if (-not [string]::IsNullOrWhiteSpace($BridgeRoot)) {
    Write-Host "No files removed from $BridgeRoot."
    Write-Host "Remove local config and binaries manually after backing up your own values."
}

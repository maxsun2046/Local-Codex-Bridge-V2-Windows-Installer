[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $false)]
    [string]$BridgeRoot = "C:\Tools\LocalCodexBridgeV2",

    [Parameter(Mandatory = $false)]
    [string]$TaskName = "LocalCodexBridgeV2Launcher",

    [Parameter(Mandatory = $false)]
    [int]$DelaySeconds = 20
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$launcherPath = Join-Path $BridgeRoot "Launcher.ps1"
if (-not (Test-Path -LiteralPath $launcherPath -PathType Leaf)) {
    throw "Launcher not found: $launcherPath"
}

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$launcherPath`""
$trigger = New-ScheduledTaskTrigger -AtLogOn
$trigger.Delay = "PT${DelaySeconds}S"
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType InteractiveToken -RunLevel Limited
$settings = New-ScheduledTaskSettingsSet -MultipleInstances IgnoreNew -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1) -ExecutionTimeLimit (New-TimeSpan -Seconds 0)

if ($PSCmdlet.ShouldProcess($TaskName, "Register scheduled task")) {
    Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force | Out-Null
}

Write-Host "Registered task: $TaskName"

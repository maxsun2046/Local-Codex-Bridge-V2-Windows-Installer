# Autostart

Use Windows Task Scheduler. Avoid depending on `vbs` or `wscript.exe`; enterprise policy can disable Windows Script Host.

## Recommended Task

```text
Task name: LocalCodexBridgeV2Launcher
Trigger: At logon
Delay: 20 seconds
Principal: current interactive user
Run level: least privilege
Multiple instances: ignore new
Restart: every 1 minute, up to 3 attempts
Execution time limit: none
```

Register it:

```powershell
.\scripts\Register-LocalCodexBridgeTask.ps1 -BridgeRoot "C:\Tools\LocalCodexBridgeV2"
```

The task runs:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "<BRIDGE_ROOT>\Launcher.ps1"
```

## Credential Context

Use the same Windows user that owns any DPAPI-protected credential or user-level environment variable. Do not run as `SYSTEM` if the Bridge needs user-scoped secrets.

## Rollback

```powershell
.\scripts\Uninstall-LocalCodexBridgeV2.ps1 -TaskName LocalCodexBridgeV2Launcher
```

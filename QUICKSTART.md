# Quickstart

This quickstart assumes you already have access to:

- A Local Codex Bridge V2 distribution or source checkout that you are allowed to use.
- A Secure MCP Tunnel client from its official or authorized source.
- A Codex app-server installation.
- PowerShell on Windows.

## 1. Choose Local Paths

Use generic, local paths. Example:

```powershell
$BridgeRoot = "C:\Tools\LocalCodexBridgeV2"
$TunnelClientPath = "C:\Tools\SecureMcpTunnel\tunnel-client.exe"
$CodexPath = "C:\Tools\Codex\codex.exe"
```

## 2. Copy Templates

```powershell
.\scripts\Install-LocalCodexBridgeV2.ps1 -BridgeRoot "C:\Tools\LocalCodexBridgeV2"
```

Edit the generated files under `C:\Tools\LocalCodexBridgeV2\config-local`.

## 3. Fill Required Fields

Fill in:

- Your own tunnel endpoint and profile name.
- Your own control plane API key or credential reference.
- Your own Codex path and ports.
- Your own Git allowlist path if enabling `codex_git`.

Do not paste real secrets back into this repository.

## 4. Register Autostart

```powershell
.\scripts\Register-LocalCodexBridgeTask.ps1 -BridgeRoot "C:\Tools\LocalCodexBridgeV2"
```

## 5. Validate

```powershell
.\scripts\Test-LocalCodexBridgeV2.ps1 -BridgePort 4115
```

Then validate from ChatGPT through Secure MCP Tunnel:

```text
Call codex_threads.
Confirm whether codex_git is visible.
If codex_git is visible, run a read-only Git status check inside an allowlisted repository.
```

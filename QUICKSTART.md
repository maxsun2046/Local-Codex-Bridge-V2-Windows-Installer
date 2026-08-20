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

<!-- ZERO_TO_WORKING_V010 -->

## Zero-to-Working Checklist

### 1. Prerequisites

You need:

- Windows PowerShell 5.1 or PowerShell 7+
- Git for Windows
- a working Codex installation/runtime
- your authorized Local Codex Bridge distribution
- your authorized Secure MCP Tunnel distribution
- ChatGPT access capable of using the MCP connection you configure

GitHub CLI is optional for normal Bridge operation. It is useful only for
repository maintenance and release workflows.

Verify the basics:

```powershell
git --version
codex --version
```

### 2. Choose Generic Local Paths

Example only:

```powershell
$BridgeRoot = "C:\Tools\LocalCodexBridgeV2"
$TunnelClientPath = "C:\Tools\SecureMcpTunnel\tunnel-client.exe"
$CodexPath = "C:\Tools\Codex\codex.exe"
```

Do not copy another person's Windows username, repository paths, tunnel profile,
tokens, ports, or credentials.

Read `docs/PLACEHOLDERS.md` before editing templates.

### 3. Install Sanitized Templates

From this repository:

```powershell
.\scripts\Install-LocalCodexBridgeV2.ps1 `
    -BridgeRoot "C:\Tools\LocalCodexBridgeV2"
```

If local config already exists, the installer backs it up before overwrite.

### 4. Fill Local-Only Values

Edit the copied files under:

```text
<BridgeRoot>\config-local\
```

Never put real credentials back into this public repository.

### 5. Start Bridge and Tunnel

Use the launch method supplied by your own authorized Bridge/Tunnel
distribution.

Do not assume a tunnel being online means the Bridge is online.

### 6. Test Local Bridge Health

Example:

```powershell
.\scripts\Test-LocalCodexBridgeV2.ps1 -BridgePort 4115
```

Use the real port from your local configuration.

Expected local proof:

```text
HTTP /readyz -> 200
```

### 7. Test From ChatGPT

The decisive validation is from the ChatGPT side.

At minimum confirm that a core Bridge tool such as:

```text
codex_threads
```

is callable.

If you enabled the optional Git broker, separately confirm:

```text
codex_git
```

Do not treat absence of `codex_git` as proof that the core Bridge is broken.

### 8. Configure Autostart Only After Manual Validation

Run the Bridge manually first.

Only after manual launch, local `/readyz`, and ChatGPT MCP validation all pass
should you register the Task Scheduler launcher.

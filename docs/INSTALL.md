# Install

## Prerequisites

Install these from their official or authorized source:

- Local Codex Bridge V2.
- Secure MCP Tunnel client.
- Codex app-server.
- Git for Windows, if you want `codex_git`.
- GitHub CLI, only if you plan to publish your own fork or scripts.

This repository intentionally does not redistribute those binaries or third-party source trees.

## Recommended Paths

Use paths like:

```powershell
C:\Tools\LocalCodexBridgeV2
C:\Tools\SecureMcpTunnel\tunnel-client.exe
C:\Tools\Codex\codex.exe
```

Avoid paths under synced notes, personal knowledge bases, or unrelated repositories.

## Install Templates

From this repository:

```powershell
.\scripts\Install-LocalCodexBridgeV2.ps1 -BridgeRoot "C:\Tools\LocalCodexBridgeV2"
```

The script creates:

```text
C:\Tools\LocalCodexBridgeV2\config-local
```

Edit only your local copies. Leave `config/*.template.json` sanitized.

## Configure

1. Fill `bridge.config.local.json` with `<BRIDGE_ROOT>`, `<CODEX_PATH>`, `<MCP_ENDPOINT>`, ports, and your credential strategy.
2. Configure the Secure MCP Tunnel profile from [TUNNEL.md](TUNNEL.md).
3. Configure MCP commands from [MCP-CONFIG.md](MCP-CONFIG.md).
4. Configure autostart from [AUTOSTART.md](AUTOSTART.md).
5. Optionally enable `codex_git` from [GIT-BROKER.md](GIT-BROKER.md).

## Success Criteria

- Bridge health endpoint returns 200.
- Bridge ready endpoint returns 200.
- ChatGPT can call `codex_threads` through Secure MCP Tunnel.
- If enabled, ChatGPT can see `codex_git` and read from an allowlisted repository.

<!-- SAFE_UPDATE_V010 -->

## Safe Install and Update Behavior

The public installer helper is intentionally conservative.

When copying sanitized templates into an existing Bridge installation:

1. it never installs Bridge/Tunnel/Codex binaries;
2. it refuses to treat this public repository itself as the Bridge root;
3. existing local configuration is backed up before overwrite;
4. public templates are copied only into `config-local`;
5. secrets remain the operator's responsibility;
6. optional validation may run after installation.

A backup directory uses a timestamp similar to:

```text
<BridgeRoot>\backup\config-local-20260820-163500\
```

If a new configuration fails, restore the previous files from the latest backup.

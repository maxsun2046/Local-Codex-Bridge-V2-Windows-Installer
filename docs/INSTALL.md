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

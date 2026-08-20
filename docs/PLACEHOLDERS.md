# Placeholder Reference

This repository is intentionally sanitized.

Values enclosed in angle brackets are placeholders and must be replaced with
values appropriate for your own Windows machine.

## Core Paths

| Placeholder | Meaning | Example only |
|---|---|---|
| `<BRIDGE_ROOT>` | Local Codex Bridge installation root | `C:\Tools\LocalCodexBridgeV2` |
| `<TUNNEL_CLIENT_PATH>` | Secure MCP Tunnel executable | `C:\Tools\SecureMcpTunnel\tunnel-client.exe` |
| `<CODEX_PATH>` | Codex executable/runtime | `C:\Tools\Codex\codex.exe` |
| `<GIT_ALLOWLIST_PATH>` | Local Git broker allowlist | `C:\Tools\LocalCodexBridgeV2\config-local\git-allowlist.json` |

## Runtime Values

| Placeholder | Meaning |
|---|---|
| `<BRIDGE_PORT>` | Local HTTP port used by the Bridge |
| `<CODEX_APP_SERVER_PORT>` | Local Codex app-server port, if required |
| `<PROFILE_NAME>` | Your Secure MCP Tunnel profile name |
| `<MCP_ENDPOINT>` | MCP endpoint used by your tunnel workflow |

## Sensitive Values

The following must remain private and must never be committed:

| Placeholder | Meaning |
|---|---|
| `<CONTROL_PLANE_API_KEY>` | Tunnel/control-plane credential |
| any real bearer token | Authentication secret |
| any GitHub token | GitHub credential |
| any DPAPI blob | Windows-user-bound encrypted credential |
| any cookie/session value | Private authenticated session material |

## Repository Allowlist

Do not copy somebody else's repository paths.

Use only repositories you explicitly want the Git broker to access.

Example:

```json
{
  "repositories": [
    "C:\\Projects\\ExampleRepo"
  ]
}
```

The allowlist is a security boundary, not a convenience list.

## DPAPI Warning

Windows DPAPI credentials can be bound to the Windows user that created them.

A credential encrypted interactively as one user may fail when the Bridge or
tunnel runs as another Windows account, SYSTEM, a service identity, a sandbox
identity, or a scheduled task with a different logon context.

Keep authentication and autostart user context consistent.
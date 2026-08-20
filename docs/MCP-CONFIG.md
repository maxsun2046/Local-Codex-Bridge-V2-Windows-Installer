# MCP Config

The Secure MCP Tunnel profile should launch Local Codex Bridge V2 through an MCP command chain:

```text
Secure MCP Tunnel profile -> mcp.commands -> Launcher.ps1 -> Local Codex Bridge -> Codex app-server
```

Use [config/mcp-profile.template.json](../config/mcp-profile.template.json) as a shape reference only. Copy it to your tunnel client's private profile location, then replace:

- `<PROFILE_NAME>`
- `<BRIDGE_ROOT>`
- `<MCP_ENDPOINT>`

Do not commit your edited profile.

## Required Local Environment

The command should point to:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "<BRIDGE_ROOT>\Launcher.ps1"
```

If your Bridge uses a local config path, set it outside this repository:

```powershell
$env:LOCAL_CODEX_BRIDGE_CONFIG = "C:\Tools\LocalCodexBridgeV2\config-local\bridge.config.local.json"
```

## Common Mistakes

- Profile still points to an old V1 launcher.
- Profile launches a tray helper but not the Bridge process.
- Profile omits the environment needed to locate the local config.
- A real endpoint or token was pasted into a tracked template.

<!-- MCP_BOUNDARY_V010 -->

## MCP Boundary Checks

A reachable public tunnel URL is not enough to prove that the MCP route is
correct.

Validate the layers independently:

```text
ChatGPT
  -> tunnel endpoint
  -> MCP route
  -> Bridge
  -> Codex app-server
```

An HTTP `404` during an MCP/SSE probe usually means the request reached an HTTP
server but the expected MCP route/path is wrong or is being handled by the wrong
component. It is different from a connection-refused error.

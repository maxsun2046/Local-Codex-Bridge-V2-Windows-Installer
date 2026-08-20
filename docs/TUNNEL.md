# Secure MCP Tunnel

Install the tunnel client from its official or authorized distribution. Do not copy a private tunnel binary, profile directory, cached login, DPAPI blob, or credential store from another Windows user.

## Template

Use [config/tunnel-profile.template.json](../config/tunnel-profile.template.json) as a sanitized reference. Required replacements:

- `<PROFILE_NAME>`
- `<TUNNEL_CLIENT_PATH>`
- `<MCP_ENDPOINT>`
- `<BRIDGE_ROOT>`
- `<CONTROL_PLANE_API_KEY>` or your own credential-store reference

The API key must be supplied by the user. This repository must never contain a real key.

## Verification

Validate both layers:

```powershell
.\scripts\Test-LocalCodexBridgeV2.ps1 -BridgePort 4115
```

Then use ChatGPT through the tunnel to call `codex_threads`. Health endpoints alone do not prove the end-to-end MCP path works.

<!-- TUNNEL_BOUNDARY_V010 -->

## Tunnel Validation Boundary

Tunnel status proves only the tunnel layer.

It does **not** prove that:

- Local Codex Bridge is ready;
- `/readyz` returns HTTP 200;
- the MCP route points to the correct local port;
- Codex app-server is available;
- Git broker configuration is valid.

Always pair tunnel validation with a direct local Bridge health check and an
actual ChatGPT MCP tool call.

If your tunnel stores credentials with Windows DPAPI, run it in the same
Windows user context that created those credentials unless your tunnel
distribution explicitly supports another model.

# Security Policy

## Never Commit

Do not commit:

- Real API keys, control plane keys, OAuth tokens, GitHub tokens, PATs, or session cookies.
- DPAPI blobs or Windows Credential Manager exports.
- Secure MCP Tunnel private profiles, profile secrets, or private endpoints.
- Private keys, certificates, `.env` files, browser state, or credential caches.
- Personal Windows usernames or user-profile directory paths.
- Internal network addresses.
- Complete private repository allowlists.

## Allowed Public Values

The following are safe when used as placeholders or generic examples:

- Placeholder strings such as `<CONTROL_PLANE_API_KEY>`.
- Generic local paths such as `C:\Tools\LocalCodexBridgeV2`.
- Variable names such as `CONTROL_PLANE_API_KEY`.
- Documentation that explains where a user must provide their own secret.

## Before Publishing

Run:

```powershell
.\scripts\Test-Repository.ps1
.\tests\Test-Repository.ps1
```

Treat every finding as blocking unless you confirm it is only a placeholder or detection rule string.

## Secret Rotation

If a real secret is ever committed, remove it from history and rotate it immediately at the issuing service. Deleting the line in a later commit is not enough.

# Troubleshooting

## 404 or Missing Tools

Check in this order:

1. Secure MCP Tunnel client is running.
2. Tunnel profile points to the current MCP command.
3. Local Codex Bridge process is running.
4. `/health` returns 200.
5. `/readyz` returns 200.
6. ChatGPT can call `codex_threads`.

Do not start by changing the Git broker allowlist. A 404 usually means the tunnel, profile, Bridge, or runtime path is broken.

## Health Passes but ChatGPT Fails

`/health` and `/readyz` prove only local HTTP readiness. They do not prove ChatGPT can reach the MCP tools through Secure MCP Tunnel.

Validate from ChatGPT:

```text
Call codex_threads.
Confirm whether codex_git is exposed.
```

If `codex_threads` works but `codex_git` does not, focus on Git broker configuration and allowlist paths.

## Runtime Stopped

Check the Bridge logs and confirm the Codex app-server path and port:

```powershell
Test-Path "C:\Tools\Codex\codex.exe"
.\scripts\Test-LocalCodexBridgeV2.ps1 -BridgePort 4115
```

Restart only the failed layer. Avoid reinstalling all components before identifying which layer stopped.

## wscript Policy

If `.vbs` or Startup shortcuts fail, register a Task Scheduler task that directly calls PowerShell. See [AUTOSTART.md](AUTOSTART.md).

## DPAPI or Credential Context

DPAPI-protected data is tied to the Windows user context. If the scheduled task runs under a different user, the Bridge may start but fail to read the key.

Check:

```powershell
whoami
$env:USERNAME
```

Then confirm the same user created the credential and owns the scheduled task.

## Git Broker Allowlist

Symptoms:

```text
Repository cwd is not allowlisted
```

Actions:

- Confirm whether the repository should be accessible to `codex_git`.
- Add only the minimum required repository path.
- Use system Git for one-time public documentation maintenance if the current repo should not be allowlisted.

Do not copy another user's allowlist.

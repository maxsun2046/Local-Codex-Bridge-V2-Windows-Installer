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

<!-- FIELD_FAILURES_V010 -->

## Field-Proven Failure Patterns

### MCP/SSE probe returns HTTP 404

Interpretation:

- network connectivity exists;
- an HTTP server answered;
- the requested MCP/SSE route is probably wrong, missing, or mapped to the wrong
  local component.

### Tunnel is alive but ChatGPT cannot call Bridge tools

Check the layers independently:

1. local Bridge `/readyz`;
2. tunnel local target;
3. MCP endpoint/path;
4. ChatGPT tool discovery;
5. Codex app-server availability.

### Git broker is alive but Bridge is not

The Git broker and Bridge are separate processes/layers.

Broker health cannot substitute for HTTP 200 from `/readyz` or a successful
core MCP tool call such as `codex_threads`.

### `wscript.exe` blocked

Managed Windows systems may block Windows Script Host.

Prefer a Task Scheduler action that directly launches PowerShell instead of
using `.vbs`/`wscript.exe`.

### `detected dubious ownership`

This can happen when files or `.git` were created by a sandbox/service identity
and later accessed by your normal Windows account.

For a repository you know and trust:

```powershell
git -c "safe.directory=C:\Path\To\TrustedRepo" status
```

Avoid blindly adding broad global safe-directory exceptions.

### `gh repo create --source .` says "not a git repository"

GitHub CLI may call Git internally without your temporary `safe.directory`
setting.

Workaround:

1. create the GitHub repository without `--source`;
2. add `origin` with your trusted Git invocation;
3. push explicitly.

### DPAPI credential works interactively but fails after autostart

Likely cause: Windows user-context mismatch.

Credentials encrypted by one user can fail under another user, SYSTEM, a
sandbox account, or another task identity.

### Health file exists but runtime is unavailable

A health-file path or saved URL is evidence of prior state, not proof of current
Bridge readiness.

Perform a live request:

```powershell
Invoke-WebRequest http://127.0.0.1:<BRIDGE_PORT>/readyz
```

Expected result: HTTP 200.

Then verify an actual MCP tool call from ChatGPT.

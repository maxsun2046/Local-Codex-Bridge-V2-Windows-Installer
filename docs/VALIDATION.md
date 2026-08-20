# Validation

Run both local checks and end-to-end ChatGPT checks.

## Local Repository Checks

```powershell
.\scripts\Test-Repository.ps1
.\tests\Test-Repository.ps1
```

These validate required files, JSON syntax, PowerShell syntax, relative Markdown links, and common secret patterns.

## Local Bridge Checks

```powershell
.\scripts\Test-LocalCodexBridgeV2.ps1 -BridgePort 4115
```

Expected:

- `/health` returns HTTP 200.
- `/readyz` returns HTTP 200.

## ChatGPT MCP Checks

From ChatGPT, through Secure MCP Tunnel:

```text
Call codex_threads.
```

Expected:

- The call returns real thread/session data or a normal empty result from the local Bridge.

Then confirm Git exposure:

```text
Check whether codex_git is available.
```

If `codex_git` is enabled, run a read-only check inside an allowlisted repository. If it is intentionally disabled, record that as the expected result.

## Autostart Checks

1. Restart Windows.
2. Log in as the target user.
3. Wait at least 60 seconds.
4. Do not manually start Bridge, Tunnel, or tray helpers.
5. Run local Bridge checks.
6. Run ChatGPT MCP checks.

Passing local health without passing `codex_threads` is not complete validation.

<!-- END_TO_END_VALIDATION_V010 -->

## End-to-End Acceptance Criteria

Do not mark the deployment successful until all applicable layers pass.

### Layer A - Local Bridge

```text
/readyz -> HTTP 200
```

### Layer B - ChatGPT MCP

A real call to a core tool such as `codex_threads` must succeed.

### Layer C - Optional Git Broker

If configured, confirm that `codex_git` is exposed and that a read-only
operation works only inside an explicitly allowlisted repository.

### Layer D - Reboot/Logon

If autostart is enabled:

1. reboot or sign out/in;
2. verify Bridge `/readyz`;
3. verify tunnel state;
4. verify ChatGPT MCP;
5. verify optional `codex_git`.

Do not accept Task Scheduler status, tunnel process existence, Git broker process
existence, a health URL file, or an open TCP port as end-to-end proof by
themselves.

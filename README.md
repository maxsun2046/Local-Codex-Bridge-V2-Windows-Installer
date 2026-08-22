# Local Codex Bridge V2 Windows Installer

Public Windows installation templates for Local Codex Bridge V2.

This repository does not include Local Codex Bridge binaries, Secure MCP Tunnel binaries, Codex binaries, private profiles, API keys, DPAPI blobs, cookies, GitHub tokens, or private repository allowlists. Use the upstream project or official distribution channel for each binary, then use these docs, templates, and scripts to configure your own Windows machine.

## Architecture

```text
ChatGPT -> Secure MCP Tunnel -> Local Codex Bridge -> Codex app-server
```

Optional Git support is a separate extension layer:

```text
codex_git -> Git broker -> allowlisted local Git repositories
```

Keep the Git broker optional. A working Bridge should expose core tools such as `codex_threads` even when `codex_git` is not enabled.

## Start Here

1. Read [QUICKSTART.md](QUICKSTART.md).
2. Follow [docs/INSTALL.md](docs/INSTALL.md).
3. Fill in local copies of the templates in [config](config).
4. Validate locally with [docs/VALIDATION.md](docs/VALIDATION.md).
5. Configure autostart with [docs/AUTOSTART.md](docs/AUTOSTART.md).

## Required User-Supplied Values

Replace placeholders with values from your own Windows computer and tunnel account:

- `<BRIDGE_ROOT>`
- `<TUNNEL_CLIENT_PATH>`
- `<PROFILE_NAME>`
- `<MCP_ENDPOINT>`
- `<CONTROL_PLANE_API_KEY>`
- `<GIT_ALLOWLIST_PATH>`
- `<CODEX_PATH>`
- `<CODEX_APP_SERVER_PORT>`
- `<BRIDGE_PORT>`

Example paths use `C:\Tools\...` only. Do not copy paths, tokens, profiles, or allowlists from another machine.

## What This Repo Installs

The scripts can create local config files from templates, check syntax, validate health endpoints, and register a Windows Task Scheduler entry that launches your local Bridge command.

The scripts do not download, vendor, or redistribute third-party binaries. If a component has license, source, or authentication requirements, install it from its own official source and record its local path in your private config.

## Repository Layout

- `config/`: sanitized JSON templates.
- `docs/`: installation, MCP, tunnel, autostart, Git broker, troubleshooting, and validation guides.
- `scripts/`: PowerShell helper scripts for install, task registration, validation, and uninstall.
- `tests/`: repository quality checks for generated templates.

## Security Boundary

Never commit real secrets. See [SECURITY.md](SECURITY.md) before filling in templates.

<!-- POST_RELEASE_AUDIT_V010 -->

## Validated Baseline

Supported/validated baseline: **Local Codex Bridge v2.1.2** custom V2 architecture
(Bridge + optional Git broker + Secure MCP Tunnel + Codex app-server).

Expected tool surface (exactly 8):

```text
codex_threads
codex_turn
codex_observe
codex_steer
codex_respond
codex_interrupt
codex_checkpoint
codex_git
```

This is an **unofficial community project**; it is not an OpenAI official
installer, product, support channel, or distribution of OpenAI software.

## Project Status and Scope

This is an **unofficial community project**. It is not an OpenAI official
installer, product, support channel, or distribution of OpenAI software.

The repository provides sanitized documentation, configuration templates,
validation guidance, and Windows helper scripts for this architecture:

```text
ChatGPT
   |
   v
Secure MCP Tunnel
   |
   v
Local Codex Bridge
   |
   v
Codex app-server
```

Optional local Git support adds another layer:

```text
codex_git -> Git broker -> explicitly allowlisted Git repositories
```

A healthy Bridge does not require `codex_git`. Core tools such as
`codex_threads` should work independently of the optional Git broker.

### Before You Start

Install each required binary from its own official, upstream, or otherwise
authorized distribution source. This repository intentionally does **not**
redistribute:

- Codex binaries
- Local Codex Bridge binaries
- Secure MCP Tunnel binaries
- private MCP/tunnel profiles
- API keys or control-plane credentials
- DPAPI-protected credential blobs
- cookies or GitHub tokens
- private Git repository allowlists

For a fresh installation, use this order:

1. [QUICKSTART.md](QUICKSTART.md)
2. [docs/PLACEHOLDERS.md](docs/PLACEHOLDERS.md)
3. [docs/INSTALL.md](docs/INSTALL.md)
4. [docs/MCP-CONFIG.md](docs/MCP-CONFIG.md)
5. [docs/TUNNEL.md](docs/TUNNEL.md)
6. [docs/AUTOSTART.md](docs/AUTOSTART.md)
7. [docs/VALIDATION.md](docs/VALIDATION.md)
8. [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

Do not treat a successful tunnel connection or a running Git broker as proof
that the Bridge itself is healthy. Validate `/readyz` and then validate the
actual MCP tools from ChatGPT.

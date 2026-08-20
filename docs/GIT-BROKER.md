# Git Broker

`codex_git` is optional. It should be exposed only when you want ChatGPT/Codex to perform Git operations through an allowlist.

## Model

```text
codex_git -> Git broker -> allowlisted repositories
```

The allowlist must be rebuilt on each Windows computer. Do not copy a personal allowlist from another machine.

## Template

Use [config/git-allowlist.template.json](../config/git-allowlist.template.json), copy it outside the repository, and replace the example path with repositories that exist locally.

Prefer read-only validation first:

```powershell
git status --short
```

If your PATH `git.exe` is a broker proxy and blocks the current repository, use system Git only for independent maintenance:

```powershell
& "C:\Program Files\Git\cmd\git.exe" status --short
```

Do not widen the allowlist just to make a temporary documentation repository easier to maintain.

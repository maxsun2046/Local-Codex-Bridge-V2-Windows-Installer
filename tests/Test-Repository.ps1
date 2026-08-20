Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

function Assert-True {
    param(
        [bool]$Condition,
        [string]$Message
    )
    if (-not $Condition) {
        throw $Message
    }
}

function Assert-FileExists {
    param([string]$RelativePath)
    $path = Join-Path $RepoRoot $RelativePath
    Assert-True (Test-Path -LiteralPath $path -PathType Leaf) "Missing required file: $RelativePath"
}

$requiredFiles = @(
    "README.md",
    "SECURITY.md",
    "LICENSE",
    ".gitignore",
    "QUICKSTART.md",
    "docs/INSTALL.md",
    "docs/MCP-CONFIG.md",
    "docs/TUNNEL.md",
    "docs/AUTOSTART.md",
    "docs/GIT-BROKER.md",
    "docs/TROUBLESHOOTING.md",
    "docs/VALIDATION.md",
    "config/bridge.config.template.json",
    "config/git-allowlist.template.json",
    "config/mcp-profile.template.json",
    "config/tunnel-profile.template.json",
    "scripts/Install-LocalCodexBridgeV2.ps1",
    "scripts/Register-LocalCodexBridgeTask.ps1",
    "scripts/Test-LocalCodexBridgeV2.ps1",
    "scripts/Uninstall-LocalCodexBridgeV2.ps1",
    "scripts/Test-Repository.ps1"
)

foreach ($file in $requiredFiles) {
    Assert-FileExists $file
}

Get-ChildItem -Path (Join-Path $RepoRoot "config") -Filter "*.json" -File | ForEach-Object {
    try {
        Get-Content -Raw -LiteralPath $_.FullName | ConvertFrom-Json | Out-Null
    } catch {
        throw "Invalid JSON: $($_.FullName): $($_.Exception.Message)"
    }
}

Get-ChildItem -Path (Join-Path $RepoRoot "scripts") -Filter "*.ps1" -File | ForEach-Object {
    $tokens = $null
    $parseErrors = $null
    [System.Management.Automation.Language.Parser]::ParseFile($_.FullName, [ref]$tokens, [ref]$parseErrors) | Out-Null
    if ($parseErrors.Count -gt 0) {
        $messages = $parseErrors | ForEach-Object { $_.Message }
        throw "PowerShell parse errors in $($_.FullName): $($messages -join '; ')"
    }
}

$secretPatterns = @(
    "ghp_[A-Za-z0-9_]{20,}",
    "github_pat_[A-Za-z0-9_]{20,}",
    "sk-[A-Za-z0-9]{20,}",
    "BEGIN (RSA |OPENSSH |EC |DSA )?PRIVATE KEY",
    "DPAPI.*[A-Za-z0-9+/]{80,}",
    "(?i)cookie\s*[:=]\s*`"?[^<\s`"][^\r\n]{8,}",
    "(?i)password\s*[:=]\s*`"?[^<\s`"][^\r\n]{8,}",
    "(?i)control_plane_api_key\s*[:=]\s*`"?[^<\s`"][^\r\n]{8,}",
    "C:\\Users\\[^\\\s]+",
    "[DE]:\\AI-Knowledge-Base",
    "(10|192\.168)\.\d{1,3}\.\d{1,3}\.\d{1,3}",
    "172\.(1[6-9]|2[0-9]|3[0-1])\.\d{1,3}\.\d{1,3}"
)

$textFiles = Get-ChildItem -Path $RepoRoot -Recurse -File |
    Where-Object { $_.FullName -notmatch "\\\.git\\" }

foreach ($file in $textFiles) {
    $content = Get-Content -Raw -LiteralPath $file.FullName
    foreach ($pattern in $secretPatterns) {
        if ($content -match $pattern) {
            throw "Potential secret or private value matched '$pattern' in $($file.FullName)"
        }
    }
}

$markdownFiles = Get-ChildItem -Path $RepoRoot -Recurse -Filter "*.md" -File
foreach ($file in $markdownFiles) {
    $content = Get-Content -Raw -LiteralPath $file.FullName
    $matches = [regex]::Matches($content, "\[[^\]]+\]\(([^)]+)\)")
    foreach ($match in $matches) {
        $target = $match.Groups[1].Value
        if ($target -match "^(https?://|mailto:|#)") {
            continue
        }
        if ($target -match "^[A-Za-z]:\\") {
            throw "Absolute local link found in $($file.FullName): $target"
        }
        $targetPath = $target.Split("#")[0]
        if ([string]::IsNullOrWhiteSpace($targetPath)) {
            continue
        }
        $resolved = Join-Path $file.DirectoryName $targetPath
        Assert-True (Test-Path -LiteralPath $resolved) "Broken relative link in $($file.FullName): $target"
    }
}

Write-Host "Repository validation passed."

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$testScript = Join-Path (Resolve-Path (Join-Path $PSScriptRoot "..")).Path "tests\Test-Repository.ps1"
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File $testScript
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

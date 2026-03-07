# Start Gitea on localhost:3000
$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "" -ForegroundColor Cyan
Write-Host "  GITEA LOCAL SETUP - localhost:3000                           " -ForegroundColor Cyan
Write-Host "" -ForegroundColor Cyan
Write-Host ""

# Check directory
if (-not (Test-Path "Makefile")) {
    Write-Host "ERROR: Makefile not found. Run from gitea-code directory" -ForegroundColor Red
    exit 1
}
Write-Host " Running in correct directory" -ForegroundColor Green

# Check tools
Write-Host ""
Write-Host "Checking required tools:" -ForegroundColor Cyan
$missing = 0
foreach ($tool in @("git", "go", "make", "node")) {
    Write-Host "  $tool... " -NoNewline
    try {
        $null = & $tool --version 2>$null
        Write-Host "OK" -ForegroundColor Green
    } catch {
        Write-Host "MISSING" -ForegroundColor Red
        $missing++
    }
}

Write-Host ""
if ($missing -gt 0) {
    Write-Host "ERROR: Missing required tools!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Install with Chocolatey (run as Administrator):" -ForegroundColor Yellow
    Write-Host "  choco install make golang nodejs --yes" -ForegroundColor White
    Write-Host "  npm install -g pnpm@10" -ForegroundColor White
    exit 1
}

Write-Host " All required tools installed" -ForegroundColor Green
Write-Host ""

# Build Gitea
if (-not (Test-Path "gitea.exe")) {
    Write-Host "Building Gitea..." -ForegroundColor Cyan
    Write-Host "  Running: go mod download"
    go mod download
    Write-Host "  Running: go build -o gitea.exe"
    go build -o gitea.exe
    Write-Host " Built gitea.exe" -ForegroundColor Green
} else {
    Write-Host " gitea.exe already exists" -ForegroundColor Green
}

# Create dirs
if (-not (Test-Path "custom\conf")) {
    New-Item -ItemType Directory -Path "custom\conf" -Force > $null
}

# Start
Write-Host ""
Write-Host "" -ForegroundColor Cyan
Write-Host "  STARTING GITEA WEB SERVER                                    " -ForegroundColor Cyan
Write-Host "" -ForegroundColor Cyan
Write-Host ""
Write-Host "   Starting: .\gitea.exe web" -ForegroundColor Yellow
Write-Host "   Open http://localhost:3000 in your browser" -ForegroundColor Yellow
Write-Host "   Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host ""

.\gitea.exe web

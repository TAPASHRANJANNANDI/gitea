# Gitea CI Local Testing Script
param([switch]$Quick, [switch]$All, [switch]$Backend, [switch]$Frontend)

if (-not (Test-Path "Makefile")) {
    Write-Host "ERROR: Makefile not found!" -ForegroundColor Red
    exit 1
}

$passed = 0
$failed = 0

Write-Host ""
Write-Host "Gitea CI Local Testing" -ForegroundColor Cyan
Write-Host ""

# Check tools
Write-Host "CHECKING TOOLS:" -ForegroundColor Cyan
foreach ($tool in @("git", "make", "go", "node", "pnpm")) {
    Write-Host "  $tool... " -NoNewline
    $null = & $tool --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "OK" -ForegroundColor Green
    } else {
        Write-Host "MISSING" -ForegroundColor Red
    }
}
Write-Host ""

if (-not $Backend -and -not $Frontend -and -not $All -and -not $Quick) { $All = $true }

# Run tests
if ($Backend -or $All) {
    Write-Host "BACKEND CHECKS:" -ForegroundColor Cyan
    foreach ($test in @("fmt-check", "lint-backend", "tidy-check", "security-check", "swagger-check")) {
        Write-Host "  $test... " -NoNewline
        $null = make $test 2>&1
        if ($LASTEXITCODE -eq 0) { 
            Write-Host "OK" -ForegroundColor Green
            $passed++
        } else { 
            Write-Host "FAIL" -ForegroundColor Red
            $failed++
        }
    }
    if (-not $Quick) {
        Write-Host "  test-backend... " -NoNewline
        $null = make test-backend 2>&1
        if ($LASTEXITCODE -eq 0) { 
            Write-Host "OK" -ForegroundColor Green
            $passed++
        } else { 
            Write-Host "FAIL" -ForegroundColor Red
            $failed++
        }
    }
    Write-Host ""
}

if ($Frontend -or $All) {
    Write-Host "FRONTEND CHECKS:" -ForegroundColor Cyan
    foreach ($test in @("lint-frontend", "test-frontend", "lockfile-check")) {
        Write-Host "  $test... " -NoNewline
        $null = make $test 2>&1
        if ($LASTEXITCODE -eq 0) { 
            Write-Host "OK" -ForegroundColor Green
            $passed++
        } else { 
            Write-Host "FAIL" -ForegroundColor Red
            $failed++
        }
    }
    Write-Host ""
}

if ($All -or $Quick) {
    Write-Host "CONTENT CHECKS:" -ForegroundColor Cyan
    foreach ($test in @("lint-spell", "lint-templates", "lint-yaml", "lint-json")) {
        Write-Host "  $test... " -NoNewline
        $null = make $test 2>&1
        if ($LASTEXITCODE -eq 0) { 
            Write-Host "OK" -ForegroundColor Green
            $passed++
        } else { 
            Write-Host "FAIL" -ForegroundColor Red
            $failed++
        }
    }
    Write-Host ""
}

Write-Host "SUMMARY:" -ForegroundColor Cyan
Write-Host "  Passed: $passed" -ForegroundColor Green
if ($failed -gt 0) { Write-Host "  Failed: $failed" -ForegroundColor Red }

if ($failed -eq 0) {
    Write-Host ""
    Write-Host "All checks passed!" -ForegroundColor Green
    exit 0
} else {
    Write-Host ""
    Write-Host "Some checks failed. Run: make fmt, make tidy, pnpm install" -ForegroundColor Red
    exit 1
}

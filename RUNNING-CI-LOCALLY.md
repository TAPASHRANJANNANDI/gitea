# Running CI Checks Locally

This guide explains how to run GitHub Actions CI checks on your local machine before pushing to GitHub.

## Quick Start

### On Windows (PowerShell)
```powershell
.\run-ci-local.ps1
```

### On macOS/Linux (Bash)
```bash
chmod +x run-ci-local.sh
./run-ci-local.sh
```

## Prerequisites

Before running CI checks, ensure you have these tools installed:

### Required Tools
- **make** - Build automation tool
  - Windows: `choco install make`
  - macOS: `brew install make`
  - Linux: `sudo apt-get install make`

- **git** - Version control
  - Windows: `git` (already installed with Git for Windows)
  - macOS: `brew install git`
  - Linux: `sudo apt-get install git`

### For Backend Tests
- **Go 1.26+**
  - Download from: https://golang.org/dl
  - Or use: `choco install golang` (Windows), `brew install go` (macOS)

### For Frontend Tests
- **Node.js 24+ LTS**
  - Download from: https://nodejs.org
  - Or use: `choco install nodejs` (Windows), `brew install node` (macOS)

- **pnpm 10+**
  ```bash
  npm install -g pnpm@10
  ```

## Manual CI Commands

If you prefer to run individual checks:

### Backend Checks

```bash
# Install dependencies
make deps-backend deps-tools

# Code formatting
make fmt-check            # Check formatting
make fmt                  # Fix formatting

# Linting
make lint-backend         # Run linter
make lint-go              # Go specific linting
make lint-editorconfig    # EditorConfig validation

# Dependency management
make tidy-check           # Check go.mod
make tidy                 # Fix go.mod

# Security
make security-check       # Vulnerability scan

# API Documentation
make swagger-check        # Generate API spec
make swagger-validate     # Validate API spec

# Testing
make test-backend         # Run Go unit tests
```

### Frontend Checks

```bash
# Install dependencies
make deps-frontend

# Linting
make lint-frontend        # Lint all frontend
make lint-js              # ESLint
make lint-js-fix          # Fix ESLint issues
make lint-css             # Stylelint

# Testing
make test-frontend        # Run Vitest

# Lockfile
make lockfile-check       # Check pnpm-lock.yaml
```

### Content Validation

```bash
# Spell checking
make lint-spell           # Find spelling errors

# Template validation
make lint-templates       # Validate Go templates

# Configuration
make lint-yaml            # Validate YAML files
make lint-json            # Validate JSON files
```

### All Checks

```bash
# Run all checks
make checks               # Backend checks only
make lint                 # All linting
make test                 # All tests

# Quick validation
make fmt-check            # Just formatting
make tidy-check          # Just dependencies
```

## Common Failure Fixes

### Code Formatting Fails
```bash
# Fix formatting automatically
make fmt
git add .
git commit -m "style: Format code"
```

### Go Module Issues
```bash
# Fix go.mod and go.sum
make tidy
git add go.mod go.sum
git commit -m "chore: Tidy go modules"
```

### Frontend Lockfile Issues
```bash
# Fix pnpm lockfile
pnpm install
git add pnpm-lock.yaml
git commit -m "chore: Update pnpm lockfile"
```

### Linting Issues
```bash
# Fix linting issues automatically
make lint-frontend-fix    # Frontend
make lint-backend         # Backend (if fixes available)
git add .
git commit -m "style: Fix linting issues"
```

### Spell Check Issues
```bash
# Review spelling errors
make lint-spell

# If legitimate, add to dictionary or fix manually
# No automatic fix available for most cases
```

### Security Vulnerabilities
```bash
# Check for vulnerabilities
make security-check

# Update vulnerable dependencies
go get -u <vulnerable-package>

# Or for frontend
pnpm update
```

## Script Options (Windows PowerShell)

```powershell
# Run all checks (default)
.\run-ci-local.ps1

# Backend checks only
.\run-ci-local.ps1 -Backend

# Frontend checks only
.\run-ci-local.ps1 -Frontend

# Quick checks (content validation only)
.\run-ci-local.ps1 -Quick

# All checks
.\run-ci-local.ps1 -All
```

## Script Options (macOS/Linux Bash)

The bash script runs all checks by default. To modify behavior, edit the script:

```bash
# Edit the script
nano run-ci-local.sh

# Or just run specific checks manually
make checks              # Basic backend checks
make lint               # All linting
make test               # All tests
```

## Workflow

### Before Committing
```bash
# 1. Run local tests
./run-ci-local.ps1            # Windows
./run-ci-local.sh             # macOS/Linux

# 2. Fix any failures
make fmt                       # Format code
make tidy                      # Tidy dependencies
make lint-*-fix                # Auto-fix linting

# 3. Verify fixes
./run-ci-local.ps1 -Quick      # Quick validation

# 4. Commit changes
git add .
git commit -m "feat: description"
```

### Before Pushing
```bash
# 1. Run full CI locally
./run-ci-local.ps1            # Full validation

# 2. If all pass
git push origin your-branch

# 3. Monitor GitHub Actions
# - Create or update PR
# - Watch Actions tab
# - Merge when all checks pass
```

## Understanding Output

### Success Examples
```
✓ PASSED: Backend format check
✓ PASSED: Backend linting
✓ PASSED: Frontend linting
✓ PASSED: Frontend testing
```

### Failure Examples
```
✗ FAILED: Backend format check
  → Fix: make fmt

✗ FAILED: Go module tidy check
  → Fix: make tidy

✗ FAILED: pnpm lockfile consistency
  → Fix: pnpm install
```

## Troubleshooting

### "make: command not found"
- Install make: See Prerequisites section
- Windows: Use `choco install make` or `scoop install make`

### "Cannot find pnpm"
- Install pnpm: `npm install -g pnpm@10`
- Or use: `npm install` if pnpm not required

### Tests timeout
- Some tests take longer on slow machines
- Increase timeout in Makefile if needed
- Or run tests selectively

### Go module cache issues
```bash
# Clear Go cache
go clean -modcache

# Reinitialize
go mod download
```

### pnpm cache issues
```bash
# Clear pnpm cache
pnpm store prune

# Reinstall
pnpm install --force
```

## Integration with IDE

### VS Code
```bash
# Run before saving
Terminal → Run Task → make deps-backend

# Or create custom task in .vscode/tasks.json
```

### JetBrains IDEs (GoLand, WebStorm, etc.)
```bash
# Run tests through IDE
Tools → Run External Tool → Make
```

## CI in GitHub Actions

Once you push code:

1. GitHub automatically triggers `.github/workflows/ci.yml`
2. The same checks run in cloud
3. Results appear in PR status
4. Can be set as required for merging

### View Results
- GitHub PR page → "Checks" section
- Click "Details" to see live logs
- Fix issues and push again

## Performance Tips

1. **Keep dependencies updated**
   - `go get -u ./...`
   - `pnpm update`

2. **Use caching**
   - GitHub Actions caches dependencies
   - Local: Run multiple jobs before commit

3. **Run quick checks first**
   - `make fmt-check`
   - `make tidy-check`
   - Then full tests

4. **Watch for slow tests**
   - Some integration tests are slow
   - Run in background or overnight
   - Can skip with `GOFLAGS` if needed

## Next Steps

1. **Install all prerequisites** (see Prerequisites)
2. **Run the local test script** (`./run-ci-local.ps1` or `./run-ci-local.sh`)
3. **Fix any issues** using the commands above
4. **Push when all checks pass** ✅
5. **Monitor GitHub Actions** for final validation

## Help & Resources

- **Makefile targets**: See `Makefile` in root
- **CI configuration**: See `.github/workflows/ci.yml`
- **Contributing**: See `CONTRIBUTING.md`
- **GitHub Actions**: https://docs.github.com/en/actions
- **Go docs**: https://golang.org/doc
- **Node.js docs**: https://nodejs.org/docs

---

**Questions?** Check the Makefile or CI workflow configuration for details on specific checks.

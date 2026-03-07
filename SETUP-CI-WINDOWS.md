# Setup Guide - Running CI Locally on Windows

## Current System Status

✅ **Installed:**
- git: 2.42.0.windows.2
- PowerShell (Windows Terminal)

❌ **Missing:**
- make (build tool)
- Go (backend tests)
- Node.js (frontend tests)
- pnpm (package manager)

## Installation Steps

### Step 1: Install Make

Make is required to run the Makefile commands. There are several options:

#### Option A: Using Chocolatey (Recommended)
```powershell
# Install Chocolatey (if not already installed)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install make
choco install make -y

# Verify installation
make --version
```

#### Option B: Using Scoop
```powershell
# Install Scoop (if not already installed)
irm get.scoop.sh | iex

# Install make
scoop install make

# Verify
make --version
```

#### Option C: Manual Download
1. Download GnuWin32 Make from: http://gnuwin32.sourceforge.net/packages/make.htm
2. Install to `C:\Program Files\GnuWin32\bin`
3. Add to PATH: `C:\Program Files\GnuWin32\bin`
4. Verify: `make --version`

### Step 2: Install Go 1.26+

```powershell
# Using Chocolatey
choco install golang -y

# Or download from: https://golang.org/dl
# Then verify
go version
```

### Step 3: Install Node.js 24+ LTS

```powershell
# Using Chocolatey
choco install nodejs -y

# Or download from: https://nodejs.org
# Then verify
node --version
npm --version
```

### Step 4: Install pnpm

```powershell
# Using npm (comes with Node.js)
npm install -g pnpm@10

# Verify
pnpm --version
```

## Quick Setup (One-Line)

If you have Chocolatey installed:

```powershell
choco install make golang nodejs -y; npm install -g pnpm@10
```

## Verification Script

Run this to verify everything is installed:

```powershell
$tools = @{
    "make" = "make --version"
    "git" = "git --version"
    "go" = "go version"
    "node" = "node --version"
    "npm" = "npm --version"
    "pnpm" = "pnpm --version"
}

foreach ($tool in $tools.GetEnumerator()) {
    try {
        $output = Invoke-Expression $tool.Value 2>&1
        Write-Host "✓ $($tool.Key): $($output | Select-Object -First 1)" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ $($tool.Key): NOT FOUND" -ForegroundColor Red
    }
}
```

## After Installation

Once all tools are installed:

### 1. Verify Installation
```powershell
# Check all tools
make --version
go version
node --version
npm --version
pnpm --version
```

### 2. Run CI Checks Locally

**Option A: Using the provided script (Windows)**
```powershell
# From d:\gitea-code directory
cd d:\gitea-code
.\run-ci-local.ps1
```

**Option B: Manual commands**
```powershell
cd d:\gitea-code

# Install dependencies
make deps-backend deps-tools
make deps-frontend

# Run checks
make fmt-check
make lint-backend
make lint-frontend
make test-backend
make test-frontend

# Full validation
make checks
make lint
```

### 3. Common First Steps

```powershell
# Install all dependencies
make deps-backend deps-tools
make deps-frontend

# Run quick format check
make fmt-check

# If format fails, fix it
make fmt
```

## Troubleshooting Installation

### "make: The term 'make' is not recognized"
- Make sure Chocolatey install completed successfully
- May need to restart PowerShell or terminal
- Check PATH environment variable includes make location

### Go download is slow
- Go download on first use is normal
- Once downloaded, subsequent runs are fast
- You can pre-download from https://golang.org/dl

### pnpm not found after installation
```powershell
# Reinstall pnpm
npm uninstall -g pnpm
npm install -g pnpm@10

# Or use npx directly
npx pnpm@10 install
```

### Node version conflicts
```powershell
# Check your Node version
node --version

# Should be 24 or higher
# If lower, upgrade Node.js
choco upgrade nodejs -y
```

## Testing the Installation

Once installed, run this to verify:

```powershell
cd d:\gitea-code

# Try a simple check
make fmt-check
```

If this works without errors, you're ready to run CI checks!

## Next Steps

1. **Install all required tools** (as described above)
2. **Verify installation** (run the verification script)
3. **Run the CI script**
   ```powershell
   .\run-ci-local.ps1
   ```
4. **Fix any issues** (see RUNNING-CI-LOCALLY.md)
5. **Commit and push** when all checks pass

## Step-by-Step for Total Beginners

```powershell
# 1. Open PowerShell as Administrator
# 2. Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# 3. Close and reopen PowerShell as Administrator

# 4. Install tools
choco install make golang nodejs -y
npm install -g pnpm@10

# 5. Navigate to project
cd d:\gitea-code

# 6. Test installation
make --version
go version
node --version
pnpm --version

# 7. Run CI locally
make deps-backend deps-tools
make deps-frontend
.\run-ci-local.ps1
```

## Estimated Time

- Chocolatey installation: ~2 minutes
- make installation: ~1 minute
- Go installation: ~5 minutes (downloads ~200MB)
- Node.js installation: ~3 minutes (downloads ~150MB)
- pnpm installation: ~1 minute
- **Total: ~15 minutes** (first time only)

---

Once installation is complete, you can run the full CI test suite locally before pushing to GitHub! 🚀

Questions? Check [RUNNING-CI-LOCALLY.md](RUNNING-CI-LOCALLY.md) for detailed usage instructions.

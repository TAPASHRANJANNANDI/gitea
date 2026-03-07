╔════════════════════════════════════════════════════════════════════════════╗
║                                                                            ║
║           Running Gitea CI Locally - Complete Getting Started              ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝

## 📋 QUICK OVERVIEW

You can now run all CI checks LOCALLY before pushing to GitHub!

Current Status:
  ✅ git (2.42.0) - Already installed
  ❌ make - Not installed
  ❌ Go - Not installed  
  ❌ Node.js - Not installed
  ❌ pnpm - Not installed

## 🚀 QUICK START (5 minutes)

### 1. Install Make (REQUIRED)

**Using Chocolatey (recommended):**
```powershell
# Open PowerShell as Administrator
choco install make -y

# Verify
make --version
```

**Alternative - Use WSL (Windows Subsystem for Linux):**
If you have WSL2 installed on Windows:
```bash
wsl
sudo apt-get update && sudo apt-get install -y make
```

### 2. Install Go & Node.js (15 minutes)

```powershell
# Using Chocolatey
choco install golang nodejs -y

# Install pnpm
npm install -g pnpm@10

# Verify all tools
make --version
go version
node --version
pnpm --version
```

### 3. Run CI Checks

From the `d:\gitea-code` directory:

```powershell
cd d:\gitea-code

# Option A: Run full CI script (automatic)
.\run-ci-local.ps1

# Option B: Run specific checks manually
make fmt-check              # Code formatting
make lint-backend          # Backend linting
make lint-frontend         # Frontend linting
make test-backend          # Go tests
make test-frontend         # JavaScript tests
```

## 📦 DETAILED INSTALLATION GUIDE

### For Windows Users

**Option 1: Chocolatey (RECOMMENDED)**

1. Install Chocolatey:
   ```powershell
   # Run PowerShell as Administrator
   Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
   ```

2. Close and reopen PowerShell as Administrator

3. Install development tools:
   ```powershell
   choco install make golang nodejs -y
   npm install -g pnpm@10
   ```

4. Verify (important!):
   ```powershell
   make --version
   go version
   node --version
   npm --version
   pnpm --version
   ```

**Option 2: Manual Downloads**

- **make**: http://gnuwin32.sourceforge.net/packages/make.htm
- **Go**: https://golang.org/dl (choose Windows installer)
- **Node.js**: https://nodejs.org (choose Windows installer)
- **pnpm**: `npm install -g pnpm@10` (requires npm from Node.js)

**Option 3: Windows Store**

```powershell
# In Windows 10/11
# Search for "App Installer" and install these from Microsoft Store:
# - Windows Terminal (recommended)
# - Node.js (Microsoft Store version)
# Then run: npm install -g pnpm@10
```

### For macOS Users

```bash
# Using Homebrew
brew install make go node

# Install pnpm
npm install -g pnpm@10

# Verify
make --version
go version
node --version
pnpm --version
```

### For Linux Users

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y make golang-go nodejs npm

# Install pnpm
npm install -g pnpm@10

# Verify
make --version
go version
node --version
pnpm --version
```

## 📊 ONE-LINE INSTALLATION

**Windows (with Chocolatey):**
```powershell
choco install make golang nodejs -y; npm install -g pnpm@10
```

**macOS:**
```bash
brew install make go node && npm install -g pnpm@10
```

**Linux:**
```bash
sudo apt-get install -y make golang-go nodejs npm && npm install -g pnpm@10
```

## 🎯 USING THE CI LOCALLY

### The Run CI Script

**Windows PowerShell:**
```powershell
cd d:\gitea-code
.\run-ci-local.ps1
```

**macOS/Linux Bash:**
```bash
cd /path/to/gitea-code
chmod +x run-ci-local.sh
./run-ci-local.sh
```

### Manual Commands

Instead of using the script, you can run individual checks:

```bash
# Backend Quality Checks
make fmt-check              # Check code formatting
make fmt                    # Fix formatting
make lint-backend           # Lint Go code
make tidy-check            # Check go.mod
make tidy                  # Fix go.mod
make security-check        # Vulnerability scan
make swagger-check         # API documentation
make test-backend          # Run Go tests

# Frontend Quality Checks
make lint-frontend         # Lint JavaScript/TypeScript
make lint-frontend-fix     # Fix linting issues
make test-frontend         # Run Vitest
make lockfile-check        # Check pnpm-lock.yaml

# Content Validation
make lint-spell            # Spelling check
make lint-templates        # Template validation
make lint-yaml             # YAML validation
make lint-json             # JSON validation

# Quick Checks
make checks                # All backend checks
make lint                  # All linting
make test                  # All tests
```

## ✅ TYPICAL WORKFLOW

### Before Each Commit

```bash
cd d:\gitea-code

# Step 1: Install dependencies (first time only)
make deps-backend deps-tools
make deps-frontend

# Step 2: Run quick checks
make fmt-check
make tidy-check

# Step 3: If anything fails, fix it
make fmt                   # Fix formatting
make tidy                  # Fix dependencies
make lint-*-fix           # Fix linting

# Step 4: Run full validation
.\run-ci-local.ps1        # Windows
./run-ci-local.sh         # macOS/Linux

# Step 5: Commit when all checks pass
git add .
git commit -m "feat: your changes"
git push origin your-branch
```

## 🔧 COMMON ISSUES & FIXES

| Issue | Cause | Solution |
|-------|-------|----------|
| "make not found" | Make not installed | Run: `choco install make` |
| "go: downloading..." | Go downloading stdlib | Wait 1-2 minutes, it's normal on first run |
| "pnpm not found" | pnpm not installed globally | Run: `npm install -g pnpm@10` |
| "node not found" | Node.js not installed | Download from nodejs.org or run: `choco install nodejs` |
| Format check fails | Code formatting | Run: `make fmt` |
| Tests timeout | Slow machine | Can skip with `GOFLAGS=-short make test-backend` |
| Lockfile out of sync | pnpm.lock not updated | Run: `pnpm install` |

## 📁 FILES CREATED FOR LOCAL CI TESTING

```
d:\gitea-code\
├── run-ci-local.ps1              ← Use this on Windows
├── run-ci-local.sh               ← Use this on macOS/Linux
├── SETUP-CI-WINDOWS.md           ← Windows setup guide
├── RUNNING-CI-LOCALLY.md         ← Detailed usage guide
├── CI-GETTING-STARTED.md         ← This file
│
└── .github\
    ├── workflows\
    │   └── ci.yml                ← GitHub Actions workflow
    ├── CI-WORKFLOW.md            ← Detailed CI documentation
    ├── CI-QUICK-REF.md           ← Quick reference
    ├── ARCHITECTURE.md           ← Architecture diagrams
    └── README-CI.md              ← CI index
```

## 📖 DOCUMENTATION GUIDE

**Read in this order:**

1. **This file** (5 min)
   - Quick start and overview

2. **[SETUP-CI-WINDOWS.md](SETUP-CI-WINDOWS.md)** (10 min, Windows only)
   - Detailed Windows setup instructions

3. **[RUNNING-CI-LOCALLY.md](RUNNING-CI-LOCALLY.md)** (15 min)
   - How to use the CI locally
   - Manual command reference
   - Troubleshooting

4. **[.github/CI-QUICK-REF.md](.github/CI-QUICK-REF.md)** (10 min)
   - Quick reference for CI jobs
   - Common tasks

5. **[.github/CI-WORKFLOW.md](.github/CI-WORKFLOW.md)** (30 min)
   - Detailed CI workflow documentation
   - Each job explained
   - Performance tips

## 🎓 LEARNING PATH

```
New to CI?
    ↓
Read: CI-GETTING-STARTED.md (this file)
    ↓
Install: Tools (see above)
    ↓
Run: .\run-ci-local.ps1
    ↓
Read: RUNNING-CI-LOCALLY.md
    ↓
Ready to develop!
```

## ✨ BENEFITS OF RUNNING CI LOCALLY

✅ **Instant Feedback** - No need to wait for GitHub
✅ **Save Time** - Fix issues before pushing
✅ **Avoid Failed PRs** - Catch problems early
✅ **Better Developer Experience** - Understand what CI expects
✅ **Offline Testing** - Works without internet (after initial setup)
✅ **Learning** - Understand code quality standards

## 📊 ESTIMATED TIMES

| Step | Duration | Notes |
|------|----------|-------|
| Install Chocolatey | 2 min | One-time |
| Install make | 1 min | One-time |
| Install Go | 5 min | One-time, downloads ~200MB |
| Install Node.js | 3 min | One-time, downloads ~150MB |
| Install pnpm | 1 min | One-time |
| **Total Setup** | **~15 min** | First time only |
| Run full CI | 5-15 min | Thereafter |
| Run quick checks | 1-3 min | Format, tidy, etc |

## 🚀 NEXT STEPS

1. **Install all tools** (see above)
2. **Verify installation**:
   ```bash
   make --version && go version && node --version && pnpm --version
   ```
3. **Navigate to project**:
   ```bash
   cd d:\gitea-code
   ```
4. **Install dependencies** (first time only):
   ```bash
   make deps-backend deps-tools
   make deps-frontend
   ```
5. **Run CI locally**:
   ```bash
   .\run-ci-local.ps1        # Windows
   ./run-ci-local.sh         # macOS/Linux
   ```
6. **Fix any issues** (see RUNNING-CI-LOCALLY.md)
7. **Commit and push** when all checks pass ✅

## 💡 TIPS & TRICKS

### Speed Up Tests
```bash
# Run tests in parallel
make test-backend

# Skip some slow tests
GOFLAGS=-short make test-backend
```

### Debug Failed Tests
```bash
# Run specific test
make test\#TestSpecificName

# See detailed output
make test-backend 2>&1 | tail -100
```

### Update Dependencies
```bash
# Go modules
go get -u ./...
make tidy

# Frontend
pnpm update
pnpm install
```

### Clean Build
```bash
# Remove build artifacts
make clean
make clean-all

# Then rebuild
make deps-backend deps-frontend
```

## ❓ FAQ

**Q: Do I need all these tools?**
A: For basic contribution to Go code, you only need make and go.
Frontend changes need node/pnpm. Most contributors need everything.

**Q: How often should I run CI locally?**
A: Before every commit. It takes 5-15 min and saves embarrassment!

**Q: Can I run CI offline?**
A: Yes, after initial installation and dependency downloads.

**Q: Does this replace GitHub Actions?**
A: No, GitHub still runs the official CI. This is for local pre-validation.

**Q: How do I update tools?**
A: Use your package manager (chocolatey, brew, apt-get, etc)

**Q: What if I don't have admin rights?**
A: Some installations might fail. Contact your IT support or use WSL.

## 🆘 NEED HELP?

1. **Installation issues?** → See [SETUP-CI-WINDOWS.md](SETUP-CI-WINDOWS.md)
2. **Using CI locally?** → See [RUNNING-CI-LOCALLY.md](RUNNING-CI-LOCALLY.md)
3. **Understanding CI?** → See [.github/CI-WORKFLOW.md](.github/CI-WORKFLOW.md)

---

**Ready to get started?** Install the tools above and run `.\run-ci-local.ps1`! 🎉

Questions? Check the companion documentation files or the Makefile for details.

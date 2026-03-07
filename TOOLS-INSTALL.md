# Fix: Install Required Tools

Your system is missing the necessary development tools. Here's how to install them:

## Windows PowerShell

### Quick Install (Chocolatey)
```powershell
# Install Chocolatey first if not already installed
choco install make golang nodejs --yes
npm install -g pnpm@10
```

### Alternative: Using Scoop
```powershell
scoop install make go nodejs
npm install -g pnpm@10
```

### Manual Installation
1. **make** - Download GNU Make from [GnuWin32](http://gnuwin32.sourceforge.net/packages/make.htm)
2. **Go** - Download from [golang.org](https://golang.org/dl)
3. **Node.js** - Download from [nodejs.org](https://nodejs.org) (get v24 LTS)
4. **pnpm** - `npm install -g pnpm@10`

## macOS

```bash
# Using Homebrew
brew install make go node
npm install -g pnpm@10

# Verify installation
make --version
go version
node --version
npm --version
pnpm --version
```

## Linux (Ubuntu/Debian)

```bash
# Install dependencies
sudo apt-get update
sudo apt-get install -y build-essential git golang-1.26

# Install Node.js (v24 LTS)
curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install pnpm
npm install -g pnpm@10

# Verify installation
make --version
go version
node --version
npm --version
pnpm --version
```

## Troubleshooting

### PowerShell errors on Windows?
Try running as Administrator and enable script execution:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### After installation, run tests
```powershell
# Windows
.\run-ci-local.ps1 -Quick

# macOS/Linux
./run-ci-local.sh --quick
```

For detailed setup instructions, see [SETUP-CI-WINDOWS.md](SETUP-CI-WINDOWS.md) or [CI-GETTING-STARTED.md](CI-GETTING-STARTED.md).

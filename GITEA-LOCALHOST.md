# Quick Start: Run Gitea on localhost:3000

## Step 1: Install Required Tools

Run this in PowerShell as Administrator:

```powershell
# Install Chocolatey (if not already installed)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install build tools and dependencies
choco install make golang nodejs --yes
npm install -g pnpm@10
```

**Verify installation:**
```powershell
make --version
go version
node --version
pnpm --version
```

## Step 2: Build Gitea

```powershell
cd d:\gitea-code

# Install dependencies
go mod download

# Build the executable
go build -o gitea.exe
```

This will create `gitea.exe` in the current directory (~2-5 minutes).

## Step 3: Initialize Database

```powershell
# Create data directory
mkdir custom\conf

# Run Gitea in install mode (opens http://localhost:3000/install)
.\gitea.exe web
```

The first time you run it, you'll be redirected to the installation wizard. You can configure:
- Database type (SQLite is easiest for local development)
- Admin user credentials
- Application settings

## Step 4: Access Gitea UI

Once installation is complete, Gitea will be running at:
```
http://localhost:3000
```

### Default Port
If port 3000 is already in use, specify a different port:
```powershell
.\gitea.exe web -p 4000
```

## Common Setup Issues

**Error: "make not found"**
- Install from Chocolatey: `choco install make --yes`

**Error: "go not found"**
- Install from Chocolatey: `choco install golang --yes`

**Database locked/permission errors**
- Delete the `data` directory and restart: `rm -r data ; .\gitea.exe web`

**Port already in use**
```powershell
# Find process using port 3000
netstat -ano | findstr :3000

# Kill the process
taskkill /PID <PID> /F

# Or use a different port
.\gitea.exe web -p 3001
```

## Development: Rebuilding Gitea

After making code changes:

```powershell
# Rebuild and restart
go build -o gitea.exe
.\gitea.exe web
```

For continuous development with auto-rebuild:
```powershell
make watch-backend
```

## Next Steps

1. Create repositories
2. Configure settings in Admin Panel
3. Start using Git with Gitea

For more configuration options, see `custom/conf/app.ini` (created after first run).

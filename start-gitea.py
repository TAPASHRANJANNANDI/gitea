#!/usr/bin/env python3
"""
Quick setup script to get Gitea running on localhost:3000
Checks dependencies and builds/runs Gitea
"""

import subprocess
import os
import sys
import platform
from pathlib import Path

def run_cmd(cmd, shell=False):
    """Run a command and return True if successful"""
    try:
        result = subprocess.run(
            cmd if isinstance(cmd, list) else cmd.split(),
            shell=shell,
            capture_output=True,
            text=True,
            timeout=120
        )
        return result.returncode == 0, result.stdout, result.stderr
    except Exception as e:
        return False, "", str(e)

def check_tool(tool):
    """Check if a tool is installed"""
    if platform.system() == "Windows":
        success, _, _ = run_cmd(f"{tool} --version")
    else:
        success, _, _ = run_cmd(f"which {tool}")
    return success

def main():
    print("\n" + "="*60)
    print("  GITEA LOCAL SETUP - localhost:3000")
    print("="*60 + "\n")
    
    # Check directory
    if not Path("Makefile").exists():
        print("❌ Makefile not found. Please run from gitea-code directory")
        sys.exit(1)
    print("✓ Running in correct directory")
    
    # Check tools
    print("\nChecking required tools:")
    tools = ["git", "go", "make", "node", "pnpm"]
    missing = []
    
    for tool in tools:
        if check_tool(tool):
            print(f"  ✓ {tool}")
        else:
            print(f"  ✗ {tool} MISSING")
            missing.append(tool)
    
    if missing:
        print(f"\n❌ Missing tools: {', '.join(missing)}")
        print("\nInstall on Windows (PowerShell as Admin):")
        print("  choco install make golang nodejs --yes")
        print("  npm install -g pnpm@10")
        print("\nInstall on macOS:")
        print("  brew install make go node")
        print("  npm install -g pnpm@10")
        print("\nInstall on Linux (Ubuntu/Debian):")
        print("  sudo apt-get install build-essential golang nodejs")
        print("  npm install -g pnpm@10")
        sys.exit(1)
    
    print("\n✓ All required tools installed\n")
    
    # Build Gitea
    print("Building Gitea...")
    exe_name = "gitea.exe" if platform.system() == "Windows" else "gitea"
    
    # Check if already built
    if not Path(exe_name).exists():
        print("  Running: go mod download")
        success, _, err = run_cmd("go mod download")
        if not success:
            print(f"  ❌ Error: {err}")
            sys.exit(1)
        
        print("  Running: go build")
        build_cmd = f"go build -o {exe_name}" if platform.system() == "Windows" else f"go build -o {exe_name}"
        success, _, err = run_cmd(build_cmd.split())
        if not success:
            print(f"  ❌ Error: {err}")
            sys.exit(1)
        print(f"  ✓ Built {exe_name}")
    else:
        print(f"  ✓ {exe_name} already exists")
    
    # Create directories
    Path("custom/conf").mkdir(parents=True, exist_ok=True)
    
    # Start Gitea
    print("\n" + "="*60)
    print("  STARTING GITEA WEB SERVER")
    print("="*60)
    print(f"\n🚀 Starting: ./{exe_name} web")
    print("📱 Open http://localhost:3000 in your browser\n")
    
    if platform.system() == "Windows":
        os.system(f".\\{exe_name} web")
    else:
        os.system(f"./{exe_name} web")

if __name__ == "__main__":
    main()

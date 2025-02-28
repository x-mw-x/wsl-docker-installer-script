<#
.SYNOPSIS
    Automated installation script for Docker and WSL on Windows
.DESCRIPTION
    This script installs and configures WSL2 and Docker Desktop on Windows
    - Enable install + Update wsl.
    - install Ubuntu.
    - Installs Docker.
.NOTES
    Author: MW
    YouTube: [https://www.youtube.com/@Hacked_by_MW]
    Version: 1.0
#>

# Check if running as administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Please run this script as Administrator. Right-click on PowerShell and select 'Run as Administrator'." -ForegroundColor Red
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# Contact information for support
$contactInfo = @"
If you encounter issues, please reach out:
- Email: hacked.by.mw@proton.me
- YouTube: https://www.youtube.com/@Hacked_by_MW
- Discord: https://discord.com/invite/DxWTvjrEd3
- Telegram: https://t.me/+xrqpNcyCqGE5M2U0
"@

Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host "   Docker & WSL Automated Installation Script" -ForegroundColor Cyan
Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check if WSL is already installed
$wslInstalled = $false
try {
    $wslVersion = wsl --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ WSL is already installed!" -ForegroundColor Green
        $wslInstalled = $true
    }
} catch {
    Write-Host "WSL is not installed yet. Proceeding with installation..." -ForegroundColor Yellow
}

# Install WSL if not already installed
if (-not $wslInstalled) {
    Write-Host "Step 1: Installing Windows Subsystem for Linux..." -ForegroundColor Cyan
    
    try {
        wsl --install
        wsl --update
        Write-Host "`n===========================================================`n" -ForegroundColor Yellow
        Write-Host "WSL INSTALLATION INITIATED" -ForegroundColor Yellow
        Write-Host "`nYOUR COMPUTER NEEDS TO RESTART to complete the WSL installation." -ForegroundColor Yellow
        Write-Host "Please restart your computer and run this script again after restarting." -ForegroundColor Yellow
        Write-Host "`n===========================================================`n" -ForegroundColor Yellow
        
        Write-Host "Press any key to exit..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        exit 0
    } catch {
        Write-Host "ERROR: Failed to install WSL. Error details:" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        Write-Host $contactInfo -ForegroundColor Yellow
        Write-Host "Press any key to exit..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        exit 1
    }
}

# Step 2: Set WSL 2 as default version
Write-Host "Step 2: Setting WSL 2 as the default version..." -ForegroundColor Cyan
try {
    wsl --update
    wsl --set-default-version 2
    Write-Host "✓ WSL 2 is now the default version" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to set WSL 2 as default. Error details:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host $contactInfo -ForegroundColor Yellow
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# Step 3: Check if Ubuntu is installed
$ubuntuInstalled = $false
try {
    $distros = wsl --list
    if ($distros -match "Ubuntu") {
        Write-Host "✓ Ubuntu is already installed" -ForegroundColor Green
        $ubuntuInstalled = $true
    }
} catch {
    Write-Host "Could not verify Ubuntu installation. Will attempt to install." -ForegroundColor Yellow
}

# Install Ubuntu if not already installed
if (-not $ubuntuInstalled) {
    Write-Host "Step 3: Installing Ubuntu on WSL..." -ForegroundColor Cyan
    try {
        wsl --install -d Ubuntu
        Write-Host "✓ Ubuntu installed successfully" -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to install Ubuntu. Error details:" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        Write-Host $contactInfo -ForegroundColor Yellow
        Write-Host "Press any key to exit..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        exit 1
    }
}

# Step 4: Check if Docker Desktop is already installed
$dockerInstalled = Test-Path "C:\Program Files\Docker\Docker\Docker Desktop.exe"
if ($dockerInstalled) {
    Write-Host "✓ Docker Desktop is already installed" -ForegroundColor Green
} else {
    Write-Host "Step 4: Installing Docker Desktop..." -ForegroundColor Cyan
    try {
        $dockerUrl = "https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe"
        $dockerInstaller = Join-Path -Path $PSScriptRoot -ChildPath "DockerDesktopInstaller.exe"

        
        Write-Host "Downloading Docker Desktop installer..." -ForegroundColor Yellow
        #Invoke-WebRequest -Uri $dockerUrl -OutFile $dockerInstaller -UseBasicParsing
        Start-BitsTransfer -Source $dockerUrl -Destination $dockerInstaller

        Write-Host "Running Docker Desktop installer..." -ForegroundColor Yellow

        Start-Process -FilePath $dockerInstaller -Wait -ArgumentList 'install', '--accept-license'
        
        if (Test-Path "C:\Program Files\Docker\Docker\Docker Desktop.exe") {
            Write-Host "✓ Docker Desktop installed successfully" -ForegroundColor Green

            Write-Host "✓ Refreshing Env" -ForegroundColor Green
            # Refresh environment variables for the current session
            $env:Path += ";C:\Program Files\Docker\Docker"
            $env:PATH = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)

        } else {
            throw "Docker Desktop executable not found after installation"
        }
    } catch {
        Write-Host "ERROR: Failed to install Docker Desktop. Error details:" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        Write-Host $contactInfo -ForegroundColor Yellow
        Write-Host "Press any key to exit..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        exit 1
    }
}

# Step 5: Start Docker Desktop and wait for it to initialize
Write-Host "Step 5: Starting Docker Desktop..." -ForegroundColor Cyan
try {
    Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    Write-Host "Docker Desktop is starting. This may take a few minutes..." -ForegroundColor Yellow
    
    # Wait for Docker to be responsive
    $dockerReady = $false
    $attempts = 0
    $maxAttempts = 30
    
    while (-not $dockerReady -and $attempts -lt $maxAttempts) {
        Start-Sleep -Seconds 10
        $attempts++
        Write-Host "Waiting for Docker to start... ($attempts/$maxAttempts)" -ForegroundColor Yellow
        
        docker info > $null 2>&1
        if ($LASTEXITCODE -eq 0) {
            $dockerReady = $true
        }
    }
    
    if ($dockerReady) {
        Write-Host "✓ Docker is running and ready!" -ForegroundColor Green
    } else {
        throw "Docker did not start properly after waiting"
    }
} catch {
    Write-Host "WARNING: Could not verify if Docker is running properly. You may need to start Docker Desktop manually." -ForegroundColor Yellow
    Write-Host "Error details: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Step 6: Test Docker installation with hello-world
Write-Host "Step 6: Testing Docker installation..." -ForegroundColor Cyan
try {
    $output = docker run hello-world
    if ($output -match "Hello from Docker!") {
        Write-Host "✓ Docker test successful!" -ForegroundColor Green
    } else {
        throw "Docker test did not produce expected output"
    }
} catch {
    Write-Host "WARNING: Docker test failed. Docker may not be fully initialized yet." -ForegroundColor Yellow
    Write-Host "Try running 'docker run hello-world' manually after a few minutes." -ForegroundColor Yellow
    Write-Host "Error details: $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host $contactInfo -ForegroundColor Yellow
}

# Success message
Write-Host "`n=========================================================" -ForegroundColor Green
Write-Host "✓ INSTALLATION COMPLETE!" -ForegroundColor Green
Write-Host "=========================================================" -ForegroundColor Green
Write-Host "Docker and WSL with Ubuntu have been successfully installed on your system." -ForegroundColor Green
Write-Host "`nTo use Ubuntu, open a new terminal and type: wsl" -ForegroundColor Cyan
Write-Host "To verify Docker is working, type: docker run hello-world" -ForegroundColor Cyan
Write-Host "`nThanks for using this installation script!" -ForegroundColor Green
Write-Host $contactInfo -ForegroundColor Cyan
Write-Host "`nPress any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
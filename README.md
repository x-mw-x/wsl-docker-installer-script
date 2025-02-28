# 🐳 Docker & WSL Automated Installation Script

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![WSL](https://img.shields.io/badge/WSL-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)

## 📋 Overview

This script automates the installation and configuration of WSL2 (Windows Subsystem for Linux) and Docker Desktop on Windows systems. It simplifies the process of setting up a complete containerization environment with just a single command.

## ✨ Features

- ✅ Automated WSL2 installation and configuration
- ✅ Ubuntu installation within WSL
- ✅ Docker Desktop download and installation
- ✅ Environment verification and testing
- ✅ Comprehensive error handling and user guidance

## 🚀 Quick Start

### Prerequisites

- Windows 10 version 2004 or higher (Build 19041 or higher)
- Administrator privileges

### Installation

1. Clone this repository or download the script
2. Open PowerShell as Administrator
3. Navigate to the script's directory
4. Run the script with the following command:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; .\wsl_docker_windows_script.ps1
```

> **Note**: You may need to restart your computer during the installation process when prompted.

## 🔄 Installation Process

The script performs the following steps:

1. Verifies administrator privileges
2. Installs and configures WSL2
3. Sets WSL2 as the default version
4. Installs Ubuntu on WSL
5. Downloads and installs Docker Desktop
6. Starts Docker Desktop and verifies installation
7. Tests Docker with a simple hello-world container

## ⚠️ Troubleshooting

If you encounter issues during installation:

- Make sure you're running PowerShell as Administrator
- Ensure your Windows version is compatible with WSL2
- Verify that virtualization is enabled in your BIOS
- Check Windows features (Hyper-V, Virtual Machine Platform) are enabled

## 📞 Contact Information

If you need assistance, please reach out:

- 📧 Email: hacked.by.mw@proton.me
- 🎬 YouTube: [https://www.youtube.com/@Hacked_by_MW](https://www.youtube.com/@Hacked_by_MW)
- 💬 Discord: [https://discord.com/invite/DxWTvjrEd3](https://discord.com/invite/DxWTvjrEd3)
- 📱 Telegram: [https://t.me/+xrqpNcyCqGE5M2U0](https://t.me/+xrqpNcyCqGE5M2U0)

## 🙏 Acknowledgements

- Created by MW
- Special thanks to the Docker and Microsoft WSL teams for their excellent documentation

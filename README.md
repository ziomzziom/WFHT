# Windows Forensic & Hacking Toolkit (WFHT)

[![PowerShell Version](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://aka.ms/powershell)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Turn Windows Server into a forensic analysis and penetration testing platform.

## Features
- Modular tool installation
- Disk space pre-checks
- WSL2 integration
- Forensic-ready configuration
- 50+ pre-configured tools

## Quick Start
```powershell
# Minimal installation
irm https://raw.githubusercontent.com/yourrepo/WFHT/main/scripts/WFHT-Core-Setup.ps1 | iex

# Full installation
.\WFHT-Core-Setup.ps1 -InstallAll -Verbose

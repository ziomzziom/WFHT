# Windows Forensic & Hacking Toolkit (WFHT)

[![PowerShell Version](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://aka.ms/powershell)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Transform Windows into a powerful forensic analysis and penetration testing workstation with infinite capabilities faster!

---

## 🚀 Quick Start

### Prerequisites

- Windows 10/11 or Windows Server 2016+
- PowerShell 5.1+
- Administrator privileges

### Installation

```powershell
# Run in an elevated PowerShell window
Set-ExecutionPolicy RemoteSigned -Scope Process -Force
irm https://raw.githubusercontent.com/yourusername/WFHT/main/scripts/WFHT-Core-Setup.ps1 | iex

---

## 🛠️ Tool Categories

### 🔍 **Forensic Tools**
| Subcategory         | Tools                                                                 |
|---------------------|-----------------------------------------------------------------------|
| **Disk Analysis**   | Autopsy, FTK Imager, X-Ways Forensics, Eric Zimmerman's Tools (KAPE) |
| **Memory Analysis** | Volatility3, Belkasoft RAM Capturer, Magnet RAM Capture              |
| **Network Forensics**| Wireshark, NetworkMiner, CapLoader                                   |
| **Mobile Forensics**| ADB, Santoku (via WSL)                                               |
| **Log Analysis**    | LogParser, Event Log Explorer, Plaso                                 |

### ⚔️ **Hacking Tools**
| Subcategory          | Tools                                                              |
|----------------------|--------------------------------------------------------------------|
| **Reconnaissance**   | Nmap, Shodan CLI, Maltego, theHarvester                           |
| **Exploitation**     | Metasploit Framework, SQLMap, Cobalt Strike (license required)    |
| **Post-Exploitation**| Mimikatz, BloodHound, PowerSploit                                 |
| **Password Cracking**| Hashcat, John the Ripper, Hydra                                   |
| **Web App Testing**  | Burp Suite Professional, OWASP ZAP, DirBuster                     |

### ⚙️ **System Tools**
| Subcategory        | Tools                                                             |
|--------------------|-------------------------------------------------------------------|
| **Core Utilities** | Sysinternals Suite, 7-Zip, NirSoft Utilities                     |
| **Development**    | Python 3.12, VS Code (with forensics extensions), Ghidra         |
| **Virtualization** | VMware Workstation Player, VirtualBox, Windows Subsystem (WSL2)  |
| **Security**       | Windows Defender Exclusions, Firewall Rule Manager, Process Monitor |

# 💾 Storage Requirements

## 📊 Overview
| Category          | Minimum Space | Recommended |
|-------------------|---------------|-------------|
| **Forensic Tools**| 8 GB          | 20 GB       |
| **Hacking Tools** | 10 GB         | 25 GB       |
| **System Tools**  | 5 GB          | 15 GB       |
| **Linux Tools**   | 15 GB         | 30 GB       |

_Note: Add 20% buffer for temporary files during installation._

---

## 🔍 Forensic Tools
| Subcategory         | Tools                          | Install Size | Temp Space | Total  |
|---------------------|--------------------------------|--------------|------------|--------|
| **Disk Analysis**   | Autopsy, FTK Imager, X-Ways    | 3.5 GB       | 1 GB       | 4.5 GB |
| **Memory Analysis** | Volatility3, Belkasoft RAM     | 1.2 GB       | 300 MB     | 1.5 GB |
| **Network Forensics**| Wireshark, NetworkMiner        | 800 MB       | 200 MB     | 1 GB   |
| **Mobile Forensics**| ADB, Santoku (WSL)             | 2 GB         | 500 MB     | 2.5 GB |
| **Log Analysis**    | LogParser, Plaso               | 500 MB       | 100 MB     | 600 MB |

---

## ⚔️ Hacking Tools
| Subcategory          | Tools                         | Install Size | Temp Space | Total  |
|----------------------|-------------------------------|--------------|------------|--------|
| **Reconnaissance**   | Nmap, Maltego, theHarvester   | 1.5 GB       | 400 MB     | 1.9 GB |
| **Exploitation**     | Metasploit, SQLMap            | 4 GB         | 1 GB       | 5 GB   |
| **Post-Exploitation**| Mimikatz, BloodHound          | 300 MB       | 50 MB      | 350 MB |
| **Password Cracking**| Hashcat, John the Ripper      | 2 GB         | 800 MB     | 2.8 GB |
| **Web App Testing**  | Burp Suite, OWASP ZAP         | 3 GB         | 1 GB       | 4 GB   |

---

## ⚙️ System Tools
| Subcategory        | Tools                        | Install Size | Temp Space | Total  |
|--------------------|------------------------------|--------------|------------|--------|
| **Core Utilities** | Sysinternals, 7-Zip          | 400 MB       | 100 MB     | 500 MB |
| **Development**    | Python, VS Code, Ghidra      | 3 GB         | 800 MB     | 3.8 GB |
| **Virtualization** | VMware, VirtualBox, WSL2     | 6 GB         | 2 GB       | 8 GB   |
| **Security**       | Defender Exclusions, Tools   | 200 MB       | 50 MB      | 250 MB |

---

## 🐧 Linux Tools (WSL)
| Subcategory       | Tools                      | Install Size | Temp Space | Total  |
|-------------------|----------------------------|--------------|------------|--------|
| **Kali Linux**    | Base System + Tools        | 10 GB        | 3 GB       | 13 GB  |
| **Forensic Tools**| Guymager, Bulk Extractor   | 2 GB         | 500 MB     | 2.5 GB |
| **Hacking Tools** | Aircrack-ng, SET           | 1.5 GB       | 400 MB     | 1.9 GB |

---

## 📝 Important Notes
1. **Evidence Storage**: Allocate separate space for case files (minimum 50 GB recommended)
2. **Variable Factors**:
   - Windows Updates: +5-10 GB annually
   - Tool Updates: +2-5 GB/month
3. **VM Recommendations**:
   ```yaml
   Forensic Workstation:
     - Base: 60 GB
     - Evidence: 100+ GB (separate VHDX)
   Pentesting Lab:
     - Base: 40 GB
     - Tools: 80 GB (dynamic allocation)
   ```

---

## 🧹 Space Management Tips

```yaml
# Clean Chocolatey temp files
Remove-Item -Path "$env:ChocolateyInstall\lib-bad" -Recurse -Force

# Clear Windows Update cache
Cleanmgr /sagerun:1
```

# Windows Forensic & Hacking Toolkit - Interactive Installer

param(
    [switch]$EstimateOnly
)

#region Configuration
$menuStructure = @{
    "Forensic Tools" = @{
        "1. Disk Analysis"       = @("autopsy", "ftkimager", "ericzimmertools")
        "2. Memory Analysis"     = @("volatility3", "belkasoft-ram-capturer")
        "3. Network Forensics"   = @("wireshark", "networkminer", "tshark")
        "4. Mobile Forensics"    = @("adb", "santoku") 
        "5. Log Analysis"        = @("logparser", "plaso")
        "Size"                   = @(4.5GB, 1.5GB, 1GB, 2.5GB, 600MB)
    }
    
    "Hacking Tools" = @{
        "1. Reconnaissance"      = @("nmap", "maltego", "theharvester")
        "2. Exploitation"        = @("metasploit-framework", "sqlmap")
        "3. Post-Exploitation"   = @("mimikatz", "bloodhound", "powersploit")
        "4. Password Cracking"   = @("hashcat", "john", "hydra")
        "5. Web App Testing"     = @("burp-suite", "owasp-zap")
        "Size"                   = @(1.9GB, 5GB, 350MB, 2.8GB, 4GB)
    }
    
    "System Tools" = @{
        "1. Core Utilities"      = @("sysinternals", "7zip", "nirlauncher")
        "2. Development"         = @("python3", "vscode", "ghidra")
        "3. Virtualization"      = @("vmware-workstation-player", "virtualbox", "wsl2")
        "Size"                   = @(500MB, 3.8GB, 8GB)
    }
}

$requiredFeatures = @(
    "Microsoft-Hyper-V",
    "Microsoft-Windows-Subsystem-Linux",
    "Containers"
)
#endregion

#region Functions
function Show-MainMenu {
    Clear-Host
    Write-Host "`n`t🔍⚔️ Windows Forensic & Hacking Toolkit Installer`n" -ForegroundColor Magenta
    Write-Host "`t=== Main Menu ==="
    Write-Host "`t[1] Install Forensic Tools"
    Write-Host "`t[2] Install Hacking Tools"
    Write-Host "`t[3] Install System Tools"
    Write-Host "`t[4] Install ALL Tools"
    Write-Host "`t[5] Estimate Space Requirements"
    Write-Host "`t[0] Exit`n"
}

function Show-SubMenu {
    param(
        [string]$Category,
        [hashtable]$SubCategories
    )
    Clear-Host
    Write-Host "`n`t=== $Category ===" -ForegroundColor Yellow
    $sizeIndex = $SubCategories["Size"].Count
    for ($i = 0; $i -lt ($SubCategories.Count - 1); $i++) {
        if ($i -lt $sizeIndex) {
            $size = "{0:N1}GB" -f ($SubCategories["Size"][$i]/1GB)
            Write-Host "`t[$($i+1)] $($SubCategories.Keys[$i]) (${size})"
        }
    }
    Write-Host "`t[0] Back to Main Menu`n"
}

function Get-SelectedTools {
    param(
        [hashtable]$SubCategories
    )
    $selected = @()
    $sizeIndex = $SubCategories["Size"].Count
    for ($i = 0; $i -lt ($SubCategories.Count - 1); $i++) {
        if ($i -lt $sizeIndex) {
            $selected += $SubCategories[$i]
        }
    }
    $selected
}

function Install-Tools {
    param(
        [array]$Tools,
        [string]$Category
    )
    Write-Host "`nInstalling $Category..." -ForegroundColor Cyan
    foreach ($tool in $Tools) {
        Write-Host "  - $tool" -ForegroundColor DarkGray
        try {
            choco install $tool -y --no-progress
        }
        catch {
            Write-Host "    [!] Failed to install $tool" -ForegroundColor Red
        }
    }
}

function Enable-WindowsFeatures {
    Write-Host "`nEnabling System Features..." -ForegroundColor Yellow
    foreach ($feature in $requiredFeatures) {
        try {
            Enable-WindowsOptionalFeature -Online -FeatureName $feature -All -NoRestart
        }
        catch {
            Write-Host "  [!] Failed to enable $feature" -ForegroundColor Red
        }
    }
}
#endregion

# Main Execution
try {
    # Check for Chocolatey
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "Installing Chocolatey..." -ForegroundColor Yellow
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }

    # Main Loop
    $exit = $false
    while (-not $exit) {
        Show-MainMenu
        $choice = Read-Host "`tEnter your choice"
        
        switch ($choice) {
            '1' { # Forensic Tools
                $sub = $menuStructure["Forensic Tools"]
                Show-SubMenu -Category "Forensic Tools" -SubCategories $sub
                $subChoice = Read-Host "`tSelect tools (comma-separated)"
                $selected = $subChoice.Split(',') | ForEach-Object { $_.Trim() }
                $tools = Get-SelectedTools -SubCategories $sub
                Install-Tools -Tools $tools -Category "Forensic Tools"
            }
            '2' { # Hacking Tools
                $sub = $menuStructure["Hacking Tools"]
                Show-SubMenu -Category "Hacking Tools" -SubCategories $sub
                $subChoice = Read-Host "`tSelect tools (comma-separated)"
                $selected = $subChoice.Split(',') | ForEach-Object { $_.Trim() }
                $tools = Get-SelectedTools -SubCategories $sub
                Install-Tools -Tools $tools -Category "Hacking Tools"
            }
            '3' { # System Tools
                $sub = $menuStructure["System Tools"]
                Show-SubMenu -Category "System Tools" -SubCategories $sub
                $subChoice = Read-Host "`tSelect tools (comma-separated)"
                $selected = $subChoice.Split(',') | ForEach-Object { $_.Trim() }
                $tools = Get-SelectedTools -SubCategories $sub
                Install-Tools -Tools $tools -Category "System Tools"
            }
            '4' { # Install ALL
                Enable-WindowsFeatures
                foreach ($category in $menuStructure.Keys) {
                    $tools = Get-SelectedTools -SubCategories $menuStructure[$category]
                    Install-Tools -Tools $tools -Category $category
                }
            }
            '5' { # Space Estimate
                # ... (space calculation logic)
            }
            '0' { $exit = $true }
            default { Write-Host "`tInvalid selection!" -ForegroundColor Red }
        }
        
        if (-not $exit) {
            Read-Host "`nPress Enter to continue..."
        }
    }
}
finally {
    Write-Host "`nOperation completed. Recommended:" -ForegroundColor Cyan
    Write-Host "- Reboot system for feature changes"
    Write-Host "- Run 'wsl --update' for Linux components`n"
}

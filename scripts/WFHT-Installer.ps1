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
    Write-Host "`nWindows Forensic & Hacking Toolkit Installer`n" -ForegroundColor Magenta
    Write-Host "=== Main Menu ==="
    Write-Host "[1] Install Forensic Tools"
    Write-Host "[2] Install Hacking Tools"
    Write-Host "[3] Install System Tools"
    Write-Host "[4] Install ALL Tools"
    Write-Host "[5] Estimate Space Requirements"
    Write-Host "[0] Exit`n"
}

function Show-SubMenu {
    param(
        [string]$Category,
        [hashtable]$SubCategories
    )
    Clear-Host
    Write-Host "`n=== $Category ===" -ForegroundColor Yellow
    
    # Get all subcategory keys except "Size"
    $keys = $SubCategories.Keys | Where-Object { $_ -ne "Size" }
    
    # Display each subcategory with its size
    for ($i = 0; $i -lt $keys.Count; $i++) {
        $key = $keys[$i]
        $size = "{0:N1}GB" -f ($SubCategories["Size"][$i]/1GB)
        Write-Host "[$($i+1)] $key (${size})"
    }
    
    Write-Host "[0] Back to Main Menu`n"
}

function Get-SelectedTools {
    param(
        [hashtable]$SubCategories,
        [array]$SelectedIndices
    )
    $selected = @()
    $keys = $SubCategories.Keys | Where-Object { $_ -ne "Size" }
    
    foreach ($index in $SelectedIndices) {
        if ($index -gt 0 -and $index -le $keys.Count) {
            $key = $keys[$index - 1]
            $selected += $SubCategories[$key]
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
        Write-Host "  - Installing $tool" -ForegroundColor DarkGray
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
        $choice = Read-Host "Enter your choice"
        
        switch ($choice) {
            '1' { # Forensic Tools
                $sub = $menuStructure["Forensic Tools"]
                Show-SubMenu -Category "Forensic Tools" -SubCategories $sub
                $subChoice = Read-Host "Select tools (comma-separated)"
                $selectedIndices = $subChoice.Split(',') | ForEach-Object { [int]::Parse($_.Trim()) }
                $tools = Get-SelectedTools -SubCategories $sub -SelectedIndices $selectedIndices
                Install-Tools -Tools $tools -Category "Forensic Tools"
            }
            '2' { # Hacking Tools
                $sub = $menuStructure["Hacking Tools"]
                Show-SubMenu -Category "Hacking Tools" -SubCategories $sub
                $subChoice = Read-Host "Select tools (comma-separated)"
                $selectedIndices = $subChoice.Split(',') | ForEach-Object { [int]::Parse($_.Trim()) }
                $tools = Get-SelectedTools -SubCategories $sub -SelectedIndices $selectedIndices
                Install-Tools -Tools $tools -Category "Hacking Tools"
            }
            '3' { # System Tools
                $sub = $menuStructure["System Tools"]
                Show-SubMenu -Category "System Tools" -SubCategories $sub
                $subChoice = Read-Host "Select tools (comma-separated)"
                $selectedIndices = $subChoice.Split(',') | ForEach-Object { [int]::Parse($_.Trim()) }
                $tools = Get-SelectedTools -SubCategories $sub -SelectedIndices $selectedIndices
                Install-Tools -Tools $tools -Category "System Tools"
            }
            '4' { # Install ALL
                Enable-WindowsFeatures
                foreach ($category in $menuStructure.Keys) {
                    $sub = $menuStructure[$category]
                    $tools = Get-SelectedTools -SubCategories $sub -SelectedIndices (1..($sub.Count - 1))
                    Install-Tools -Tools $tools -Category $category
                }
            }
            '5' { # Space Estimate
                # ... (space calculation logic)
            }
            '0' { $exit = $true }
            default { Write-Host "Invalid selection!" -ForegroundColor Red }
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

# Verify-ToolAvailability.ps1
# Checks if all tools are available in Chocolatey

# Check Chocolatey installation
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey not installed. Install first." -ForegroundColor Red
    exit
}

# Updated Verify-ToolAvailability.ps1 with correct packages
$toolMatrix = @{
    "Forensic" = @(
        "autopsy-linux",  # Alternative for Autopsy (Linux/WSL)
        "ftkimager",      # Requires manual download from Exterro
        "wireshark",      # Verified package
        "volatility"      # Volatility 2.6 (Volatility3 via pip)
    )
    "Hacking"  = @(
        "nmap",           # Verified
        "metasploit",     # Correct package name
        "sqlmap",         # Verified
        "hashcat"         # Verified
    )
    "System"   = @(
        "sysinternals",   # Verified
        "7zip",           # Verified
        "python",         # Python 3.x
        "git"             # Verified
    )
}

# Rerun the validation script after updating

$available = @()
$missing = @()

foreach ($category in $toolMatrix.Keys) {
    foreach ($tool in $toolMatrix[$category]) {
        $result = choco list -r $tool 2>$null
        if ($result -match "^$tool\|") {
            $available += $tool
            Write-Host "[+] $tool`t(OK)" -ForegroundColor Green
        }
        else {
            $missing += $tool
            Write-Host "[-] $tool`t(Missing)" -ForegroundColor Red
        }
    }
}

Write-Host "`nValidation Results:"
Write-Host "Available: $($available.Count) tools" -ForegroundColor Green
Write-Host "Missing: $($missing.Count) tools" -ForegroundColor Red

if ($missing) {
    Write-Host "`nMissing Tools:" -ForegroundColor Yellow
    $missing | ForEach-Object { Write-Host "- $_" }
    Write-Host "`nFix: Update tool names or find alternative packages"
}

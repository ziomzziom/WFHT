# Verify-ToolAvailability.ps1
# Checks if all tools are available in Chocolatey

# Check Chocolatey installation
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey not installed. Install first." -ForegroundColor Red
    exit
}

# Tool list (update with your actual tools)
$toolMatrix = @{
    "Forensic" = @("autopsy", "ftkimager", "wireshark", "volatility3")
    "Hacking"  = @("nmap", "metasploit-framework", "sqlmap", "hashcat")
    "System"   = @("sysinternals", "7zip", "python3", "git")
}

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

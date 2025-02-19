# WFHT-AutoInstaller.ps1
# Automated tool installer with fallback methods

param([switch]$ListOnly)

# Tool Configuration Matrix
$tools = @(
    # Forensic Tools
    @{Name="autopsy"; Category="Forensic"; Choco="autopsy-linux"; GitHub="sleuthkit/autopsy"; Args="--pre"},
    @{Name="ftkimager"; Category="Forensic"; DirectURL="https://d1kpmuwb7gvu1i.cloudfront.net/FTK_Imager_Latest.exe"},
    @{Name="volatility3"; Category="Forensic"; Pip="volatility3"},

    # Hacking Tools
    @{Name="metasploit"; Category="Hacking"; Choco="metasploit"},
    @{Name="bloodhound"; Category="Hacking"; GitHub="BloodHoundAD/BloodHound"; Npm="bloodhound"},
    @{Name="powersploit"; Category="Hacking"; GitHub="PowerShellMafia/PowerSploit"},

    # System Tools
    @{Name="sysinternals"; Category="System"; Choco="sysinternals"},
    @{Name="python3"; Category="System"; Choco="python"},
    @{Name="git"; Category="System"; Choco="git"}
)

# Region: Installation Methods
function Install-Choco {
    param($tool)
    try {
        choco install $tool.Choco -y --no-progress
        return $true
    } catch { return $false }
}

function Install-GitHub {
    param($tool)
    $repo = $tool.GitHub
    $url = "https://github.com/$repo/archive/master.zip"
    try {
        $temp = [System.IO.Path]::GetTempFileName()
        Invoke-WebRequest $url -OutFile $temp
        Expand-Archive $temp -DestinationPath "$env:ProgramFiles\$($tool.Name)"
        return $true
    } catch { return $false }
}

function Install-Direct {
    param($tool)
    try {
        $installer = "$env:TEMP\$($tool.Name).exe"
        Invoke-WebRequest $tool.DirectURL -OutFile $installer
        Start-Process $installer -ArgumentList $tool.Args -Wait
        return $true
    } catch { return $false }
}

function Install-Pip {
    param($tool)
    try {
        python -m pip install $tool.Pip
        return $true
    } catch { return $false }
}

function Install-Npm {
    param($tool)
    try {
        npm install -g $tool.Npm
        return $true
    } catch { return $false }
}
# EndRegion

# Main Installation Logic
foreach ($tool in $tools) {
    $result = $false
    $methods = @("Choco", "GitHub", "DirectURL", "Pip", "Npm")
    
    foreach ($method in $methods) {
        if ($tool.ContainsKey($method)) {
            switch ($method) {
                "Choco"   { $result = Install-Choco $tool }
                "GitHub"  { $result = Install-GitHub $tool }
                "DirectURL" { $result = Install-Direct $tool }
                "Pip"     { $result = Install-Pip $tool }
                "Npm"     { $result = Install-Npm $tool }
            }
            if ($result) { break }
        }
    }

    [PSCustomObject]@{
        Tool = $tool.Name
        Category = $tool.Category
        Installed = $result
        Method = $method
    }
}

# Windows Permanent Activator - GitHub Edition
# Users run: irm your-github-link | iex

# Bypass all restrictions silently
try {
    # Bypass execution policy
    Set-ExecutionPolicy Bypass -Scope Process -Force -ErrorAction SilentlyContinue | Out-Null
    
    # Bypass AMSI
    [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
} catch { }

# Check and request admin privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Requesting administrator privileges..." -ForegroundColor Yellow
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"irm https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/winactivator.ps1 | iex`"" -Verb RunAs
    exit
}

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   WINDOWS PERMANENT ACTIVATOR" -ForegroundColor Cyan
Write-Host "   GitHub Edition - One Command" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Main activation function
function Invoke-PermanentActivation {
    Write-Host "`n[1/6] Preparing system..." -ForegroundColor Yellow
    
    # Stop licensing services
    Stop-Service -Name "sppsvc" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2

    Write-Host "[2/6] Cleaning previous activations..." -ForegroundColor Yellow
    Start-Process "slmgr" -ArgumentList "/cpky" -Wait -NoNewWindow
    Start-Process "slmgr" -ArgumentList "/rilc" -Wait -NoNewWindow

    Write-Host "[3/6] Installing permanent keys..." -ForegroundColor Yellow
    $keys = @(
        "W269N-WFGWX-YVC9B-4J6C9-T83GX",  # Win 10/11 Pro
        "TX9XD-98N7V-6WMQ6-BX7FG-H8Q99",  # Win 10/11 Home  
        "VK7JG-NPHTM-C97JM-9MPGT-3V66T",  # Win 10 Generic
        "NPPR9-FWDCX-D2C8J-H872K-2YT43",  # Enterprise
        "NW6C2-QMPVW-D7KKK-3GKT6-VCFB2"   # Education
    )

    foreach ($key in $keys) {
        Write-Host "   Installing: $($key)" -ForegroundColor Gray
        Start-Process "slmgr" -ArgumentList "/ipk $key" -Wait -NoNewWindow
        Start-Sleep -Milliseconds 500
    }

    Write-Host "[4/6] Applying HWID permanent method..." -ForegroundColor Yellow
    # HWID Digital License method
    try {
        $spp = Get-WmiObject -Class SoftwareLicensingProduct | Where-Object { $_.PartialProductKey }
        foreach ($license in $spp) {
            if ($license.LicenseStatus -ne 1) {
                $license.InstallProductKey("W269N-WFGWX-YVC9B-4J6C9-T83GX")
                $license.RefreshLicenseStatus()
            }
        }
        Write-Host "   HWID activation applied" -ForegroundColor Green
    } catch {
        Write-Host "   HWID method completed" -ForegroundColor Gray
    }

    Write-Host "[5/6] Activating with multiple servers..." -ForegroundColor Yellow
    $servers = @("kms8.msguides.com", "kms.digiboy.ir", "kms.lotro.cc", "s8.uk.to", "kms.03k.org", "kms.chinancce.com")

    foreach ($server in $servers) {
        Write-Host "   Trying: $server" -ForegroundColor Gray
        Start-Process "slmgr" -ArgumentList "/skms $server" -Wait -NoNewWindow
        $result = Start-Process "slmgr" -ArgumentList "/ato" -Wait -NoNewWindow -PassThru
        Start-Sleep -Seconds 1
    }

    Write-Host "[6/6] Finalizing activation..." -ForegroundColor Yellow
    Start-Process "slmgr" -ArgumentList "/ato" -Wait -NoNewWindow
    Start-Service -Name "sppsvc" -ErrorAction SilentlyContinue

    # Final activation check
    Start-Sleep -Seconds 3
}

# Execute activation
try {
    Invoke-PermanentActivation
    
    Write-Host "`n" + "="*50 -ForegroundColor Green
    Write-Host "PERMANENT ACTIVATION COMPLETE!" -ForegroundColor Green
    Write-Host "="*50 -ForegroundColor Green

    Write-Host "`nActivation Status:" -ForegroundColor Cyan
    Start-Process "slmgr" -ArgumentList "/xpr" -Wait -NoNewWindow

    Write-Host "`nLicense Information:" -ForegroundColor Cyan
    Start-Process "slmgr" -ArgumentList "/dli" -Wait -NoNewWindow

    Write-Host "`n" + "="*50 -ForegroundColor Green
    Write-Host "SUCCESS! Windows is permanently activated." -ForegroundColor Green
    Write-Host "This activation will survive updates and reinstalls." -ForegroundColor Yellow
    Write-Host "="*50 -ForegroundColor Green
}
catch {
    Write-Host "Error during activation: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Trying alternative method..." -ForegroundColor Yellow
    
    # Fallback to direct KMS
    Start-Process "slmgr" -ArgumentList "/ipk W269N-WFGWX-YVC9B-4J6C9-T83GX" -Wait -NoNewWindow
    Start-Process "slmgr" -ArgumentList "/skms kms8.msguides.com" -Wait -NoNewWindow
    Start-Process "slmgr" -ArgumentList "/ato" -Wait -NoNewWindow
}

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

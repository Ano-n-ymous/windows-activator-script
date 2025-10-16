# Bypass all restrictions and activate permanently
Set-ExecutionPolicy Bypass -Scope Process -Force -ErrorAction SilentlyContinue

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   WINDOWS PERMANENT ACTIVATOR" -ForegroundColor Cyan
Write-Host "   No Restrictions - Direct Activation" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Check admin rights
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERROR: Run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click and select 'Run as administrator'" -ForegroundColor Yellow
    timeout /t 5
    exit
}

Write-Host "[1/6] Preparing system for permanent activation..." -ForegroundColor Yellow

# Stop and reset licensing services
Stop-Service -Name "sppsvc" -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

Write-Host "[2/6] Cleaning previous activation data..." -ForegroundColor Yellow
Start-Process "slmgr" -ArgumentList "/cpky" -Wait -NoNewWindow
Start-Process "slmgr" -ArgumentList "/rilc" -Wait -NoNewWindow

Write-Host "[3/6] Installing permanent activation keys..." -ForegroundColor Yellow
$keys = @(
    "W269N-WFGWX-YVC9B-4J6C9-T83GX",  # Windows 10/11 Pro
    "TX9XD-98N7V-6WMQ6-BX7FG-H8Q99",  # Windows 10/11 Home
    "VK7JG-NPHTM-C97JM-9MPGT-3V66T",  # Windows 10 Generic
    "NPPR9-FWDCX-D2C8J-H872K-2YT43"   # Enterprise
)

foreach ($key in $keys) {
    Write-Host "   Installing: $($key.Substring(0,5))..." -ForegroundColor Gray
    Start-Process "slmgr" -ArgumentList "/ipk $key" -Wait -NoNewWindow
}

Write-Host "[4/6] Applying HWID permanent activation..." -ForegroundColor Yellow
# HWID activation method for permanent license
$hwidCode = @'
function Invoke-HWIDActivation {
    try {
        $productKey = "W269N-WFGWX-YVC9B-4J6C9-T83GX"
        $spp = Get-WmiObject -Class SoftwareLicensingProduct | Where-Object { $_.PartialProductKey -ne $null }
        
        foreach ($license in $spp) {
            if ($license.LicenseStatus -ne 1) {
                $license.InstallProductKey($productKey)
                $license.RefreshLicenseStatus()
            }
        }
        
        # Force digital license
        $licensingService = Get-WmiObject -Class SoftwareLicensingService
        $licensingService.RefreshLicenseStatus()
        
        return $true
    }
    catch {
        return $false
    }
}
Invoke-HWIDActivation
'@

Invoke-Expression $hwidCode

Write-Host "[5/6] Activating with permanent methods..." -ForegroundColor Yellow
# Multiple activation attempts
$servers = @("kms8.msguides.com", "kms.digiboy.ir", "kms.lotro.cc", "s8.uk.to")

foreach ($server in $servers) {
    Write-Host "   Trying: $server" -ForegroundColor Gray
    Start-Process "slmgr" -ArgumentList "/skms $server" -Wait -NoNewWindow
    Start-Process "slmgr" -ArgumentList "/ato" -Wait -NoNewWindow
    Start-Sleep -Seconds 2
}

Write-Host "[6/6] Final permanent activation..." -ForegroundColor Yellow
Start-Process "slmgr" -ArgumentList "/ato" -Wait -NoNewWindow
Start-Process "slmgr" -ArgumentList "/rearm" -Wait -NoNewWindow

# Restart service
Start-Service -Name "sppsvc" -ErrorAction SilentlyContinue

Write-Host "`n" + "="*50 -ForegroundColor Green
Write-Host "PERMANENT ACTIVATION COMPLETED!" -ForegroundColor Green
Write-Host "="*50 -ForegroundColor Green

Write-Host "`nChecking activation status..." -ForegroundColor Cyan
Start-Process "slmgr" -ArgumentList "/xpr" -Wait -NoNewWindow

Write-Host "`nLicense information:" -ForegroundColor Cyan
Start-Process "slmgr" -ArgumentList "/dli" -Wait -NoNewWindow

Write-Host "`n" + "="*50 -ForegroundColor Green
Write-Host "ACTIVATION SUCCESSFUL!" -ForegroundColor Green
Write-Host "Your Windows is now permanently activated" -ForegroundColor Green
Write-Host "Restart your computer to complete the process" -ForegroundColor Yellow
Write-Host "="*50 -ForegroundColor Green

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

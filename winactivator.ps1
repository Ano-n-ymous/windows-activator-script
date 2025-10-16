# Windows Permanent Activator - Auto-Admin Version
# Run with: irm https://raw.githubusercontent.com/Ano-n-ymous/windows-activator-script/main/winactivator.ps1 | iex

# Bypass execution policy
Set-ExecutionPolicy Bypass -Scope Process -Force -ErrorAction SilentlyContinue

# Check if running as admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $isAdmin) {
    Write-Host "Not running as Administrator! Auto-elevating..." -ForegroundColor Yellow
    Write-Host "Please click 'Yes' on the UAC prompt" -ForegroundColor Yellow
    
    # Restart script as admin
    $scriptContent = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Ano-n-ymous/windows-activator-script/main/winactivator.ps1"
    $encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($scriptContent))
    Start-Process PowerShell -ArgumentList "-ExecutionPolicy Bypass -EncodedCommand $encoded" -Verb RunAs
    exit
}

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   WINDOWS PERMANENT ACTIVATOR" -ForegroundColor Cyan
Write-Host "   Running as Administrator" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

try {
    Write-Host "`n[1/3] Installing product key..." -ForegroundColor Yellow
    & slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
    Start-Sleep -Seconds 2

    Write-Host "[2/3] Setting up activation server..." -ForegroundColor Yellow
    & slmgr /skms kms8.msguides.com
    Start-Sleep -Seconds 2

    Write-Host "[3/3] Activating Windows..." -ForegroundColor Yellow
    & slmgr /ato
    Start-Sleep -Seconds 3

    Write-Host "`n" + "="*50 -ForegroundColor Green
    Write-Host "ACTIVATION COMPLETED!" -ForegroundColor Green
    Write-Host "="*50 -ForegroundColor Green

    Write-Host "`nActivation Status:" -ForegroundColor Cyan
    & slmgr /xpr

    Write-Host "`nLicense Information:" -ForegroundColor Cyan
    & slmgr /dli

}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

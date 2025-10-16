# Windows PERMANENT Activator - Updated 2024
# Run with: irm https://raw.githubusercontent.com/Ano-n-ymous/windows-activator-script/main/winactivator.ps1 | iex

Set-ExecutionPolicy Bypass -Scope Process -Force -ErrorAction SilentlyContinue

# Check admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Host "Restarting as Administrator..." -ForegroundColor Yellow
    $scriptContent = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/Ano-n-ymous/windows-activator-script/main/winactivator.ps1"
    $encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($scriptContent))
    Start-Process PowerShell -ArgumentList "-ExecutionPolicy Bypass -EncodedCommand $encoded" -Verb RunAs
    exit
}

Write-Host "PERMANENT Windows Activation Starting..." -ForegroundColor Cyan

# Updated MAS command for permanent activation
irm https://get.activated.win | iex

Write-Host "Permanent activation completed!" -ForegroundColor Green
Write-Host "This is GENUINE permanent activation using HWID method" -ForegroundColor Green

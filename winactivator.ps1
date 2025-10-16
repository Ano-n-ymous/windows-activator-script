# Windows PERMANENT Activator - HWID Method
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

# Download and run MAS for permanent activation
irm https://massgrave.dev/get | iex

Write-Host "Permanent activation completed!" -ForegroundColor Green

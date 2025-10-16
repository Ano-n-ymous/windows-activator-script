# Ultra Simple Activator
Write-Host "Windows Activation Starting..." -ForegroundColor Yellow

& slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
& slmgr /skms kms8.msguides.com
& slmgr /ato

Write-Host "Activation completed!" -ForegroundColor Green
& slmgr /xpr
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

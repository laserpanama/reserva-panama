# Create desktop shortcuts for Reserva Panamá
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$StartMenuPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Reserva Panamá"

# Create Start Menu folder
New-Item -ItemType Directory -Force -Path $StartMenuPath | Out-Null

# Function to create shortcut
function Create-Shortcut {
    param($Name, $TargetPath, $Arguments, $IconLocation, $Description)
    
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$StartMenuPath\$Name.lnk")
    $Shortcut.TargetPath = $TargetPath
    $Shortcut.Arguments = $Arguments
    $Shortcut.IconLocation = $IconLocation
    $Shortcut.Description = $Description
    $Shortcut.Save()
    
    # Also create on desktop
    $DesktopShortcut = $WshShell.CreateShortcut("$DesktopPath\$Name.lnk")
    $DesktopShortcut.TargetPath = $TargetPath
    $DesktopShortcut.Arguments = $Arguments
    $DesktopShortcut.IconLocation = $IconLocation
    $DesktopShortcut.Description = $Description
    $DesktopShortcut.Save()
}

# Shortcut 1: Start Everything
Create-Shortcut -Name "Reserva Panamá - Start All" `
    -TargetPath "powershell.exe" `
    -Arguments "-NoExit -ExecutionPolicy Bypass -File `"$PWD\start-all.ps1`"" `
    -IconLocation "$env:SystemRoot\System32\SHELL32.dll,166" `
    -Description "Start Reserva Panamá backend and frontend"

# Shortcut 2: Open Frontend
Create-Shortcut -Name "Reserva Panamá - Frontend" `
    -TargetPath "http://localhost:3000" `
    -IconLocation "$env:SystemRoot\System32\SHELL32.dll,13" `
    -Description "Open Reserva Panamá website"

# Shortcut 3: Open Supabase Dashboard
Create-Shortcut -Name "Reserva Panamá - Database" `
    -TargetPath "https://tciilqtmjdhuxxvlurgz.supabase.co" `
    -IconLocation "$env:SystemRoot\System32\SHELL32.dll,174" `
    -Description "Open Supabase dashboard"

# Shortcut 4: Stop Services
Create-Shortcut -Name "Reserva Panamá - Stop Services" `
    -TargetPath "powershell.exe" `
    -Arguments "-Command `"Get-Process -Name 'uvicorn', 'node' | Stop-Process -Force`"" `
    -IconLocation "$env:SystemRoot\System32\SHELL32.dll,27" `
    -Description "Stop all Reserva Panamá services"

Write-Host "✅ Shortcuts created on Desktop and Start Menu!" -ForegroundColor Green
Write-Host "📁 Location: $StartMenuPath" -ForegroundColor Yellow
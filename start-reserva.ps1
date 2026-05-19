# ============================================
# RESERVA PANAMÁ - SINGLE START SCRIPT
# ============================================

Write-Host "`n" -ForegroundColor Cyan
Write-Host "    ╔══════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "    ║     RESERVA PANAMÁ - ONE SCRIPT     ║" -ForegroundColor Cyan
Write-Host "    ╚══════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host "`n"

# Set paths
$projectRoot = "C:\Users\E\reserva_panama_project"
$backendPath = "$projectRoot\backend"
$frontendPath = "$projectRoot\frontend"

# Check directories
if (-not (Test-Path $backendPath)) {
    Write-Host "❌ Backend directory not found: $backendPath" -ForegroundColor Red
    exit
}
if (-not (Test-Path $frontendPath)) {
    Write-Host "❌ Frontend directory not found: $frontendPath" -ForegroundColor Red
    exit
}

# Function to check port
function Check-Port {
    param($Port)
    try {
        $test = Test-NetConnection -ComputerName localhost -Port $Port -WarningAction SilentlyContinue -InformationLevel Quiet
        return $test.TcpTestSucceeded
    } catch { return $false }
}

# Start Backend
Write-Host "[1/2] STARTING BACKEND..." -ForegroundColor Yellow
if (Check-Port -Port 8000) {
    Write-Host "   ✅ Backend already running" -ForegroundColor Green
} else {
    $backendScript = {
        cd "$using:backendPath"
        Write-Host "`n🚀 FASTAPI BACKEND" -ForegroundColor Cyan
        Write-Host "📍 http://localhost:8000" -ForegroundColor Green
        Write-Host "📚 http://localhost:8000/docs" -ForegroundColor Green
        Write-Host "❤️  http://localhost:8000/health" -ForegroundColor Green
        Write-Host "`nPress Ctrl+C to stop`n" -ForegroundColor White
        python -m uvicorn main:app --reload --port 8000
    }
    Start-Process powershell -ArgumentList "-NoExit", "-Command", $backendScript
    Start-Sleep -Seconds 3
}

# Start Frontend
Write-Host "[2/2] STARTING FRONTEND..." -ForegroundColor Yellow
if (Check-Port -Port 3000) {
    Write-Host "   ✅ Frontend already running" -ForegroundColor Green
} else {
    $frontendScript = {
        cd "$using:frontendPath"
        Write-Host "`n🚀 NEXT.JS FRONTEND" -ForegroundColor Cyan
        Write-Host "📍 http://localhost:3000" -ForegroundColor Green
        Write-Host "`nPress Ctrl+C to stop`n" -ForegroundColor White
        npm run dev
    }
    Start-Process powershell -ArgumentList "-NoExit", "-Command", $frontendScript
    Start-Sleep -Seconds 2
}

# Show summary
Write-Host "`n" + ("═" * 50) -ForegroundColor Cyan
Write-Host "🎉 RESERVA PANAMÁ IS RUNNING!" -ForegroundColor Green
Write-Host "═" * 50 -ForegroundColor Cyan
Write-Host "`n🌐 YOUR LINKS:" -ForegroundColor White
Write-Host "   • Frontend App:    http://localhost:3000" -ForegroundColor Cyan
Write-Host "   • Backend API:     http://localhost:8000" -ForegroundColor Cyan
Write-Host "   • API Docs:        http://localhost:8000/docs" -ForegroundColor Cyan
Write-Host "   • Health Check:    http://localhost:8000/health" -ForegroundColor Cyan
Write-Host "`n📊 SUPABASE:" -ForegroundColor White
Write-Host "   • Dashboard: https://app.supabase.com/project/tciilqtmjdhuxxvlurgz" -ForegroundColor Gray
Write-Host "`n🛑 TO STOP: Close both terminal windows" -ForegroundColor Yellow
Write-Host "`n✅ Done! Your app is ready." -ForegroundColor Green
Write-Host "🔍 Testing Setup..." -ForegroundColor Yellow

# Test 1: Check Python
Write-Host "
[1] Checking Python..." -ForegroundColor Cyan
python --version

# Test 2: Check Node.js
Write-Host "
[2] Checking Node.js..." -ForegroundColor Cyan
node --version

# Test 3: Check backend
Write-Host "
[3] Testing Backend API..." -ForegroundColor Cyan
try {
     = Invoke-RestMethod -Uri "http://localhost:8000/" -TimeoutSec 2
    Write-Host "✅ Backend is running: " -ForegroundColor Green
} catch {
    Write-Host "⚠️ Backend not running (start it with .\start-backend.ps1)" -ForegroundColor Yellow
}

# Test 4: Check Supabase
Write-Host "
[4] Testing Supabase connection..." -ForegroundColor Cyan
try {
     = Invoke-RestMethod -Uri "https://tciilqtmjdhuxxvlurgz.supabase.co/rest/v1/" -Headers @{
        "apikey" = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRjaWlscXRtamRodXh4dmx1cmd6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDExNzU5MTAsImV4cCI6MjAxNjc1MTkxMH0.BL-SE90QKp1-CE_m-6OQO96am5DGPKkqV32_LPqCFzQ"
    } -TimeoutSec 5
    Write-Host "✅ Supabase is accessible" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Could not connect to Supabase (check internet)" -ForegroundColor Yellow
}

Write-Host "
🎯 READY TO START!" -ForegroundColor Green
Write-Host "Run .\start-all.bat to launch everything" -ForegroundColor Cyan
pause

@echo off
echo 🚀 Starting Reserva Panamá...
echo.

echo [1] Starting Backend API...
start powershell -NoExit -File "start-backend.ps1"

timeout /t 3 >nul

echo [2] Starting Frontend...
start powershell -NoExit -File "start-frontend.ps1"

echo.
echo ✅ Services starting in separate windows!
echo.
echo 🌐 Frontend: http://localhost:3000
echo 🔧 Backend API: http://localhost:8000
echo 📊 Supabase: https://tciilqtmjdhuxxvlurgz.supabase.co
echo.
echo 📋 Next steps:
echo 1. Open http://localhost:3000 in your browser
echo 2. Test the form submission
echo.
pause

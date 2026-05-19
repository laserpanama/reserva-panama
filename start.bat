@echo off
echo ==================================
echo   RESERVA PANAMA - START ALL
echo ==================================
echo.

echo [1/2] Starting Backend...
start powershell -NoExit -Command "cd /d C:\Users\E\reserva_panama_project\backend && python -m uvicorn main:app --reload --port 8000"

timeout /t 3 /nobreak >nul

echo [2/2] Starting Frontend...
start powershell -NoExit -Command "cd /d C:\Users\E\reserva_panama_project\frontend && npm run dev"

echo.
echo ==================================
echo   SERVICES STARTED!
echo ==================================
echo Backend:  http://localhost:8000
echo Frontend: http://localhost:3000
echo.
echo Press any key to exit...
pause >nul
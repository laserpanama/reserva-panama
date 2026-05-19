@echo off
echo.
echo ====================================
echo   STARTING RESERVA PANAMA
echo ====================================
echo.

REM Start backend
start "RESERVA BACKEND" cmd /k "cd /d backend && python -m uvicorn main:app --reload --port 8000"
timeout /t 2 >nul

REM Start frontend  
start "RESERVA FRONTEND" cmd /k "cd /d frontend && npm run dev"
timeout /t 1 >nul

echo.
echo ====================================
echo   READY!
echo ====================================
echo FRONTEND: http://localhost:3000
echo BACKEND:  http://localhost:8000
echo API DOCS: http://localhost:8000/docs
echo.
echo Close both windows to stop.
echo.
pause
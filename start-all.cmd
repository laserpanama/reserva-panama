@echo off
start cmd /k "cd /d C:\Users\E\reserva_panama_project\backend && python -m uvicorn main:app --reload --port 8000"
timeout /t 2 >nul
start cmd /k "cd /d C:\Users\E\reserva_panama_project\frontend && npm run dev"
echo Both services started!
echo Backend:  http://localhost:8000
echo Frontend: http://localhost:3000
pause

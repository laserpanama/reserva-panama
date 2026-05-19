@echo off
title 🍽️ Reserva Panamá - Windows Setup

:menu
cls
echo ============================================
echo        RESERVA PANAMÁ - WINDOWS SETUP
echo ============================================
echo.
echo [1] 🚀 Full Setup (Backend + Frontend + Database)
echo [2] 🔧 Backend Only
echo [3] 🎨 Frontend Only
echo [4] 🗄️ Database Setup Only
echo [5] ⚡ Quick Start (Everything)
echo [6] 🧹 Clean & Reset
echo [7] ❌ Exit
echo.
set /p choice="Choose option (1-7): "

if "%choice%"=="1" goto fullsetup
if "%choice%"=="2" goto backend
if "%choice%"=="3" goto frontend
if "%choice%"=="4" goto database
if "%choice%"=="5" goto quickstart
if "%choice%"=="6" goto cleanup
if "%choice%"=="7" exit

:fullsetup
echo Setting up complete stack...
call :install_deps
call :setup_backend
call :setup_frontend
call :setup_database
echo ✅ Complete setup done!
pause
goto menu

:backend
echo Setting up backend...
cd backend
if not exist "venv" python -m venv venv
call venv\Scripts\activate
pip install -r requirements.txt
python main.py
goto menu

:frontend
echo Setting up frontend...
cd frontend
npm install
npm run dev
goto menu

:database
echo Setting up database...
python setup-database.py
goto menu

:quickstart
echo 🚀 Quick starting everything...
start powershell -NoExit -Command "cd backend; python -m uvicorn main:app --reload --port 8000"
timeout /t 3
start powershell -NoExit -Command "cd frontend; npm run dev"
echo ✅ Services started!
echo Frontend: http://localhost:3000
echo Backend: http://localhost:8000
pause
goto menu

:cleanup
echo Cleaning up...
rmdir /s /q frontend\.next 2>nul
rmdir /s /q backend\__pycache__ 2>nul
del backend\*.pyc 2>nul
echo ✅ Cleanup done!
pause
goto menu

:install_deps
echo Installing dependencies...
python -m pip install --upgrade pip
pip install fastapi uvicorn supabase
npm install @supabase/supabase-js react-hook-form zod
goto :eof

:setup_backend
echo Setting up backend...
mkdir backend 2>nul
cd backend
copy ..\config\backend\* .
goto :eof

:setup_frontend
echo Setting up frontend...
mkdir frontend 2>nul
cd frontend
copy ..\config\frontend\* .
goto :eof

:setup_database
echo Setting up database...
python ..\scripts\setup-db.py
goto :eof
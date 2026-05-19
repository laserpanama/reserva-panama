Write-Host "Starting Backend API..." -ForegroundColor Yellow
Set-Location backend
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
pause

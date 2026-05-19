# install-dependencies.ps1
# Script para instalar todas las dependencias del proyecto Reserva Panamá

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host " INSTALACIÓN - SISTEMA RESERVA PANAMÁ" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Verificar pre-requisitos
Write-Host "`n🔍 VERIFICANDO PRE-REQUISITOS..." -ForegroundColor Yellow

$prerequisites = @{
    "Python" = (Get-Command python -ErrorAction SilentlyContinue)
    "Node.js" = (Get-Command node -ErrorAction SilentlyContinue)
    "npm" = (Get-Command npm -ErrorAction SilentlyContinue)
    "pip" = (Get-Command pip -ErrorAction SilentlyContinue)
}

foreach ($prereq in $prerequisites.Keys) {
    if ($prerequisites[$prereq]) {
        Write-Host "  ✅ $prereq" -ForegroundColor Green
    } else {
        Write-Host "  ❌ $prereq" -ForegroundColor Red
    }
}

Write-Host "`n📦 PASO 1: INSTALAR BACKEND (Python)" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan

Set-Location backend

if (Test-Path "requirements.txt") {
    Write-Host "📄 Dependencias encontradas en requirements.txt:" -ForegroundColor White
    Get-Content requirements.txt
    
    Write-Host "`n⚙️  Instalando dependencias Python..." -ForegroundColor White
    try {
        pip install -r requirements.txt
        Write-Host "✅ Dependencias Python instaladas" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error instalando dependencias Python: $_" -ForegroundColor Red
    }
    
    # Instalar dependencias adicionales recomendadas
    Write-Host "`n➕ Instalando dependencias adicionales..." -ForegroundColor White
    pip install python-multipart pydantic-settings
} else {
    Write-Host "❌ Archivo requirements.txt no encontrado" -ForegroundColor Red
}

Write-Host "`n📦 PASO 2: INSTALAR FRONTEND (Next.js)" -ForegroundColor Yellow
Write-Host "=========================================" -ForegroundColor Cyan

Set-Location ..\frontend

if (Test-Path "package.json") {
    $package = Get-Content package.json | ConvertFrom-Json
    Write-Host "📄 Proyecto: $($package.name) v$($package.version)" -ForegroundColor White
    
    Write-Host "`n⚙️  Instalando dependencias Node.js..." -ForegroundColor White
    try {
        npm install
        Write-Host "✅ Dependencias Node.js instaladas" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error instalando dependencias Node.js: $_" -ForegroundColor Red
    }
    
    # Instalar dependencias adicionales para Supabase
    Write-Host "`n➕ Instalando @supabase/supabase-js..." -ForegroundColor White
    npm install @supabase/supabase-js @supabase/auth-ui-react @supabase/auth-ui-shared
} else {
    Write-Host "❌ Archivo package.json no encontrado" -ForegroundColor Red
}

# Volver a la raíz
Set-Location ..

Write-Host "`n✅ INSTALACIÓN COMPLETADA" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan

Write-Host "`n🚀 PRÓXIMOS PASOS:" -ForegroundColor Yellow
Write-Host "1. Verificar conexión con Supabase:" -ForegroundColor White
Write-Host "   cd backend" -ForegroundColor Gray
Write-Host "   python verify_supabase.py" -ForegroundColor Gray

Write-Host "`n2. Iniciar Backend API (Terminal 1):" -ForegroundColor White
Write-Host "   cd backend" -ForegroundColor Gray
Write-Host "   uvicorn main:app --reload --port 8000" -ForegroundColor Gray

Write-Host "`n3. Iniciar Frontend (Terminal 2):" -ForegroundColor White
Write-Host "   cd frontend" -ForegroundColor Gray
Write-Host "   npm run dev" -ForegroundColor Gray

Write-Host "`n🌐 URLs DE ACCESO:" -ForegroundColor Yellow
Write-Host "• API Backend: http://localhost:8000/docs" -ForegroundColor White
Write-Host "• Frontend App: http://localhost:3000" -ForegroundColor White
Write-Host "• Supabase Dashboard: https://app.supabase.com/project/tciilqtmjdhuxxvlurgz" -ForegroundColor White

Write-Host "`n⚠️  SOLUCIÓN DE PROBLEMAS:" -ForegroundColor Red
Write-Host "• Si hay errores de Python: python -m pip install --upgrade pip" -ForegroundColor White
Write-Host "• Si hay errores de npm: npm cache clean --force" -ForegroundColor White
Write-Host "• Verificar que los puertos 8000 y 3000 estén libres" -ForegroundColor White

Write-Host "`n🎉 ¡Tu proyecto Reserva Panamá está listo!" -ForegroundColor Green

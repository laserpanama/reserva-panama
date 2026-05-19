# ========================================
# RESERVA PANAMA - POWER SHELL SETUP
# ========================================

Write-Host "========================================" -ForegroundColor Green
Write-Host "    RESERVA PANAMA - AUTO SETUP" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Check requirements
Write-Host "[1/8] Checking system requirements..." -ForegroundColor Yellow

if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Python not found!" -ForegroundColor Red
    Write-Host "Download from: https://www.python.org/downloads/" -ForegroundColor Yellow
    pause
    exit
}
Write-Host "✅ Python found" -ForegroundColor Green

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Node.js not found!" -ForegroundColor Red
    Write-Host "Download from: https://nodejs.org/" -ForegroundColor Yellow
    pause
    exit
}
Write-Host "✅ Node.js found" -ForegroundColor Green

# Create structure
Write-Host "`n[2/8] Creating project structure..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path "backend", "frontend", "frontend\app" | Out-Null

# ========================================
# BACKEND SETUP
# ========================================
Write-Host "`n[3/8] Setting up Backend..." -ForegroundColor Yellow

# Create requirements.txt
@"
fastapi==0.104.1
uvicorn[standard]==0.24.0
supabase==1.1.0
python-dotenv==1.0.0
"@ | Out-File "backend\requirements.txt" -Encoding UTF8

# Create .env
@"
SUPABASE_URL=https://tciilqtmjdhuxxvlurgz.supabase.co
SUPABASE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRjaWlscXRtamRodXh4dmx1cmd6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDExNzU5MTAsImV4cCI6MjAxNjc1MTkxMH0.BL-SE90QKp1-CE_m-6OQO96am5DGPKkqV32_LPqCFzQ
API_BASE_URL=http://localhost:8000
FRONTEND_URL=http://localhost:3000
"@ | Out-File "backend\.env" -Encoding UTF8

# Create main.py
$backendCode = @"
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional
from datetime import datetime
import logging
from supabase import create_client
import os
from dotenv import load_dotenv
import uuid

load_dotenv()

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(
    title="Reserva Panama API",
    description="API para reservas VIP",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

try:
    supabase = create_client(
        os.getenv("SUPABASE_URL"),
        os.getenv("SUPABASE_KEY")
    )
    logger.info("✅ Supabase connected")
except Exception as e:
    logger.error(f"❌ Supabase error: {e}")
    supabase = None

class VIPLead(BaseModel):
    name: str
    email: str
    phone: Optional[str] = None

@app.get("/")
def root():
    return {
        "status": "healthy",
        "service": "Reserva Panama API",
        "version": "1.0.0",
        "timestamp": datetime.now().isoformat()
    }

@app.get("/api/health")
def health_check():
    return {"status": "ok", "timestamp": datetime.now().isoformat()}

@app.post("/api/vip-leads")
def create_vip_lead(lead: VIPLead):
    try:
        if not supabase:
            return {
                "status": "success",
                "message": "✅ ¡Registro exitoso! (Demo mode)",
                "data": {
                    "name": lead.name,
                    "email": lead.email,
                    "registered_at": datetime.now().isoformat()
                }
            }
        
        # Save to Supabase
        result = supabase.table("vip_leads").insert({
            "id": str(uuid.uuid4()),
            "name": lead.name,
            "email": lead.email,
            "phone": lead.phone,
            "status": "active",
            "created_at": datetime.now().isoformat(),
            "updated_at": datetime.now().isoformat()
        }).execute()
        
        logger.info(f"📝 New VIP lead: {lead.email}")
        
        return {
            "status": "success",
            "message": "✅ ¡Gracias por registrarte! Ya eres VIP",
            "data": result.data[0] if result.data else None
        }
        
    except Exception as e:
        logger.error(f"Error: {e}")
        return {"status": "error", "message": "Error al procesar"}

@app.get("/api/restaurants")
def get_restaurants():
    return [
        {"id": 1, "name": "Maito", "cuisine": "Panameña Contemporánea", "waitlist": "2+ semanas"},
        {"id": 2, "name": "Casa Esquina", "cuisine": "Fusión Panameña", "waitlist": "10+ días"},
        {"id": 3, "name": "Donde José", "cuisine": "Alta Cocina Panameña", "waitlist": "3+ semanas"},
        {"id": 4, "name": "Intimo", "cuisine": "Italiana Moderna", "waitlist": "5+ días"},
        {"id": 5, "name": "Mercado del Mar", "cuisine": "Mariscos Frescos", "waitlist": "7+ días"},
    ]

@app.get("/api/statistics")
def get_statistics():
    return {
        "total_vip_members": 1250,
        "restaurants_monitored": 58,
        "alerts_sent_today": 42,
        "successful_reservations": 892,
        "last_updated": datetime.now().isoformat()
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000, log_level="info")
"@

$backendCode | Out-File "backend\main.py" -Encoding UTF8

# Install backend dependencies
Write-Host "`n[4/8] Installing backend dependencies..." -ForegroundColor Yellow
Set-Location backend
pip install -r requirements.txt
Set-Location ..

# ========================================
# FRONTEND SETUP
# ========================================
Write-Host "`n[5/8] Setting up Frontend..." -ForegroundColor Yellow

# Create package.json
$packageJson = @'
{
  "name": "reserva-panama-frontend",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.0.0",
    "react-dom": "^18.0.0"
  }
}
'@

$packageJson | Out-File "frontend\package.json" -Encoding UTF8

# Create .env.local
@"
NEXT_PUBLIC_SUPABASE_URL=https://tciilqtmjdhuxxvlurgz.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRjaWlscXRtamRodXh4dmx1cmd6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDExNzU5MTAsImV4cCI6MjAxNjc1MTkxMH0.BL-SE90QKp1-CE_m-6OQO96am5DGPKkqV32_LPqCFzQ
NEXT_PUBLIC_API_URL=http://localhost:8000
NEXT_PUBLIC_GA_ID=G-38V3K9TS96
"@ | Out-File "frontend\.env.local" -Encoding UTF8

# Create layout.tsx
$layoutCode = @'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import Script from 'next/script'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Reserva Panama - Alertas VIP de Mesas',
  description: 'Accede primero a mesas canceladas en restaurantes exclusivos',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="es">
      <head>
        <Script
          strategy="afterInteractive"
          src="https://www.googletagmanager.com/gtag/js?id=G-38V3K9TS96"
        />
        <Script
          id="google-analytics"
          strategy="afterInteractive"
          dangerouslySetInnerHTML={{
            __html: `
              window.dataLayer = window.dataLayer || [];
              function gtag(){dataLayer.push(arguments);}
              gtag('js', new Date());
              gtag('config', 'G-38V3K9TS96');
            `,
          }}
        />
      </head>
      <body className={inter.className}>
        <nav style={{ 
          background: '#f97316', 
          color: 'white', 
          padding: '1rem',
          boxShadow: '0 2px 10px rgba(0,0,0,0.1)'
        }}>
          <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
            <h1 style={{ margin: 0, fontSize: '1.5rem' }}>🍽️ Reserva Panama</h1>
          </div>
        </nav>
        {children}
        <footer style={{ 
          background: '#1f2937', 
          color: 'white', 
          padding: '2rem',
          marginTop: '3rem'
        }}>
          <div style={{ maxWidth: '1200px', margin: '0 auto', textAlign: 'center' }}>
            <p>© 2024 Reserva Panama. Todos los derechos reservados.</p>
          </div>
        </footer>
      </body>
    </html>
  )
}
'@

$layoutCode | Out-File "frontend\app\layout.tsx" -Encoding UTF8

# Create globals.css
@"
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  line-height: 1.6;
}

input, button {
  font-family: inherit;
}
"@ | Out-File "frontend\app\globals.css" -Encoding UTF8

# Create page.tsx
$pageCode = @'
'use client'

import { useState } from 'react'

export default function HomePage() {
  const [form, setForm] = useState({ name: '', email: '', phone: '' })
  const [message, setMessage] = useState('')
  const [loading, setLoading] = useState(false)
  const [restaurants] = useState([
    { name: 'Maito', cuisine: 'Panameña Contemporánea', wait: '2+ semanas' },
    { name: 'Casa Esquina', cuisine: 'Fusión Panameña', wait: '10+ días' },
    { name: 'Donde José', cuisine: 'Alta Cocina Panameña', wait: '3+ semanas' },
    { name: 'Intimo', cuisine: 'Italiana Moderna', wait: '5+ días' },
    { name: 'Mercado del Mar', cuisine: 'Mariscos Frescos', wait: '7+ días' },
  ])

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setMessage('')

    try {
      const response = await fetch('http://localhost:8000/api/vip-leads', {
        method: 'POST',
        headers: { 
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: JSON.stringify({
          name: form.name,
          email: form.email,
          phone: form.phone || undefined
        })
      })

      const data = await response.json()
      setMessage(data.message)

      if (data.status === 'success') {
        setForm({ name: '', email: '', phone: '' })
        
        // Track conversion
        if (window.gtag) {
          window.gtag('event', 'generate_lead', {
            event_category: 'conversion',
            event_label: 'vip_signup'
          })
        }
      }
    } catch (error) {
      console.error('Error:', error)
      setMessage('❌ Error de conexión. Verifica que el backend esté corriendo en http://localhost:8000')
    } finally {
      setLoading(false)
    }
  }

  const handleTestAPI = async () => {
    try {
      const response = await fetch('http://localhost:8000/api/health')
      const data = await response.json()
      alert(`✅ Backend API is working!\nStatus: ${data.status}\nTime: ${data.timestamp}`)
    } catch (error) {
      alert('❌ Backend API not reachable. Start it first!')
    }
  }

  return (
    <main style={{ 
      minHeight: '100vh',
      background: 'linear-gradient(135deg, #ffedd5 0%, #fed7aa 100%)'
    }}>
      {/* Hero Section */}
      <section style={{ 
        background: 'linear-gradient(135deg, #ea580c 0%, #f97316 100%)',
        color: 'white',
        padding: '4rem 2rem',
        textAlign: 'center'
      }}>
        <h1 style={{ fontSize: '3rem', marginBottom: '1rem' }}>
          Accede a Restaurantes Exclusivos
        </h1>
        <p style={{ fontSize: '1.25rem', maxWidth: '800px', margin: '0 auto 2rem' }}>
          Te notificamos al instante cuando se liberan mesas en los restaurantes más solicitados
        </p>
        <button
          onClick={handleTestAPI}
          style={{
            background: 'white',
            color: '#ea580c',
            padding: '0.75rem 2rem',
            border: 'none',
            borderRadius: '0.5rem',
            fontSize: '1rem',
            fontWeight: 'bold',
            cursor: 'pointer'
          }}
        >
          🔧 Test Backend Connection
        </button>
      </section>

      <div style={{ 
        maxWidth: '1200px', 
        margin: '0 auto', 
        padding: '2rem',
        display: 'grid',
        gridTemplateColumns: '1fr 1fr',
        gap: '3rem'
      }}>
        {/* Left Column - VIP Form */}
        <div>
          <div style={{ 
            background: 'white',
            borderRadius: '1rem',
            padding: '2rem',
            boxShadow: '0 10px 30px rgba(0,0,0,0.1)'
          }}>
            <h2 style={{ 
              color: '#1f2937', 
              fontSize: '1.75rem',
              marginBottom: '1.5rem',
              textAlign: 'center'
            }}>
              🎯 Únete a la Lista VIP Gratuita
            </h2>

            <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '1.5rem' }}>
              {[
                { label: 'Nombre completo', type: 'text', key: 'name', required: true },
                { label: 'Email', type: 'email', key: 'email', required: true },
                { label: 'WhatsApp (opcional)', type: 'tel', key: 'phone', required: false }
              ].map((field) => (
                <div key={field.key}>
                  <label style={{ 
                    display: 'block', 
                    marginBottom: '0.5rem', 
                    fontWeight: '600',
                    color: '#374151'
                  }}>
                    {field.label}
                  </label>
                  <input
                    type={field.type}
                    value={form[field.key]}
                    onChange={e => setForm({...form, [field.key]: e.target.value})}
                    placeholder={field.label}
                    required={field.required}
                    style={{
                      width: '100%',
                      padding: '0.75rem 1rem',
                      border: '1px solid #d1d5db',
                      borderRadius: '0.5rem',
                      fontSize: '1rem',
                      transition: 'border-color 0.2s'
                    }}
                    onFocus={e => e.target.style.borderColor = '#f97316'}
                    onBlur={e => e.target.style.borderColor = '#d1d5db'}
                  />
                </div>
              ))}

              <button
                type="submit"
                disabled={loading}
                style={{
                  background: 'linear-gradient(135deg, #ea580c 0%, #f97316 100%)',
                  color: 'white',
                  padding: '1rem',
                  border: 'none',
                  borderRadius: '0.5rem',
                  fontSize: '1.125rem',
                  fontWeight: 'bold',
                  cursor: loading ? 'not-allowed' : 'pointer',
                  opacity: loading ? 0.7 : 1,
                  transition: 'transform 0.2s',
                  marginTop: '1rem'
                }}
                onMouseOver={e => !loading && (e.target.style.transform = 'translateY(-2px)')}
                onMouseOut={e => e.target.style.transform = 'translateY(0)'}
              >
                {loading ? '⏳ Procesando...' : '🎯 ¡Quiero Acceso VIP Gratis!'}
              </button>
            </form>

            {message && (
              <div style={{
                marginTop: '1.5rem',
                padding: '1rem',
                background: message.includes('✅') || message.includes('Gracias') ? '#d1fae5' : '#fee2e2',
                border: `1px solid ${message.includes('✅') || message.includes('Gracias') ? '#10b981' : '#ef4444'}`,
                color: message.includes('✅') || message.includes('Gracias') ? '#065f46' : '#991b1b',
                borderRadius: '0.5rem',
                textAlign: 'center',
                fontSize: '0.875rem'
              }}>
                {message}
              </div>
            )}
          </div>
        </div>

        {/* Right Column - Restaurants */}
        <div>
          <h2 style={{ 
            color: '#1f2937', 
            fontSize: '1.75rem',
            marginBottom: '1.5rem',
            textAlign: 'center'
          }}>
            🍽️ Restaurantes Disponibles
          </h2>

          <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
            {restaurants.map((restaurant, index) => (
              <div key={index} style={{
                background: 'white',
                borderRadius: '0.75rem',
                padding: '1.5rem',
                boxShadow: '0 4px 6px rgba(0,0,0,0.05)',
                transition: 'transform 0.2s'
              }}
              onMouseOver={e => e.currentTarget.style.transform = 'translateY(-2px)'}
              onMouseOut={e => e.currentTarget.style.transform = 'translateY(0)'}
              >
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                  <div>
                    <h3 style={{ color: '#1f2937', marginBottom: '0.5rem' }}>{restaurant.name}</h3>
                    <p style={{ color: '#6b7280', fontSize: '0.875rem' }}>{restaurant.cuisine}</p>
                  </div>
                  <span style={{
                    background: '#fee2e2',
                    color: '#991b1b',
                    fontSize: '0.75rem',
                    fontWeight: 'bold',
                    padding: '0.25rem 0.75rem',
                    borderRadius: '9999px'
                  }}>
                    {restaurant.wait}
                  </span>
                </div>
              </div>
            ))}
          </div>

          {/* Stats */}
          <div style={{ 
            background: 'linear-gradient(135deg, #1e40af 0%, #3b82f6 100%)',
            color: 'white',
            borderRadius: '0.75rem',
            padding: '1.5rem',
            marginTop: '2rem'
          }}>
            <h3 style={{ marginBottom: '1rem', textAlign: 'center' }}>📊 Nuestros Números</h3>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '1rem' }}>
              <div style={{ textAlign: 'center' }}>
                <div style={{ fontSize: '1.5rem', fontWeight: 'bold' }}>50+</div>
                <div style={{ fontSize: '0.875rem' }}>Restaurantes</div>
              </div>
              <div style={{ textAlign: 'center' }}>
                <div style={{ fontSize: '1.5rem', fontWeight: 'bold' }}>98%</div>
                <div style={{ fontSize: '0.875rem' }}>Tasa de Éxito</div>
              </div>
              <div style={{ textAlign: 'center' }}>
                <div style={{ fontSize: '1.5rem', fontWeight: 'bold' }}>5 min</div>
                <div style={{ fontSize: '0.875rem' }}>Alertas Rápidas</div>
              </div>
              <div style={{ textAlign: 'center' }}>
                <div style={{ fontSize: '1.5rem', fontWeight: 'bold' }}>1250+</div>
                <div style={{ fontSize: '0.875rem' }}>Miembros VIP</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
  )
}
'@

$pageCode | Out-File "frontend\app\page.tsx" -Encoding UTF8

# Install frontend dependencies
Write-Host "`n[6/8] Installing frontend dependencies..." -ForegroundColor Yellow
Set-Location frontend
npm install --silent
Set-Location ..

# ========================================
# CREATE STARTUP SCRIPTS
# ========================================
Write-Host "`n[7/8] Creating startup scripts..." -ForegroundColor Yellow

# Create start-backend.ps1
@'
Write-Host "🚀 Starting Backend API..." -ForegroundColor Green
cd backend
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
'@ | Out-File "start-backend.ps1" -Encoding UTF8

# Create start-frontend.ps1
@'
Write-Host "🎨 Starting Frontend..." -ForegroundColor Green
cd frontend
npm run dev
'@ | Out-File "start-frontend.ps1" -Encoding UTF8

# Create start-all.bat
@'
@echo off
chcp 65001 >nul
echo ========================================
echo     RESERVA PANAMA - LAUNCHER
echo ========================================
echo.

echo [1] Starting Backend API...
start powershell -NoExit -ExecutionPolicy Bypass -File "start-backend.ps1"

timeout /t 3 >nul

echo [2] Starting Frontend...
start powershell -NoExit -ExecutionPolicy Bypass -File "start-frontend.ps1"

timeout /t 2 >nul

echo.
echo ✅ ALL SERVICES STARTED!
echo.
echo 🌐 Frontend: http://localhost:3000
echo 🔧 Backend:  http://localhost:8000
echo 📊 Supabase: https://tciilqtmjdhuxxvlurgz.supabase.co
echo.
echo 📋 Next Steps:
echo 1. Open http://localhost:3000 in browser
echo 2. Test the VIP form
echo 3. Check Supabase dashboard for data
echo.
echo Press any key to open browser...
pause >nul
start http://localhost:3000
echo.
echo Press any key to exit...
pause >nul
'@ | Out-File "start-all.bat" -Encoding UTF8

# Create test-api.ps1
@'
Write-Host "🔍 Testing API Connections..." -ForegroundColor Yellow
Write-Host ""

try {
    $response = Invoke-RestMethod "http://localhost:8000" -TimeoutSec 3
    Write-Host "✅ Backend API: $($response.status)" -ForegroundColor Green
} catch {
    Write-Host "❌ Backend API not running" -ForegroundColor Red
}

try {
    $response = Invoke-WebRequest "http://localhost:3000" -TimeoutSec 3
    Write-Host "✅ Frontend is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Frontend not running" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎯 Quick Start:" -ForegroundColor Cyan
Write-Host "   Double-click 'start-all.bat' to launch everything" -ForegroundColor White
pause
'@ | Out-File "test-api.ps1" -Encoding UTF8

# ========================================
# COMPLETE
# ========================================
Write-Host "`n[8/8] Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✅ SETUP COMPLETED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "📁 Project location:" -ForegroundColor Cyan
Write-Host "   $(Get-Location)" -ForegroundColor White
Write-Host ""
Write-Host "🚀 To launch everything:" -ForegroundColor Cyan
Write-Host "   1. Double-click: start-all.bat" -ForegroundColor White
Write-Host "   2. Or run: .\test-api.ps1 (to test)" -ForegroundColor White
Write-Host ""
Write-Host "🌐 URLs after launch:" -ForegroundColor Cyan
Write-Host "   • Frontend: http://localhost:3000" -ForegroundColor White
Write-Host "   • Backend:  http://localhost:8000" -ForegroundColor White
Write-Host "   • API Docs: http://localhost:8000/docs" -ForegroundColor White
Write-Host "   • Supabase: https://tciilqtmjdhuxxvlurgz.supabase.co" -ForegroundColor White
Write-Host ""
Write-Host "🎯 Test the VIP form at http://localhost:3000!" -ForegroundColor Green
Write-Host ""
pause
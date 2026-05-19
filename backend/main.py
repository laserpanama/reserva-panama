from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime
import os

# ============================================================================
# FASTAPI APP
# ============================================================================

app = FastAPI(
    title="Reserva Panamá API",
    description="Sistema de reservas para hoteles y restaurantes en Panamá",
    version="2.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",
        "http://localhost:8000",
        "http://127.0.0.1:3000",
        "http://127.0.0.1:8000",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ============================================================================
# DATA MODELS
# ============================================================================

class HealthResponse(BaseModel):
    status: str
    service: str
    timestamp: str
    version: str

class ReservationCreate(BaseModel):
    nombre: str
    email: str
    telefono: str
    fecha: str
    hora: str
    personas: int
    notas: Optional[str] = None

class ReservationResponse(BaseModel):
    id: str
    nombre: str
    email: str
    telefono: str
    fecha: str
    hora: str
    personas: int
    estado: str
    creado_en: str

class PanamaInfo(BaseModel):
    pais: str
    codigo_pais: str
    moneda: str
    idioma: str
    zona_horaria: str
    telefono_codigo: str
    impuesto_itbms: float
    impuesto_turistico: float

# ============================================================================
# ROUTES
# ============================================================================

@app.get("/", tags=["Root"])
async def root():
    return {
        "message": "Bienvenido a Reserva Panamá API",
        "version": "2.0.0",
        "description": "Sistema de reservas para Panamá",
        "endpoints": {
            "docs": "/docs",
            "health": "/health",
            "panama_info": "/api/panama/info",
            "reservations": "/api/reservations"
        }
    }

@app.get("/health", response_model=HealthResponse, tags=["Health"])
async def health_check():
    return HealthResponse(
        status="healthy",
        service="reserva-panama-api",
        timestamp=datetime.now().isoformat(),
        version="2.0.0"
    )

@app.get("/api/panama/info", response_model=PanamaInfo, tags=["Panama"])
async def get_panama_info():
    return PanamaInfo(
        pais="Panamá",
        codigo_pais="PA",
        moneda="USD",
        idioma="es",
        zona_horaria="America/Panama",
        telefono_codigo="+507",
        impuesto_itbms=7.0,
        impuesto_turistico=10.0
    )

@app.get("/api/reservations", tags=["Reservations"])
async def get_reservations():
    # For now, return empty array - will connect to Supabase later
    return {
        "success": True,
        "count": 0,
        "reservations": [],
        "message": "Endpoint listo para conectar con Supabase"
    }

@app.post("/api/reservations", tags=["Reservations"])
async def create_reservation(reservation: ReservationCreate):
    # For now, simulate success - will save to Supabase later
    return {
        "success": True,
        "message": "Reservación recibida exitosamente",
        "reservation_id": "temp_" + datetime.now().strftime("%Y%m%d%H%M%S"),
        "reservation": reservation.dict(),
        "status": "pendiente",
        "timestamp": datetime.now().isoformat()
    }

@app.get("/api/test", tags=["Test"])
async def test_endpoint():
    return {
        "status": "working",
        "message": "API funcionando correctamente",
        "timestamp": datetime.now().isoformat(),
        "endpoints": [
            "/",
            "/health", 
            "/docs",
            "/api/panama/info",
            "/api/reservations"
        ]
    }


# VIP Leads endpoint
class VIPLead(BaseModel):
    name: str
    email: str
    phone: str = ""

@app.post("/api/vip-leads", tags=["VIP"])
async def create_vip_lead(lead: VIPLead):
    return {
        "status": "success",
        "message": f"Lead VIP recibido: {lead.name}",
        "lead": lead.dict(),
        "timestamp": datetime.now().isoformat()
    }

# ============================================================================
# MAIN EXECUTION
# ============================================================================

if __name__ == "__main__":
    import uvicorn
    print("\n" + "="*60)
    print("🚀 RESERVA PANAMÁ API - Starting Server")
    print("="*60)
    print(f"📡 URL: http://localhost:8000")
    print(f"📚 Docs: http://localhost:8000/docs")
    print(f"❤️  Health: http://localhost:8000/health")
    print("="*60 + "\n")
    uvicorn.run(app, host="0.0.0.0", port=8000, log_level="info")


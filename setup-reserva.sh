#!/bin/bash

echo "🚀 Starting Reserva Panamá Automated Setup..."
echo "============================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
SUPABASE_URL="https://tciilqtmjdhuxxvlurgz.supabase.co"
SUPABASE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRjaWlscXRtamRodXh4dmx1cmd6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDExNzU5MTAsImV4cCI6MjAxNjc1MTkxMH0.BL-SE90QKp1-CE_m-6OQO96am5DGPKkqV32_LPqCFzQ"
SUPABASE_SERVICE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRjaWlscXRtamRodXh4dmx1cmd6Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcwMTE3NTkxMCwiZXhwIjoyMDE2NzUxOTEwfQ.Q5yOJAC8lFSCpA2jppvdfG-R8Dnib0WpFq8CInMAlAE"

echo -e "${YELLOW}📦 Installing dependencies...${NC}"

# Install Python dependencies
pip install fastapi uvicorn pydantic python-dotenv supabase psycopg2-binary httpx

# Install Node.js dependencies
npm install @supabase/supabase-js @hookform/resolvers zod react-hook-form

echo -e "${GREEN}✅ Dependencies installed${NC}"

echo -e "${YELLOW}🗄️ Setting up Supabase database...${NC}"

# Create database schema using Supabase API
curl -X POST "${SUPABASE_URL}/rest/v1/rpc/create_schema" \
  -H "apikey: ${SUPABASE_KEY}" \
  -H "Authorization: Bearer ${SUPABASE_SERVICE_KEY}" \
  -H "Content-Type: application/json" \
  -d '{}' \
  --silent

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Database schema created${NC}"
else
    echo -e "${RED}⚠️ Could not create schema via API, will create manually${NC}"
fi

# Create backend directory structure
echo -e "${YELLOW}📁 Creating backend structure...${NC}"
mkdir -p backend
cd backend

# Create requirements.txt
cat > requirements.txt << 'EOF'
fastapi==0.104.1
uvicorn[standard]==0.24.0
pydantic==2.5.0
python-dotenv==1.0.0
supabase==1.1.0
psycopg2-binary==2.9.9
httpx==0.25.1
python-multipart==0.0.6
celery==5.3.4
redis==5.0.1
EOF

# Create .env file
cat > .env << EOF
# Supabase Configuration
SUPABASE_URL=${SUPABASE_URL}
SUPABASE_KEY=${SUPABASE_KEY}
SUPABASE_SERVICE_KEY=${SUPABASE_SERVICE_KEY}

# API Configuration
API_BASE_URL=http://localhost:8000
FRONTEND_URL=http://localhost:3000

# JWT Configuration
JWT_SECRET=$(openssl rand -hex 32)
JWT_EXPIRATION=24h

# Email Configuration (Optional)
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=your-email@gmail.com
EMAIL_PASSWORD=your-app-password

# WhatsApp Configuration (Optional)
TWILIO_ACCOUNT_SID=your-twilio-sid
TWILIO_AUTH_TOKEN=your-twilio-token
TWILIO_WHATSAPP_NUMBER=whatsapp:+14155238886
EOF

# Create main.py
cat > main.py << 'EOF'
from fastapi import FastAPI, HTTPException, BackgroundTasks, Depends, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, EmailStr, Field
from typing import Optional, List
from datetime import datetime
import logging
from supabase import create_client, Client
import os
from dotenv import load_dotenv
import uuid

load_dotenv()

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(title="Reserva Panamá API", version="2.0.0")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize Supabase
supabase: Client = create_client(
    os.getenv("SUPABASE_URL"),
    os.getenv("SUPABASE_KEY")
)

class VIPLead(BaseModel):
    name: str
    email: EmailStr
    phone: Optional[str] = None
    restaurants: List[str] = []
    notification_method: str = "both"

@app.get("/")
async def root():
    return {"status": "healthy", "service": "Reserva Panamá API"}

@app.post("/api/vip-leads")
async def create_vip_lead(lead: VIPLead, background_tasks: BackgroundTasks):
    try:
        # Check if lead exists
        existing = supabase.table("vip_leads").select("*").eq("email", lead.email).execute()
        
        if existing.data:
            # Update existing
            result = supabase.table("vip_leads").update({
                "name": lead.name,
                "phone": lead.phone,
                "restaurants": lead.restaurants,
                "notification_method": lead.notification_method,
                "updated_at": datetime.now().isoformat()
            }).eq("email", lead.email).execute()
        else:
            # Create new
            result = supabase.table("vip_leads").insert({
                "id": str(uuid.uuid4()),
                "name": lead.name,
                "email": lead.email,
                "phone": lead.phone,
                "restaurants": lead.restaurants,
                "notification_method": lead.notification_method,
                "status": "active",
                "created_at": datetime.now().isoformat(),
                "updated_at": datetime.now().isoformat()
            }).execute()
        
        # Log analytics
        supabase.table("analytics_events").insert({
            "event_type": "vip_signup",
            "user_email": lead.email,
            "metadata": {"restaurants_count": len(lead.restaurants)},
            "created_at": datetime.now().isoformat()
        }).execute()
        
        return {
            "status": "success",
            "message": "¡Registro exitoso!",
            "data": result.data[0] if result.data else None
        }
        
    except Exception as e:
        logger.error(f"Error: {str(e)}")
        raise HTTPException(status_code=500, detail="Error interno")

@app.get("/api/statistics")
async def get_statistics():
    try:
        vip_count = supabase.table("vip_leads").select("*", count="exact").eq("status", "active").execute()
        restaurants = supabase.table("restaurants").select("*", count="exact").eq("is_active", True).execute()
        alerts = supabase.table("restaurant_alerts").select("*", count="exact").eq("is_active", True).execute()
        
        return {
            "total_vip_members": vip_count.count or 0,
            "restaurants_monitored": restaurants.count or 0,
            "active_alerts": alerts.count or 0,
            "last_updated": datetime.now().isoformat()
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail="Error al obtener estadísticas")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
EOF

echo -e "${GREEN}✅ Backend created${NC}"
cd ..

echo -e "${YELLOW}🎨 Setting up frontend...${NC}"

# Create frontend .env.local
cat > frontend/.env.local << EOF
NEXT_PUBLIC_SUPABASE_URL=${SUPABASE_URL}
NEXT_PUBLIC_SUPABASE_ANON_KEY=${SUPABASE_KEY}
NEXT_PUBLIC_API_URL=http://localhost:8000
NEXT_PUBLIC_GA_ID=G-38V3K9TS96
EOF

# Create lib/supabase.ts
mkdir -p frontend/lib
cat > frontend/lib/supabase.ts << 'EOF'
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

export async function createVIPLead(data: any) {
  try {
    const response = await fetch('/api/vip-leads', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    })
    return await response.json()
  } catch (error) {
    console.error('Error:', error)
    throw error
  }
}
EOF

echo -e "${GREEN}✅ Frontend configured${NC}"

echo -e "${YELLOW}🚀 Starting services...${NC}"

# Start backend
cd backend && python -m uvicorn main:app --reload --port 8000 &
BACKEND_PID=$!

# Start frontend
cd ../frontend && npm run dev &
FRONTEND_PID=$!

echo -e "${GREEN}✅ Services started!${NC}"
echo ""
echo -e "${GREEN}🎉 Setup Complete!${NC}"
echo ""
echo "🌐 Frontend: http://localhost:3000"
echo "🔧 Backend API: http://localhost:8000"
echo "📊 Supabase Dashboard: https://tciilqtmjdhuxxvlurgz.supabase.co"
echo ""
echo "📋 Next Steps:"
echo "1. Open http://localhost:3000 in your browser"
echo "2. Test the VIP form submission"
echo "3. Check Supabase for stored data"
echo ""
echo "Press Ctrl+C to stop all services"

# Wait for user interrupt
trap "kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit" INT
wait
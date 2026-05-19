# 🍽️ RESERVA PANAMÁ

**Agregador inteligente de reservaciones para restaurantes en Ciudad de Panamá**

Encuentra y reserva en los mejores restaurantes para fechas especiales: Día de las Madres, Navidad, San Valentín y más.

---

## 📋 CONTENIDO DEL PROYECTO

Este repositorio contiene TODO lo que necesitas para lanzar Reserva Panamá al mercado:

```
reserva_panama_project/
│
├── BLUEPRINT.md              # 📘 Visión estratégica completa del proyecto
├── ROADMAP.md                # 🗓️ Plan de ejecución semana por semana
├── README.md                 # 📖 Este archivo (inicio rápido)
│
├── database_schema.sql       # 🗄️ Schema de PostgreSQL/Supabase
│
├── backend/                  # 🐍 Backend API (Python + FastAPI)
│   ├── main.py              # API endpoints principales
│   ├── scraper_instagram.py # Scraper automatizado
│   ├── requirements.txt     # Dependencias Python
│   └── .env.example         # Template de variables de entorno
│
└── frontend/                 # ⚛️ Frontend Web (Next.js 14)
    ├── app/
    │   └── page.tsx         # Landing page principal
    └── components/
        └── SearchBar.tsx    # Componente de búsqueda
```

---

## 🚀 INICIO RÁPIDO (15 minutos)

### Prerrequisitos
- Python 3.11+
- Node.js 18+
- Cuenta en Supabase (gratis)
- Git

### Paso 1: Clonar el Proyecto
```bash
git clone https://github.com/tu-usuario/reserva-panama.git
cd reserva-panama
```

### Paso 2: Setup Backend
```bash
cd backend

# Crear entorno virtual
python3 -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Instalar dependencias
pip install -r requirements.txt
playwright install chromium

# Configurar variables de entorno
cp .env.example .env
# Editar .env con tus keys de Supabase
```

### Paso 3: Setup Base de Datos
1. Crear cuenta en [Supabase](https://supabase.com)
2. Crear nuevo proyecto: "reserva-panama"
3. Ir a SQL Editor
4. Copiar y ejecutar `database_schema.sql`
5. Copiar API keys a `backend/.env`

### Paso 4: Setup Frontend
```bash
cd frontend

# Instalar dependencias
npm install

# Configurar API URL
# Crear archivo .env.local con:
# NEXT_PUBLIC_API_URL=http://localhost:8000
```

### Paso 5: Ejecutar Localmente
```bash
# Terminal 1 - Backend
cd backend
python main.py
# API corriendo en http://localhost:8000

# Terminal 2 - Frontend
cd frontend
npm run dev
# Web corriendo en http://localhost:3000
```

Abre http://localhost:3000 en tu navegador 🎉

---

## 📚 DOCUMENTACIÓN PRINCIPAL

### Lee PRIMERO estos archivos (en orden):

1. **[BLUEPRINT.md](BLUEPRINT.md)**
   - Visión completa del proyecto
   - Stack tecnológico explicado
   - Arquitectura de base de datos
   - Modelo de negocio y monetización
   - Costos reales del primer año

2. **[ROADMAP.md](ROADMAP.md)**
   - Plan de ejecución de 8 semanas
   - Checklist día por día
   - Métricas de éxito
   - Criterios de go/no-go

3. **[database_schema.sql](database_schema.sql)**
   - Schema completo de PostgreSQL
   - Funciones útiles incluidas
   - Datos de ejemplo (seed data)

---

## 🛠️ STACK TECNOLÓGICO

### Backend
- **FastAPI** (Python 3.11+) - API REST
- **Supabase** (PostgreSQL) - Base de datos + Auth
- **Playwright** - Web scraping con JavaScript rendering

### Frontend
- **Next.js 14** (App Router) - React framework
- **Tailwind CSS** - Styling
- **Lucide Icons** - Iconografía

### Deployment
- **Vercel** - Frontend (gratis)
- **Railway** - Backend ($5/mes)
- **Supabase** - Database (gratis hasta 500MB)

---

## 📊 FEATURES PRINCIPALES

### MVP (Semana 1-3)
- ✅ Búsqueda de restaurantes con filtros
- ✅ Vista detallada de restaurantes
- ✅ Lista de eventos especiales
- ✅ Links directos a reservación (WhatsApp/teléfono)
- ✅ Scraper automatizado de Instagram
- ✅ SEO optimizado

### Post-MVP (Semana 4+)
- ⬜ Sistema de reviews
- ⬜ Integración con OpenTable API
- ⬜ Notificaciones de nuevos eventos
- ⬜ Dashboard para restaurantes
- ⬜ Sistema de pagos (Stripe)

---

## 🎯 PRÓXIMOS PASOS INMEDIATOS

1. ✅ Leer `BLUEPRINT.md` completo
2. ⬜ Crear cuentas necesarias (Supabase, Vercel, Railway)
3. ⬜ Ejecutar setup local y probar
4. ⬜ Agregar 20 restaurantes manualmente a la DB
5. ⬜ Ejecutar scraper de Instagram
6. ⬜ Seguir el `ROADMAP.md` semana por semana

---

## 💡 COMANDOS ÚTILES

### Backend
```bash
# Ejecutar API en desarrollo
python main.py

# Ejecutar scraper manualmente
python scraper_instagram.py

# Ejecutar tests (cuando los agregues)
pytest

# Ver documentación automática de la API
# http://localhost:8000/docs
```

### Frontend
```bash
# Desarrollo con hot reload
npm run dev

# Build de producción
npm run build

# Preview del build
npm run start

# Linting
npm run lint
```

---

## 🐛 TROUBLESHOOTING

### Error: "ModuleNotFoundError: No module named 'supabase'"
```bash
pip install -r requirements.txt
```

### Error: "playwright._impl._api_types.Error: Executable doesn't exist"
```bash
playwright install chromium
```

### Error: Frontend no conecta con Backend
- Verifica que el backend esté corriendo en puerto 8000
- Verifica CORS settings en `backend/main.py`
- Revisa `NEXT_PUBLIC_API_URL` en `.env.local`

### Error: "relation 'restaurants' does not exist"
- Ejecuta `database_schema.sql` en Supabase SQL Editor

---

## 📈 MÉTRICAS DE ÉXITO (3 meses)

- 50+ restaurantes en la base de datos
- 500+ visitas orgánicas/mes
- 10+ clicks a reservaciones/semana
- 3+ restaurantes interesados en tier premium
- Tasa de rebote < 70%
- Tiempo en sitio > 2 minutos

---

## 🤝 CONTRIBUIR (Si decides hacer open source)

1. Fork el proyecto
2. Crea un branch (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add AmazingFeature'`)
4. Push al branch (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

---

## 📄 LICENCIA

Este proyecto es privado y propietario de PIPO.

---

## 📞 CONTACTO

**PIPO** - Founder & Developer

- Email: tu-email@ejemplo.com
- Instagram: [@reservapanama](https://instagram.com/reservapanama)
- Website: [reservapanama.com](https://reservapanama.com)

---

## 🙏 AGRADECIMIENTOS

- Comunidad de Next.js
- Comunidad de FastAPI
- Food bloggers de Panamá
- Early adopters y testers

---

**¿Listo para lanzar?** Lee el [BLUEPRINT.md](BLUEPRINT.md) y luego sigue el [ROADMAP.md](ROADMAP.md) paso a paso.

**¡Ahora ejecuta! 🚀**

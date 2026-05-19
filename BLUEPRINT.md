# 🎯 RESERVA PANAMÁ - BLUEPRINT EJECUTIVO

## LA VISIÓN EN UNA FRASE
**Agregador inteligente de reservaciones para restaurantes en Ciudad de Panamá, enfocado en fechas especiales de alta demanda.**

---

## EL PROBLEMA REAL
- Las reservaciones para fechas especiales (Día de las Madres, Navidad, San Valentín) son un CAOS
- Usuarios saltan entre 5+ plataformas: OpenTable, Instagram, Facebook, sitios web individuales
- Información fragmentada, desactualizada, o inexistente
- Restaurantes pierden clientes por mala visibilidad
- Usuarios frustrados pierden tiempo y oportunidades

## LA SOLUCIÓN
**Una sola app/web donde:**
1. Ver TODOS los restaurantes con disponibilidad para fechas especiales
2. Filtrar por: precio, tipo de comida, zona, eventos especiales (brunch, música en vivo)
3. Reservar directo (WhatsApp/llamada) o via OpenTable integrado
4. Recibir notificaciones de nuevos eventos y disponibilidad

---

## STACK TECNOLÓGICO DEFINITIVO

### Backend
- **FastAPI** (Python 3.11+)
  - Endpoints REST ultra-rápidos
  - Async/await nativo para scrapers
  - Documentación automática (Swagger)
  
- **Supabase** (PostgreSQL + Auth + Storage)
  - Base de datos relacional
  - Authentication lista para usar
  - Real-time subscriptions
  - Tier gratuito: 500MB database, 2GB bandwidth/mes

### Frontend
- **Next.js 14** (App Router)
  - React Server Components
  - SEO optimizado out-of-the-box
  - Static + Dynamic rendering
  - Image optimization automática
  
- **Tailwind CSS + shadcn/ui**
  - Componentes pre-hechos profesionales
  - Responsive por defecto
  - Dark mode nativo

### Scrapers & Automation
- **Playwright** (Python)
  - Scraping de Instagram/Facebook
  - JavaScript rendering
  - Screenshots para eventos
  
- **BeautifulSoup + httpx**
  - Scraping de sitios web estáticos
  - Async requests

### Deployment
- **Vercel** (Frontend) - GRATIS
  - Deploy automático desde GitHub
  - CDN global
  - Analytics incluido
  
- **Railway** (Backend + DB) - $5/mes inicial
  - PostgreSQL incluido
  - Cron jobs para scrapers
  - Logs y monitoring

### APIs Externas
- **OpenTable** (si consigues acceso a API privada)
- **Google Maps API** (ubicaciones, reviews)
- **WhatsApp Business API** (notificaciones)

---

## ARQUITECTURA DE BASE DE DATOS

```sql
-- Tabla: restaurants
id (uuid, PK)
name (text)
slug (text, unique)
description (text)
address (text)
latitude (decimal)
longitude (decimal)
phone (text)
whatsapp (text)
instagram (text)
facebook (text)
opentable_url (text)
website (text)
cuisine_type (text[])
price_range (integer) -- 1-4 ($-$$$$)
average_rating (decimal)
image_url (text)
is_active (boolean)
created_at (timestamp)
updated_at (timestamp)

-- Tabla: special_events
id (uuid, PK)
restaurant_id (uuid, FK -> restaurants)
event_name (text)
event_date (date)
start_time (time)
end_time (time)
description (text)
menu_details (text)
price_adult (decimal)
price_child (decimal)
price_senior (decimal)
has_live_music (boolean)
has_special_menu (boolean)
image_url (text)
booking_url (text)
booking_phone (text)
booking_whatsapp (text)
seats_available (integer)
is_active (boolean)
created_at (timestamp)

-- Tabla: user_searches (analytics)
id (uuid, PK)
search_date (date)
search_location (text)
filters_used (jsonb)
results_count (integer)
clicked_restaurant_id (uuid, nullable)
created_at (timestamp)
```

---

## MVP - FUNCIONALIDADES CORE (Semana 1-3)

### ✅ Fase 1: Base Funcional
1. **Landing Page**
   - Hero section con buscador principal
   - Filtros: Fecha, zona, tipo de comida, rango de precio
   - Grid de restaurantes con cards atractivas
   
2. **Página de Restaurante**
   - Galería de imágenes
   - Info completa + mapa
   - Eventos especiales listados
   - Botones CTA: "Reservar por WhatsApp", "Llamar", "OpenTable"
   
3. **Backend API**
   - GET /api/restaurants (con filtros)
   - GET /api/restaurants/:slug
   - GET /api/events?date=YYYY-MM-DD
   - Admin endpoints (CRUD protegido)

4. **Scraper Inicial**
   - Script Python que corre 1x/día
   - Scraping de Instagram de 10 restaurantes top
   - Detección de posts con palabras clave: "Día de las Madres", "reserva", "8 diciembre"
   - Almacena eventos en DB

### ✅ Fase 2: Validación (Semana 4)
5. **SEO Optimization**
   - Meta tags dinámicos
   - Schema.org markup (Restaurant, Event)
   - Sitemap.xml generado dinámicamente
   
6. **Analytics Básico**
   - Google Analytics 4
   - Tracking de: búsquedas, clicks, conversiones
   
7. **Admin Panel Simple**
   - CRUD manual de restaurantes
   - CRUD manual de eventos
   - Dashboard con métricas básicas

---

## PLAN DE LANZAMIENTO - 8 SEMANAS

### Semana 1-2: Setup + Backend
- [ ] Configurar repos GitHub (frontend + backend)
- [ ] Setup Supabase project
- [ ] Crear schema de base de datos
- [ ] Implementar FastAPI base con endpoints CRUD
- [ ] Deploy backend a Railway
- [ ] Implementar scraper básico de Instagram

### Semana 3-4: Frontend MVP
- [ ] Setup Next.js 14 project
- [ ] Componentes UI base (shadcn/ui)
- [ ] Landing page con búsqueda
- [ ] Página de restaurante individual
- [ ] Integrar con backend API
- [ ] Deploy a Vercel

### Semana 5: Contenido Inicial
- [ ] Agregar manualmente 20-30 restaurantes top de PTY
- [ ] Scraping de eventos para Día de las Madres (8 dic)
- [ ] Validar datos con llamadas a restaurantes
- [ ] Tomar/conseguir fotos de calidad

### Semana 6: Polish & SEO
- [ ] Optimización de performance
- [ ] SEO on-page completo
- [ ] Google Maps integration
- [ ] Formularios de contacto
- [ ] Políticas de privacidad / términos

### Semana 7: Testing & Soft Launch
- [ ] Testing en devices reales
- [ ] Fix bugs críticos
- [ ] Soft launch con amigos/familia
- [ ] Recolectar feedback

### Semana 8: Launch Público
- [ ] Marketing en redes sociales
- [ ] Outreach a restaurantes (partnerships)
- [ ] Ads pagados (opcional, budget bajo)
- [ ] PR local (prensa, bloggers de comida)

---

## MONETIZACIÓN (Fase Post-MVP)

### Modelo Freemium
**GRATIS para usuarios:**
- Búsqueda ilimitada
- Ver info de restaurantes
- Links directos a reserva

**PREMIUM para restaurantes (después de validar tracción):**
- **Tier Básico** ($30/mes):
  - Perfil destacado
  - Aparecer en top de búsquedas
  - Analytics de visitas
  
- **Tier Pro** ($80/mes):
  - Todo lo anterior +
  - Post de eventos ilimitados
  - Badge "Verificado"
  - Soporte prioritario
  - Galería de fotos ampliada

**Comisiones (futuro):**
- 5-10% comisión por reservas completadas via la plataforma
- Requiere sistema de reservas propio (complejo, Fase 3)

---

## COSTOS REALES - PRIMER AÑO

### Desarrollo (DIY)
- **Tu tiempo:** INVALUABLE (pero $0 en cash)
- **Freelancer opcional:** $0-2000 (solo si necesitas ayuda puntual)

### Infraestructura
- **Dominio:** $12/año (reservapanama.com)
- **Railway (Backend):** $5-20/mes = $60-240/año
- **Supabase:** $0 (tier gratis suficiente para MVP)
- **Vercel:** $0 (tier gratis)
- **Google Maps API:** ~$50/mes con tráfico moderado = $600/año
- **WhatsApp Business API:** $0-100/año (depende volumen)

**TOTAL AÑO 1:** $700-1000 USD (sin marketing)

### Marketing (opcional)
- **Facebook/Instagram Ads:** $200-500/mes durante picos (Navidad, Madres, San Valentín)
- **Google Ads:** $300-800/mes (keywords locales)
- **Influencers locales:** $50-200/post

---

## RIESGOS & MITIGACIÓN

### Riesgo 1: Datos desactualizados
**Mitigación:** 
- Scrapers automáticos diarios
- Sistema de reportes de usuarios
- Llamadas manuales pre-fechas críticas

### Riesgo 2: Restaurantes no cooperan
**Mitigación:**
- Empezar con info pública (no necesitas permiso)
- Ofrecer valor gratis primero
- Demostrar tráfico antes de pedir partnership

### Riesgo 3: OpenTable/competidores bloquean scraping
**Mitigación:**
- Rotar IPs (proxies)
- Rate limiting inteligente
- Tener plan B: agregación manual

### Riesgo 4: Baja adopción de usuarios
**Mitigación:**
- SEO agresivo desde día 1
- Marketing en fechas específicas (no constante)
- Partnerships con bloggers de comida

---

## MÉTRICAS DE ÉXITO - 3 MESES

**MVP es exitoso SI:**
- ✅ 50+ restaurantes en la base de datos
- ✅ 500+ visitas orgánicas/mes
- ✅ 10+ clicks a reservaciones/semana
- ✅ 3+ restaurantes piden información sobre tier premium
- ✅ Tasa de rebote < 70%
- ✅ Tiempo en sitio > 2 minutos promedio

**Si NO se cumple:**
- Pivotar a nicho más específico (solo eventos de lujo, solo brunch, etc.)
- Considerar otras ciudades de LATAM
- O... hacer sunset y aprender de la experiencia

---

## NEXT STEPS INMEDIATOS (HOY)

1. ✅ Leer este documento completo
2. ⬜ Revisar el código base que viene en los siguientes archivos
3. ⬜ Crear cuenta en Supabase (gratis)
4. ⬜ Crear cuenta en Vercel (gratis)
5. ⬜ Crear cuenta en Railway (gratis, luego $5/mes)
6. ⬜ Clonar repos y hacer setup local
7. ⬜ Ejecutar primer scraper de prueba
8. ⬜ Decidir: ¿Voy solo o busco 1 co-founder técnico?

---

**PIPO, este es el mapa. El territorio está ahí afuera. Ahora viene el código.** 🚀

# 🗓️ RESERVA PANAMÁ - ROADMAP DE EJECUCIÓN

## FASE 0: SETUP INICIAL (Semana 1)

### Día 1-2: Infraestructura
- [ ] **Crear cuenta Supabase** (gratis)
  - Ir a https://supabase.com
  - Crear nuevo proyecto: "reserva-panama"
  - Copiar API keys (Settings > API)
  - Guardar URL del proyecto
  
- [ ] **Crear cuenta Vercel** (gratis)
  - Ir a https://vercel.com
  - Conectar con GitHub
  - Preparar para deploy automático
  
- [ ] **Crear cuenta Railway** (gratis, luego $5/mes)
  - Ir a https://railway.app
  - Alternativa: Render.com también gratis

- [ ] **Comprar dominio** (opcional para MVP)
  - reservapanama.com o similar
  - ~$12/año en Namecheap/GoDaddy

### Día 3-4: Base de Datos
- [ ] **Ejecutar SQL en Supabase**
  - Ir a SQL Editor en Supabase
  - Crear tabla `restaurants`
  - Crear tabla `special_events`
  - Crear índices para búsquedas rápidas
  
```sql
-- Script SQL completo en archivo separado: database_schema.sql
```

- [ ] **Configurar autenticación** (para admin después)
  - Habilitar Email Auth en Supabase
  - Crear usuario admin

### Día 5-7: Código Base
- [ ] **Clonar estructura de carpetas**
  ```bash
  mkdir reserva_panama_project
  cd reserva_panama_project
  mkdir backend frontend
  ```

- [ ] **Setup Backend**
  ```bash
  cd backend
  python3 -m venv venv
  source venv/bin/activate  # En Windows: venv\Scripts\activate
  pip install -r requirements.txt
  playwright install chromium
  cp .env.example .env
  # Editar .env con tus keys de Supabase
  ```

- [ ] **Setup Frontend**
  ```bash
  cd frontend
  npx create-next-app@latest . --typescript --tailwind --app
  npm install lucide-react
  # Copiar componentes del código proporcionado
  ```

- [ ] **Primer test local**
  ```bash
  # Terminal 1 - Backend
  cd backend
  python main.py
  # Debe correr en http://localhost:8000
  
  # Terminal 2 - Frontend
  cd frontend
  npm run dev
  # Debe correr en http://localhost:3000
  ```

---

## FASE 1: MVP FUNCIONAL (Semana 2-3)

### Semana 2: Backend + Scraping

#### Día 1-2: API Endpoints
- [ ] Implementar GET /api/restaurants con filtros
- [ ] Implementar GET /api/restaurants/:slug
- [ ] Implementar GET /api/events
- [ ] Probar endpoints con Postman/Thunder Client

#### Día 3-4: Scraper de Instagram
- [ ] Configurar lista inicial de 10 restaurantes
- [ ] Ejecutar scraper manualmente
- [ ] Validar que guarda eventos en Supabase
- [ ] Refinar keywords de detección

#### Día 5-7: Contenido Inicial
- [ ] **Agregar manualmente 20 restaurantes a la DB**
  - Buscar en Google Maps
  - Extraer: nombre, dirección, teléfono, Instagram
  - Clasificar por zona y tipo de cocina
  - Conseguir fotos (Google Maps, Instagram con permiso)

- [ ] **Agregar eventos para Día de las Madres**
  - Buscar anuncios en Instagram/Facebook
  - Llamar a restaurantes para confirmar datos
  - Ingresar manualmente en Supabase

### Semana 3: Frontend

#### Día 1-2: Landing Page
- [ ] Implementar hero section
- [ ] Implementar SearchBar component
- [ ] Conectar con API backend
- [ ] Probar búsqueda y filtros

#### Día 3-4: Página de Resultados
- [ ] Crear /restaurantes/page.tsx
- [ ] Grid de tarjetas de restaurantes
- [ ] Paginación
- [ ] Filtros sidebar

#### Día 5-6: Página Individual de Restaurante
- [ ] Crear /restaurantes/[slug]/page.tsx
- [ ] Galería de imágenes
- [ ] Mapa integrado (Google Maps iframe básico)
- [ ] Lista de eventos especiales
- [ ] Botones de CTA (WhatsApp, teléfono, OpenTable)

#### Día 7: Polish
- [ ] Loading states (skeletons)
- [ ] Error handling
- [ ] Responsive design mobile
- [ ] Optimización de imágenes (Next.js Image)

---

## FASE 2: LANZAMIENTO SUAVE (Semana 4)

### Semana 4: Deployment + Testing

#### Día 1-2: Deploy Backend
- [ ] Crear proyecto en Railway
- [ ] Conectar repo GitHub
- [ ] Configurar variables de entorno
- [ ] Verificar que API responde
- [ ] Configurar dominio custom (api.reservapanama.com)

#### Día 3: Deploy Frontend
- [ ] Push código a GitHub
- [ ] Importar proyecto en Vercel
- [ ] Configurar variables de entorno
- [ ] Verificar build exitoso
- [ ] Conectar dominio custom (reservapanama.com)

#### Día 4: SEO Básico
- [ ] Configurar metadata en cada página
- [ ] Generar sitemap.xml
- [ ] Crear robots.txt
- [ ] Submit a Google Search Console
- [ ] Verificar Schema.org markup

#### Día 5-6: Testing Real
- [ ] Probar en móviles reales (iOS/Android)
- [ ] Probar en diferentes navegadores
- [ ] Compartir con 5-10 amigos cercanos
- [ ] Recolectar feedback
- [ ] Fix bugs críticos

#### Día 7: Soft Launch
- [ ] Publicar en redes sociales personales
- [ ] Enviar a grupos de WhatsApp de comida
- [ ] Post en Reddit Panama
- [ ] Instalar Google Analytics 4

---

## FASE 3: MARKETING & GROWTH (Semana 5-8)

### Semana 5: Contenido + Outreach

- [ ] **Expandir a 50 restaurantes**
  - Priorizar restaurantes populares
  - Diversificar zonas y tipos de cocina
  
- [ ] **Contactar restaurantes directamente**
  - Email template profesional
  - Oferta: "Listado gratis durante 3 meses"
  - Pedir: verificar datos, compartir eventos
  
- [ ] **Crear contenido de blog** (opcional)
  - "Top 10 Restaurantes para Día de las Madres 2025"
  - "Guía Completa: Brunch en Ciudad de Panamá"
  - SEO-optimizado

### Semana 6: Redes Sociales

- [ ] **Crear perfiles**
  - Instagram: @reservapanama
  - Facebook Page: Reserva Panamá
  - TikTok (opcional)
  
- [ ] **Estrategia de contenido**
  - 3-5 posts/semana
  - Contenido: recomendaciones, tips, eventos destacados
  - Repostear contenido de restaurantes (con permiso)
  
- [ ] **Colaboraciones**
  - Contactar food bloggers locales
  - Ofrecer features destacados a cambio de shares
  - Intercambio de audiencias

### Semana 7: Paid Marketing (Opcional - Budget: $200-500)

- [ ] **Facebook/Instagram Ads**
  - Campaña específica para Día de las Madres
  - Target: Panamá, 25-55 años, interés en restaurantes
  - Objetivo: Tráfico al sitio web
  
- [ ] **Google Ads** (si budget permite)
  - Keywords: "restaurantes día de las madres panama"
  - "brunch panama", "eventos especiales restaurantes"
  - Búsquedas locales

### Semana 8: Análisis + Iteración

- [ ] **Revisar métricas**
  - Google Analytics: tráfico, fuentes, conversiones
  - Supabase: restaurantes más vistos
  - Clicks en botones de reserva
  
- [ ] **Encuesta a usuarios**
  - Form simple: "¿Qué mejorarías?"
  - ¿Encontraste lo que buscabas?
  
- [ ] **Decidir próximos pasos**
  - ¿Funciona? → Escalar
  - ¿No funciona? → Pivotar o sunset

---

## FASE 4: MONETIZACIÓN (Semana 9+)

### Solo si el MVP muestra tracción

- [ ] **Tier Premium para restaurantes**
  - Diseñar página de precios
  - Crear dashboard para restaurantes
  - Sistema de pagos (Stripe)
  
- [ ] **Features premium**
  - Perfil destacado
  - Analytics avanzado
  - Soporte prioritario
  
- [ ] **Buscar primeros 3-5 clientes de pago**
  - Ofrecer 50% descuento primeros 3 meses
  - Testimonios y caso de estudio

---

## CHECKLIST DIARIO (Durante Desarrollo)

### Cada Mañana
- [ ] Revisar analytics (tráfico, errores)
- [ ] Monitorear uptime (UptimeRobot gratis)
- [ ] Ejecutar scraper si no está automatizado

### Cada Semana
- [ ] Actualizar eventos manualmente
- [ ] Agregar 5+ restaurantes nuevos
- [ ] Publicar 3+ posts en redes sociales
- [ ] Responder comentarios/mensajes

### Cada Mes
- [ ] Review de métricas completo
- [ ] Llamar a 10 restaurantes para feedback
- [ ] Ajustar estrategia según data

---

## RECURSOS CRÍTICOS

### Tools Gratuitas Recomendadas
- **Design**: Figma (gratis)
- **Images**: Unsplash, Pexels
- **Icons**: Lucide Icons (ya en el proyecto)
- **Analytics**: Google Analytics 4, Vercel Analytics
- **Monitoring**: UptimeRobot (gratis 50 monitors)
- **Email**: Gmail + Aliases (gratis)

### Comunidades de Ayuda
- **Reddit**: r/Panama, r/nextjs, r/FastAPI
- **Discord**: Next.js Discord, FastAPI Discord
- **Stack Overflow**: Para bugs específicos

### Contingencia si Te Atascas
1. **Google el error específico**
2. **Preguntar en Stack Overflow**
3. **Consultar documentación oficial**
4. **Contratar freelancer en Fiverr** ($50-200 para fixes puntuales)

---

## CRITERIOS DE GO/NO-GO

### Después de 3 meses, reevaluar:

**Continuar SI:**
- ✅ 500+ usuarios únicos/mes
- ✅ 50+ clicks a reservaciones/semana
- ✅ 2+ restaurantes interesados en pagar
- ✅ Tasa de crecimiento positiva MoM

**Pivotar SI:**
- ⚠️ Tráfico estancado o bajando
- ⚠️ Alta tasa de rebote (>80%)
- ⚠️ Cero interés de restaurantes en pagar

**Sunset SI:**
- ❌ Cero tracción después de marketing intensivo
- ❌ Problemas legales/bloqueos técnicos insuperables
- ❌ Ya no te apasiona el proyecto

---

## FILOSOFÍA DE EJECUCIÓN

> "Hecho es mejor que perfecto. Lanzado es mejor que pulido."

- **Prioriza velocidad** sobre perfección en MVP
- **Habla con usuarios reales** desde semana 1
- **Mide todo**, pero no te paralices con data
- **Automatiza solo después** de validar manualmente
- **No optimices prematuramente**

**PIPO: Este es tu mapa. Ahora ejecuta. 🚀**

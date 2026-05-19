# RESERVA PANAMÁ - Instagram Scraper
# Archivo: backend/scraper_instagram.py
# Scraper para detectar eventos especiales en Instagram de restaurantes

import asyncio
import re
from datetime import datetime, date
from typing import List, Dict, Optional
import os

# Playwright para scraping con JavaScript rendering
from playwright.async_api import async_playwright, Page
from supabase import create_client, Client

# ============================================
# CONFIGURACIÓN
# ============================================

SUPABASE_URL = os.getenv("SUPABASE_URL", "https://tu-proyecto.supabase.co")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_KEY", "tu-service-key-aqui")  # Usar service key para admin
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

# Lista de restaurantes a monitorear (expandir dinámicamente desde DB)
TARGET_RESTAURANTS = [
    {
        "name": "Bazaar Restaurant",
        "instagram": "bazaarpanama",
        "restaurant_id": "uuid-placeholder-1"
    },
    {
        "name": "Michael's Restaurant",
        "instagram": "michaelspty",
        "restaurant_id": "uuid-placeholder-2"
    },
    {
        "name": "Restaurante Mansa",
        "instagram": "restaurante.mansa",
        "restaurant_id": "uuid-placeholder-3"
    },
    # Agregar más restaurantes aquí
]

# Keywords para detectar eventos especiales
EVENT_KEYWORDS = [
    "día de las madres",
    "día de la madre",
    "mother's day",
    "mothers day",
    "8 de diciembre",
    "reserva",
    "reservación",
    "reservations",
    "evento especial",
    "brunch",
    "buffet",
    "menú especial",
    "special menu"
]

# ============================================
# FUNCIONES DE SCRAPING
# ============================================

async def scrape_instagram_profile(page: Page, username: str) -> List[Dict]:
    """
    Scrape posts recientes de un perfil de Instagram
    """
    try:
        url = f"https://www.instagram.com/{username}/"
        await page.goto(url, wait_until="networkidle", timeout=30000)
        
        # Esperar a que carguen los posts
        await page.wait_for_selector("article", timeout=10000)
        
        # Extraer posts (últimos 9-12 posts visibles sin scroll)
        posts = await page.eval_on_selector_all(
            "article a[href*='/p/']",
            """
            (elements) => elements.slice(0, 9).map(el => ({
                url: el.href,
                image: el.querySelector('img')?.src
            }))
            """
        )
        
        print(f"✓ Encontrados {len(posts)} posts de @{username}")
        return posts
        
    except Exception as e:
        print(f"✗ Error scraping @{username}: {str(e)}")
        return []

async def scrape_instagram_post(page: Page, post_url: str) -> Optional[Dict]:
    """
    Scrape detalles de un post individual
    """
    try:
        await page.goto(post_url, wait_until="networkidle", timeout=20000)
        await asyncio.sleep(2)  # Dar tiempo para que cargue el contenido
        
        # Extraer caption/texto del post
        caption = await page.eval_on_selector(
            "h1",
            "el => el.textContent"
        ) if await page.query_selector("h1") else ""
        
        # Extraer fecha de publicación
        time_element = await page.query_selector("time")
        post_date = await time_element.get_attribute("datetime") if time_element else None
        
        # Extraer imagen principal
        image = await page.eval_on_selector(
            "article img",
            "el => el.src"
        ) if await page.query_selector("article img") else None
        
        return {
            "url": post_url,
            "caption": caption,
            "date": post_date,
            "image": image
        }
        
    except Exception as e:
        print(f"✗ Error scraping post {post_url}: {str(e)}")
        return None

def detect_event_in_text(text: str) -> bool:
    """
    Detectar si el texto contiene keywords de eventos especiales
    """
    text_lower = text.lower()
    return any(keyword in text_lower for keyword in EVENT_KEYWORDS)

def extract_event_details(text: str, restaurant_id: str) -> Optional[Dict]:
    """
    Extraer detalles del evento del texto (NLP básico)
    """
    if not detect_event_in_text(text):
        return None
    
    # Extraer precio (formato: $XX, $XX.XX, B/.XX)
    price_match = re.search(r'(?:B\/\.|\$)\s*(\d+(?:\.\d{2})?)', text)
    price = float(price_match.group(1)) if price_match else None
    
    # Detectar "8 de diciembre" o "December 8"
    date_match = re.search(r'8\s+de\s+diciembre|december\s+8', text, re.IGNORECASE)
    event_date = date(2025, 12, 8) if date_match else None
    
    # Detectar "música en vivo" / "live music"
    has_live_music = bool(re.search(r'música\s+en\s+vivo|live\s+music', text, re.IGNORECASE))
    
    # Detectar "menú especial" / "special menu"
    has_special_menu = bool(re.search(r'menú\s+especial|special\s+menu', text, re.IGNORECASE))
    
    # Extraer número de teléfono / WhatsApp
    phone_match = re.search(r'(?:\+?507[\s-]?)?[0-9]{4}[\s-]?[0-9]{4}', text)
    phone = phone_match.group(0) if phone_match else None
    
    return {
        "restaurant_id": restaurant_id,
        "event_name": "Día de las Madres 2025",  # Ajustar según detección
        "event_date": event_date.isoformat() if event_date else None,
        "description": text[:500],  # Primeros 500 caracteres
        "price_adult": price,
        "has_live_music": has_live_music,
        "has_special_menu": has_special_menu,
        "booking_phone": phone,
        "is_active": True
    }

# ============================================
# PIPELINE PRINCIPAL
# ============================================

async def scrape_all_restaurants():
    """
    Pipeline completo: scraping + detección + almacenamiento
    """
    async with async_playwright() as p:
        # Lanzar navegador (usar chromium)
        browser = await p.chromium.launch(headless=True)
        context = await browser.new_context(
            viewport={"width": 1280, "height": 720},
            user_agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36"
        )
        page = await context.new_page()
        
        all_events = []
        
        for restaurant in TARGET_RESTAURANTS:
            print(f"\n🔍 Scraping @{restaurant['instagram']}...")
            
            # Obtener posts del perfil
            posts = await scrape_instagram_profile(page, restaurant["instagram"])
            
            # Analizar cada post
            for post in posts:
                post_details = await scrape_instagram_post(page, post["url"])
                
                if post_details and post_details["caption"]:
                    # Detectar si es un evento especial
                    event_data = extract_event_details(
                        post_details["caption"],
                        restaurant["restaurant_id"]
                    )
                    
                    if event_data:
                        print(f"  ✓ Evento detectado: {post['url']}")
                        event_data["image_url"] = post_details["image"]
                        event_data["booking_url"] = post["url"]
                        all_events.append(event_data)
                
                await asyncio.sleep(1)  # Rate limiting
        
        await browser.close()
        
        # Guardar eventos en la base de datos
        if all_events:
            print(f"\n💾 Guardando {len(all_events)} eventos en la base de datos...")
            try:
                response = supabase.table("special_events").upsert(all_events).execute()
                print(f"✓ {len(response.data)} eventos guardados exitosamente")
            except Exception as e:
                print(f"✗ Error guardando eventos: {str(e)}")
        else:
            print("\n⚠️  No se detectaron eventos especiales")
        
        return all_events

# ============================================
# EJECUCIÓN
# ============================================

async def main():
    print("🚀 Iniciando scraper de Instagram para Reserva Panamá")
    print(f"📅 Fecha: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 60)
    
    events = await scrape_all_restaurants()
    
    print("\n" + "=" * 60)
    print(f"✅ Scraping completado. Total eventos: {len(events)}")

if __name__ == "__main__":
    # Instalar dependencias primero:
    # pip install playwright supabase
    # playwright install chromium
    
    asyncio.run(main())

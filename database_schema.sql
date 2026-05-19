-- RESERVA PANAMÁ - Database Schema (Supabase/PostgreSQL)
-- Archivo: database_schema.sql
--
-- INSTRUCCIONES:
-- 1. Abrir Supabase Dashboard > SQL Editor
-- 2. Copiar y pegar este script completo
-- 3. Ejecutar (Run)
-- 4. Verificar que las tablas se crearon correctamente

-- ============================================
-- ENABLE EXTENSIONS
-- ============================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm"; -- Para búsqueda fuzzy

-- ============================================
-- TABLE: restaurants
-- ============================================
CREATE TABLE IF NOT EXISTS restaurants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    description TEXT,
    address TEXT NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    phone TEXT,
    whatsapp TEXT,
    instagram TEXT,
    facebook TEXT,
    opentable_url TEXT,
    website TEXT,
    cuisine_type TEXT[] DEFAULT '{}',
    price_range INTEGER CHECK (price_range >= 1 AND price_range <= 4),
    average_rating DECIMAL(3, 2) CHECK (average_rating >= 0 AND average_rating <= 5),
    image_url TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para búsquedas rápidas
CREATE INDEX idx_restaurants_slug ON restaurants(slug);
CREATE INDEX idx_restaurants_is_active ON restaurants(is_active);
CREATE INDEX idx_restaurants_cuisine_type ON restaurants USING GIN(cuisine_type);
CREATE INDEX idx_restaurants_name_trgm ON restaurants USING GIN(name gin_trgm_ops);
CREATE INDEX idx_restaurants_location ON restaurants(latitude, longitude);

-- Trigger para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_restaurants_updated_at 
    BEFORE UPDATE ON restaurants
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- TABLE: special_events
-- ============================================
CREATE TABLE IF NOT EXISTS special_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    restaurant_id UUID NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
    event_name TEXT NOT NULL,
    event_date DATE NOT NULL,
    start_time TIME,
    end_time TIME,
    description TEXT,
    menu_details TEXT,
    price_adult DECIMAL(10, 2),
    price_child DECIMAL(10, 2),
    price_senior DECIMAL(10, 2),
    has_live_music BOOLEAN DEFAULT FALSE,
    has_special_menu BOOLEAN DEFAULT FALSE,
    image_url TEXT,
    booking_url TEXT,
    booking_phone TEXT,
    booking_whatsapp TEXT,
    seats_available INTEGER,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX idx_events_restaurant_id ON special_events(restaurant_id);
CREATE INDEX idx_events_event_date ON special_events(event_date);
CREATE INDEX idx_events_is_active ON special_events(is_active);
CREATE INDEX idx_events_date_active ON special_events(event_date, is_active);

CREATE TRIGGER update_special_events_updated_at 
    BEFORE UPDATE ON special_events
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- TABLE: user_searches (Analytics)
-- ============================================
CREATE TABLE IF NOT EXISTS user_searches (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    search_date DATE,
    search_location TEXT,
    filters_used JSONB,
    results_count INTEGER,
    clicked_restaurant_id UUID REFERENCES restaurants(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_user_searches_date ON user_searches(created_at);
CREATE INDEX idx_user_searches_restaurant ON user_searches(clicked_restaurant_id);

-- ============================================
-- TABLE: restaurant_reviews (Futuro)
-- ============================================
CREATE TABLE IF NOT EXISTS restaurant_reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    restaurant_id UUID NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
    user_name TEXT,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    visit_date DATE,
    is_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_reviews_restaurant_id ON restaurant_reviews(restaurant_id);
CREATE INDEX idx_reviews_rating ON restaurant_reviews(rating);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

-- Habilitar RLS en todas las tablas
ALTER TABLE restaurants ENABLE ROW LEVEL SECURITY;
ALTER TABLE special_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_searches ENABLE ROW LEVEL SECURITY;
ALTER TABLE restaurant_reviews ENABLE ROW LEVEL SECURITY;

-- Políticas: Lectura pública, escritura solo autenticado

-- RESTAURANTS: Lectura pública de restaurantes activos
CREATE POLICY "Public read access for active restaurants"
    ON restaurants FOR SELECT
    USING (is_active = TRUE);

-- RESTAURANTS: Admin puede hacer todo (requiere auth)
CREATE POLICY "Authenticated users can manage restaurants"
    ON restaurants FOR ALL
    USING (auth.role() = 'authenticated');

-- EVENTS: Lectura pública de eventos activos
CREATE POLICY "Public read access for active events"
    ON special_events FOR SELECT
    USING (is_active = TRUE);

-- EVENTS: Admin puede hacer todo
CREATE POLICY "Authenticated users can manage events"
    ON special_events FOR ALL
    USING (auth.role() = 'authenticated');

-- USER_SEARCHES: Cualquiera puede insertar (analytics anónimo)
CREATE POLICY "Anyone can insert search logs"
    ON user_searches FOR INSERT
    WITH CHECK (TRUE);

-- USER_SEARCHES: Solo admin puede leer
CREATE POLICY "Only authenticated can read search logs"
    ON user_searches FOR SELECT
    USING (auth.role() = 'authenticated');

-- REVIEWS: Lectura pública de reviews activas
CREATE POLICY "Public read access for active reviews"
    ON restaurant_reviews FOR SELECT
    USING (is_active = TRUE);

-- REVIEWS: Cualquiera puede insertar (moderar después)
CREATE POLICY "Anyone can insert reviews"
    ON restaurant_reviews FOR INSERT
    WITH CHECK (TRUE);

-- ============================================
-- FUNCIONES ÚTILES
-- ============================================

-- Función para generar slug a partir del nombre
CREATE OR REPLACE FUNCTION generate_slug(text_input TEXT)
RETURNS TEXT AS $$
BEGIN
    RETURN lower(
        regexp_replace(
            regexp_replace(
                unaccent(text_input),
                '[^a-zA-Z0-9\s-]', '', 'g'
            ),
            '\s+', '-', 'g'
        )
    );
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Función para buscar restaurantes (full-text search)
CREATE OR REPLACE FUNCTION search_restaurants(search_query TEXT)
RETURNS TABLE (
    id UUID,
    name TEXT,
    slug TEXT,
    description TEXT,
    similarity REAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.id,
        r.name,
        r.slug,
        r.description,
        GREATEST(
            similarity(r.name, search_query),
            similarity(COALESCE(r.description, ''), search_query)
        ) AS sim
    FROM restaurants r
    WHERE 
        r.is_active = TRUE
        AND (
            r.name ILIKE '%' || search_query || '%'
            OR r.description ILIKE '%' || search_query || '%'
            OR search_query <% r.name
        )
    ORDER BY sim DESC
    LIMIT 20;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- DATOS DE EJEMPLO (Seed Data)
-- ============================================

-- Insertar 3 restaurantes de ejemplo
INSERT INTO restaurants (
    name, 
    slug, 
    description, 
    address, 
    latitude, 
    longitude, 
    phone, 
    whatsapp,
    instagram,
    cuisine_type, 
    price_range, 
    average_rating,
    image_url,
    is_active
) VALUES 
(
    'Bazaar Restaurant',
    'bazaar-restaurant',
    'Restaurante buffet internacional en Megapolis Hotel con eventos especiales para fechas importantes.',
    'Megapolis Hotel, Avenida Balboa, Ciudad de Panamá',
    8.9667,
    -79.5333,
    '+507 6948-9268',
    '+5076948-9268',
    'bazaarpanama',
    ARRAY['Internacional', 'Buffet', 'Contemporánea'],
    3,
    4.2,
    'https://example.com/bazaar.jpg',
    TRUE
),
(
    'Michael''s Restaurant',
    'michaels-restaurant',
    'Experiencia culinaria de alta gama con menús innovadores y ambiente sofisticado.',
    'Calle 53 Este, Marbella, Ciudad de Panamá',
    8.9833,
    -79.5167,
    '+507 265-7011',
    '+507265-7011',
    'michaelspty',
    ARRAY['Fusión', 'Gourmet', 'Contemporánea'],
    4,
    4.7,
    'https://example.com/michaels.jpg',
    TRUE
),
(
    'Restaurante Mansa',
    'restaurante-mansa',
    'Cocina panameña contemporánea en Buenaventura Resort con vistas espectaculares.',
    'Buenaventura Golf & Beach Resort, Río Hato',
    8.3833,
    -80.1167,
    '+507 6837-3118',
    '+5076837-3118',
    'restaurante.mansa',
    ARRAY['Panameña', 'Contemporánea', 'Mariscos'],
    3,
    4.5,
    'https://example.com/mansa.jpg',
    TRUE
);

-- Insertar eventos de ejemplo para Día de las Madres
INSERT INTO special_events (
    restaurant_id,
    event_name,
    event_date,
    start_time,
    end_time,
    description,
    price_adult,
    price_child,
    has_live_music,
    has_special_menu,
    booking_phone,
    booking_whatsapp,
    is_active
) VALUES
(
    (SELECT id FROM restaurants WHERE slug = 'bazaar-restaurant'),
    'Buffet Día de las Madres 2025',
    '2025-12-08',
    '12:00:00',
    '15:00:00',
    'Buffet internacional con música en vivo y regalos para todas las madres.',
    42.00,
    21.00,
    TRUE,
    TRUE,
    '+507 6948-9268',
    '+5076948-9268',
    TRUE
),
(
    (SELECT id FROM restaurants WHERE slug = 'michaels-restaurant'),
    'Brunch Especial Día de las Madres',
    '2025-12-08',
    '11:00:00',
    '15:00:00',
    'Menú exclusivo de 4 tiempos con maridaje de vinos.',
    85.00,
    NULL,
    FALSE,
    TRUE,
    '+507 265-7011',
    '+507265-7011',
    TRUE
),
(
    (SELECT id FROM restaurants WHERE slug = 'restaurante-mansa'),
    'Almuerzo Día de las Madres Vista al Mar',
    '2025-12-08',
    '12:30:00',
    '16:00:00',
    'Menú especial con mariscos frescos y vistas espectaculares al Pacífico.',
    65.00,
    32.50,
    TRUE,
    TRUE,
    '+507 6837-3118',
    '+5076837-3118',
    TRUE
);

-- ============================================
-- VERIFICACIÓN
-- ============================================

-- Contar registros insertados
SELECT 
    'restaurants' AS table_name, 
    COUNT(*) AS total_rows 
FROM restaurants
UNION ALL
SELECT 
    'special_events' AS table_name, 
    COUNT(*) AS total_rows 
FROM special_events
UNION ALL
SELECT 
    'user_searches' AS table_name, 
    COUNT(*) AS total_rows 
FROM user_searches;

-- Mostrar restaurantes con sus eventos
SELECT 
    r.name AS restaurant,
    e.event_name,
    e.event_date,
    e.price_adult
FROM restaurants r
LEFT JOIN special_events e ON r.id = e.restaurant_id
WHERE r.is_active = TRUE
ORDER BY r.name, e.event_date;

-- ============================================
-- FIN DEL SCRIPT
-- ============================================

-- Siguiente paso: Copiar tus API keys de Supabase al archivo .env del backend

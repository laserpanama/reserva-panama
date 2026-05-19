// RESERVA PANAMÁ - Search Bar Component
// Archivo: frontend/components/SearchBar.tsx

'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { Search, Calendar, MapPin, DollarSign } from 'lucide-react'

const ZONES = [
  'Todas las zonas',
  'Casco Viejo',
  'Cinta Costera',
  'Costa del Este',
  'Paitilla',
  'Marbella',
  'San Francisco',
  'Multiplaza',
]

const PRICE_RANGES = [
  { value: '', label: 'Todos los precios' },
  { value: '1', label: '$ (Económico)' },
  { value: '2', label: '$$ (Moderado)' },
  { value: '3', label: '$$$ (Alto)' },
  { value: '4', label: '$$$$ (Premium)' },
]

export default function SearchBar() {
  const router = useRouter()
  const [searchQuery, setSearchQuery] = useState('')
  const [selectedDate, setSelectedDate] = useState('')
  const [selectedZone, setSelectedZone] = useState('Todas las zonas')
  const [selectedPrice, setSelectedPrice] = useState('')

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault()
    
    // Construir query params
    const params = new URLSearchParams()
    if (searchQuery) params.set('q', searchQuery)
    if (selectedDate) params.set('date', selectedDate)
    if (selectedZone !== 'Todas las zonas') params.set('zone', selectedZone)
    if (selectedPrice) params.set('price', selectedPrice)
    
    // Navegar a página de resultados
    router.push(`/restaurantes?${params.toString()}`)
  }

  return (
    <form onSubmit={handleSearch} className="space-y-4">
      {/* Búsqueda principal */}
      <div className="relative">
        <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400 w-5 h-5" />
        <input
          type="text"
          placeholder="Buscar restaurantes, cocina, eventos..."
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          className="w-full pl-12 pr-4 py-4 rounded-lg border-2 border-gray-200 focus:border-orange-500 focus:outline-none text-gray-900 text-lg"
        />
      </div>

      {/* Filtros rápidos */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
        {/* Fecha */}
        <div className="relative">
          <Calendar className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 w-4 h-4" />
          <input
            type="date"
            value={selectedDate}
            onChange={(e) => setSelectedDate(e.target.value)}
            min={new Date().toISOString().split('T')[0]}
            className="w-full pl-10 pr-4 py-3 rounded-lg border-2 border-gray-200 focus:border-orange-500 focus:outline-none text-gray-700"
          />
        </div>

        {/* Zona */}
        <div className="relative">
          <MapPin className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 w-4 h-4" />
          <select
            value={selectedZone}
            onChange={(e) => setSelectedZone(e.target.value)}
            className="w-full pl-10 pr-4 py-3 rounded-lg border-2 border-gray-200 focus:border-orange-500 focus:outline-none text-gray-700 appearance-none bg-white"
          >
            {ZONES.map(zone => (
              <option key={zone} value={zone}>{zone}</option>
            ))}
          </select>
        </div>

        {/* Precio */}
        <div className="relative">
          <DollarSign className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 w-4 h-4" />
          <select
            value={selectedPrice}
            onChange={(e) => setSelectedPrice(e.target.value)}
            className="w-full pl-10 pr-4 py-3 rounded-lg border-2 border-gray-200 focus:border-orange-500 focus:outline-none text-gray-700 appearance-none bg-white"
          >
            {PRICE_RANGES.map(range => (
              <option key={range.value} value={range.value}>{range.label}</option>
            ))}
          </select>
        </div>
      </div>

      {/* Botón de búsqueda */}
      <button
        type="submit"
        className="w-full bg-gradient-to-r from-orange-600 to-amber-600 text-white py-4 rounded-lg font-semibold text-lg hover:from-orange-700 hover:to-amber-700 transition-all shadow-lg hover:shadow-xl"
      >
        Buscar Restaurantes
      </button>

      {/* Búsquedas rápidas sugeridas */}
      <div className="flex flex-wrap gap-2 justify-center">
        <QuickSearchButton onClick={() => setSelectedDate('2025-12-08')}>
          Día de las Madres
        </QuickSearchButton>
        <QuickSearchButton onClick={() => setSearchQuery('brunch')}>
          Brunch
        </QuickSearchButton>
        <QuickSearchButton onClick={() => setSearchQuery('música en vivo')}>
          Música en Vivo
        </QuickSearchButton>
        <QuickSearchButton onClick={() => setSelectedZone('Casco Viejo')}>
          Casco Viejo
        </QuickSearchButton>
      </div>
    </form>
  )
}

function QuickSearchButton({ 
  children, 
  onClick 
}: { 
  children: React.ReactNode
  onClick: () => void 
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      className="px-4 py-2 bg-orange-100 text-orange-700 rounded-full text-sm font-medium hover:bg-orange-200 transition-colors"
    >
      {children}
    </button>
  )
}

'use client'

import { useState } from 'react'
import { Hotel, UtensilsCrossed, Calendar, CheckCircle, Phone, Mail, MapPin } from 'lucide-react'

export default function HomePage() {
  const [form, setForm] = useState({ name: '', email: '', phone: '', date: '', guests: '2' })
  const [message, setMessage] = useState('')
  const [loading, setLoading] = useState(false)

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    try {
      const response = await fetch('http://localhost:8000/api/reservations', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          nombre: form.name,
          email: form.email,
          telefono: form.phone,
          fecha: form.date,
          hora: '19:00',
          personas: parseInt(form.guests)
        })
      })
      const data = await response.json()
      setMessage(data.message || '¡Reserva enviada con éxito!')
      if (data.success) {
        setForm({ name: '', email: '', phone: '', date: '', guests: '2' })
      }
    } catch (error) {
      setMessage('Error de conexión con el servidor')
    } finally {
      setLoading(false)
    }
  }

  const features = [
    { icon: <Hotel className="w-8 h-8" />, title: 'Hoteles 5 Estrellas', desc: 'Los mejores alojamientos' },
    { icon: <UtensilsCrossed className="w-8 h-8" />, title: 'Restaurantes Gourmet', desc: 'Experiencia culinaria única' },
    { icon: <Calendar className="w-8 h-8" />, title: 'Reservas Instantáneas', desc: 'Confirmación inmediata' },
    { icon: <CheckCircle className="w-8 h-8" />, title: 'Garantía de Calidad', desc: 'Servicio premium garantizado' }
  ]

  return (
    <div className="min-h-screen bg-gradient-to-b from-orange-50 to-amber-50">
      {/* Hero Section */}
      <div className="relative overflow-hidden bg-gradient-to-r from-orange-500 to-amber-500 text-white">
        <div className="absolute inset-0 bg-black/10"></div>
        <div className="relative container mx-auto px-4 py-20">
          <div className="max-w-3xl">
            <h1 className="text-5xl md:text-6xl font-bold mb-6">
              Descubre el <span className="text-amber-200">lujo tropical</span> de Panamá
            </h1>
            <p className="text-xl mb-8 opacity-90">
              Reserva los mejores hoteles, restaurantes y experiencias exclusivas en el corazón de Centroamérica.
            </p>
            <div className="flex gap-4">
              <button className="bg-white text-orange-600 px-8 py-3 rounded-lg font-semibold hover:bg-amber-50 transition">
                Explorar Destinos
              </button>
              <button className="border-2 border-white text-white px-8 py-3 rounded-lg font-semibold hover:bg-white/10 transition">
                Ver Ofertas
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Features */}
      <div className="container mx-auto px-4 py-16">
        <h2 className="text-3xl font-bold text-center text-gray-800 mb-12">
          Por qué elegir <span className="text-orange-500">Reserva Panamá</span>
        </h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          {features.map((feature, idx) => (
            <div key={idx} className="bg-white p-6 rounded-2xl shadow-lg hover:shadow-xl transition-shadow">
              <div className="text-orange-500 mb-4">{feature.icon}</div>
              <h3 className="text-xl font-bold text-gray-800 mb-2">{feature.title}</h3>
              <p className="text-gray-600">{feature.desc}</p>
            </div>
          ))}
        </div>
      </div>

      {/* Booking Form */}
      <div className="container mx-auto px-4 pb-20">
        <div className="max-w-2xl mx-auto bg-white rounded-3xl shadow-2xl overflow-hidden">
          <div className="bg-gradient-to-r from-orange-500 to-amber-500 p-8 text-white">
            <h2 className="text-3xl font-bold mb-2">Reserva Tu Experiencia</h2>
            <p className="opacity-90">Complete el formulario para acceder a ofertas exclusivas</p>
          </div>
          
          <form onSubmit={handleSubmit} className="p-8">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
              <div>
                <label className="block text-gray-700 mb-2">Nombre Completo</label>
                <input
                  type="text"
                  value={form.name}
                  onChange={e => setForm({...form, name: e.target.value})}
                  className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                  placeholder="Juan Pérez"
                  required
                />
              </div>
              <div>
                <label className="block text-gray-700 mb-2">Correo Electrónico</label>
                <input
                  type="email"
                  value={form.email}
                  onChange={e => setForm({...form, email: e.target.value})}
                  className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                  placeholder="juan@email.com"
                  required
                />
              </div>
              <div>
                <label className="block text-gray-700 mb-2">Teléfono</label>
                <input
                  type="tel"
                  value={form.phone}
                  onChange={e => setForm({...form, phone: e.target.value})}
                  className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                  placeholder="+507 6000 0000"
                />
              </div>
              <div>
                <label className="block text-gray-700 mb-2">Fecha de Reserva</label>
                <input
                  type="date"
                  value={form.date}
                  onChange={e => setForm({...form, date: e.target.value})}
                  className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                  required
                />
              </div>
              <div className="md:col-span-2">
                <label className="block text-gray-700 mb-2">Número de Personas</label>
                <select
                  value={form.guests}
                  onChange={e => setForm({...form, guests: e.target.value})}
                  className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                >
                  {[1,2,3,4,5,6,7,8].map(num => (
                    <option key={num} value={num}>{num} {num === 1 ? 'persona' : 'personas'}</option>
                  ))}
                </select>
              </div>
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-gradient-to-r from-orange-500 to-amber-500 text-white py-4 rounded-lg font-semibold text-lg hover:from-orange-600 hover:to-amber-600 transition disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? (
                <span className="flex items-center justify-center">
                  <svg className="animate-spin h-5 w-5 mr-3 text-white" viewBox="0 0 24 24">
                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" />
                    <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                  </svg>
                  Procesando...
                </span>
              ) : 'Reservar Ahora'}
            </button>

            {message && (
              <div className={`mt-6 p-4 rounded-lg ${message.includes('éxito') ? 'bg-green-50 text-green-700' : 'bg-red-50 text-red-700'}`}>
                {message}
              </div>
            )}
          </form>
        </div>
      </div>

      {/* Stats */}
      <div className="bg-gray-900 text-white py-12">
        <div className="container mx-auto px-4">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-8 text-center">
            <div>
              <div className="text-4xl font-bold text-amber-400 mb-2">500+</div>
              <div className="text-gray-400">Hoteles Asociados</div>
            </div>
            <div>
              <div className="text-4xl font-bold text-amber-400 mb-2">10K+</div>
              <div className="text-gray-400">Reservas Mensuales</div>
            </div>
            <div>
              <div className="text-4xl font-bold text-amber-400 mb-2">98%</div>
              <div className="text-gray-400">Satisfacción Cliente</div>
            </div>
            <div>
              <div className="text-4xl font-bold text-amber-400 mb-2">24/7</div>
              <div className="text-gray-400">Soporte Disponible</div>
            </div>
          </div>
        </div>
      </div>

      {/* Footer */}
      <footer className="bg-gray-800 text-white py-12">
        <div className="container mx-auto px-4">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div>
              <h3 className="text-2xl font-bold mb-4 flex items-center">
                <span className="text-amber-400">🏝️</span> Reserva Panamá
              </h3>
              <p className="text-gray-400">
                Tu puerta de entrada al lujo tropical. Experiencias exclusivas en el corazón de Centroamérica.
              </p>
            </div>
            <div>
              <h4 className="text-xl font-bold mb-4">Contacto</h4>
              <div className="space-y-3">
                <div className="flex items-center text-gray-400">
                  <Phone className="w-5 h-5 mr-3" /> +507 1234 5678
                </div>
                <div className="flex items-center text-gray-400">
                  <Mail className="w-5 h-5 mr-3" /> info@reservapanama.com
                </div>
                <div className="flex items-center text-gray-400">
                  <MapPin className="w-5 h-5 mr-3" /> Ciudad de Panamá, Panamá
                </div>
              </div>
            </div>
            <div>
              <h4 className="text-xl font-bold mb-4">Enlaces Rápidos</h4>
              <div className="space-y-2">
                <a href="http://localhost:8000/docs" target="_blank" className="block text-gray-400 hover:text-amber-400 transition">
                  📚 Documentación API
                </a>
                <a href="http://localhost:8000/health" target="_blank" className="block text-gray-400 hover:text-amber-400 transition">
                  ❤️ Estado del Sistema
                </a>
                <a href="https://supabase.com" target="_blank" className="block text-gray-400 hover:text-amber-400 transition">
                  🗄️ Dashboard Supabase
                </a>
              </div>
            </div>
          </div>
          <div className="border-t border-gray-700 mt-8 pt-8 text-center text-gray-500">
            <p>© 2024 Reserva Panamá. Sistema completamente operacional. Backend: FastAPI + Supabase | Frontend: Next.js</p>
          </div>
        </div>
      </footer>
    </div>
  )
}
---
layout: default
title: "Galeria"
permalink: /galeria/
---

<section class="relative overflow-hidden bg-gradient-to-br from-navy-50 via-white to-teal-50 py-20">
  <div class="absolute inset-0 overflow-hidden">
    <div class="absolute -top-20 -right-20 w-80 h-80 bg-accent-100/20 rounded-full blur-3xl"></div>
  </div>
  <div class="relative max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="text-center mb-12">
      <h1 class="text-3xl sm:text-4xl font-bold text-navy-700 mb-4">Galería</h1>
      <p class="text-lg text-gray-500 max-w-2xl mx-auto">
        Fotos de nuestros eventos y reuniones. Celebramos la comunidad en cada meetup.
      </p>
    </div>

    <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 mb-12">
      <div class="aspect-square rounded-xl overflow-hidden bg-gradient-to-br from-accent-100 to-teal-100 flex items-center justify-center group hover:scale-105 transition-transform duration-300">
        <span class="text-4xl">🎉</span>
      </div>
      <div class="aspect-square rounded-xl overflow-hidden bg-gradient-to-br from-teal-100 to-navy-100 flex items-center justify-center group hover:scale-105 transition-transform duration-300">
        <span class="text-4xl">💻</span>
      </div>
      <div class="aspect-square rounded-xl overflow-hidden bg-gradient-to-br from-navy-100 to-accent-100 flex items-center justify-center group hover:scale-105 transition-transform duration-300">
        <span class="text-4xl">🤝</span>
      </div>
      <div class="aspect-square rounded-xl overflow-hidden bg-gradient-to-br from-accent-200 to-teal-200 flex items-center justify-center group hover:scale-105 transition-transform duration-300">
        <span class="text-4xl">🍕</span>
      </div>
      <div class="aspect-square rounded-xl overflow-hidden bg-gradient-to-br from-teal-200 to-navy-200 flex items-center justify-center group hover:scale-105 transition-transform duration-300">
        <span class="text-4xl">📱</span>
      </div>
      <div class="aspect-square rounded-xl overflow-hidden bg-gradient-to-br from-navy-200 to-accent-200 flex items-center justify-center group hover:scale-105 transition-transform duration-300">
        <span class="text-4xl">🎤</span>
      </div>
      <div class="aspect-square rounded-xl overflow-hidden bg-gradient-to-br from-accent-100 to-navy-100 flex items-center justify-center group hover:scale-105 transition-transform duration-300">
        <span class="text-4xl">🌮</span>
      </div>
      <div class="aspect-square rounded-xl overflow-hidden bg-gradient-to-br from-teal-100 to-accent-200 flex items-center justify-center group hover:scale-105 transition-transform duration-300">
        <span class="text-4xl">🚀</span>
      </div>
    </div>

    <div class="bg-gradient-to-br from-navy-50 to-teal-50 rounded-2xl p-8 text-center">
      <h2 class="text-2xl font-bold text-navy-700 mb-4">Tienes fotos de nuestros eventos?</h2>
      <p class="text-gray-500 mb-6 max-w-xl mx-auto">
        Si tomaste fotos en alguno de nuestros meetups y quieres compartirlas con la comunidad,
        envialas por nuestro grupo de Telegram.
      </p>
      <a href="{{ site.community.telegram }}" target="_blank" rel="noopener"
         class="inline-flex items-center gap-2 bg-accent-500 text-white px-6 py-3 rounded-xl font-semibold hover:bg-accent-600 transition-all shadow-lg shadow-accent-500/25">
        Compartir fotos
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3"/></svg>
      </a>
    </div>
  </div>
</section>
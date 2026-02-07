---
layout: default
title: Eventos
permalink: /eventos/
---

<section class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
  <div class="mb-12">
    <h1 class="text-3xl sm:text-4xl font-bold text-navy-700 mb-3">Eventos</h1>
    <p class="text-gray-500 max-w-lg">Meetups, talleres y actividades de la comunidad Oaxacoders.</p>
  </div>

  {% assign events = site.events | sort: "event_date" | reverse %}
  {% if events.size > 0 %}
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      {% for event in events %}
        {% include event-card.html event=event %}
      {% endfor %}
    </div>
  {% else %}
    <div class="text-center py-16">
      <img src="/assets/images/programmer.jpeg" alt="Chapulin programando"
           class="w-72 mx-auto rounded-2xl shadow-lg mb-8" />
      <p class="text-gray-500 text-lg mb-2">No hay eventos programados por el momento.</p>
      <p class="text-gray-400">
        Únete a nuestros canales de
        <a href="{{ site.community.telegram }}" class="text-teal-500 hover:underline" target="_blank" rel="noopener">Telegram</a> o
        <a href="{{ site.community.whatsapp }}" class="text-teal-500 hover:underline" target="_blank" rel="noopener">WhatsApp</a>
        para enterarte de los proximos eventos. </p>
    </div>
  {% endif %}
</section>

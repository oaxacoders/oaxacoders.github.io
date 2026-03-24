---
layout: default
title: Todos los Eventos
permalink: /eventos/todos/
---

<section class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
  <div class="mb-12">
    <a href="/eventos/" class="inline-flex items-center gap-1 text-sm text-gray-400 hover:text-teal-500 transition mb-4">
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/></svg>
      Eventos
    </a>
    <h1 class="text-3xl sm:text-4xl font-bold text-navy-700 mb-3">Todos los Eventos</h1>
    <p class="text-gray-500 max-w-lg">Historial completo de meetups, talleres y actividades de la comunidad.</p>
  </div>

  {% assign now = site.time | date: "%Y-%m-%d" %}
  {% assign all_events = site.events | sort: "date" %}
  {% assign upcoming_events = "" | split: "" %}
  {% for event in all_events %}
    {% assign event_date = event.date | date: "%Y-%m-%d" %}
    {% if event_date >= now %}
      {% assign upcoming_events = upcoming_events | push: event %}
    {% endif %}
  {% endfor %}

  {% if upcoming_events.size > 0 %}
    <div class="mb-16">
      <h2 class="text-2xl font-bold text-navy-700 mb-6">Próximos</h2>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {% for event in upcoming_events %}
          {% include event-card.html event=event %}
        {% endfor %}
      </div>
    </div>
  {% endif %}

  {% assign eventos_pasados = site.posts | where: "category", "eventos-pasados" %}
  {% if eventos_pasados.size > 0 %}
    <div>
      <h2 class="text-2xl font-bold text-navy-700 mb-6">Pasados</h2>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {% for post in eventos_pasados %}
          <a href="{{ post.url }}" class="group block bg-white rounded-xl border border-gray-100 p-6 hover:border-teal-200 hover:shadow-lg hover:shadow-teal-100/50 transition-all duration-200">
            {% if post.date_display %}
              <p class="text-xs font-semibold uppercase tracking-wider text-accent-600 mb-2">{{ post.date_display }}</p>
            {% else %}
              <p class="text-xs font-semibold uppercase tracking-wider text-accent-600 mb-2">{{ post.date | date: "%d de %B, %Y" }}</p>
            {% endif %}
            <h3 class="text-lg font-semibold text-navy-700 group-hover:text-teal-500 transition-colors mb-2">{{ post.title }}</h3>
            {% if post.time_display %}
              <p class="text-sm text-gray-500 mb-1">{{ post.time_display }}</p>
            {% endif %}
            {% if post.venue %}
              <p class="text-sm text-gray-500 mb-3">{{ post.venue }}</p>
            {% endif %}
            <p class="text-gray-600 text-sm leading-relaxed mb-4">{{ post.excerpt | strip_html | truncatewords: 30 }}</p>
            <span class="text-teal-500 text-sm font-medium group-hover:underline">Ver detalles &rarr;</span>
          </a>
        {% endfor %}
      </div>
    </div>
  {% endif %}
</section>

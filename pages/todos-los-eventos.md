---
layout: default
title: Todos los Eventos
permalink: /eventos/todos/
description: Archivo completo de meetups, talleres y hackathons de Oaxacoders — eventos próximos y pasados en Oaxaca, México.
---

<section class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 pt-12 md:pt-16 pb-6">
  <a href="/eventos/" class="inline-flex items-center gap-1 label-mono text-anil/70 hover:text-rosa transition mb-4">
    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M15 19l-7-7 7-7"/></svg>
    Eventos
  </a>
  <h1 class="font-display text-[44px] sm:text-[60px] md:text-[72px] text-anil leading-[0.95]">Todos los eventos</h1>
  <p class="text-[20px] text-anil/80 mt-3 max-w-xl">Historial completo de meetups, talleres y actividades de la comunidad.</p>
</section>

{% include listones.html %}

<section class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
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
      <h2 class="font-display text-[34px] sm:text-[44px] text-anil leading-[0.95] mb-6">Próximos</h2>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
        {% for event in upcoming_events %}
          {% include event-card.html event=event %}
        {% endfor %}
      </div>
    </div>
  {% endif %}

  {% assign eventos_pasados = site.posts | where: "category", "eventos-pasados" %}
  {% if eventos_pasados.size > 0 %}
    <div>
      <h2 class="font-display text-[34px] sm:text-[44px] text-anil leading-[0.95] mb-6">Pasados</h2>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
        {% for post in eventos_pasados %}
          <a href="{{ post.url }}" class="group block bg-white rounded-[12px] p-6 border-2 border-transparent hover:border-anil transition">
            {% if post.date_display %}
              <p class="font-mono text-[13px] font-bold text-anil/70 uppercase tracking-[0.06em] mb-2">{{ post.date_display }}</p>
            {% else %}
              <p class="font-mono text-[13px] font-bold text-anil/70 uppercase tracking-[0.06em] mb-2">{{ post.date | date: "%d de %B, %Y" }}</p>
            {% endif %}
            <h3 class="text-[26px] font-extrabold text-anil leading-[1.1] mb-2 group-hover:underline decoration-anil decoration-2 underline-offset-4">{{ post.title }}</h3>
            {% if post.time_display or post.venue %}
              <p class="font-mono text-[13px] text-anil/80 mb-3">
                {% if post.time_display %}{{ post.time_display }}{% endif %}{% if post.time_display and post.venue %} · {% endif %}{% if post.venue %}{{ post.venue }}{% endif %}
              </p>
            {% endif %}
            <p class="text-anil/85 text-[16px] leading-relaxed mb-4">{{ post.excerpt | strip_html | truncatewords: 30 }}</p>
            <span class="text-[16px] font-extrabold text-anil group-hover:underline decoration-rosa decoration-2 underline-offset-4">Ver detalles →</span>
          </a>
        {% endfor %}
      </div>
    </div>
  {% endif %}
</section>

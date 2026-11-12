---
layout: default
title: Eventos
permalink: /eventos/
description: Próximos meetups, talleres y hackathons de Oaxacoders — la comunidad de programadores en Oaxaca, México. Participación gratuita.
---

<section class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 pt-12 md:pt-16 pb-16">
  <div class="mb-6">
    <h1 class="font-display text-[44px] sm:text-[60px] md:text-[72px] text-anil leading-[0.95]">Eventos</h1>
    <p class="text-[20px] text-anil/80 mt-3 max-w-xl">Meetups, talleres y actividades de la comunidad Oaxacoders.</p>
  </div>
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
    <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
      {% for event in upcoming_events %}
        {% include event-card.html event=event %}
      {% endfor %}
    </div>
  {% else %}
    <div class="grid md:grid-cols-2 gap-10 items-center">
      <div class="">
        {% include mascota.html src="/assets/images/mascota/constructor.png" alt="Chapulín con casco y martillo" pedestal="cempasuchil" %}
      </div>
      <div>
        <p class="text-[22px] text-anil leading-[1.4] mb-3">No hay eventos programados por el momento.</p>
        <p class="text-[18px] text-anil/80 leading-relaxed mb-6">
          Únete a nuestros canales para enterarte de los próximos.
        </p>
        <div class="flex flex-wrap gap-3">
          <a href="{{ site.community.telegram }}" target="_blank" rel="noopener"
             class="inline-flex items-center justify-center h-11 px-5 rounded-[6px] bg-rosa text-white text-[17px] font-extrabold hover:bg-rosa-700 transition">
            Telegram
          </a>
          <a href="{{ site.community.whatsapp }}" target="_blank" rel="noopener"
             class="inline-flex items-center justify-center h-11 px-5 rounded-[6px] border-2 border-anil text-anil text-[17px] font-extrabold hover:bg-anil hover:text-crema transition">
            WhatsApp
          </a>
        </div>
      </div>
    </div>
  {% endif %}

  <div class="mt-12">
    <a href="/eventos/todos/" class="inline-flex items-center gap-2 text-[17px] font-extrabold text-anil underline decoration-rosa decoration-2 underline-offset-4 hover:text-rosa transition">
      Ver todos los eventos (pasados y futuros) →
    </a>
  </div>
</section>

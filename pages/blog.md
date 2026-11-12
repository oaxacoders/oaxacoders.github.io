---
layout: default
title: Blog
permalink: /blog/
description: Artículos, tutoriales y resúmenes de eventos pasados de la comunidad Oaxacoders en Oaxaca, México.
---

{% assign general_posts = site.posts | where_exp: "post", "post.category != 'eventos-pasados'" %}
{% assign eventos_pasados = site.posts | where_exp: "post", "post.category == 'eventos-pasados'" %}

<section class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 pt-12 md:pt-16 pb-6">
  <h1 class="font-display text-[44px] sm:text-[60px] md:text-[72px] text-anil leading-[0.95]">Blog</h1>
  <p class="text-[20px] text-anil/80 mt-3 max-w-xl">Artículos, tutoriales y noticias de la comunidad.</p>
</section>

{% include listones.html %}

<section class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
  {% if general_posts.size > 0 %}
    <div class="space-y-5 mb-16">
      {% for post in general_posts %}
        <a href="{{ post.url }}" class="group block bg-white rounded-[12px] p-6 border-2 border-transparent hover:border-anil transition">
          <p class="font-mono text-[13px] font-bold text-anil/70 uppercase tracking-[0.06em] mb-2">{{ post.date | date: "%d de %B, %Y" }}</p>
          <h2 class="text-[26px] font-extrabold text-anil leading-[1.1] mb-2 group-hover:underline decoration-anil decoration-2 underline-offset-4">{{ post.title }}</h2>
          <p class="text-anil/85 text-[16px] leading-relaxed mb-4">{{ post.excerpt | strip_html | truncatewords: 40 }}</p>
          <span class="text-[16px] font-extrabold text-anil group-hover:underline decoration-rosa decoration-2 underline-offset-4">Leer más →</span>
        </a>
      {% endfor %}
    </div>
  {% else %}
    <div class="py-10">
      <p class="text-[20px] text-anil/80">Próximamente publicaremos artículos aquí.</p>
    </div>
  {% endif %}

  {% if eventos_pasados.size > 0 %}
    <div class="mb-6">
      <h2 class="font-display text-[34px] sm:text-[44px] text-anil leading-[0.95] mb-2">Eventos pasados</h2>
      <p class="text-[18px] text-anil/80 max-w-xl">Resúmenes, presentaciones y recursos de nuestros eventos anteriores.</p>
    </div>

    <div class="space-y-5">
      {% for post in eventos_pasados %}
        <a href="{{ post.url }}" class="group block bg-white rounded-[12px] p-6 border-2 border-transparent hover:border-anil transition">
          <p class="font-mono text-[13px] font-bold text-anil/70 uppercase tracking-[0.06em] mb-2">{% if post.date_display %}{{ post.date_display }}{% else %}{{ post.date | date: "%d de %B, %Y" }}{% endif %}</p>
          <h3 class="text-[26px] font-extrabold text-anil leading-[1.1] mb-2 group-hover:underline decoration-anil decoration-2 underline-offset-4">{{ post.title }}</h3>
          {% if post.venue or post.time_display %}
            <p class="font-mono text-[13px] text-anil/80 mb-3">
              {% if post.time_display %}{{ post.time_display }}{% endif %}{% if post.time_display and post.venue %} · {% endif %}{% if post.venue %}{{ post.venue }}{% endif %}
            </p>
          {% endif %}
          <p class="text-anil/85 text-[16px] leading-relaxed mb-4">{{ post.excerpt | strip_html | truncatewords: 40 }}</p>
          <span class="text-[16px] font-extrabold text-anil group-hover:underline decoration-rosa decoration-2 underline-offset-4">Ver detalles →</span>
        </a>
      {% endfor %}
    </div>
  {% endif %}
</section>

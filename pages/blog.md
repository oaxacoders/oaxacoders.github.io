---
layout: default
title: Blog
permalink: /blog/
---

{% assign general_posts = site.posts | where_exp: "post", "post.category != 'eventos-pasados'" %}
{% assign eventos_pasados = site.posts | where_exp: "post", "post.category == 'eventos-pasados'" %}

<section class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
  <div class="mb-12">
    <h1 class="text-3xl sm:text-4xl font-bold text-navy-700 mb-3">Blog</h1>
    <p class="text-gray-500">Artículos, tutoriales y noticias de la comunidad.</p>
  </div>

  {% if general_posts.size > 0 %}
    <div class="space-y-6 mb-16">
      {% for post in general_posts %}
        <a href="{{ post.url }}" class="group block bg-white rounded-xl border border-gray-100 p-6 hover:border-teal-200 hover:shadow-lg hover:shadow-teal-100/50 transition-all duration-200">
          <p class="text-xs text-gray-400 mb-2">{{ post.date | date: "%d de %B, %Y" }}</p>
          <h2 class="text-xl font-semibold text-navy-700 group-hover:text-teal-500 transition-colors mb-2">{{ post.title }}</h2>
          <p class="text-gray-500 text-sm leading-relaxed">{{ post.excerpt | strip_html | truncatewords: 40 }}</p>
          <span class="inline-block mt-3 text-teal-500 text-sm font-medium group-hover:underline">Leer mas &rarr;</span>
        </a>
      {% endfor %}
    </div>
  {% else %}
    <div class="text-center py-16">
      <p class="text-gray-500 text-lg">Próximamente publicaremos artículos aquí.</p>
    </div>
  {% endif %}

  {% if eventos_pasados.size > 0 %}
    <div class="mb-8">
      <h2 class="text-2xl sm:text-3xl font-bold text-navy-700 mb-3">Eventos Pasados</h2>
      <p class="text-gray-500">Resúmenes, presentaciones y recursos de nuestros eventos anteriores.</p>
    </div>

    <div class="space-y-6">
      {% for post in eventos_pasados %}
        <a href="{{ post.url }}" class="group block bg-white rounded-xl border border-gray-100 p-6 hover:border-teal-200 hover:shadow-lg hover:shadow-teal-100/50 transition-all duration-200">
          <p class="text-xs text-gray-400 mb-2">{% if post.date_display %}{{ post.date_display }}{% else %}{{ post.date | date: "%d de %B, %Y" }}{% endif %}</p>
          <h2 class="text-xl font-semibold text-navy-700 group-hover:text-teal-500 transition-colors mb-2">{{ post.title }}</h2>
          <div class="flex flex-wrap gap-2 mb-2">
            {% if post.venue %}
              <span class="inline-flex items-center gap-1 text-xs text-teal-600 bg-teal-50 px-2 py-1 rounded-md">
                <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M17.657 16.657L13.414 20.9a2 2 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                {{ post.venue }}
              </span>
            {% endif %}
            {% if post.time_display %}
              <span class="inline-flex items-center gap-1 text-xs text-teal-600 bg-teal-50 px-2 py-1 rounded-md">
                <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 6v6l4 2m6-2a10 10 0 11-20 0 10 10 0 0120 0z"/></svg>
                {{ post.time_display }}
              </span>
            {% endif %}
          </div>
          <p class="text-gray-500 text-sm leading-relaxed">{{ post.excerpt | strip_html | truncatewords: 40 }}</p>
          <span class="inline-block mt-3 text-teal-500 text-sm font-medium group-hover:underline">Ver detalles &rarr;</span>
        </a>
      {% endfor %}
    </div>
  {% endif %}
</section>

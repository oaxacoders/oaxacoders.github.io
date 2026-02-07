---
layout: default
title: Blog
permalink: /blog/
---

<section class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
  <div class="mb-12">
    <h1 class="text-3xl sm:text-4xl font-bold text-navy-700 mb-3">Blog</h1>
    <p class="text-gray-500">Artículos, tutoriales y noticias de la comunidad.</p>
  </div>

  {% if site.posts.size > 0 %}
    <div class="space-y-6">
      {% for post in site.posts %}
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
</section>

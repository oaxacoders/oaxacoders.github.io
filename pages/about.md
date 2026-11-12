---
layout: default
title: Nosotros
permalink: /nosotros/
description: Conoce a Oaxacoders, la comunidad abierta y gratuita de programadores, diseñadores y entusiastas de la tecnología en Oaxaca de Juárez, México.
---

<!-- Intro -->
<section class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 pt-12 md:pt-16 pb-8">
  <div class="grid md:grid-cols-2 gap-10 md:gap-14 items-center">
    <div>
      <p class="label-mono text-rosa mb-5">Comunidad</p>
      <h1 class="font-display text-[48px] sm:text-[64px] md:text-[72px] text-anil leading-[0.95] mb-6">Nosotros.</h1>
      <p class="text-[20px] text-anil leading-[1.5] max-w-xl">
        <strong class="font-extrabold">Oaxacoders</strong> es una comunidad abierta de programadores, diseñadores y entusiastas de la tecnología en Oaxaca, México. El chapulín, símbolo oaxaqueño, acompaña nuestra marca — tradición mezclada con tecnología.
      </p>
    </div>
    <div class="flex justify-center md:justify-end">
      <div class="w-full max-w-sm pr-6 pb-6">
        {% include marco-ilustracion.html src="/assets/images/programmer_grasshopper.jpeg" alt="Chapulin programador" %}
      </div>
    </div>
  </div>
</section>

{% include listones.html %}

<!-- Qué hacemos -->
<section class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
  <h2 class="font-display text-[34px] sm:text-[44px] text-anil leading-[0.95] mb-2">Qué hacemos.</h2>
  <p class="text-[18px] text-anil/80 mb-10 max-w-xl">Actividades para crecer juntos como comunidad tech.</p>
  <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
    <div class="bg-white rounded-[12px] p-6">
      <p class="label-mono text-rosa mb-2">Plática</p>
      <h3 class="text-[26px] font-extrabold text-anil mb-2 leading-tight">Meetups</h3>
      <p class="text-[17px] text-anil/85 leading-relaxed">Reuniones periódicas para compartir conocimientos y experiencias.</p>
    </div>
    <div class="bg-white rounded-[12px] p-6">
      <p class="label-mono text-turquesa mb-2">Taller</p>
      <h3 class="text-[26px] font-extrabold text-anil mb-2 leading-tight">Talleres</h3>
      <p class="text-[17px] text-anil/85 leading-relaxed">Sesiones prácticas para aprender nuevas tecnologías.</p>
    </div>
    <div class="bg-white rounded-[12px] p-6">
      <p class="label-mono text-cempasuchil mb-2">Hackathon</p>
      <h3 class="text-[26px] font-extrabold text-anil mb-2 leading-tight">Hackathons</h3>
      <p class="text-[17px] text-anil/85 leading-relaxed">Eventos para construir proyectos en equipo.</p>
    </div>
    <div class="bg-white rounded-[12px] p-6">
      <p class="label-mono text-turquesa mb-2">Coding Dojo</p>
      <h3 class="text-[26px] font-extrabold text-anil mb-2 leading-tight">Networking</h3>
      <p class="text-[17px] text-anil/85 leading-relaxed">Un espacio para conectar con otras personas de la tecnología en Oaxaca.</p>
    </div>
  </div>
</section>

<!-- Únete -->
{% include listones.html %}
<section class="bg-anil text-crema on-anil">
  <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-16 md:py-20">
    <div class="grid md:grid-cols-2 gap-10 md:gap-14 items-center">
      <div class="pr-6 pb-6">
        {% include marco-ilustracion.html src="/assets/images/programmers.jpeg" alt="Chapulines programadores" %}
      </div>
      <div>
        <p class="label-mono text-cempasuchil mb-5">Unirse</p>
        <h2 class="font-display text-[40px] sm:text-[52px] text-crema leading-[0.95] mb-6">Únete a la comunidad.</h2>
        <p class="text-[20px] text-crema leading-[1.5] mb-6 max-w-xl">
          La comunidad es abierta y gratuita. Puedes unirte a través de cualquiera de nuestros canales:
        </p>
        <div class="flex flex-col gap-3 max-w-md">
          <a href="{{ site.community.telegram }}" target="_blank" rel="noopener"
             class="flex items-center justify-between h-12 px-5 rounded-[6px] bg-crema text-anil font-extrabold text-[17px] hover:bg-cempasuchil transition">
            <span>Telegram</span><span>↗</span>
          </a>
          <a href="{{ site.community.whatsapp }}" target="_blank" rel="noopener"
             class="flex items-center justify-between h-12 px-5 rounded-[6px] bg-crema text-anil font-extrabold text-[17px] hover:bg-cempasuchil transition">
            <span>WhatsApp</span><span>↗</span>
          </a>
          <a href="{{ site.community.twitter }}" target="_blank" rel="noopener"
             class="flex items-center justify-between h-12 px-5 rounded-[6px] bg-crema text-anil font-extrabold text-[17px] hover:bg-cempasuchil transition">
            <span>Twitter / X</span><span>↗</span>
          </a>
          <a href="{{ site.community.bluesky }}" target="_blank" rel="noopener"
             class="flex items-center justify-between h-12 px-5 rounded-[6px] bg-crema text-anil font-extrabold text-[17px] hover:bg-cempasuchil transition">
            <span>BlueSky</span><span>↗</span>
          </a>
          <a href="{{ site.community.github }}" target="_blank" rel="noopener"
             class="flex items-center justify-between h-12 px-5 rounded-[6px] bg-crema text-anil font-extrabold text-[17px] hover:bg-cempasuchil transition">
            <span>GitHub</span><span>↗</span>
          </a>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- Newsletter -->
<section class="bg-crema py-16 md:py-20">
  <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
    {% include newsletter-form.html %}
  </div>
</section>

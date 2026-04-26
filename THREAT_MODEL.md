# Modelo de Amenazas: Oaxacoders.org

## Documento de Análisis de Amenazas y Modelado de Seguridad

**Fecha de creación:** 26 de Abril, 2026  
**Versión:** 1.0  
**Autor:** Equipo de Seguridad Oaxacoders  
**Clasificación:** Uso interno  

---

## 1. Información General del Sistema

### 1.1 Propósito del Sistema
Portal web comunitario para programadores en Oaxaca, México. Sirve como punto de reunión virtual para compartir conocimiento sobre programación, organizar eventos y mantener contacto con la comunidad tecnológica local.

### 1.2 Alcance del Análisis
- Frontend del sitio web ( Jekyll + Tailwind CSS )
- Integraciones con servicios externos
- Infraestructura de CDNs y APIs
- Workflows de GitHub Actions
- Formularios de captura de datos

### 1.3 Tecnologías Identificadas

| Componente | Tecnología | Versión |
|------------|------------|---------|
| Generador sitio | Jekyll | 4.4.1 |
| Framework CSS | Tailwind CSS | 4.x (CDN) |
| Lenguaje backend | Ruby | 4.0.3 |
| Hosting | GitHub Pages | - |
| DNS | Cloudflare (implícito) | - |
| Newsletter | Buttondown | API |
| Fuentes | Google Fonts | Inter |
| Video hosting | YouTube Embed | - |
| Comunidad | Telegram, WhatsApp, Bluesky, Twitter | - |

---

## 2. Objetivos de Seguridad

### 2.1 Objetivos de Confidencialidad
- Proteger información personal de suscriptores del newsletter
- Mantener la privacidad de los datos de contacto de organizadores
- Salvaguardar tokens de API almacenados en GitHub Secrets

### 2.2 Objetivos de Integridad
- Garantizar que el contenido del sitio no sea modificado por actores no autorizados
- Asegurar que los scripts CDNs no sean comprometidos
- Mantener la coherencia de los enlaces a redes sociales

### 2.3 Objetivos de Disponibilidad
- Minimizar tiempo de inactividad del sitio
- Implementar protecciones contra DDoS
- Plan de recuperación ante desastres

### 2.4 Objetivos de Autenticación y Autorización
- Control de acceso a repositorio GitHub
- Gestión de secretos para workflows
- Revisión de código para pull requests

---

## 3. Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────────────────────────┐
│                              USUARIOS                                    │
│                    Visitantes, Miembros, Admins                         │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         INTERNET / RED                                   │
│                    HTTP/HTTPS Traffic                                   │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                      GitHub Pages CDN                                    │
│                    (oaxacoders.org)                                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                   │
│  │ HTML estático│  │   Assets     │  │   RSS Feed   │                   │
│  │   (.html)    │  │ (CSS, IMG)   │  │  (feed.xml)  │                   │
│  └──────────────┘  └──────────────┘  └──────────────┘                   │
└─────────────────────────────────────────────────────────────────────────┘
         │                    │                    │
         ▼                    ▼                    ▼
┌────────────────┐  ┌────────────────┐  ┌────────────────┐
│   Tailwind CDN │  │ Google Fonts   │  │ YouTube Embed  │
│  (cdn.tailwind)│  │ (fonts.gstatic)│  │ (youtube.com) │
└────────────────┘  └────────────────┘  └────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                      TERCEROS / APIs                                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                   │
│  │  Buttondown  │  │   Telegram    │  │   WhatsApp   │                   │
│  │ (Newsletter) │  │    Bot API    │  │   Groups     │                   │
│  └──────────────┘  └──────────────┘  └──────────────┘                   │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                      GitHub Repository                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                   │
│  │ Source Code │  │   Actions    │  │    Secrets   │                   │
│  │  (_posts,   │  │  (Workflows) │  │ (Tokens,TG)  │                   │
│  │  _includes) │  │              │  │              │                   │
│  └──────────────┘  └──────────────┘  └──────────────┘                   │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 4. Identificación de Actores (Threat Actors)

### 4.1 Actores Externos

| Actor | Motivación | Capacidad | Nivel de Riesgo |
|-------|------------|-----------|-----------------|
| **Script Kiddies** | Diversión, prestigio | Baja | BAJO |
| **Cyber Criminales** | Financiero | Media | MEDIO |
| **Hacktivistas** | Ideología política | Media-Alta | MEDIO |
| **Estado-Nación APT** | Espionaje, disrupting | Muy Alta | ALTO |
| **Competidores** | Ventaja competitiva | Media | MEDIO |
| **Insiders (discontent)** | Venganza,利益的 | Alta | ALTO |

### 4.2 Perfil de Actor Estado-Nación (AT&T/APT)

**Capacidades:**
- Interceptación de tráfico a nivel de red (MitM)
- Compromiso de CA (Certificate Authorities)
- Acceso a exploits zero-day
- Recursos de análisis forense
- Capacidad de Ataque supply chain (CDNs)
- Infraestructura de Comando y Control (C2)

**Motivaciones potenciales:**
- Monitoreo de comunidades tecnológicas mexicanas
- Identificar individuos con conocimientos técnicos
- Investigación sobre tendencias tecnológicas en región
- Potencial reclutamiento o cooptación

---

## 5. Análisis STRIDE

### 5.1 S - Spoofing (Suplantación)

| Amenaza | Descripción | Impacto | Probabilidad | Riesgo |
|---------|-------------|---------|--------------|--------|
| S-1 | Suplantación de dominio oaxacoders.org | Phishing a miembros | Media | MEDIO |
| S-2 | Falsificación de emails de newsletter | Daño reputacional | Baja | BAJO |
| S-3 | Suplantación de cuenta de Telegram/WhatsApp | Robo de información | Media | MEDIO |
| S-4 | DNS spoofing para redirección | Compromiso de visitantes | Baja | BAJO |

**Mitigaciones implementadas:**
- HTTPS habilitado
- HSTS con preload
- DKIM/SPF para emails (tercero - Buttondown)

### 5.2 T - Tampering (Manipulación)

| Amenaza | Descripción | Impacto | Probabilidad | Riesgo |
|---------|-------------|---------|--------------|--------|
| T-1 | Modificación de archivos HTML en CDN | Inyección de malware | Alta | ALTO |
| T-2 | Manipulación de scripts Tailwind CDN | Compromiso de todos los visitantes | Alta | CRÍTICO |
| T-3 | Alteración de workflow de GitHub Actions | Robo de secrets, backdoor | Alta | CRÍTICO |
| T-4 | Inyección de código en posts/blog | XSS en otros usuarios | Media | MEDIO |

**Mitigaciones implementadas:**
- Content-Security-Policy configurado
- Validación de inputs en formularios
- GitHub Actions con revisión requerida

### 5.3 R - Repudiation (No repudio)

| Amenaza | Descripción | Impacto | Probabilidad | Riesgo |
|---------|-------------|---------|--------------|--------|
| R-1 | Usuario niega haberse suscrito al newsletter | Jurídico | Baja | BAJO |
| R-2 | Admin niega haber hecho cambios en código | Auditoría | Media | MEDIO |
| R-3 | No rastrear quién accedió a secrets | Forénsico | Alta | ALTO |

**Mitigaciones implementadas:**
- Logs de GitHub Actions conservados
- Git history con автор verification
- Newsletter con doble opt-in (Buttondown)

### 5.4 I - Information Disclosure (Divulgación de información)

| Amenaza | Descripción | Impacto | Probabilidad | Riesgo |
|---------|-------------|---------|--------------|--------|
| I-1 | Exposición de secretos en logs de Actions | Robo de tokens | Alta | CRÍTICO |
| I-2 | Información de rutas/estructura en errores | Reconocimiento | Media | MEDIO |
| I-3 | Metadata expuesta en HTML (version Jekyll) | Fingerprinting | Baja | BAJO |
| I-4 | Emails de suscriptoresinterceptados | GDPR/privacidad | Media | MEDIO |
| I-5 | Tokens de API en código fuente | Compromiso total | Alta | CRÍTICO |

**Mitigaciones implementadas:**
- Secrets cifrados en GitHub
- Headers de seguridad (X-Content-Type-Options)
- NO exponer información de versiones en producción

### 5.5 D - Denial of Service (Denegación de servicio)

| Amenaza | Descripción | Impacto | Probabilidad | Riesgo |
|---------|-------------|---------|--------------|--------|
| D-1 | DDoS al dominio oaxacoders.org | Indisponibilidad | Media | MEDIO |
| D-2 | Inundación del formulario de newsletter | Servicio no disponible | Baja | BAJO |
| D-3 | Ataque a CDNs (Tailwind, Google) | Compromiso cadena suministro | Media | ALTO |
| D-4 | Saturación de repositorio GitHub (actions) | Costos elevados, inactividad | Baja | BAJO |

**Mitigaciones implementadas:**
- GitHub Pages con protección DDoS implícita
- CSP con lista blanca de recursos
- Rate limiting en APIs de terceros (depende de provider)

### 5.6 E - Elevation of Privilege (Escalación de privilegios)

| Amenaza | Descripción | Impacto | Probabilidad | Riesgo |
|---------|-------------|---------|--------------|--------|
| E-1 | Acceso no autorizado a repo GitHub | Modificación de código | Alta | CRÍTICO |
| E-2 | Extracción de secrets de GitHub Actions | Control total | Alta | CRÍTICO |
| E-3 | Compromiso de cuenta de collaborator | Same as E-1 | Media | ALTO |
| E-4 | XSS permitiendo robar cookies/sesiones | Sesión de admin (si existe) | Baja | MEDIO |

**Mitigaciones implementadas:**
- Autenticación 2FA en GitHub (recomendado)
- CODEOWNERS para review obligatorio
- Secrets almacenados cifrados
- No exposición de tokens en frontend

---

## 6. Matriz de RieSgo Consolidada

| ID | Categoría | Amenaza | Impacto | Probabilidad | Riesgo | Prioridad |
|----|-----------|---------|---------|--------------|--------|-----------|
| T-2 | Tampering | Manipulación CDN Tailwind | CRÍTICO | Alta | CRÍTICO | P1 |
| E-1 | Elevation | Acceso no autorizado a repo | CRÍTICO | Alta | CRÍTICO | P1 |
| E-2 | Elevation | Extracción de secrets | CRÍTICO | Alta | CRÍTICO | P1 |
| I-5 | Info Disclosure | Tokens en código | CRÍTICO | Alta | CRÍTICO | P1 |
| T-3 | Tampering | Manipulación GitHub Actions | CRÍTICO | Alta | CRÍTICO | P1 |
| I-1 | Info Disclosure | Secrets en logs | CRÍTICO | Alta | CRÍTICO | P1 |
| S-1 | Spoofing | Suplantación dominio | ALTO | Media | ALTO | P2 |
| T-4 | Tampering | XSS via posts | ALTO | Media | ALTO | P2 |
| S-3 | Spoofing | Suplantación Telegram/WhatsApp | ALTO | Media | ALTO | P2 |
| I-4 | Info Disclosure | Interceptación emails | ALTO | Media | ALTO | P2 |
| D-3 | DoS | Ataque a CDNs | ALTO | Media | ALTO | P2 |
| D-1 | DoS | DDoS al dominio | MEDIO | Media | MEDIO | P3 |
| I-2 | Info Disclosure | Metadata en errores | MEDIO | Media | MEDIO | P3 |
| S-2 | Spoofing | Emails falsos newsletter | MEDIO | Baja | BAJO | P4 |
| R-2 | Repudiation | Admin niega cambios | MEDIO | Media | MEDIO | P4 |

---

## 7. Diagrama de Flujo de Datos (DFD)

### 7.1 Niveles de Proceso

**Nivel 0 (Contexto):**
```
[Usuario] ──────> (Sitio Web Oaxacoders) ──────> (Internet Services)
                 
                 <──────────────────────────────
                    Respuestas, Emails, Updates
```

**Nivel 1 (Detalle):**
```
┌─────────────────────────────────────────────────────────────┐
│                    SITIO OAXACODERS                          │
│                                                             │
│  ┌──────────┐     ┌──────────┐     ┌──────────┐           │
│  │ Content  │────>│ Jekyll   │────>│ GitHub   │           │
│  │ (MD/HTML)│     │ Build    │     │ Pages    │           │
│  └──────────┘     └──────────┘     └──────────┘           │
│       │                                     │              │
│       │                                     ▼              │
│       │                            ┌──────────────┐        │
│       │                            │   CDN        │        │
│       │                            │  (Static)    │        │
│       │                            └──────────────┘        │
│       │                                     │              │
│       ▼                                     ▼              │
│  ┌──────────┐                      ┌──────────────┐        │
│  │ Actions  │                      │   Browser    │        │
│  │ (CI/CD)  │                      │   (Usuario)  │        │
│  └──────────┘                      └──────────────┘        │
│       │                                     │              │
│       ▼                                     ▼              │
│  ┌──────────┐                      ┌──────────────┐        │
│  │ Secrets  │                      │  External     │        │
│  │ (Tokens) │                      │  Services     │        │
│  └──────────┘                      └──────────────┘        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 7.2 Stores de Datos

| Store | Tipo | Datos Sensibles | Protección |
|-------|------|-----------------|------------|
| `_posts/` | Archivos MD | Contenido público | Git versioning |
| `_config.yml` | YAML | URLs públicas | Repo público |
| `secrets` | GitHub Secrets | Tokens API | Cifrado GitHub |
| `_site/` | HTML estático | Cache compilado | GitHub Pages CDN |
| Buttondown DB | Externo | Emails suscriptores | Política Buttondown |

### 7.3 Procesos de Confianza

| Proceso | Nivel de confianza | Validación requerida |
|---------|-------------------|----------------------|
| GitHub Pages deploy | Bajo (automatizado) | CODEOWNERS review |
| Jekyll build | Medio | Solo archivos MD/HTML |
| GitHub Actions | Medio | Secrets no expuestos |
| CDN Tailwind | Muy bajo | CSP restrictivo |

---

## 8. Casos de Uso de Abuso (Misuse Cases)

### 8.1 Actor: Script Kiddie

**Caso de uso: Defacement del sitio**
```
Actor: Script Kiddie
Objetivo: Obtener prestigio en comunidad hacker
Pasos:
  1. Escanea sitio con Burp Suite
  2. Identifica plugin Jekyll vulnerable (si existe)
  3. Busca exploit en exploit-db
  4. Compromete cuenta de collaborator débil
  5. Modifica archivo HTML
  6. Publica defacement
Mitigación: 2FA, CODEOWNERS, backup automático
```

### 8.2 Actor: Estado-Nación APT

**Caso de uso: Supply Chain Attack via CDN**
```
Actor: APT (Estado-nación)
Objetivo: Comprometer visitantes del sitio
Pasos:
  1. Monitoreacdn.tailwindcss.com por tiempo
  2. Identifica vulnerabilidad en servidor CDN
  3. Compromete servidor de CDN
  4. Inserta payload en archivo Tailwind
  5. Espera que visitantes carguen script malicioso
  6. Ejecuta malware en navegadores
  7. Extrae datos sensibles (cookies, tokens)
Mitigación: SRI (Subresource Integrity), CSP, monitoreo CDN
```

### 8.3 Actor: Cyber Criminal

**Caso de uso: Robo de emails via Newsletter**
```
Actor: Cyber Criminal
Objetivo: Obtener lista de emails para phishing
Pasos:
  1. Intercepta tráfico HTTP (MitM en red pública)
  2. Captura petición POST a Buttondown
  3. Extrae email y posibles tags
  4. Vende lista en dark web
  5. Ejecuta campaña de phishing dirigida
Mitigación: HTTPS forzado, CSP, no enviar datos sensibles en claro
```

### 8.4 Actor: Insider Malicioso

**Caso de uso: Exfiltración de Secrets**
```
Actor: Collaborator descontecto
Objetivo: Robar tokens de API para otros propósitos
Pasos:
  1. Crea pull request aparentemente legítima
  2. Incluye código que exfiltra secrets
  3. Espera merge sin revisión (si no hay CODEOWNERS)
  4. Acciona workflow que envía secrets a servidor externo
  5. Limpia rastros
Mitigación: CODEOWNERS, monitoreo de actions, alerts de seguridad
```

---

## 9. Estrategia de Mitigación

### 9.1 Matriz de Mitigación

| Amenaza | Controls Preventivos | Controls Detective | Controls Correctivos |
|---------|----------------------|-------------------|---------------------|
| T-2 (CDN) | CSP strict, SRI | Monitoreo CDN | Rotar todos los secretos |
| E-1 (Repo) | 2FA obligatorio, CODEOWNERS | GitHub Security Alerts | Revocar access inmediatamente |
| E-2 (Secrets) | Least privilege, no logs | Audit logs | Rotar tokens |
| I-5 (Tokens) | Secrets como variables entorno | Monitoreo Actions | Eliminar token comprometido |
| T-3 (Actions) | CODEOWNERS, no inline scripts | Revisión de permisos | Disable workflow |
| I-1 (Logs) | No exponer secrets en echo | Filter secrets in logs | Scrub logs |
| S-1 (Domain) | HSTS, DNSSEC | Monitorización DNS | Transfer domain |
| T-4 (XSS) | CSP, sanitización input | WAF | SanitizarBD |
| D-3 (CDN DoS) | Multi-CDN fallback | Rate limiting | Switch to backup |
| I-4 (Emails) | HTTPS only | Monitorización red | Notificar usuarios |

### 9.2 Implementaciones de Seguridad Activas

| Control | Implementación | Estado |
|---------|---------------|--------|
| HTTPS | GitHub Pages + HSTS | ✅ Implementado |
| CSP | Meta tag en default.html | ✅ Implementado |
| X-Frame-Options | DENY | ✅ Implementado |
| X-Content-Type-Options | nosniff | ✅ Implementado |
| HSTS | max-age=31536000 | ✅ Implementado |
| Referrer-Policy | strict-origin-when-cross-origin | ✅ Implementado |
| Permissions-Policy | camera=(), microphone=(), geolocation=() | ✅ Implementado |
| 2FA GitHub | Recomendado pero no obligatorio | ⚠️ Pendiente |
| CODEOWNERS | No configurado | ⚠️ Pendiente |
| SRI | No implementado en Tailwind | ⚠️ Pendiente |
| Monitoreo CDN | No implementado | ⚠️ Pendiente |

---

## 10. Plan de Respuesta a Incidentes

### 10.1 Categorización de Incidentes

| Nivel | Descripción | Tiempo de respuesta | Ejemplos |
|-------|-------------|--------------------|----------|
| P1 | Crítico - compromiso activo | Inmediato (< 1 hora) | Backdoor descubierto, XSS activo |
| P2 | Alto - compromiso potencial | < 4 horas | Secrets expuestos en público |
| P3 | Medio - anomalía detectada | < 24 horas | Intentos de DDoS, phishing |
| P4 | Bajo -informativo | < 72 horas | Scans detectados, errores inusual |

### 10.2 Flujo de Respuesta

```
┌──────────────────────────────────────────────────────┐
│                   INCIDENTE DETECTADO                 │
└──────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────┐
│  1. IDENTIFICACIÓN                                    │
│  - ¿Qué sistemas afectados?                          │
│  - ¿Qué datos en riesgo?                             │
│  - ¿Cuándo se detectó?                               │
└──────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────┐
│  2. CONTENCIÓN                                        │
│  - Aislar sistemas afectados                         │
│  - Revocar credenciales comprometidas                │
│  - Bloquear IPs suspectas                             │
└──────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────┐
│  3. ERRADICACIÓN                                      │
│  - Eliminar malware/backdoor                         │
│  - Cerrar vectores de ataque                          │
│  - Reset de passwords/tokens                          │
└──────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────┐
│  4. RECUPERACIÓN                                      │
│  - Restaurar desde backup limpio                     │
│  - Verificar integridad del código                   │
│  - Monitoreo intensificado                            │
└──────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────┐
│  5. LECCIONES APRENDIDAS                              │
│  - Documentar incidente                               │
│  - Actualizar modelo de amenazas                     │
│  - Mejorar controles                                  │
└──────────────────────────────────────────────────────┘
```

### 10.3 Contactos de Emergencia

| Rol | Acción | Canal |
|-----|--------|-------|
| Administrador repo | Revocar acceso,丧eliminarr código malicioso | GitHub Admin |
| DNS Provider | Cambiar registros, suspender dominio | Panel DNS |
| GitHub Support | Reportar vulnerabilidad | github.com/security |
| Comunidad | Notificar a miembros | Telegram, Twitter |

---

## 11. Revisión y Mantenimiento

### 11.1 Frecuencia de Revisión

| Actividad | Frecuencia | Responsabilidad |
|------------|------------|-----------------|
| Revisión completa del modelo | Trimestral | Equipo seguridad |
| Actualización de amenazas | Mensual | Administrador |
| Verificación de controles | Quincenal | Administrador |
| Prueba de incidentes | Semestral | Equipo completo |
| Auditoría de acceso | Trimestral | GitHub Admin |

### 11.2 Criterios de Actualización

Este documento debe actualizarse cuando:
- Nueva funcionalidad agregada al sitio
- Nuevo servicio de terceros integrado
- Incidente de seguridad ocurre
- Nueva vulnerabilidad descubierta en tecnologías usadas
- Cambios significativos en la arquitectura

---

## 12. Aprobaciones

| Rol | Nombre | Fecha | Firma |
|-----|--------|-------|-------|
| Autor | Equipo Oaxacoders | 26/04/2026 | - |
| Revisor | - | - | - |
| Aprobador | - | - | - |

---

## 13. Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0 | 26/04/2026 | Equipo Oaxacoders | Versión inicial |

---

*Este documento es confidencial y solo para uso interno del equipo de Oaxacoders.*
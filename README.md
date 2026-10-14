# 👓 Óptica Güzellik – App Móvil

Aplicación móvil para la gestión de mostrador de **Óptica Güzellik**, desarrollada con **Flutter** y un backend **Node.js + MongoDB**, bajo metodología ágil **Scrum**.

> **Paleta corporativa:** Azul Real `#1A2B4C` · Turquesa `#40B7B7`

---

## 👥 Equipo Scrum

| Rol | Integrante | Responsabilidad |
|---|---|---|
| **Scrum Master / Backend Lead** | Paola López (Pao) | Facilitación del proceso, control de impedimentos, API REST y servicio HTTP |
| **Product Owner / Frontend Architect** | Gerardo Manzano (Gera) | Contacto con el cliente, visión de producto, arquitectura Flutter y autenticación |
| **Developer Frontend** | Jennifer Medina (Jenni) | Catálogo de productos, GridView y filtros |

---

## 🛠️ Stack Tecnológico

- **Frontend:** Flutter / Dart (Android)
- **Backend:** Node.js, Express, Mongoose
- **Base de datos:** MongoDB Atlas
- **Autenticación:** JWT
- **Seguridad:** Helmet, Rate Limiter, CORS
- **Gestión:** Jira (tablero Scrum) y Git (ramas por desarrollador)

---

## 🚀 Sprint 1 (5 oct – 12 oct 2026)

**Objetivo:** Inicializar el proyecto Flutter con su arquitectura base y tema corporativo, configurar una API REST segura para consumo desde el emulador Android, implementar un cliente HTTP centralizado con JWT y construir el Login, el Catálogo con GridView y los filtros interactivos para mostrador.

### 📋 Backlog del Sprint

| Clave | Tarea | Responsable | Cierre | Estado |
|---|---|---|---|---|
| SCRUM-5 | [OP-01] Inicialización del proyecto Flutter, estructura y tema | Gera | 6 oct | ✅ Finalizado |
| SCRUM-2 | [OP-02] Pantalla de Login y autenticación con JWT | Gera | 8 oct | ⏳ En revisión |
| SCRUM-7 | [OP-03] Disponibilidad de API REST para emulador Android | Pao | 6 oct | ✅ Finalizado |
| SCRUM-8 | [OP-04] Servicio HTTP centralizado (ApiService) y mapeo JSON | Pao | 8 oct | ⏳ En revisión |
| SCRUM-9 | [OP-05] Catálogo con GridView y Cards personalizadas | Jenni | 7 oct | ✅ Finalizado |
| SCRUM-10 | [OP-06] Filtros por categoría y barra de búsqueda | Jenni | 8 oct | ⏳ En revisión |

---

## ✅ Lo realizado en el Sprint 1

### [OP-01] Inicialización del proyecto Flutter – *Gera*
- Estructura de carpetas limpia: `models`, `screens`, `services`, `widgets`, `utils`.
- Paleta corporativa centralizada en `utils/colors.dart`.
- Splash Screen interactivo con verificación de sesión.
- Compilación limpia en emulador Android, sin alertas de dependencias.

### [OP-02] Login y autenticación JWT – *Gera*
- Interfaz de login con la identidad visual de Óptica Güzellik.
- Validaciones: formato de correo y contraseña de mínimo 8 caracteres.
- Consumo del endpoint `POST /api/auth/login`.
- Persistencia de sesión (token y datos de usuario) en `SharedPreferences` mediante `AuthStorage`.
- Redirección según rol: `AdminDashboard` o `EmpleadoDashboard`.
- Lista de correos recientes para agilizar el acceso en mostrador.
- **Bug resuelto:** tras el login la sesión no guardaba el usuario y la redirección dejaba la pantalla en blanco. Se corrigió en pair programming con Pao, ajustando la persistencia y el payload del backend (objeto `user` completo con su `rol`).

### [OP-03] API REST para emulador Android – *Pao*
- Servidor Express con respuestas JSON estándar bajo `/api`.
- Conexión estable a MongoDB Atlas con Mongoose (lista blanca de IPs y variables `.env` protegidas).
- Middlewares de seguridad: Helmet y Rate Limiter.
- CORS habilitado para `10.0.2.2` (emulador Android).

### [OP-04] Servicio HTTP centralizado – *Pao*
- `ApiService` y `ApiClient` con métodos `GET`, `POST`, `PUT`, `PATCH` y `DELETE`.
- Inyección automática del token `Bearer` desde `AuthStorage`.
- Clase `ApiException` e interceptor de errores: 401 (sesión expirada), 403 (permisos), 404 y 500.
- Mapeo de respuestas JSON a objetos Dart.
- `PATCH` pensado para actualización rápida de stock.

### [OP-05] Catálogo con GridView – *Jenni*
- `LayoutBuilder` responsivo: 2 columnas en móvil, 3 en tablet y 4 en pantallas amplias.
- Cards con imagen, nombre, marca y precio destacado.
- Badges de stock: 🔴 Agotado, 🟠 Stock Bajo, 🟢 Disponible.
- Consumo de la lista de productos con manejo de carga y reintentos.

### [OP-06] Filtros y búsqueda – *Jenni*
- `FilterChips`: Todos, Armazones, Micas, Lentes de Contacto y Accesorios.
- Búsqueda reactiva en vivo por nombre, marca o código.
- Estado sin resultados con icono `search_off` y botón **Limpiar Filtros**.
- Conflicto de merge con OP-05 resuelto en `productos_empleado.dart`.
- Resultado: encontrar un armazón o mica en menos de 2 segundos.

---

## 🌟 Hitos del Sprint

- **Demo con el cliente (7 oct):** se presentó el Splash, los colores corporativos y el Login a los encargados de Óptica Güzellik. Quedaron muy satisfechos con la identidad visual y dieron luz verde para continuar con la misma línea de diseño.
- **Flujo Scrum completo:** Sprint Planning, Daily Standups (lunes a jueves), Code Review cruzado y preparación de Sprint Review y Retrospective.
- **Control de versiones:** ramas por desarrollador (`dev/gerardo-manzano`, `dev/pao-lopez`, `dev/jenni`) integradas a `develop`.

---

## 📊 Resultado del Sprint 1

| Estado | Historias |
|---|---|
| ✅ Cerradas | OP-01, OP-03, OP-05 |
| ⏳ En revisión | OP-02, OP-04, OP-06 |

El 100 % de los entregables del incremento quedó codificado; las historias en revisión esperan la validación final en la Sprint Review.



<p align="center">Proyecto Óptica Güzellik · Metodología Scrum · Sprint 1</p>

# 👓 Óptica Güzellik – Sistema Integral de Gestión Optométrica y Mostrador

[![Flutter](https://img.shields.io/badge/Frontend-Flutter%203.5+-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Node.js](https://img.shields.io/badge/Backend-Node.js%20Express-339933?logo=node.js&logoColor=white)](https://nodejs.org/)
[![MongoDB](https://img.shields.io/badge/Database-MongoDB%20Atlas-47A248?logo=mongodb&logoColor=white)](https://www.mongodb.com/)
[![JWT](https://img.shields.io/badge/Security-JWT%20%2B%20Bcrypt-black?logo=jsonwebtokens)](https://jwt.io/)
[![Architecture](https://img.shields.io/badge/Architecture-REST%20API%20%7C%20RBAC-orange)](#-arquitectura-del-sistema)

Plataforma móvil y backend diseñada para digitalizar de punta a punta las operaciones de mostrador, gabinete optométrico, inventario clínico, taller de laboratorio y punto de venta (POS) en **Óptica Güzellik**.

---

## 👥 Equipo de Desarrollo y Roles

| Integrante | Rol | Responsabilidades Clave |
| :--- | :--- | :--- |
| **Paola López (Pao)** | *Scrum Master & Backend Lead* | Arquitectura API REST, seguridad Express, modelos Mongoose, base de datos MongoDB Atlas y capa HTTP en cliente |
| **Gerardo Manzano (Gera)** | *Product Owner & Frontend Architect* | Arquitectura Flutter, autenticación JWT, gestión de estado, diseño UI y módulo optométrico |
| **Jennifer Medina (Jenni)** | *Frontend Developer* | Módulo de catálogo responsivo (GridView), cards personalizadas, sistema de filtrado reactivo y flujo de mostrador |

---

## 🎨 Identidad Visual y Paleta Corporativa

El sistema implementa un tema centralizado en `AppColors` con base en una escala cromática médica y elegante:

* 🟦 **Azul Real (`#1A2B4C`):** Color institucional primario, barras de navegación y encabezados principales.
* 🌑 **Azul Marino (`#0F1A30`):** Sombras de elevación, contraste y estados profundos.
* 🔷 **Azul Cobalto (`#2A4F6E`):** Botones secundarios, iconos de acción y transiciones.
* ❇️ **Turquesa / Aqua (`#40B7B7`):** Color de acento, precios, botones primarios (CTA) e indicadores de éxito.

---

## 🏗️ Arquitectura del Sistema

El ecosistema utiliza una arquitectura desacoplada **Cliente-Servidor** comunicada mediante llamadas asíncronas HTTPS/JSON protegidas:

```mermaid
flowchart TB
    %% Estilos de Nodos
    classDef client fill:#EBF3FA,stroke:#1A2B4C,stroke-width:2px,color:#1A2B4C;
    classDef security fill:#FEF3D6,stroke:#D97706,stroke-width:2px,color:#78350F;
    classDef backend fill:#E8F7F7,stroke:#40B7B7,stroke-width:2px,color:#0F1A30;
    classDef database fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px,color:#1B5E20;
    classDef external fill:#F3E8FF,stroke:#7E22CE,stroke-width:2px,color:#4A044E;

    subgraph CLIENTE["📱 APLICACIÓN MÓVIL (Flutter 3.5 & Android)"]
        direction TB
        UI["🎨 UI Responsiva (LayoutBuilder)"]
        STATE["⚡ Provider (Gestión Reactiva de Estado)"]
        CLIENT["🌐 ApiClient & Interceptores HTTP"]
        STORAGE[("💾 SharedPreferences (JWT / Sesión Local)")]
        
        UI --> STATE
        STATE --> CLIENT
        CLIENT <--> STORAGE
    end
    class UI,STATE,CLIENT,STORAGE client;

    subgraph SEGURIDAD["🛡️ CAPA PERIMETRAL DE SEGURIDAD"]
        HELMET["🔒 Helmet (Cabeceras HTTP Seguras)"]
        LIMITER["⏱️ Rate Limiter (Anti-Fuerza Bruta)"]
        CORS["🌍 CORS Policy (Aislamiento de Origen)"]
        AUTH["🔑 JWT Middleware (Verificación de Token)"]
        VALIDATOR["✅ Express Validator & Sanitizer"]
        
        LIMITER --> HELMET --> CORS --> AUTH --> VALIDATOR
    end
    class HELMET,LIMITER,CORS,AUTH,VALIDATOR security;

    subgraph BACKEND["⚙️ SERVIDOR REST API (Node.js & Express)"]
        AUTH_CTRL["🔑 Auth Controller"]
        PROD_CTRL["📦 Productos Controller"]
        PAC_CTRL["👁️ Pacientes & Clínico"]
        VENTAS_CTRL["🛒 Ventas & POS Controller"]
        REP_CTRL["📊 Reportes & BI Controller"]
    end
    class AUTH_CTRL,PROD_CTRL,PAC_CTRL,VENTAS_CTRL,REP_CTRL backend;

    subgraph EXTERN["🔌 INTEGRACIONES EXTERNAS"]
        WSP["📲 WhatsApp API (url_launcher)"]
        PRINT["🖨️ Impresión Térmica & Generador PDF"]
        EXCEL["📑 Motor de Exportación Excel (.xlsx)"]
    end
    class WSP,PRINT,EXCEL external;

    subgraph DB["🗄️ CAPA DE PERSISTENCIA (MongoDB Atlas Cloud)"]
        COL_USERS[("👤 Usuarios & Roles")]
        COL_PRODS[("📦 Catálogo & Existencias")]
        COL_PACIENTES[("👁️ Pacientes & Historial Clínico")]
        COL_VENTAS[("🛒 Ventas, Abonos & Taller")]
    end
    class COL_USERS,COL_PRODS,COL_PACIENTES,COL_VENTAS database;

    %% Conexiones entre capas
    CLIENT -->|"Petición HTTP / JSON"| LIMITER
    VALIDATOR --> BACKEND

    AUTH_CTRL --> COL_USERS
    PROD_CTRL --> COL_PRODS
    PAC_CTRL --> COL_PACIENTES
    VENTAS_CTRL --> COL_VENTAS
    REP_CTRL --> COL_VENTAS

    VENTAS_CTRL -.-> WSP
    VENTAS_CTRL -.-> PRINT
    REP_CTRL -.-> EXCEL
```

---

## 🗄️ Modelo de Datos Entidad-Relación

La base de datos relacional sobre MongoDB modela el ciclo clínico, comercial y de existencias:

```mermaid
erDiagram
    USUARIO {
        ObjectId _id PK
        string nombre
        string email
        string password_hash
        string rol "admin | empleado"
        boolean activo
    }

    PACIENTE {
        ObjectId _id PK
        string nombre
        string telefono
        string ocupacion
        object antecedentes "Alergias, Diabetes, Hipertensión"
        object sintomas "Fotofobia, Cefalea, Astenopía"
        object agudeza_visual "AV Lejana, Cerca, Estenopeica"
        object graduacion_actual "OD / OI: Esfera, Cil, Eje, Adición"
    }

    PRODUCTO {
        ObjectId _id PK
        string codigo UK
        string nombre
        string tipo "armazon | mica | lente_contacto | accesorio"
        string marca
        number costo
        number precio_venta
        number stock
        number stock_minimo
        object armazon_specs "Material, Forma, Medidas"
        object mica_specs "Material, Tratamientos, Serie"
    }

    VENTA {
        ObjectId _id PK
        string folio UK
        date fecha
        ObjectId paciente_id FK
        ObjectId vendedor_id FK
        number total
        number anticipo
        number saldo_pendiente
        string metodo_pago "efectivo | tarjeta | transferencia | mixto"
        string estado_pago "pagado | anticipo | pendiente"
        string estado_laboratorio "en_taller | biselado | listo | entregado"
    }

    ITEM_VENTA {
        ObjectId _id PK
        ObjectId producto_id FK
        string nombre
        number cantidad
        number precio_unitario
        number subtotal
        object graduacion "Prescripción montada"
    }

    ABONO {
        ObjectId _id PK
        number monto
        date fecha
        string forma_pago
        string registrado_por
        string nota
    }

    PACIENTE ||--o{ VENTA : "solicita"
    USUARIO ||--o{ VENTA : "registra y atiende"
    VENTA ||--|{ ITEM_VENTA : "contiene productos"
    PRODUCTO ||--o{ ITEM_VENTA : "corresponde a"
    VENTA ||--o{ ABONO : "recibe pagos parciales"

-- ============================================================
-- RUTASTICK · Esquema de base de datos
-- Compatible con SQLite (usado en la app de consola) y con
-- pequeños ajustes de tipos, con MySQL/PostgreSQL en producción.
-- ============================================================

CREATE TABLE usuarios (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre        TEXT NOT NULL,
    email         TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    rol           TEXT NOT NULL CHECK (rol IN ('administrador','gestor','conductor'))
);

CREATE TABLE camiones (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    matricula           TEXT NOT NULL UNIQUE,
    modelo              TEXT,
    capacidad_peso_kg   REAL NOT NULL,
    capacidad_volumen_m3 REAL NOT NULL,
    estado              TEXT NOT NULL DEFAULT 'disponible'
                         CHECK (estado IN ('disponible','en_ruta','taller','baja'))
);

CREATE TABLE conductores (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario_id INTEGER UNIQUE REFERENCES usuarios(id),
    nombre     TEXT NOT NULL,
    dni        TEXT NOT NULL UNIQUE,
    telefono   TEXT,
    camion_id  INTEGER REFERENCES camiones(id)
);

-- Tiendas, almacenes y clientes: cualquier punto que pueda ser
-- origen, destino o parada de una ruta.
CREATE TABLE clientes (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre     TEXT NOT NULL,
    tipo       TEXT NOT NULL DEFAULT 'tienda' CHECK (tipo IN ('almacen','tienda','cliente')),
    direccion  TEXT,
    ciudad     TEXT,
    provincia  TEXT,
    pais       TEXT DEFAULT 'España',
    latitud    REAL,
    longitud   REAL,
    telefono   TEXT
);

CREATE TABLE rutas (
    id                    INTEGER PRIMARY KEY AUTOINCREMENT,
    origen_id             INTEGER NOT NULL REFERENCES clientes(id),
    destino_id            INTEGER NOT NULL REFERENCES clientes(id),
    camion_id             INTEGER REFERENCES camiones(id),
    conductor_id          INTEGER REFERENCES conductores(id),
    fecha_salida          TEXT NOT NULL,
    fecha_llegada_estimada TEXT,
    estado                TEXT NOT NULL DEFAULT 'pendiente'
                          CHECK (estado IN ('pendiente','en_curso','entregada','incidencia')),
    distancia_km          REAL,
    tarifa_km             REAL DEFAULT 0.90,
    importe_total         REAL
);

-- Paradas intermedias entre el origen y el destino de una ruta
CREATE TABLE paradas (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    ruta_id       INTEGER NOT NULL REFERENCES rutas(id),
    cliente_id    INTEGER NOT NULL REFERENCES clientes(id),
    orden         INTEGER NOT NULL,
    hora_estimada TEXT,
    estado        TEXT NOT NULL DEFAULT 'pendiente'
                  CHECK (estado IN ('pendiente','completada'))
);

-- Mercancía que transporta cada ruta (peso y volumen)
CREATE TABLE cargas (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    ruta_id     INTEGER NOT NULL REFERENCES rutas(id),
    descripcion TEXT NOT NULL,
    peso_kg     REAL NOT NULL,
    volumen_m3  REAL NOT NULL
);

-- Traza de cada cambio de estado de una ruta (para trazabilidad)
CREATE TABLE historial_estados (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    ruta_id    INTEGER NOT NULL REFERENCES rutas(id),
    estado     TEXT NOT NULL,
    fecha_hora TEXT NOT NULL
);

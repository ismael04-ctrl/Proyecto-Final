# Rutastick · Aplicación de consola (versión básica en desarrollo por ahora y )

Proyecto Intermodular 1. Gestión de rutas de camiones para el reparto de
mercancías a tiendas y almacenes, con cálculo del kilometraje a facturar.


## Requisitos

- Python 3.8 o superior (no necesita instalar ninguna librería adicional:
  usa solo `sqlite3`, incluido en Python).

## Cómo ejecutarla

```
python3 main.py
```

Al arrancar, crea automáticamente el archivo `rutastick.db` con todas las
tablas (ver `schema.sql`). La primera vez hay que crear un usuario
(opción 2 del menú inicial) antes de poder iniciar sesión.

## Funcionalidades incluidas

- Alta de usuarios con rol (administrador / gestor / conductor) e inicio
  de sesión con contraseña cifrada (hash SHA-256).
- Gestión de camiones: alta, listado y cambio de estado.
- Gestión de conductores: alta, listado y asignación de camión.
- Gestión de clientes (almacenes, tiendas, clientes), con coordenadas
  para calcular distancias.
- Creación de rutas: origen, destino, paradas intermedias, camión,
  conductor, carga (peso y volumen) y cálculo automático de
  kilómetros e importe.
- Listado y filtrado de rutas por estado.
- Cambio de estado de una ruta (pendiente → en curso → entregada /
  incidencia), con historial de cambios.
- Informe de kilometraje: total a pagar por las rutas ya entregadas.

## Estructura del proyecto

```
rutastick_app/
├── main.py      -> menús de la aplicación (interfaz de consola)
├── database.py  -> conexión SQLite y funciones CRUD
├── utils.py     -> cálculo de distancia, contraseñas y utilidades
├── schema.sql   -> estructura de la base de datos
└── diseño_base_datos.md -> explicación del diseño y diagrama E-R
```

## Nota sobre la distancia

La distancia entre origen y destino se calcula en línea recta (fórmula
de Haversine) a partir de las coordenadas guardadas en `clientes`. No es
la distancia real por carretera: en una versión con conexión a
internet, se sustituiría por una llamada a la API de rutas de Google
Maps, como estaba previsto en la idea original del proyecto.

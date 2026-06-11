# DavidBriosoSQL

# Proyecto

## Descripción
SQL es el lenguaje universal de las bases de datos relacionales. Cualquier backend Node.js, Python, Golang o cualquier otro framework necesita SQL para leer y manipular datos. Dominar CRUD y JOINs es la base de todo desarrollo backend profesional.

Actividad
Título de la actividad:
Script SQL con consultas CRUD y consultas JOIN funcionales sobre la base de datos existente.

Modalidad: 
Tarea individual

📝 Indicaciones
Utilizando la base de datos de gestión de alojamientos turísticos proporcionada, se debe escribir y ejecutar las 20 consultas SQL guiadas de esta práctica, guardar todas las consultas en un único archivo .sql y documentar los resultados obtenidos con capturas de pantalla.

## Tecnologías utilizadas

* Base de datos: accommodation_database_task.sql
* Consulta:DavidBrioso_Consultas.sql

## Motor de Base de Datos

**Motor utilizado:** PostgreSQL 18* 


Para cubrir las 20 consultas que muestras (propietarios, alojamientos, huéspedes, reservas, pagos y reseñas), un esquema relacional adecuado sería el siguiente:

# Esquema de Base de Datos - Sistema de Alojamientos

## Tabla: propietarios

```sql
CREATE TABLE propietarios (
    id_propietario INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    fecha_registro DATE DEFAULT CURRENT_DATE
);
```

## Tabla: alojamientos

```sql
CREATE TABLE alojamientos (
    id_alojamiento INT PRIMARY KEY AUTO_INCREMENT,
    id_propietario INT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    direccion VARCHAR(255),
    ciudad VARCHAR(100),
    pais VARCHAR(100),
    precio_noche DECIMAL(10,2) NOT NULL,
    capacidad INT,
    estado ENUM('Activo','Inactivo') DEFAULT 'Activo',

    FOREIGN KEY (id_propietario)
        REFERENCES propietarios(id_propietario)
);
```

## Tabla: huespedes

```sql
CREATE TABLE huespedes (
    id_huesped INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    pais VARCHAR(100),
    telefono VARCHAR(20)
);
```

## Tabla: reservas

```sql
CREATE TABLE reservas (
    id_reserva INT PRIMARY KEY AUTO_INCREMENT,
    id_huesped INT NOT NULL,
    id_alojamiento INT NOT NULL,
    fecha_entrada DATE NOT NULL,
    fecha_salida DATE NOT NULL,
    estado ENUM('Pendiente','Confirmada','Cancelada','Finalizada')
        DEFAULT 'Pendiente',

    FOREIGN KEY (id_huesped)
        REFERENCES huespedes(id_huesped),

    FOREIGN KEY (id_alojamiento)
        REFERENCES alojamientos(id_alojamiento)
);
```

## Tabla: pagos

```sql
CREATE TABLE pagos (
    id_pago INT PRIMARY KEY AUTO_INCREMENT,
    id_reserva INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fecha_pago DATE NOT NULL,
    metodo_pago VARCHAR(50),

    FOREIGN KEY (id_reserva)
        REFERENCES reservas(id_reserva)
);
```

## Tabla: resenas

```sql
CREATE TABLE resenas (
    id_resena INT PRIMARY KEY AUTO_INCREMENT,
    id_reserva INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comentario TEXT,
    fecha_resena DATE,

    FOREIGN KEY (id_reserva)
        REFERENCES reservas(id_reserva)
);
```

# Relaciones

propietarios (1) -------- (N) alojamientos

alojamientos (1) -------- (N) reservas

huespedes (1) ----------- (N) reservas

reservas (1) ------------ (N) pagos

reservas (1) ------------ (0..1 o N) resenas

Con este esquema puedes ejecutar todas las consultas de tu guía:

* INSERT: propietarios, alojamientos, huéspedes, reservas y pagos.
* SELECT: alojamientos activos, huéspedes por país, reservas por fechas.
* UPDATE: precio de alojamiento y estado de reserva.
* DELETE: reseñas.
* JOIN: reservas + huéspedes, alojamiento completo, pagos + reservas.
* LEFT JOIN: alojamientos sin reseñas o sin reservas.
* AGGREGATE: SUM, AVG, COUNT.
* HAVING: alojamientos con más de 3 reservas.
* SUBCONSULTA: alojamiento más caro.



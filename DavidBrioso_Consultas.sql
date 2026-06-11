-- 01. Agregar un nuevo propietario usando los campos reales
INSERT INTO tourism.owners (first_name, last_name, email, phone, company_name, tax_id, address_line1, city, state, country, postal_code) 
VALUES ('Juan', 'Pérez', 'juan.perez@example.com', '+503 7000-0000', 'Inversiones Pérez S.A.', '0614-010190-101-1', 'Paseo General Escalón #123', 'San Salvador', 'San Salvador', 'El Salvador', '01101');

-- 02. INSERT - Insertar alojamiento
-- Descripción: Crea un alojamiento vinculado a Juan Pérez usando los nombres exactos de columnas obligatorias.
INSERT INTO tourism.accommodations (owner_id, accommodation_type_id, location_id, name, description, max_guests, base_price_per_night, currency_code) 
VALUES (
    (SELECT owner_id FROM tourism.owners WHERE email = 'juan.perez@example.com' LIMIT 1),
    1,
    1,
    'Eco-Hotel El Boquerón',
    'Hermoso hotel de montaña con vista al cráter y clima fresco.',
    4,
    85.00,
    'USD'
);

-- 03. Registrar huésped y reserva
-- Descripción: Crea la reserva enlazando de forma dinámica al huésped Alice Smith con el Eco-Hotel El Boquerón.

INSERT INTO tourism.bookings (guest_id, accommodation_id, booking_status_id, booking_reference, check_in_date, check_out_date, adult_count, child_count, subtotal_amount, tax_amount, discount_amount, total_amount) 
VALUES (
    (SELECT guest_id FROM tourism.guests WHERE email = 'alice.smith@example.com' LIMIT 1),
    (SELECT accommodation_id FROM tourism.accommodations WHERE name = 'Eco-Hotel El Boquerón' LIMIT 1),
    1, 
    'BK-2026-ALICE-3', -- Cambiado a 3 para esquivar el duplicado
    '2026-07-15', 
    '2026-07-20', 
    2, 
    0, 
    525.00, 
    0.00, 
    0.00, 
    525.00
);

-- 04. INSERT - Registrar pago
-- Descripción: Registra el pago completo de la reserva de Alice Smith de forma dinámica.

INSERT INTO tourism.payments (booking_id, payment_date, amount, payment_method, payment_status, transaction_reference, notes) 
VALUES (
    (SELECT booking_id FROM tourism.bookings WHERE booking_reference = 'BK-2026-ALICE' LIMIT 1),
    '2026-06-07', -- payment_date (Fecha actual)
    425.00,       -- amount (Monto total de la reserva)
    'credit_card',-- payment_method
    'completed',  -- payment_status
    'TXN-998822', -- transaction_reference (Obligatorio/Único)
    'Pago completo con tarjeta de crédito de la huésped Alice Smith.' -- notes
);

-- 05. SELECT - Alojamientos activos
-- Descripción: Muestra la lista de todos los hospedajes que se encuentran activos actualmente en el sistema.

SELECT accommodation_id, name, base_price_per_night, currency_code, bedroom_count, is_active
FROM tourism.accommodations
WHERE is_active = true;

-- 06. SELECT - Huéspedes por país
-- Descripción: Muestra el listado de huéspedes ordenados y agrupados por su nacionalidad.

SELECT guest_id, first_name, last_name, email, nationality
FROM tourism.guests
ORDER BY nationality, last_name;

-- 07. SELECT - Reservas por fechas (Uso de BETWEEN)
-- Descripción: Filtra y muestra las reservas cuya fecha de entrada (check-in) se encuentra dentro de un rango específico.

SELECT booking_id, guest_id, accommodation_id, check_in_date, check_out_date, total_amount
FROM tourism.bookings
WHERE check_in_date BETWEEN '2026-01-01' AND '2026-04-30'
ORDER BY check_in_date;

-- 08. Actualizar precio de un alojamiento
-- Descripción: Modifica el precio base por noche de un hospedaje específico usando su ID.

-- Paso 1: Modificar el valor en la base de datos
UPDATE tourism.accommodations
SET base_price_per_night = 499.99
WHERE accommodation_id = 1;

-- Paso 2: Verificar el cambio de forma inmediata
SELECT accommodation_id, name, base_price_per_night, currency_code
FROM tourism.accommodations
WHERE accommodation_id = 1;

-- 09. UPDATE - Actualizar estado de una reserva
-- Descripción: Modifica el identificador de estado de una reserva específica usando su ID único.

-- Paso 1: Actualizar el estado en la base de datos
UPDATE tourism.bookings
SET booking_status_id = 2
WHERE booking_id = 11;

-- Paso 2: Verificar el cambio de forma inmediata
SELECT booking_id, guest_id, booking_status_id, total_amount
FROM tourism.bookings
WHERE booking_id = 11;

-- 10. DELETE - Eliminar reseña específica
-- Descripción: Remueve permanentemente un registro de calificación del sistema utilizando su clave primaria.

-- Paso 1: Eliminar la fila de manera quirúrgica
DELETE FROM tourism.reviews
WHERE review_id = 2;

-- Paso 2: Verificar la remoción del registro
SELECT review_id, booking_id, rating, review_text
FROM tourism.reviews
WHERE review_id = 2;

-- 11. Relación de Reservas y Huéspedes
-- Descripción: Cruza la tabla de reservas con la de huéspedes usando la llave común guest_id.

SELECT 
    b.booking_id,
    g.first_name,
    g.last_name,
    b.check_in_date,
    b.total_amount
FROM tourism.bookings b
INNER JOIN tourism.guests g ON b.guest_id = g.guest_id
ORDER BY b.booking_id
LIMIT 9; -- se añade un límite para visualizar un segmento limpio de pruebas

-- 12. Alojamiento completo (INNER JOIN múltiple)
-- Descripción: Une la tabla de alojamientos con sus respectivos dueños y destinos geográficos.

SELECT 
    a.accommodation_id,
    a.name AS alojamiento,
    o.first_name AS nombre_dueno,
    o.last_name AS apellido_dueno,
    l.city AS ciudad_destino, -- Corregido: cambiamos 'name' por 'city'
    a.base_price_per_night AS precio
FROM tourism.accommodations a
INNER JOIN tourism.owners o ON a.owner_id = o.owner_id
INNER JOIN tourism.locations l ON a.location_id = l.location_id
ORDER BY a.accommodation_id
LIMIT 9;

-- 13. Pagos + reservas (JOIN combinado)
-- Descripción: Combina la información de los pagos realizados con los detalles de sus respectivas reservas.

SELECT 
    p.payment_id,
    p.booking_id,
    p.amount AS monto_pagado,
    p.payment_method AS metodo_pago,
    p.payment_status AS estado_pago,
    b.check_in_date AS fecha_ingreso,
    b.check_out_date AS fecha_salida,
    b.total_amount AS total_reserva
FROM tourism.payments p
INNER JOIN tourism.bookings b ON p.booking_id = b.booking_id
ORDER BY p.payment_id
LIMIT 9;

-- 14. LEFT JOIN - Alojamientos sin reseñas (Incluye nulls)
-- Descripción: Muestra todos los alojamientos y arrastra sus reseñas. Los que no tienen comentarios mostrarán NULL.

SELECT 
    a.accommodation_id,
    a.name AS alojamiento,
    r.review_id,
    r.rating AS calificacion,
    r.review_text AS comentario
FROM tourism.accommodations a
LEFT JOIN tourism.reviews r ON a.accommodation_id = r.accommodation_id
ORDER BY r.review_id ASC NULLS FIRST
LIMIT 12;

-- 15. LEFT JOIN - Alojamientos sin reservas (Filtrar null)
-- Descripción: Filtra y muestra únicamente las propiedades que jamás han sido reservadas.

SELECT 
    a.accommodation_id,
    a.name AS alojamiento,
    a.base_price_per_night AS precio,
    b.booking_id AS codigo_reserva
FROM tourism.accommodations a
LEFT JOIN tourism.bookings b ON a.accommodation_id = b.accommodation_id
WHERE b.booking_id IS NULL
ORDER BY a.accommodation_id;

-- 16. AGG - Total de ingresos recaudados (SUM)
-- Descripción: Calcula la suma total acumulada de todos los pagos exitosos en la plataforma.

SELECT 
    COUNT(payment_id) AS cantidad_pagos_exitosos,
    SUM(amount) AS total_ingresos_recaudados
FROM tourism.payments
WHERE payment_status = 'Completed';

-- 17. AGG - Promedio de calificación global (AVG)
-- Descripción: Calcula la nota media de satisfacción otorgada por los huéspedes en la plataforma.

SELECT 
    COUNT(review_id) AS total_reseñas_evaluadas,
    ROUND(AVG(rating), 3) AS promedio_rating_global
FROM tourism.reviews;

-- 18. AGG - Top alojamientos con mayor volumen de reservas (COUNT + LIMIT)
-- Descripción: Muestra los alojamientos preferidos por los usuarios según su cantidad de reservas.
SELECT 
    a.accommodation_id,
    a.name AS alojamiento,
    COUNT(b.booking_id) AS total_reservas
FROM tourism.accommodations a
INNER JOIN tourism.bookings b ON a.accommodation_id = b.accommodation_id
GROUP BY a.accommodation_id, a.name
ORDER BY total_reservas DESC
LIMIT 6;

-- 19. HAVING - Alojamientos con alta tracción comercial (Más de 3 reservas)
-- Descripción: Filtra los alojamientos agrupados cuyo conteo acumulado de reservas sea estrictamente mayor a 3.
SELECT 
    a.accommodation_id,
    a.name AS alojamiento,
    COUNT(b.booking_id) AS total_reservas
FROM tourism.accommodations a
INNER JOIN tourism.bookings b ON a.accommodation_id = b.accommodation_id
GROUP BY a.accommodation_id, a.name
HAVING COUNT(b.booking_id) > 3
ORDER BY total_reservas DESC;

-- 20. Subconsulta - Identificación de la propiedad Premium (Subquery)
-- Descripción: Selecciona el o los alojamientos cuyo precio base iguala al valor máximo del catálogo.
SELECT 
    accommodation_id,
    name AS alojamiento,
    base_price_per_night AS precio_base_maximo,
    description AS descripcion
FROM tourism.accommodations
WHERE base_price_per_night = (
    SELECT MAX(base_price_per_night) 
    FROM tourism.accommodations
);

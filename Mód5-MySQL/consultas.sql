-- Evaluación portafolio módulo 5 - Bases de datos relacionales.

-- =====================================================
-- SECCIÓN 1: DEFINICIÓN DE DATOS (DDL)
-- Creación de tablas y estructura de la base de datos
-- =====================================================


-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- Quitar de comentarios si la base de datos no existe!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- CREATE DATABASE modportafolio5ValeSV;
-- USE modportafolio5ValeSV;

-- Tabla: clientes
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(200),
    fecha_registro DATE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: productos
CREATE TABLE productos (
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL CHECK (precio >= 0),
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
    categoria VARCHAR(50)
);

-- Tabla: metodos_pago
CREATE TABLE metodos_pago (
    id_metodo INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(50) NOT NULL,
    descripcion VARCHAR(100)
);

-- Tabla: pedidos
CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_cliente INT NOT NULL,
    total DECIMAL(10, 2) NOT NULL CHECK (total >= 0),
    estado VARCHAR(20) DEFAULT 'Pendiente',
    id_metodo INT,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_metodo) REFERENCES metodos_pago(id_metodo)
);

-- Tabla: detalle_pedidos (relación muchos a muchos entre pedidos y productos)
CREATE TABLE detalle_pedidos (
    id_detalle INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- =====================================================
-- MODIFICACIONES DE ESTRUCTURA (DDL - ALTER)
-- =====================================================

-- Agregar una columna adicional a clientes
ALTER TABLE clientes 
ADD COLUMN ciudad VARCHAR(50);

-- Agregar índice para mejorar búsquedas por email
CREATE INDEX idx_email ON clientes(email);

-- Agregar índice para búsquedas por categoría de productos
CREATE INDEX idx_categoria ON productos(categoria);

-- =====================================================
-- SECCIÓN 2: MANIPULACIÓN DE DATOS (DML)
-- Inserción de datos de ejemplo
-- =====================================================

-- Insertar métodos de pago
INSERT INTO metodos_pago (tipo, descripcion) VALUES
('Tarjeta de Crédito', 'Visa, Mastercard, American Express'),
('Tarjeta de Débito', 'Débito bancario'),
('PayPal', 'Pago a través de PayPal'),
('Transferencia', 'Transferencia bancaria directa');

-- Insertar clientes
INSERT INTO clientes (nombre, email, telefono, direccion, ciudad) VALUES
('Juan Pérez', 'juan.perez@email.com', '+56912345678', 'Av. Providencia 123', 'Santiago'),
('María González', 'maria.gonzalez@email.com', '+56987654321', 'Calle Los Aromos 456', 'Valparaíso'),
('Carlos Rodríguez', 'carlos.rodriguez@email.com', '+56923456789', 'Pasaje Central 789', 'Concepción'),
('Ana Martínez', 'ana.martinez@email.com', '+56934567890', 'Av. Libertad 321', 'La Serena');

-- Insertar productos
INSERT INTO productos (nombre, descripcion, precio, stock, categoria) VALUES
('Laptop HP Pavilion', 'Laptop 15.6", Intel i5, 8GB RAM, 256GB SSD', 599990, 15, 'Computadores'),
('Mouse Inalámbrico Logitech', 'Mouse óptico inalámbrico con receptor USB', 12990, 50, 'Accesorios'),
('Teclado Mecánico RGB', 'Teclado mecánico con retroiluminación RGB', 45990, 30, 'Accesorios'),
('Monitor Samsung 24"', 'Monitor Full HD, 75Hz, Panel IPS', 129990, 20, 'Monitores'),
('Auriculares Sony WH-1000XM4', 'Auriculares con cancelación de ruido', 249990, 10, 'Audio'),
('Webcam Logitech C920', 'Cámara web Full HD 1080p', 59990, 25, 'Accesorios'),
('Disco Duro Externo 1TB', 'Disco duro portátil USB 3.0', 49990, 40, 'Almacenamiento');

-- Insertar pedidos
INSERT INTO pedidos (id_cliente, total, estado, id_metodo) VALUES
(1, 612980, 'Completado', 1),
(2, 179980, 'En Proceso', 2),
(1, 45990, 'Completado', 1),
(3, 599990, 'Pendiente', 3),
(4, 309980, 'Completado', 1);

-- Insertar detalle de pedidos
INSERT INTO detalle_pedidos (id_pedido, id_producto, cantidad, precio_unitario) VALUES
-- Pedido 1 (Juan Pérez)
(1, 1, 1, 599990),
(1, 2, 1, 12990),
-- Pedido 2 (María González)
(2, 4, 1, 129990),
(2, 6, 1, 49990),
-- Pedido 3 (Juan Pérez)
(3, 3, 1, 45990),
-- Pedido 4 (Carlos Rodríguez)
(4, 1, 1, 599990),
-- Pedido 5 (Ana Martínez)
(5, 5, 1, 249990),
(5, 6, 1, 59990);

-- =====================================================
-- OPERACIONES DE ACTUALIZACIÓN (UPDATE)
-- =====================================================

-- Actualizar la dirección de un cliente
UPDATE clientes
SET direccion = 'Nueva Av. Providencia 999', ciudad = 'Santiago'
WHERE id_cliente = 1;

-- Actualizar el stock después de una venta
UPDATE productos
SET stock = stock - 1
WHERE id_producto = 1;

-- Cambiar el estado de un pedido
UPDATE pedidos
SET estado = 'Enviado'
WHERE id_pedido = 2;

-- Actualizar precio de un producto (descuento del 10%)
UPDATE productos
SET precio = precio * 0.90
WHERE categoria = 'Accesorios';

-- =====================================================
-- OPERACIONES DE ELIMINACIÓN (DELETE)
-- =====================================================

-- Eliminar un pedido cancelado (primero eliminar detalles por integridad referencial)
-- Nota: Si se configuró ON DELETE CASCADE, solo se necesita eliminar el pedido padre

-- Eliminar pedidos antiguos con estado 'Cancelado' (ejemplo hipotético)
DELETE FROM pedidos
WHERE estado = 'Cancelado' AND fecha < DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR);

-- Eliminar productos sin stock que no se venderán más
DELETE FROM productos
WHERE stock = 0 AND categoria = 'Descontinuado';

-- =====================================================
-- SECCIÓN 3: CONSULTAS DE SELECCIÓN (SELECT)
-- =====================================================

-- 3.1 Consulta Simple: Todos los clientes
SELECT * FROM clientes;

-- 3.2 Consulta con filtro: Clientes de Santiago
SELECT nombre, email, telefono
FROM clientes
WHERE ciudad = 'Santiago';

-- 3.3 Consulta con JOIN: Pedidos con información del cliente
SELECT 
    p.id_pedido,
    p.fecha,
    c.nombre AS cliente,
    c.email,
    p.total,
    p.estado
FROM pedidos p
INNER JOIN clientes c ON p.id_cliente = c.id_cliente;

-- 3.4 Consulta específica: Todos los pedidos de un cliente específico
SELECT 
    p.id_pedido,
    p.fecha,
    p.total,
    p.estado,
    m.tipo AS metodo_pago
FROM pedidos p
INNER JOIN clientes c ON p.id_cliente = c.id_cliente
LEFT JOIN metodos_pago m ON p.id_metodo = m.id_metodo
WHERE c.nombre = 'Juan Pérez'
ORDER BY p.fecha DESC;

-- 3.5 Consulta con múltiples JOINS: Detalle completo de pedidos
SELECT 
    p.id_pedido,
    c.nombre AS cliente,
    prod.nombre AS producto,
    dp.cantidad,
    dp.precio_unitario,
    (dp.cantidad * dp.precio_unitario) AS subtotal,
    p.fecha
FROM pedidos p
INNER JOIN clientes c ON p.id_cliente = c.id_cliente
INNER JOIN detalle_pedidos dp ON p.id_pedido = dp.id_pedido
INNER JOIN productos prod ON dp.id_producto = prod.id_producto
ORDER BY p.id_pedido, prod.nombre;

-- 3.6 Consulta con GROUP BY: Total de ventas por cliente
SELECT 
    c.nombre AS cliente,
    COUNT(p.id_pedido) AS cantidad_pedidos,
    SUM(p.total) AS total_gastado,
    AVG(p.total) AS promedio_pedido
FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre
ORDER BY total_gastado DESC;

-- 3.7 Consulta con GROUP BY: Productos más vendidos
SELECT 
    prod.nombre AS producto,
    prod.categoria,
    SUM(dp.cantidad) AS unidades_vendidas,
    SUM(dp.cantidad * dp.precio_unitario) AS ingresos_totales
FROM productos prod
INNER JOIN detalle_pedidos dp ON prod.id_producto = dp.id_producto
GROUP BY prod.id_producto, prod.nombre, prod.categoria
ORDER BY unidades_vendidas DESC;

-- 3.8 Consulta con HAVING: Clientes con más de un pedido
SELECT 
    c.nombre AS cliente,
    c.email,
    COUNT(p.id_pedido) AS cantidad_pedidos,
    SUM(p.total) AS total_gastado
FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre, c.email
HAVING COUNT(p.id_pedido) > 1
ORDER BY cantidad_pedidos DESC;

-- 3.9 Consulta con subconsulta: Productos con precio superior al promedio
SELECT 
    nombre,
    precio,
    stock,
    categoria
FROM productos
WHERE precio > (SELECT AVG(precio) FROM productos)
ORDER BY precio DESC;

-- 3.10 Consulta con agregaciones: Resumen de ventas por categoría
SELECT 
    prod.categoria,
    COUNT(DISTINCT dp.id_pedido) AS pedidos,
    SUM(dp.cantidad) AS unidades_vendidas,
    SUM(dp.cantidad * dp.precio_unitario) AS ingresos_totales,
    AVG(dp.precio_unitario) AS precio_promedio
FROM productos prod
INNER JOIN detalle_pedidos dp ON prod.id_producto = dp.id_producto
GROUP BY prod.categoria
ORDER BY ingresos_totales DESC;

-- 3.11 Consulta de inventario: Productos con stock bajo
SELECT 
    nombre,
    categoria,
    stock,
    precio
FROM productos
WHERE stock < 20
ORDER BY stock ASC;

-- 3.12 Consulta de análisis: Métodos de pago más utilizados
SELECT 
    m.tipo AS metodo_pago,
    COUNT(p.id_pedido) AS veces_utilizado,
    SUM(p.total) AS total_procesado
FROM metodos_pago m
LEFT JOIN pedidos p ON m.id_metodo = p.id_metodo
GROUP BY m.id_metodo, m.tipo
ORDER BY veces_utilizado DESC;

-- 3.13 Consulta con fechas: Pedidos del último mes
SELECT 
    p.id_pedido,
    c.nombre AS cliente,
    p.fecha,
    p.total,
    p.estado
FROM pedidos p
INNER JOIN clientes c ON p.id_cliente = c.id_cliente
WHERE p.fecha >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)
ORDER BY p.fecha DESC;

-- 3.14 Consulta compleja: Clientes sin pedidos (LEFT JOIN con IS NULL)
SELECT 
    c.id_cliente,
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.id_pedido IS NULL;

-- =====================================================
-- SECCIÓN 4: VISTAS (VIEWS)
-- Consultas predefinidas para uso frecuente
-- =====================================================

-- Vista: Resumen de clientes con sus estadísticas
CREATE VIEW vista_resumen_clientes AS
SELECT 
    c.id_cliente,
    c.nombre,
    c.email,
    c.ciudad,
    COUNT(p.id_pedido) AS total_pedidos,
    COALESCE(SUM(p.total), 0) AS total_gastado,
    MAX(p.fecha) AS ultimo_pedido
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre, c.email, c.ciudad;

-- Vista: Inventario actual con valorización
CREATE VIEW vista_inventario AS
SELECT 
    id_producto,
    nombre,
    categoria,
    stock,
    precio,
    (stock * precio) AS valor_inventario
FROM productos
WHERE stock > 0;

-- Consultar las vistas creadas
SELECT * FROM vista_resumen_clientes;
SELECT * FROM vista_inventario ORDER BY valor_inventario DESC;

-- =====================================================
-- SECCIÓN 5: CONSULTAS AVANZADAS
-- =====================================================

-- 5.1 Consulta con CASE: Clasificación de clientes por volumen de compra
SELECT 
    c.nombre,
    SUM(p.total) AS total_gastado,
    CASE 
        WHEN SUM(p.total) >= 500000 THEN 'VIP'
        WHEN SUM(p.total) >= 200000 THEN 'Premium'
        WHEN SUM(p.total) >= 50000 THEN 'Regular'
        ELSE 'Nuevo'
    END AS categoria_cliente
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre
ORDER BY total_gastado DESC;

-- 5.2 Consulta con UNION: Productos vendidos y no vendidos
SELECT 
    'Vendido' AS estado,
    p.nombre,
    p.categoria,
    p.stock
FROM productos p
INNER JOIN detalle_pedidos dp ON p.id_producto = dp.id_producto
GROUP BY p.id_producto, p.nombre, p.categoria, p.stock

UNION

SELECT 
    'Sin Ventas' AS estado,
    p.nombre,
    p.categoria,
    p.stock
FROM productos p
LEFT JOIN detalle_pedidos dp ON p.id_producto = dp.id_producto
WHERE dp.id_detalle IS NULL;

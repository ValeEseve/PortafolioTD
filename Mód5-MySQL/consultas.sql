-- Evaluación portafolio módulo 5 - Bases de datos relacionales.

-- =====================================================
-- SECCIÓN 1: DEFINICIÓN DE DATOS (DDL)
-- Creación de tablas y estructura de la base de datos
-- =====================================================

-- Tabla: Clientes
CREATE TABLE Clientes (
    ID_Cliente INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefono VARCHAR(20),
    Direccion VARCHAR(200),
    Fecha_Registro DATE DEFAULT CURRENT_DATE
);

-- Tabla: Productos
CREATE TABLE Productos (
    ID_Producto INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion TEXT,
    Precio DECIMAL(10, 2) NOT NULL CHECK (Precio >= 0),
    Stock INT NOT NULL DEFAULT 0 CHECK (Stock >= 0),
    Categoria VARCHAR(50)
);

-- Tabla: Métodos de Pago
CREATE TABLE Metodos_Pago (
    ID_Metodo INT PRIMARY KEY AUTO_INCREMENT,
    Tipo VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(100)
);

-- Tabla: Pedidos
CREATE TABLE Pedidos (
    ID_Pedido INT PRIMARY KEY AUTO_INCREMENT,
    Fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    ID_Cliente INT NOT NULL,
    Total DECIMAL(10, 2) NOT NULL CHECK (Total >= 0),
    Estado VARCHAR(20) DEFAULT 'Pendiente',
    ID_Metodo INT,
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente),
    FOREIGN KEY (ID_Metodo) REFERENCES Metodos_Pago(ID_Metodo)
);

-- Tabla: Detalle de Pedidos (relación muchos a muchos entre Pedidos y Productos)
CREATE TABLE Detalle_Pedidos (
    ID_Detalle INT PRIMARY KEY AUTO_INCREMENT,
    ID_Pedido INT NOT NULL,
    ID_Producto INT NOT NULL,
    Cantidad INT NOT NULL CHECK (Cantidad > 0),
    Precio_Unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (ID_Pedido) REFERENCES Pedidos(ID_Pedido) ON DELETE CASCADE,
    FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Producto)
);

-- =====================================================
-- MODIFICACIONES DE ESTRUCTURA (DDL - ALTER)
-- =====================================================

-- Agregar una columna adicional a Clientes
ALTER TABLE Clientes 
ADD COLUMN Ciudad VARCHAR(50);

-- Agregar índice para mejorar búsquedas por email
CREATE INDEX idx_email ON Clientes(Email);

-- Agregar índice para búsquedas por categoría de productos
CREATE INDEX idx_categoria ON Productos(Categoria);

-- =====================================================
-- SECCIÓN 2: MANIPULACIÓN DE DATOS (DML)
-- Inserción de datos de ejemplo
-- =====================================================

-- Insertar Métodos de Pago
INSERT INTO Metodos_Pago (Tipo, Descripcion) VALUES
('Tarjeta de Crédito', 'Visa, Mastercard, American Express'),
('Tarjeta de Débito', 'Débito bancario'),
('PayPal', 'Pago a través de PayPal'),
('Transferencia', 'Transferencia bancaria directa');

-- Insertar Clientes
INSERT INTO Clientes (Nombre, Email, Telefono, Direccion, Ciudad) VALUES
('Juan Pérez', 'juan.perez@email.com', '+56912345678', 'Av. Providencia 123', 'Santiago'),
('María González', 'maria.gonzalez@email.com', '+56987654321', 'Calle Los Aromos 456', 'Valparaíso'),
('Carlos Rodríguez', 'carlos.rodriguez@email.com', '+56923456789', 'Pasaje Central 789', 'Concepción'),
('Ana Martínez', 'ana.martinez@email.com', '+56934567890', 'Av. Libertad 321', 'La Serena');

-- Insertar Productos
INSERT INTO Productos (Nombre, Descripcion, Precio, Stock, Categoria) VALUES
('Laptop HP Pavilion', 'Laptop 15.6", Intel i5, 8GB RAM, 256GB SSD', 599990, 15, 'Computadores'),
('Mouse Inalámbrico Logitech', 'Mouse óptico inalámbrico con receptor USB', 12990, 50, 'Accesorios'),
('Teclado Mecánico RGB', 'Teclado mecánico con retroiluminación RGB', 45990, 30, 'Accesorios'),
('Monitor Samsung 24"', 'Monitor Full HD, 75Hz, Panel IPS', 129990, 20, 'Monitores'),
('Auriculares Sony WH-1000XM4', 'Auriculares con cancelación de ruido', 249990, 10, 'Audio'),
('Webcam Logitech C920', 'Cámara web Full HD 1080p', 59990, 25, 'Accesorios'),
('Disco Duro Externo 1TB', 'Disco duro portátil USB 3.0', 49990, 40, 'Almacenamiento');

-- Insertar Pedidos
INSERT INTO Pedidos (ID_Cliente, Total, Estado, ID_Metodo) VALUES
(1, 612980, 'Completado', 1),
(2, 179980, 'En Proceso', 2),
(1, 45990, 'Completado', 1),
(3, 599990, 'Pendiente', 3),
(4, 309980, 'Completado', 1);

-- Insertar Detalle de Pedidos
INSERT INTO Detalle_Pedidos (ID_Pedido, ID_Producto, Cantidad, Precio_Unitario) VALUES
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
UPDATE Clientes
SET Direccion = 'Nueva Av. Providencia 999', Ciudad = 'Santiago'
WHERE ID_Cliente = 1;

-- Actualizar el stock después de una venta
UPDATE Productos
SET Stock = Stock - 1
WHERE ID_Producto = 1;

-- Cambiar el estado de un pedido
UPDATE Pedidos
SET Estado = 'Enviado'
WHERE ID_Pedido = 2;

-- Actualizar precio de un producto (descuento del 10%)
UPDATE Productos
SET Precio = Precio * 0.90
WHERE Categoria = 'Accesorios';

-- =====================================================
-- OPERACIONES DE ELIMINACIÓN (DELETE)
-- =====================================================

-- Eliminar un pedido cancelado (primero eliminar detalles por integridad referencial)
-- Nota: Si se configuró ON DELETE CASCADE, solo se necesita eliminar el pedido padre

-- Eliminar pedidos antiguos con estado 'Cancelado' (ejemplo hipotético)
DELETE FROM Pedidos
WHERE Estado = 'Cancelado' AND Fecha < DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR);

-- Eliminar productos sin stock que no se venderán más
DELETE FROM Productos
WHERE Stock = 0 AND Categoria = 'Descontinuado';

-- =====================================================
-- SECCIÓN 3: CONSULTAS DE SELECCIÓN (SELECT)
-- =====================================================

-- 3.1 Consulta Simple: Todos los clientes
SELECT * FROM Clientes;

-- 3.2 Consulta con filtro: Clientes de Santiago
SELECT Nombre, Email, Telefono
FROM Clientes
WHERE Ciudad = 'Santiago';

-- 3.3 Consulta con JOIN: Pedidos con información del cliente
SELECT 
    p.ID_Pedido,
    p.Fecha,
    c.Nombre AS Cliente,
    c.Email,
    p.Total,
    p.Estado
FROM Pedidos p
INNER JOIN Clientes c ON p.ID_Cliente = c.ID_Cliente;

-- 3.4 Consulta específica: Todos los pedidos de un cliente específico
SELECT 
    p.ID_Pedido,
    p.Fecha,
    p.Total,
    p.Estado,
    m.Tipo AS Metodo_Pago
FROM Pedidos p
INNER JOIN Clientes c ON p.ID_Cliente = c.ID_Cliente
LEFT JOIN Metodos_Pago m ON p.ID_Metodo = m.ID_Metodo
WHERE c.Nombre = 'Juan Pérez'
ORDER BY p.Fecha DESC;

-- 3.5 Consulta con múltiples JOINS: Detalle completo de pedidos
SELECT 
    p.ID_Pedido,
    c.Nombre AS Cliente,
    prod.Nombre AS Producto,
    dp.Cantidad,
    dp.Precio_Unitario,
    (dp.Cantidad * dp.Precio_Unitario) AS Subtotal,
    p.Fecha
FROM Pedidos p
INNER JOIN Clientes c ON p.ID_Cliente = c.ID_Cliente
INNER JOIN Detalle_Pedidos dp ON p.ID_Pedido = dp.ID_Pedido
INNER JOIN Productos prod ON dp.ID_Producto = prod.ID_Producto
ORDER BY p.ID_Pedido, prod.Nombre;

-- 3.6 Consulta con GROUP BY: Total de ventas por cliente
SELECT 
    c.Nombre AS Cliente,
    COUNT(p.ID_Pedido) AS Cantidad_Pedidos,
    SUM(p.Total) AS Total_Gastado,
    AVG(p.Total) AS Promedio_Pedido
FROM Clientes c
INNER JOIN Pedidos p ON c.ID_Cliente = p.ID_Cliente
GROUP BY c.ID_Cliente, c.Nombre
ORDER BY Total_Gastado DESC;

-- 3.7 Consulta con GROUP BY: Productos más vendidos
SELECT 
    prod.Nombre AS Producto,
    prod.Categoria,
    SUM(dp.Cantidad) AS Unidades_Vendidas,
    SUM(dp.Cantidad * dp.Precio_Unitario) AS Ingresos_Totales
FROM Productos prod
INNER JOIN Detalle_Pedidos dp ON prod.ID_Producto = dp.ID_Producto
GROUP BY prod.ID_Producto, prod.Nombre, prod.Categoria
ORDER BY Unidades_Vendidas DESC;

-- 3.8 Consulta con HAVING: Clientes con más de un pedido
SELECT 
    c.Nombre AS Cliente,
    c.Email,
    COUNT(p.ID_Pedido) AS Cantidad_Pedidos,
    SUM(p.Total) AS Total_Gastado
FROM Clientes c
INNER JOIN Pedidos p ON c.ID_Cliente = p.ID_Cliente
GROUP BY c.ID_Cliente, c.Nombre, c.Email
HAVING COUNT(p.ID_Pedido) > 1
ORDER BY Cantidad_Pedidos DESC;

-- 3.9 Consulta con subconsulta: Productos con precio superior al promedio
SELECT 
    Nombre,
    Precio,
    Stock,
    Categoria
FROM Productos
WHERE Precio > (SELECT AVG(Precio) FROM Productos)
ORDER BY Precio DESC;

-- 3.10 Consulta con agregaciones: Resumen de ventas por categoría
SELECT 
    prod.Categoria,
    COUNT(DISTINCT dp.ID_Pedido) AS Pedidos,
    SUM(dp.Cantidad) AS Unidades_Vendidas,
    SUM(dp.Cantidad * dp.Precio_Unitario) AS Ingresos_Totales,
    AVG(dp.Precio_Unitario) AS Precio_Promedio
FROM Productos prod
INNER JOIN Detalle_Pedidos dp ON prod.ID_Producto = dp.ID_Producto
GROUP BY prod.Categoria
ORDER BY Ingresos_Totales DESC;

-- 3.11 Consulta de inventario: Productos con stock bajo
SELECT 
    Nombre,
    Categoria,
    Stock,
    Precio
FROM Productos
WHERE Stock < 20
ORDER BY Stock ASC;

-- 3.12 Consulta de análisis: Métodos de pago más utilizados
SELECT 
    m.Tipo AS Metodo_Pago,
    COUNT(p.ID_Pedido) AS Veces_Utilizado,
    SUM(p.Total) AS Total_Procesado
FROM Metodos_Pago m
LEFT JOIN Pedidos p ON m.ID_Metodo = p.ID_Metodo
GROUP BY m.ID_Metodo, m.Tipo
ORDER BY Veces_Utilizado DESC;

-- 3.13 Consulta con fechas: Pedidos del último mes
SELECT 
    p.ID_Pedido,
    c.Nombre AS Cliente,
    p.Fecha,
    p.Total,
    p.Estado
FROM Pedidos p
INNER JOIN Clientes c ON p.ID_Cliente = c.ID_Cliente
WHERE p.Fecha >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)
ORDER BY p.Fecha DESC;

-- 3.14 Consulta compleja: Clientes sin pedidos (LEFT JOIN con IS NULL)
SELECT 
    c.ID_Cliente,
    c.Nombre,
    c.Email,
    c.Fecha_Registro
FROM Clientes c
LEFT JOIN Pedidos p ON c.ID_Cliente = p.ID_Cliente
WHERE p.ID_Pedido IS NULL;

-- =====================================================
-- SECCIÓN 4: VISTAS (VIEWS)
-- Consultas predefinidas para uso frecuente
-- =====================================================

-- Vista: Resumen de clientes con sus estadísticas
CREATE VIEW Vista_Resumen_Clientes AS
SELECT 
    c.ID_Cliente,
    c.Nombre,
    c.Email,
    c.Ciudad,
    COUNT(p.ID_Pedido) AS Total_Pedidos,
    COALESCE(SUM(p.Total), 0) AS Total_Gastado,
    MAX(p.Fecha) AS Ultimo_Pedido
FROM Clientes c
LEFT JOIN Pedidos p ON c.ID_Cliente = p.ID_Cliente
GROUP BY c.ID_Cliente, c.Nombre, c.Email, c.Ciudad;

-- Vista: Inventario actual con valorización
CREATE VIEW Vista_Inventario AS
SELECT 
    ID_Producto,
    Nombre,
    Categoria,
    Stock,
    Precio,
    (Stock * Precio) AS Valor_Inventario
FROM Productos
WHERE Stock > 0;

-- Consultar las vistas creadas
SELECT * FROM Vista_Resumen_Clientes;
SELECT * FROM Vista_Inventario ORDER BY Valor_Inventario DESC;

-- =====================================================
-- SECCIÓN 5: CONSULTAS AVANZADAS
-- =====================================================

-- 5.1 Consulta con CASE: Clasificación de clientes por volumen de compra
SELECT 
    c.Nombre,
    SUM(p.Total) AS Total_Gastado,
    CASE 
        WHEN SUM(p.Total) >= 500000 THEN 'VIP'
        WHEN SUM(p.Total) >= 200000 THEN 'Premium'
        WHEN SUM(p.Total) >= 50000 THEN 'Regular'
        ELSE 'Nuevo'
    END AS Categoria_Cliente
FROM Clientes c
LEFT JOIN Pedidos p ON c.ID_Cliente = p.ID_Cliente
GROUP BY c.ID_Cliente, c.Nombre
ORDER BY Total_Gastado DESC;

-- 5.2 Consulta con UNION: Productos vendidos y no vendidos
SELECT 
    'Vendido' AS Estado,
    p.Nombre,
    p.Categoria,
    p.Stock
FROM Productos p
INNER JOIN Detalle_Pedidos dp ON p.ID_Producto = dp.ID_Producto
GROUP BY p.ID_Producto, p.Nombre, p.Categoria, p.Stock

UNION

SELECT 
    'Sin Ventas' AS Estado,
    p.Nombre,
    p.Categoria,
    p.Stock
FROM Productos p
LEFT JOIN Detalle_Pedidos dp ON p.ID_Producto = dp.ID_Producto
WHERE dp.ID_Detalle IS NULL;

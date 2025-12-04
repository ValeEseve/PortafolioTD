# Sistema de Gestión de Tienda en Línea - Base de Datos SQL

## 📖 Descripción

Este proyecto implementa una base de datos relacional completa para la gestión de una tienda en línea. El archivo `consultas.sql` contiene todas las estructuras, datos de ejemplo y consultas necesarias para comprender el funcionamiento de un sistema de comercio electrónico desde la perspectiva de bases de datos.

## 🎯 Propósito del Código

El archivo `consultas.sql` está diseñado para demostrar:

- **Diseño de bases de datos relacionales**: Estructura de 5 tablas interconectadas que representan clientes, productos, pedidos, detalles de pedidos y métodos de pago
- **Relaciones entre entidades**: Implementación de claves primarias, foráneas y diferentes tipos de relaciones (1:1, 1:N, N:M)
- **Operaciones DDL**: Creación y modificación de estructuras de tablas, índices y vistas
- **Operaciones DML**: Inserción, actualización y eliminación de datos
- **Consultas SQL**: Desde consultas básicas hasta avanzadas con JOIN, GROUP BY, subconsultas y agregaciones

## 🗂️ Estructura de la Base de Datos

### Diagrama EER 
- Revisar archivo "EER consultas.sql.png"

### Tablas Principales

1. **Clientes**: Información de usuarios (ID, nombre, email, teléfono, dirección, ciudad)
2. **Productos**: Catálogo de artículos (ID, nombre, descripción, precio, stock, categoría)
3. **Pedidos**: Transacciones realizadas (ID, fecha, cliente, total, estado, método de pago)
4. **Detalle_Pedidos**: Productos incluidos en cada pedido (relación N:M entre Pedidos y Productos)
5. **Metodos_Pago**: Opciones de pago disponibles (ID, tipo, descripción)

### Relaciones

- Un **cliente** puede realizar múltiples **pedidos** (1:N)
- Un **pedido** contiene múltiples **productos** a través de **Detalle_Pedidos** (N:M)
- Un **pedido** utiliza un **método de pago** específico (N:1)

## 🚀 Cómo Ejecutar las Consultas

### Opción 1: Ejecutar el archivo completo

```bash
# MySQL desde terminal
mysql -u tu_usuario -p nombre_base_datos < consultas.sql

# PostgreSQL desde terminal
psql -U tu_usuario -d nombre_base_datos -f consultas.sql
```

### Opción 2: Ejecutar secciones específicas

1. **Abrir MySQL Workbench / phpMyAdmin / DBeaver** u otro cliente SQL
2. Crear una nueva base de datos:
   ```sql
   CREATE DATABASE tienda_online;
   USE tienda_online;
   ```
3. Copiar y ejecutar las secciones del archivo `consultas.sql` en el siguiente orden:

#### Paso 1: Crear la Estructura (DDL)
Ejecutar la **Sección 1** completa para crear todas las tablas con sus relaciones.

#### Paso 2: Insertar Datos de Ejemplo (DML)
Ejecutar la **Sección 2** para poblar las tablas con datos de prueba.

#### Paso 3: Probar Consultas
Ejecutar las consultas de las **Secciones 3, 4 y 5** individualmente para ver los resultados.

### Opción 3: Ejecución por Bloques

Puedes ejecutar las consultas por bloques según tu necesidad:

- **Crear solo tablas**: Líneas de la Sección 1 (CREATE TABLE)
- **Insertar datos**: Líneas de la Sección 2 (INSERT INTO)
- **Consultas básicas**: Consultas 3.1 a 3.5
- **Consultas avanzadas**: Consultas 3.6 a 3.14
- **Vistas**: Sección 4
- **Consultas complejas**: Sección 5

## 📊 Ejemplos de Consultas Incluidas

### Consultas Básicas
- Listar todos los clientes
- Filtrar clientes por ciudad
- Ver pedidos con información del cliente

### Consultas con JOIN
- Pedidos de un cliente específico
- Detalle completo de pedidos con productos
- Productos vendidos con sus cantidades

### Consultas con Agregaciones
- Total de ventas por cliente
- Productos más vendidos
- Resumen de ventas por categoría
- Métodos de pago más utilizados

### Consultas Avanzadas
- Clasificación de clientes por volumen de compra (CASE)
- Productos vendidos vs. sin ventas (UNION)
- Clientes sin pedidos (LEFT JOIN con IS NULL)
- Productos con precio superior al promedio (subconsultas)

## 💡 Notas Importantes

### Prerequisitos
- Motor de base de datos instalado (MySQL 5.7+, PostgreSQL 9.6+, MariaDB 10.2+ o similar)
- Permisos para crear bases de datos y tablas
- Cliente SQL o interfaz gráfica para ejecutar las consultas

### Integridad Referencial
- Las tablas deben crearse en el orden establecido debido a las dependencias de claves foráneas
- Al eliminar datos, considerar las relaciones `ON DELETE CASCADE` configuradas
- Los datos de ejemplo están diseñados para mantener la integridad referencial

### Modificaciones
- Puedes modificar los datos de ejemplo según tus necesidades
- Las consultas están comentadas para facilitar su comprensión y adaptación
- Los índices están optimizados para las consultas más frecuentes

## 🔍 Verificación de Funcionamiento

Después de ejecutar las secciones 1 y 2, verifica que todo funcione correctamente:

```sql
-- Verificar que las tablas se crearon
SHOW TABLES;

-- Contar registros en cada tabla
SELECT 'Clientes' AS Tabla, COUNT(*) AS Registros FROM Clientes
UNION ALL
SELECT 'Productos', COUNT(*) FROM Productos
UNION ALL
SELECT 'Pedidos', COUNT(*) FROM Pedidos
UNION ALL
SELECT 'Detalle_Pedidos', COUNT(*) FROM Detalle_Pedidos
UNION ALL
SELECT 'Metodos_Pago', COUNT(*) FROM Metodos_Pago;
```

Resultado esperado:
- Clientes: 4 registros
- Productos: 7 registros
- Pedidos: 5 registros
- Detalle_Pedidos: 8 registros
- Métodos_Pago: 4 registros

## 🛠️ Solución de Problemas

### Error: "Table already exists"
```sql
-- Eliminar la base de datos y empezar de nuevo
DROP DATABASE IF EXISTS tienda_online;
CREATE DATABASE tienda_online;
USE tienda_online;
```

### Error: "Cannot add foreign key constraint"
- Verifica que las tablas referenciadas existan
- Asegúrate de ejecutar las secciones en orden
- Verifica que los tipos de datos coincidan entre claves primarias y foráneas

### Error: "Unknown column in field list"
- Verifica que hayas ejecutado la sección DDL completa
- Revisa que no falten campos en las definiciones de tablas

## 📚 Recursos Adicionales

- [Documentación MySQL](https://dev.mysql.com/doc/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [SQL Tutorial - W3Schools](https://www.w3schools.com/sql/)

---

**Módulo**: 5 - MySQL  
**Bootcamp**: Full Stack Python - Talento Digital  
**Última actualización**: Diciembre 2025
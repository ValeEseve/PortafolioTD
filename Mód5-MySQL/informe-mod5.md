# Informe: Fundamentos de Bases de Datos Relacionales
### Introducción

Este informe aborda los conceptos fundamentales de las bases de datos relacionales y su aplicación práctica en la gestión de información organizacional. Se desarrollarán ejemplos concretos utilizando SQL para demostrar cada uno de los requerimientos funcionales.

### 1. Características y Elementos Fundamentales de una Base de Datos Relacional
#### 1.1 Componentes Básicos

Una base de datos relacional se compone de varios elementos esenciales que permiten organizar y estructurar la información de manera eficiente:

Tablas: Son estructuras bidimensionales que almacenan datos organizados en filas y columnas. Cada tabla representa una entidad del mundo real (por ejemplo, clientes, productos, pedidos).

Registros (Filas): Representan instancias individuales de la entidad. Cada registro contiene información completa sobre un elemento específico.

Campos (Columnas): Definen los atributos o características de la entidad. Cada campo tiene un tipo de dato específico (texto, número, fecha, etc.).

Claves Primarias: Son campos o combinaciones de campos que identifican de manera única cada registro en una tabla. No pueden contener valores duplicados ni nulos.

Claves Foráneas: Son campos que establecen relaciones entre tablas al referenciar la clave primaria de otra tabla, permitiendo la integridad referencial.

#### 1.2 Gestión y Almacenamiento de Datos

Los datos se almacenan en tablas siguiendo principios de normalización para evitar redundancia y mantener la consistencia. Las relaciones entre tablas permiten distribuir la información de manera lógica y eficiente, facilitando consultas complejas que combinan datos de múltiples fuentes.

#### 1.3 Ejemplo Práctico: Sistema de Gestión de Pedidos

Para ilustrar estos conceptos, consideremos un sistema básico con dos tablas relacionadas:

Tabla Clientes: Almacena información de los clientes (ID_Cliente, Nombre, Email, Teléfono, Dirección).

Tabla Pedidos: Registra los pedidos realizados (ID_Pedido, Fecha, ID_Cliente, Total, Estado).

La relación se establece mediante la clave foránea ID_Cliente en la tabla Pedidos, que referencia la clave primaria ID_Cliente de la tabla Clientes. Esto permite conocer qué cliente realizó cada pedido sin duplicar toda la información del cliente en cada registro de pedido.


### 2. Consultas SQL para Obtención de Información

El Lenguaje Estructurado de Consultas (SQL) proporciona herramientas poderosas para extraer información específica de las bases de datos. Las principales cláusulas incluyen:

SELECT: Define qué columnas se desean recuperar.

WHERE: Establece condiciones para filtrar registros.

JOIN: Combina datos de múltiples tablas basándose en relaciones.

GROUP BY: Agrupa registros para realizar operaciones agregadas.

ORDER BY: Ordena los resultados según criterios específicos.
Ejemplo de Consulta

Para obtener todos los pedidos de un cliente específico con sus detalles, se utiliza un JOIN que combina información de ambas tablas, filtrando por el nombre o identificador del cliente deseado.


### 3. Manipulación de Datos con DML

El Lenguaje de Manipulación de Datos permite modificar el contenido de las tablas mediante tres operaciones principales:

INSERT: Agrega nuevos registros a una tabla, especificando valores para cada campo requerido.

UPDATE: Modifica datos existentes en uno o varios registros, utilizando condiciones para identificar qué registros actualizar.

DELETE: Elimina registros de una tabla según criterios específicos. Debe usarse con precaución para evitar pérdida de datos importante.
Casos de Uso Prácticos

En un sistema de gestión de clientes, estas operaciones permiten actualizar direcciones cuando un cliente se muda, eliminar pedidos cancelados o agregar nuevos clientes al sistema. La cláusula WHERE es crucial para asegurar que las modificaciones afecten únicamente los registros deseados.


### 4. Definición de Estructuras con DDL

El Lenguaje de Definición de Datos permite crear y mantener la estructura de la base de datos mediante comandos como:

CREATE TABLE: Define nuevas tablas especificando nombres de columnas, tipos de datos, restricciones y claves.

ALTER TABLE: Modifica la estructura de tablas existentes, agregando o eliminando columnas, o cambiando tipos de datos.

DROP TABLE: Elimina tablas completas de la base de datos.
Consideraciones de Diseño

Al crear tablas, es fundamental definir correctamente los tipos de datos (VARCHAR para texto, INT para números enteros, DATE para fechas, DECIMAL para valores monetarios), establecer restricciones de integridad (NOT NULL, UNIQUE, CHECK) y definir las claves primarias y foráneas apropiadas.


### 5. Modelamiento de Datos
#### 5.1 Diagrama Entidad-Relación

El modelamiento de datos comienza con la creación de un diagrama entidad-relación que representa visualmente las entidades del sistema, sus atributos y las relaciones entre ellas. Los tipos de relaciones pueden ser uno a uno, uno a muchos o muchos a muchos.

#### 5.2 Modelo Propuesto: Tienda en Línea

Para una tienda en línea de complejidad básica, el modelo incluye las siguientes entidades:

Clientes: Almacena información de usuarios registrados (identificador, nombre, email, teléfono, dirección de envío).

Productos: Contiene el catálogo de artículos disponibles (identificador, nombre, descripción, precio, stock disponible, categoría).

Pedidos: Registra las transacciones realizadas (identificador, fecha, cliente asociado, total, estado del pedido).

Detalle_Pedidos: Especifica los productos incluidos en cada pedido (identificador, pedido asociado, producto, cantidad, precio unitario).

Métodos_Pago: Define las opciones de pago disponibles (identificador, tipo de método, descripción).

#### 5.3 Relaciones del Modelo

Las relaciones establecidas son:

    Un cliente puede realizar múltiples pedidos (relación uno a muchos).
    Un pedido pertenece a un único cliente (relación muchos a uno).
    Un pedido puede incluir múltiples productos a través de la tabla intermedia Detalle_Pedidos (relación muchos a muchos).
    Un pedido utiliza un método de pago específico (relación muchos a uno).


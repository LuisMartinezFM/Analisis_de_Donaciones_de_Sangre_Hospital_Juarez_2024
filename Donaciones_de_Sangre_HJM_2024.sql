-- ============================================================
-- Creación de la tabla DONACIONES
-- Contiene información sobre donadores y características de cada donación
-- ============================================================

CREATE TABLE donaciones (
    numero SERIAL PRIMARY KEY,          -- Identificador único autoincremental
    tipo_donacion VARCHAR(50),          -- Tipo de donación 
    tipo_extraccion VARCHAR(50),        -- Tipo de extracción realizada
    grupo_sanguineo VARCHAR(20),         -- A+, O-, B+, etc.
    estado_donador VARCHAR(50),         -- Estado de salud o estatus del donador
    sexo VARCHAR(10),                   -- Sexo del donador (M/F/otro)
    edad INTEGER,                       -- Edad del donador
    ultima_version VARCHAR(20)          -- Campo para control de versiones del registro
);


-- ============================================================
-- Consulta para contar cuántos tipos de donación distintos existen
-- ============================================================

SELECT 
    COUNT(DISTINCT tipo_donacion) AS total_tipos_donacion
FROM 
    donaciones;
    
-- ============================================================
-- Consulta para listar los tipos de donación distintos
-- ============================================================

SELECT 
    DISTINCT tipo_donacion
FROM 
    donaciones												   -- Primera kpi que porcentaje tiene cada tipo de donacion grafica de pastel
ORDER BY 
    tipo_donacion;

-- ============================================================
-- Resultado: lista ordenada de cada tipo de donación único
-- ============================================================


--- se subieron valores de forma erronae modificamos la grafica principal

-- ============================================================
-- Eliminación de tabla previa (solo si ya existía)
-- OJO: esto borra todos los datos anteriores
-- ============================================================

DROP TABLE IF EXISTS donaciones;

-- ============================================================
-- Creación de la tabla DONACIONES desde cero
-- ============================================================

CREATE TABLE donaciones (
    numero INTEGER,          -- ID único autoincremental
    tipo_donacion VARCHAR(50),          -- Tipo de donación (sangre, plaquetas, etc.)
    tipo_extraccion VARCHAR(50),        -- Método de extracción
    grupo_sanguineo VARCHAR(20),         -- A+, O-, B-, etc.
    estado_donador VARCHAR(50),         -- Estado/estatus del donador
    sexo VARCHAR(10),                   -- Sexo del donador
    edad INTEGER,                       -- Edad del donador
    ultima_version INTEGER              -- Año o versión numérica (ej. 2019, 2020)
);

-- Ver exactamente qué está recibiendo PostgreSQL en la columna
SELECT DISTINCT ultima_version
FROM donaciones;

-- =================================================0
-- tipos de estado del donador

-- ============================================================
-- Consulta para listar los tipos de donación distintos
-- ============================================================

SELECT 
    DISTINCT estado_donador
FROM 
    donaciones			
    
-- ============================================================
-- Consulta para obtener los registros donde el estado del donador
-- sea exactamente '<Proceso>'
-- ============================================================

SELECT *
FROM donaciones
WHERE estado_donador = '<Proceso>';                           ---- Segunda kpi cuantas donaciones fueron aceptadas en 2024 en porcentaje


SELECT 
    DISTINCT grupo_sanguineo                                  ---- Tercera kpi porcentaje de cada tipo de sangre de los donadores del hospital juarez de mexico
FROM 
    donaciones
    
															 --- 4ta Porcenataje se sexos donantes
SELECT 
    DISTINCT tipo_extraccion
FROM 
    donaciones	                                            --- 5ta porcentaje de cada tipo de extraccion
    
SELECT 
    AVG(edad)::NUMERIC(10,2) AS promedio_edad                -- 6ta edad promedio de los donates
FROM 
    donaciones;
SELECT 
    DISTINCT numero
FROM 
    donaciones	
-- ======================================
-- kpi 1 Grafica de pastel tipos de donacion
---kpi 2 tarjeta del porcentaje de donaciones aceptadas
-- kpi 3 Grafica de pastel del prcentaje de los tipos de snagre donados
-- kpi 4 porcentaje de donaciones masculinas en tarjeta
-- kpi 5 porcentaje de donaciones femenias en tarjeta
-- kpi 6 porcentaje de tipos de extracion en tabla
-- kpi 7 promedio de edad de los donadores en 2024 en el hospital juarez

-- ============================================================
-- Tabla dimensión: tipos de donación
-- ============================================================

-- ============================================================
-- Crear tabla con cantidad y porcentaje por tipo de extracción
-- ============================================================

CREATE TABLE kpi_tipo_extraccion AS
SELECT 
    tipo_extraccion,
    COUNT(*) AS cantidad,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS porcentaje
FROM donaciones
GROUP BY tipo_extraccion
ORDER BY cantidad DESC;

-- ============================================================
-- KPI 2: Crear tabla con cantidad y porcentaje por tipo de donación
-- ============================================================

CREATE TABLE kpi_tipo_donacion AS
SELECT 
    tipo_donacion,
    COUNT(*) AS cantidad,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS porcentaje
FROM donaciones
GROUP BY tipo_donacion
ORDER BY cantidad DESC;

-- ============================================================
-- KPI 3: Crear tabla con cantidad y porcentaje por grupo sanguíneo
-- ============================================================

CREATE TABLE kpi_grupo_sanguineo AS
SELECT 
    grupo_sanguineo,
    COUNT(*) AS cantidad,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS porcentaje
FROM donaciones
GROUP BY grupo_sanguineo
ORDER BY cantidad DESC;

-- ============================================================
-- KPI: Crear tabla con cantidad y porcentaje por tipo de donación
-- ============================================================

CREATE TABLE kpi_tipo_donacion AS
SELECT 
    tipo_donacion,                                   -- Nombre del tipo de donación
    COUNT(*) AS cantidad,                            -- Número de registros de ese tipo
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),  -- Porcentaje respecto al total
          2) AS porcentaje
FROM donaciones
GROUP BY tipo_donacion
ORDER BY cantidad DESC;                              -- Ordenado de mayor a menor

-- ============================================================
-- KPI: Crear tabla con cantidad y porcentaje por estado del donador
-- ============================================================

CREATE TABLE kpi_estado_donador AS
SELECT 
    estado_donador,                                  -- Estado: Aceptado, Rechazado, Proceso, etc.
    COUNT(*) AS cantidad,                            -- Número de donaciones con ese estado
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),  -- Porcentaje del total
          2) AS porcentaje
FROM donaciones
GROUP BY estado_donador
ORDER BY cantidad DESC;                              -- Ordenado del más común al menos común

-- ============================================================
-- KPI: Crear tabla con cantidad y porcentaje por sexo del donador
-- ============================================================

CREATE TABLE kpi_sexo AS
SELECT 
    sexo,                                             -- Masculino, Femenino, etc.
    COUNT(*) AS cantidad,                             -- Número de donantes por sexo
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),   -- Porcentaje respecto al total
          2) AS porcentaje
FROM donaciones
GROUP BY sexo
ORDER BY cantidad DESC;                               -- Ordenado de mayor a menor

-- ============================================================
-- KPI: Promedio de edad de los donadores
-- Consulta directa para Power BI
-- ============================================================

SELECT 
    AVG(edad)::NUMERIC(10,2) AS promedio_edad
FROM donaciones;

-- ============================================================
-- KPI: Crear tabla con el promedio de edad
-- Use esta opción si Power BI no acepta la consulta directa
-- ============================================================

CREATE TABLE kpi_promedio_edad AS
SELECT 
    AVG(edad)::NUMERIC(10,2) AS promedio_edad
FROM donaciones;

-- ============================================================
-- KPI: Crear tabla con el promedio de edad por sexo
-- ============================================================

CREATE TABLE kpi_promedio_edad_sexo AS
SELECT 
    sexo,                                              -- Masculino, Femenino, etc.
    AVG(edad)::NUMERIC(10,2) AS promedio_edad          -- Promedio de edad por sexo
FROM donaciones
GROUP BY sexo
ORDER BY sexo;


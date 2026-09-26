
-- =============================================
-- ANÁLISIS ANDINA RETAIL 2025
-- Autor: [NATALIA BERMUDEZ]
-- =============================================

-- 1. Ventas por categoría
SELECT 
    Categoria,
    COUNT(*) AS total_transacciones,
    ROUND(SUM(Ventas_Totales_USD), 2) AS ventas_totales
FROM ventas
GROUP BY Categoria
ORDER BY ventas_totales DESC;

-- 2. Ventas por región
SELECT 
    Region,
    ROUND(SUM(Ventas_Totales_USD), 2) AS ventas_totales,
    ROUND(AVG(Ventas_Totales_USD), 2) AS ticket_promedio
FROM ventas
GROUP BY Region
ORDER BY ventas_totales DESC;

-- 3. Margen de ganancia por categoría
SELECT 
    Categoria,
    ROUND(SUM(Ventas_Totales_USD), 2) AS ventas_totales,
    ROUND(SUM(Costo_Total_USD), 2) AS costo_total,
    ROUND(SUM(Ventas_Totales_USD) - SUM(Costo_Total_USD), 2) AS ganancia,
    ROUND(
        (SUM(Ventas_Totales_USD) - SUM(Costo_Total_USD)) 
        / SUM(Ventas_Totales_USD) * 100, 1
    ) AS margen_pct
FROM ventas
GROUP BY Categoria
ORDER BY margen_pct DESC;

-- 4. Margen por región
SELECT 
    Region,
    ROUND(SUM(Ventas_Totales_USD), 2) AS ventas_totales,
    ROUND(SUM(Ventas_Totales_USD) - SUM(Costo_Total_USD), 2) AS ganancia,
    ROUND(
        (SUM(Ventas_Totales_USD) - SUM(Costo_Total_USD)) 
        / SUM(Ventas_Totales_USD) * 100, 1
    ) AS margen_pct
FROM ventas
GROUP BY Region
ORDER BY margen_pct DESC;

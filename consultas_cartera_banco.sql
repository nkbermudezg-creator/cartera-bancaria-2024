
-- =============================================
-- ANÁLISIS DE CARTERA CREDITICIA 2024
-- Autor: Natalia Bermudez
-- =============================================

-- 1. Cartera por nivel de riesgo
SELECT 
    Nivel_Riesgo,
    COUNT(*) AS total_creditos,
    ROUND(SUM(Saldo_Pendiente_USD), 2) AS saldo_total,
    ROUND(AVG(Dias_Mora), 1) AS mora_promedio
FROM Fact_Cartera
GROUP BY Nivel_Riesgo
ORDER BY mora_promedio DESC;

-- 2. Top ejecutivos por cartera colocada
SELECT 
    e.Nombre_Ejecutivo,
    e.Region,
    COUNT(c.ID_Credito) AS creditos_colocados,
    ROUND(SUM(c.Valor_Credito_USD), 2) AS cartera_total,
    ROUND(SUM(c.Valor_Credito_USD) / e.Meta_Colocacion_USD * 100, 1) AS cumplimiento_pct
FROM Fact_Cartera c
JOIN Dim_Ejecutivos e ON c.ID_Ejecutivo = e.ID_Ejecutivo
GROUP BY e.ID_Ejecutivo
ORDER BY cartera_total DESC
LIMIT 5;

-- 3. Clientes con mayor riesgo
SELECT 
    cl.ID_Cliente,
    cl.Segmento_Ingresos,
    cl.Ingresos_Mensuales_USD,
    COUNT(c.ID_Credito) AS creditos_activos,
    ROUND(SUM(c.Saldo_Pendiente_USD), 2) AS deuda_total,
    MAX(c.Dias_Mora) AS max_dias_mora
FROM Fact_Cartera c
JOIN Dim_Clientes cl ON c.ID_Cliente = cl.ID_Cliente
WHERE c.Nivel_Riesgo IN ('Riesgo Alto', 'Castigado')
GROUP BY cl.ID_Cliente
ORDER BY max_dias_mora DESC
LIMIT 10;

-- 4. Pagos por canal
SELECT 
    Canal_Pago,
    COUNT(ID_Pago) AS total_pagos,
    ROUND(SUM(Valor_Pago_USD), 2) AS valor_total,
    ROUND(AVG(Valor_Pago_USD), 2) AS pago_promedio
FROM Fact_Pagos
GROUP BY Canal_Pago
ORDER BY valor_total DESC;

-- 5. Riesgo por segmento de cliente
SELECT 
    cl.Segmento_Ingresos,
    c.Nivel_Riesgo,
    COUNT(*) AS total_creditos,
    ROUND(SUM(c.Saldo_Pendiente_USD), 2) AS saldo_en_riesgo
FROM Fact_Cartera c
JOIN Dim_Clientes cl ON c.ID_Cliente = cl.ID_Cliente
GROUP BY cl.Segmento_Ingresos, c.Nivel_Riesgo
ORDER BY cl.Segmento_Ingresos, saldo_en_riesgo DESC;

-- 6. Tasa de mora por tipo de credito
SELECT 
    Tipo_Credito,
    COUNT(*) AS total_creditos,
    SUM(CASE WHEN Dias_Mora > 0 THEN 1 ELSE 0 END) AS creditos_en_mora,
    ROUND(
        SUM(CASE WHEN Dias_Mora > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1
    ) AS tasa_mora_pct,
    ROUND(SUM(Saldo_Pendiente_USD), 2) AS saldo_total
FROM Fact_Cartera
GROUP BY Tipo_Credito
ORDER BY tasa_mora_pct DESC;

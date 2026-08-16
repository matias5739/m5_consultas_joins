-- Consulta 1 — Vista base del proyecto (INNER JOIN) --

SELECT*FROM dim_clientes;
SELECT*FROM dim_productos;
SELECT*FROM dim_territorios;
SELECT*FROM fact_ventas;

SELECT 
    tv.fecha_pedido,
    dc.nombre_apellido AS nombre_cliente,
    dc.tipo_cliente AS segmento,
    dt.ciudad,
    dt.provincia,
    dp.producto,
    dp.categoria_producto AS categoria,
    dp.precio_unitario,
    tv.cantidad,
    tv.monto_total AS total_venta,
    tv.canal_venta AS canal
   
FROM fact_ventas AS tv
INNER JOIN dim_clientes AS dc
    ON tv.id_cliente = dc.id_cliente
INNER JOIN dim_productos AS dp
    ON tv.id_producto = dp.id_producto
INNER JOIN dim_territorios AS dt
    ON tv.id_territorio = dt.id_territorio;

-- Consulta 2 — Clientes sin ventas (LEFT JOIN) --

SELECT*FROM dim_clientes;
SELECT*FROM fact_ventas;

SELECT 
    tv.fecha_pedido,
    tv.id_venta,
    dc.nombre_apellido,
    dc.mail,
    dc.fecha_registro
   
FROM dim_clientes AS dc
LEFT JOIN fact_ventas AS tv
    ON dc.id_cliente = tv.id_cliente
    WHERE id_venta IS NULL;

-- Consulta 3 — Productos sin ventas (LEFT JOIN) --

SELECT*FROM dim_productos;
SELECT*FROM fact_ventas;

SELECT 
    tv.fecha_pedido,
    tv.id_venta,
    dp.producto,
    dp.categoria_producto AS categoria,
    dp.precio_unitario
    
FROM dim_productos AS dp
LEFT JOIN fact_ventas AS tv
    ON dp.id_producto = tv.id_producto
    WHERE id_venta IS NULL;

-- Consulta 4 — Consolidado por canal (UNION ALL) --

SELECT*FROM dim_productos;
SELECT*FROM fact_ventas;

SELECT
    canal,
    SUM(monto_total) AS total_por_canal
FROM (
    SELECT
    tv.canal_venta AS canal,
    tv.monto_total

    FROM fact_ventas AS tv
        WHERE canal_venta = 'Web'
    
    UNION ALL
    
    SELECT
    tv.canal_venta AS canal,
    tv.monto_total

    FROM fact_ventas AS tv
        WHERE canal_venta = 'Local'
) AS tabla_resultante_canal

GROUP BY canal;
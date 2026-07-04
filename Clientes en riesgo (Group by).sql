SELECT *
FROM clientes;
SELECT id_cliente, nombre_cliente, segmento, arr_usd, pais
FROM clientes;
SELECT id_cliente, nombre_cliente, segmento, arr_usd, pais
FROM clientes
ORDER BY arr_usd DESC;
SELECT id_cliente, nombre_cliente, segmento, arr_usd, pais
FROM clientes
ORDER BY arr_usd DESC;
SELECT 
    c.id_cliente,
    c.nombre_cliente,
    c.segmento,
    c.arr_usd,
    c.pais,
    s.fecha_solicitud,
    s.estado_solicitud
FROM clientes c
LEFT JOIN solicitudes_soporte s ON c.id_cliente = s.id_cliente
ORDER BY c.arr_usd DESC;
SELECT 
    c.id_cliente,
    c.nombre_cliente,
    c.segmento,
    c.arr_usd,
    c.pais,
    COUNT(DISTINCT s.id_solicitud) AS total_solicitudes,
    SUM(CASE WHEN s.estado_solicitud = 'Abierto' THEN 1 ELSE 0 END) AS solicitudes_abiertas,
    ROUND(AVG(h.consumo_documentos), 0) AS consumo_promedio
FROM clientes c
LEFT JOIN solicitudes_soporte s ON c.id_cliente = s.id_cliente
LEFT JOIN historico_consumo h ON c.id_cliente = h.id_cliente
GROUP BY c.id_cliente, c.nombre_cliente, c.segmento, c.arr_usd, c.pais
ORDER BY solicitudes_abiertas DESC, consumo_promedio ASC;
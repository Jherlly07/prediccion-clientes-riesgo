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
    s.fecha_solicitud,
    s.estado_solicitud,
    h.mes,
    h.consumo_documentos,
    CASE 
        WHEN c.segmento IN ('A', 'B', 'C') THEN 'Estrategico'
        ELSE 'Masivo'
    END AS tipo_cliente
FROM clientes c
LEFT JOIN solicitudes_soporte s ON c.id_cliente = s.id_cliente
LEFT JOIN historico_consumo h ON c.id_cliente = h.id_cliente
ORDER BY c.arr_usd DESC;








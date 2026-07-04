# 🔍 Predicción de Clientes en Riesgo (Churn)
### SQL · MySQL · Power BI · Excel · ODBC

![SQL](https://img.shields.io/badge/MySQL-8.0-blue?logo=mysql)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow?logo=powerbi)
![Status](https://img.shields.io/badge/Status-Completado-green)

---

## 📋 Descripción del Proyecto

Caso de estudio completo de análisis de datos para identificar **clientes en riesgo de cancelar su contrato (churn)** en una empresa SaaS de facturación electrónica en Latinoamérica.

El proyecto recorre el flujo completo de trabajo de un analista de datos:

```
Excel → MySQL → SQL → Power BI
```

Partiendo de tres hojas de Excel, se construyó una base de datos relacional en MySQL, se escribieron consultas SQL para cruzar las fuentes de datos, y se conectó el resultado en vivo a un informe de Power BI.

---

## 🎯 Hipótesis de Negocio

> Un cliente con **muchos tickets de soporte abiertos** y **consumo de documentos que cae** es una señal de riesgo de churn.

---

## 🗂️ Estructura del Repositorio

```
Prediccion_Clientes_Riesgo/
│
├── README.md                        ← Este archivo
├── sql/
│   ├── 01_crear_tablas.sql          ← Creación de las 3 tablas en MySQL
│   ├── 02_insert_clientes.sql       ← Carga de 100 clientes
│   ├── 03_insert_soporte.sql        ← Carga de 70 tickets de soporte
│   ├── 04_insert_historico.sql      ← Carga de 600 registros de consumo
│   └── 05_consulta_final.sql        ← Consulta integradora con JOIN
├── powerbi/
│   └── Clientes_en_Riesgo.pbix      ← Informe de Power BI
├── docs/
│   └── Manual_SQL_Clientes_Riesgo.docx  ← Manual del caso de estudio
└── data/
    ├── clientes.csv                 ← Datos de clientes
    ├── solicitudes_soporte.csv      ← Tickets de soporte
    └── historico_consumo.csv        ← Histórico de consumo mensual
```

---

## 🗄️ Modelo de Datos

Las tres tablas se relacionan por el campo `id_cliente`:

```
clientes (100 registros) — Tabla maestra
    │
    ├── solicitudes_soporte (70 registros) — Tickets de soporte
    │       id_cliente (FK)
    │       fecha_solicitud
    │       estado_solicitud (Abierto / En progreso / Cerrado)
    │
    └── historico_consumo (600 registros) — Consumo mensual
            id_cliente (FK)
            mes (Ene-2026 a Jun-2026)
            consumo_documentos
```

---

## 🔧 Herramientas Utilizadas

| Herramienta | Versión | Uso |
|---|---|---|
| MySQL | 8.0.42 | Motor de base de datos local |
| MySQL Workbench | 8.0 | Editor SQL y administración |
| MySQL ODBC Driver | 9.7 | Conector MySQL ↔ Excel / Power BI |
| Excel | Microsoft 365 | Origen de datos y destino de consultas |
| Power BI Desktop | Última versión | Modelado y visualización |

---

## 📊 Consulta SQL Principal

La consulta que integra las tres tablas y calcula el indicador de riesgo:

```sql
SELECT
    c.id_cliente,
    c.nombre_cliente,
    c.segmento,
    c.arr_usd,
    c.pais,
    COUNT(DISTINCT s.id_solicitud)                                    AS total_solicitudes,
    SUM(CASE WHEN s.estado_solicitud = 'Abierto' THEN 1 ELSE 0 END)  AS solicitudes_abiertas,
    ROUND(AVG(h.consumo_documentos), 0)                               AS consumo_promedio,
    CASE
        WHEN c.segmento IN ('A', 'B', 'C') THEN 'Estrategico'
        ELSE 'Masivo'
    END AS tipo_cliente
FROM clientes_riesgo.clientes c
LEFT JOIN clientes_riesgo.solicitudes_soporte s ON c.id_cliente = s.id_cliente
LEFT JOIN clientes_riesgo.historico_consumo   h ON c.id_cliente = h.id_cliente
GROUP BY c.id_cliente, c.nombre_cliente, c.segmento, c.arr_usd, c.pais
ORDER BY solicitudes_abiertas DESC, consumo_promedio ASC;
```

---

## 📈 Informe de Power BI

El informe tiene dos páginas:

### Página 1 — Resumen Ejecutivo
- KPIs: Total Clientes, ARR Total, Tickets Abiertos, Clientes en Riesgo.
- ARR total por segmento.
- Distribución de clientes por país.
- Clientes Estratégico vs Masivo.

### Página 2 — Detalle Operativo
- Tickets por estado de solicitud.
- Tendencia de consumo mensual.
- Tabla de clientes en riesgo con formato condicional.
- Segmentador por segmento de cliente.

---

## 🚀 Cómo Replicar Este Proyecto

### Prerequisitos
- MySQL 8.0 instalado localmente.
- MySQL Workbench.
- MySQL ODBC Driver 64 bits.
- Power BI Desktop.
- Excel (Microsoft 365).

### Pasos

**1. Crear la base de datos:**
```sql
CREATE DATABASE clientes_riesgo;
USE clientes_riesgo;
```

**2. Ejecutar los scripts SQL en orden:**
```
01_crear_tablas.sql
02_insert_clientes.sql
03_insert_soporte.sql
04_insert_historico.sql
```

**3. Configurar el conector ODBC:**
- Data Source Name: `MySQL_Clientes_Riesgo`
- Server: `127.0.0.1` | Port: `3306`
- Database: `clientes_riesgo`

**4. Conectar Power BI:**
- Obtener datos → ODBC → `MySQL_Clientes_Riesgo`
- Pegar la consulta del archivo `05_consulta_final.sql`

---

## 💡 Lecciones Aprendidas

| Error | Causa | Solución |
|---|---|---|
| `1046: No database selected` | Falta el USE antes de CREATE TABLE | Agregar `USE nombre_db;` |
| `1824: Failed to open referenced table` | FOREIGN KEY antes de la tabla maestra | Crear primero la tabla `clientes` |
| `Incorrect date value` | Fechas en formato DD/MM/AAAA | Usar formato AAAA-MM-DD en el CSV |
| `Unable to connect to 127.0.0.1:3306` | Servicio MySQL detenido | Iniciar MySQL80 en services.msc |

---

## 👤 Autor

**Joe Cocker**  
Analista de Datos  
Excel · Power Query · Power BI · SQL

---

## 📄 Licencia

Este proyecto es de uso educativo y personal.

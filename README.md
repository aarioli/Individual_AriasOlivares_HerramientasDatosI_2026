# La huella ecológica de la nube: Demanda de Recursos y Huella de Carbono en Google, Meta y Microsoft (2020–2025)

- **Curso:** CA-0204 Herramientas de Ciencia de Datos I — II Ciclo 2026
- **Estudiante:** Allison Arias Olivares
- **Carné:** C4C751

## Descripción y estructura del proyecto
Proyecto individual enfocado en el análisis comparativo del consumo eléctrico, demanda hídrica y huella de carbono (Alcances 1, 2 y 3) de Google, Meta y Microsoft entre 2020 y 2025, a partir de sus reportes oficiales de sostenibilidad:

- `cod/01_limpiar_datos.R`: Script de limpieza, estandarización de unidades y cálculo de métricas derivadas.
- `cod/02_analisis_datos.R`: Script de cálculo de tasas de crecimiento, brechas contables, intensidades y generación de visualizaciones en `ggplot2`.
- `cod/Individual_AriasOlivares_HerramientasDatosI_2026.qmd`: Documento fuente del reporte ejecutivo en Quarto/Typst.
- `Data/processed/base_tidy.csv`: Base de datos limpia en formato *tidy*.
- `info/`: Reportes corporativos originales y guía metodológica (*GHG Protocol Scope 2 Guidance*).
- `res/`: Gráficos exportados (`res/graficos/`) y reporte final renderizado en PDF.

## Diccionario de variables (`base_tidy.csv`)
El conjunto de datos procesado contiene 18 observaciones anuales (2020–2025) con las siguientes variables principales:

- `company` y `year`: Corporación analizada (`Google`, `Meta`, `Microsoft`) y año fiscal del reporte (`2020` a `2025`).
- `electricity_twh`: Consumo eléctrico anual bruto de centros de datos e infraestructura (TWh).
- `renewable_pct`: Porcentaje de la electricidad consumida cubierta mediante contratos de energía renovable (%).
- `pue`: *Power Usage Effectiveness*, indicador de eficiencia térmica de los centros de datos (ratio).
- `water_million_m3`: Consumo neto de agua dulce evaporada en sistemas de enfriamiento (millones de m³).
- `scope1_mt`: Emisiones directas por quema de combustibles fósiles en sitio (MtCO₂e).
- `scope2_location_mt`: Emisiones indirectas de electricidad calculadas según el factor físico de la red local (MtCO₂e).
- `scope2_market_mt`: Emisiones indirectas netas de electricidad tras descontar contratos y certificados limpios (MtCO₂e).
- `scope3_mt`: Emisiones indirectas de la cadena de valor, hardware y construcción (MtCO₂e).
- `intensidad.agua`, `brecha.scope2`, `emisiones.totales`, `pct.scope3` e `intensidad.total`: Métricas analíticas derivadas en R para evaluar eficiencia hídrica, reducción contable en papel e intensidad de carbono por TWh.

*Nota sobre valores ausentes (`NA`):* Corresponden a los datos de Meta de `2025` (informe no publicado al cierre del estudio) y a la métrica `pue` de Microsoft (no reportada de forma consolidada).

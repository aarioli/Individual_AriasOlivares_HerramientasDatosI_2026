# ---------------------------------------------------------------
# Script: 02_analisis.R
# Propósito: Calcular tasas de crecimiento, brechas contables e
#            intensidades de emisión; exportar gráficos y tablas
#            para el reporte ejecutivo (Quarto).
# Insumos: data/processed/base_tidy.csv
# Salidas: data/processed/resumen_objetivos.csv, figuras en res/
# ---------------------------------------------------------------

library(readr)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(forcats)

datos <- "../data/processed/base_tidy.csv"
datos.tidy <- read_csv(datos)

# Analisis Objetivo 1: Cuantificar la evolución 2020–2025 del 
#                      consumo eléctrico (TWh) y del consumo de 
#                      agua (millones de m³) Google, Meta y 
#                      Microsoft, comparando sus tasas de 
#                      crecimiento.

# Consumo Electrico

etiquetas.elec <- datos.tidy %>% 
  filter(!is.na(electricity_twh)) %>% 
  group_by(company) %>% 
  slice_tail(n = 1) %>% 
  ungroup()


consumo.electrico <- datos.tidy %>% 
  filter(!is.na(electricity_twh)) %>% 
  ggplot( aes(x = year, y = electricity_twh, group = company)
  ) +
  
  geom_line(
    data = datos.tidy %>% filter(company != "Google" & !is.na(electricity_twh)),
    colour = "grey75", linewidth = 0.9
  ) +
  
  geom_point(
    data = datos.tidy %>% filter(company != "Google" & !is.na(electricity_twh)),
    colour = "grey75", size = 2
  ) +
  
  geom_line(
    data = datos.tidy %>% filter(company == "Google" & !is.na(electricity_twh)),
    colour = "#1A73E8", linewidth = 1.3
  ) +
  
  geom_point(
    data = datos.tidy %>% filter(company == "Google" & !is.na(electricity_twh)),
    colour = "#1A73E8", size = 3
  ) +
  
  geom_text(
    data = etiquetas.elec,
    aes(
      label = paste0(" ", company, " (", round(electricity_twh, 1), " TWh)"),
      colour = company == "Google"
    ),
    hjust = 0, size = 3.3, show.legend = FALSE
  ) +
  
  scale_colour_manual(values = c("TRUE" = "#1A73E8", "FALSE" = "grey40")
  ) +
  
  scale_x_continuous(
    breaks = 2020:2025,
    expand = expansion(mult = c(0.03, 0.28))
  ) +
  
  scale_y_continuous(limits = c(0, 50)) +
  labs(
    title = "Google lidera el consumo eléctrico y su crecimiento supera al de Meta y Microsoft",
    subtitle = "Consumo anual en centros de datos e infraestructura (TWh, 2020–2025)",
    x = "Año fiscal / reporte",
    y = "Consumo eléctrico (TWh)",
    caption = "Fuente: Environmental Reports de Alphabet (Google), Meta Platforms y Microsoft Corporation."
  ) +
  
  theme_minimal(base_size = 11) +
  theme(
    panel.grid.minor = element_blank(),
    plot.title.position = "plot",
    plot.title = element_text(face = "bold", size = 12)
  )

consumo.electrico

# Consumo de agua

etiquetas.agua <- datos.tidy %>% 
  filter(!is.na(water_million_m3)) %>% 
  group_by(company) %>%  
  slice_tail(n = 1) %>%  
  ungroup()

consumo.agua <- datos.tidy %>% 
  filter(!is.na(water_million_m3)) %>% 
  ggplot( aes(x = year, y = water_million_m3, group = company)
  ) +
  
  geom_line(
    data = datos.tidy %>%  filter(company != "Google" & !is.na(water_million_m3)),
    colour = "grey75", linewidth = 0.9
  ) +
  
  geom_point(
    data = datos.tidy %>% filter(company != "Google"),
    colour = "grey75", size = 2
  ) +
  
  geom_line(
    data = datos.tidy %>%  filter(company == "Google"),
    colour = "#1A73E8", linewidth = 1.3
  ) +
  
  geom_point(
    data = datos.tidy %>%  filter(company == "Google"),
    colour = "#1A73E8", size = 3
  ) +
  
  geom_text(
    data = etiquetas.agua,
    aes(
      label = paste0(" ", company, " (", round(water_million_m3, 1), " M m³)"),
      colour = company == "Google"
    ),
    hjust = 0, size = 3.3, show.legend = FALSE
  ) +
  
  scale_colour_manual(values = c("TRUE" = "#1A73E8", "FALSE" = "grey40")
  ) +
  
  scale_x_continuous(
    breaks = 2020:2025,
    expand = expansion(mult = c(0.03, 0.30))
  ) +
  
  scale_y_continuous(limits = c(0, 45)
  ) +
  
  labs(
    title = "El consumo de agua de Google se disparó un 190% entre 2020 y 2025",
    subtitle = "Google (azul) vs. Meta y Microsoft (gris) · Millones de m³ consumidos",
    x = "Año fiscal / reporte",
    y = "Agua consumida (millones de m³)",
    caption = "Fuente: Environmental Reports de Alphabet (Google), Meta Platforms y Microsoft Corporation."
  ) +
  
  theme_minimal(base_size = 11) +
  theme(
    panel.grid.minor = element_blank(),
    plot.title.position = "plot",
    plot.title = element_text(face = "bold", size = 12)
  )

consumo.agua

# Tabla Comparación de tasas de crecimiento

tabla.obj1 <- datos.tidy |> 
  arrange(company, year) |> 
  group_by(company) |> 
  summarise(
    # Electricidad (TWh)
    consumo.e.inicial = first(electricity_twh[!is.na(electricity_twh)]),
    consumo.e.final   = last(electricity_twh[!is.na(electricity_twh)]),
    crecimiento.e.pct = round(((consumo.e.final - consumo.e.inicial) / consumo.e.inicial) * 100, 1),
    
    # Agua (millones m3)
    consumo.a.inicial = first(water_million_m3[!is.na(water_million_m3)]),
    consumo.a.final   = last(water_million_m3[!is.na(water_million_m3)]),
    crecimiento.a.pct = round(((consumo.a.final - consumo.a.inicial) / consumo.a.inicial) * 100, 1),
    .groups = "drop"
  )

tabla.obj1


# Analisis Objetivo 2: Cuantificar la reducción contable de 
#                      emisiones de Scope 2 atribuible a la 
#                      contratación de electricidad renovable, 
#                      usando la brecha entre Scope 2 location-based 
#                      y market-based como proxy.


datos.obj2.reciente <- datos.tidy |> 
  filter(!is.na(scope2_location_mt) & !is.na(scope2_market_mt)) |> 
  arrange(company, year) |> 
  group_by(company) |> 
  slice_tail(n = 1) |> 
  ungroup() |> 
  mutate(
    company = fct_reorder(company, scope2_location_mt),
    brecha = scope2_location_mt - scope2_market_mt,
    punto_medio = (scope2_location_mt + scope2_market_mt) / 2
  )

grafico.scope2.dumbbell <- ggplot(datos.obj2.reciente) +
  
  geom_segment(
    aes(
      y = company, yend = company,
      x = scope2_market_mt, xend = scope2_location_mt
    ),
    colour = "grey75", linewidth = 2
  ) +
  
  geom_point(aes(y = company, x = scope2_market_mt), colour = "#00FFFF", size = 4) +
  geom_point(aes(y = company, x = scope2_location_mt), colour = "#7570B3", size = 4) +
  
  geom_text(
    aes(y = company, x = scope2_market_mt, label = paste0(round(scope2_market_mt, 1), " Mt")),
    vjust = -1, colour = "#00FFFF", size = 3.2
  ) +
  geom_text(
    aes(y = company, x = scope2_location_mt, label = paste0(round(scope2_location_mt, 1), " Mt")),
    vjust = -1, colour = "#7570B3", size = 3.2
  ) +
  scale_x_continuous(expand = expansion(mult = c(0.12, 0.15))) +
  labs(
    title = "Contratos limpios abren una brecha de hasta 12 Mt frente a la red física",
    subtitle = "Scope 2: Contable (celeste) vs. Red física (morado) en el último año reportado",
    x = "Emisiones de Alcance 2 (MtCO2e)",
    y = NULL,
    caption = "Fuente: Reportes de sostenibilidad bajo GHG Protocol Scope 2 Guidance."
  ) +
  theme_minimal(base_size = 11) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    plot.title.position = "plot",
    plot.title = element_text(face = "bold", size = 11)
  )

grafico.scope2.dumbbell


# Tabla resumen de la brecha Scope 2 (Año más reciente)

tabla.brecha.obj2 <- datos.obj2.reciente |> 
  mutate(
    brecha.absoluta.mt = round(scope2_location_mt - scope2_market_mt, 2),
    pct.mitigado.papel = round((brecha.absoluta.mt / scope2_location_mt) * 100, 1)
  ) |> 
  select(
    company, 
    year, 
    scope2_location_mt, 
    scope2_market_mt, 
    brecha.absoluta.mt, 
    pct.mitigado.papel
  )

tabla.brecha.obj2



# Objetivo 3: Evaluar si esa reducción del Scope 2 se traduce 
#             en una menor huella total, examinando la participación
#             del Scope 3 y las intensidades de carbono operativa y 
#             total (Scope 1 + 2 market + 3 por TWh).


tabla.resumen.obj3 <- datos.tidy |> 
  filter(
    !is.na(scope1_mt), 
    !is.na(scope2_market_mt), 
    !is.na(scope3_mt), 
    !is.na(electricity_twh)
  ) |> 
  arrange(company, year) |> 
  mutate(
    emisiones.operativas = scope1_mt + scope2_market_mt,
    emisiones.totales    = emisiones.operativas + scope3_mt,
    pct.scope3           = (scope3_mt / emisiones.totales) * 100,
    intensidad.carbono   = emisiones.totales / electricity_twh
  ) |> 
  group_by(company) |> 
  summarise(
    
    # Alcance 3 en el último año reportado
    scope3.ultimo.mt   = round(last(scope3_mt), 2),
    pct.scope3.ultimo  = round(last(pct.scope3), 1),
    
    # Intensidad: año inicial vs último año
    intensidad.2020    = round(first(intensidad.carbono), 2),
    intensidad.ultimo  = round(last(intensidad.carbono), 2),
    var.intensidad.pct = round(((last(intensidad.carbono) - first(intensidad.carbono)) / first(intensidad.carbono)) * 100, 1),
    .groups = "drop"
  )

tabla.resumen.obj3
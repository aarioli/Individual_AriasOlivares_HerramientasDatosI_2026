# ---------------------------------------------------------------
# Script: 01_limpieza.R
# Propósito: leer el Excel crudo, homologar variables, aplicar
#            correcciones documentadas, derivar variables y
#            exportar base tidy a CSV.
# Insumos: data/Datos crudos/Datos crudos.xlsx
# Salidas: data/processed/base_tidy.csv
# ---------------------------------------------------------------

library(readxl) 
library(dplyr)    
library(tidyr)    
library(purrr)    
library(readr)    

archivo.excel <- "data/Datos crudos/Datos crudos.xlsx"
archivo.limpio <- "data/processed/base_tidy.csv"

datos.consolidados <- read_excel(
  archivo.excel, 
  sheet = 1,
  na = "NA") %>% 
  mutate(
    company = factor( 
      company, 
      levels = c("Google", "Meta", "Microsoft")
      ),
    year = as.integer(year),
    across(
      c(electricity_twh, renewable_pct, pue, water_million_m3,
        scope1_mt, scope2_market_mt, scope2_location_mt, scope3_mt),
      as.numeric
    )
  )

datos.limpios <- datos.consolidados %>% 
  mutate(
    intensidad.agua = water_million_m3 / electricity_twh,
    brecha.scope2 = scope2_location_mt - scope2_market_mt,
    emisiones.totales = scope1_mt + scope2_market_mt + scope3_mt,
    pct.scope3 = (scope3_mt / emisiones.totales) * 100,
    intensidad.operativa = (scope1_mt + scope2_market_mt) / electricity_twh,
    intensidad.total = emisiones.totales / electricity_twh
  )

write_csv(datos.limpios, archivo.limpio)


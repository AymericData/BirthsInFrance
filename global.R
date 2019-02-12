# Packages -------------------------------------------------------------------------------------------

# install.packages("shiny")
# install.packages("shinydashboard")
# install.packages("dplyr")
# install.packages("highcharter")
# install.packages("leaflet")
# install.packages("Rcpp")
# install.packages("DT")

require(DT)
require(shiny)
require(shinydashboard)
require(dplyr)
require(highcharter)
require(leaflet)
require(sp)
require(rsconnect)


load("R_data/naissances.RData")
load("R_data/france_dept.RData")
load("R_data/naissances_total.RData")

# création de la colonne évolution du nombre de naissances
naissances_total = naissances_total %>%
  mutate(Evo_naissance = round(Nbre_naissance-lag(Nbre_naissance))/lag(Nbre_naissance) * 100, 2)
naissances_total$Evo_naissance = round(naissances_total$Evo_naissance, 2)

# création de la colonne évolution du nombre de naissances par département
naissances = naissances %>%
  mutate(Annee = as.numeric(naissances$Annee))

naissances = naissances %>%
  mutate(Evo_naissance = round(Nbre_naissance-lag(Nbre_naissance, 96))/lag(Nbre_naissance, 96) * 100, 2)
naissances$Evo_naissance = round(naissances$Evo_naissance, 2)

pal <- colorFactor(
  palette = "BuGn",
  domain = france_dept@data$Classe)

naissances_map = read.csv2("R_data/naissances.csv")
naissances = naissances[,1:5]
naissances_total = naissances_total[,1:5]
naissancesChr = naissances %>%
  mutate(Annee = as.character(naissances$Annee))




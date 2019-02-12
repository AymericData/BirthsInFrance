


#  ------------------------------------------------------------------------
#
# Title : Graph highchart
#    By : dreamRs
#  Date : lundi 21 mai 2018
#    
#  ------------------------------------------------------------------------



# Packages ----------------------------------------------------------------

library(highcharter)
library(treemap)
library(data.table)

# Bar Chart --------------------------------------------------------------

dcr_pct <- data.frame(DCR = c("Ouest","Est","Ile de France","Mediterranée","Rhône Alpe Auvergne",
                              "Nord Ouest","Sud Ouest","Grand Centre","Grands Comptes"),
                      PCT_SITES_SELECT = c(25,30,25,-30,25,30,25,30,-25))



hc <-   highcharter::highchart() %>% 
  highcharter::hc_chart(type = "bar") %>% 
  highcharter::hc_title(text = "Bar Chart") %>% 
  highcharter::hc_xAxis(categories = as.list(dcr_pct[["DCR"]])) %>% 
  highcharter::hc_add_series(
    data = dcr_pct[["PCT_SITES_SELECT"]],
    color = "#011A70",
    name = "DCR",
    showInLegend = FALSE
  ) %>% 
  highcharter::hc_tooltip(
    formatter = highcharter::JS("function() {return this.point.category + \' : <b>\' + this.y + \'<b>\'}")
  ) %>% 
  highcharter::hc_plotOptions(bar = list(dataLabels = list(enabled = TRUE)))

hc

hc <-   highcharter::highchart() %>% 
  highcharter::hc_chart(type = "column") %>% 
  highcharter::hc_title(text = "Column Chart") %>% 
  highcharter::hc_xAxis(categories = as.list(dcr_pct[["DCR"]])) %>% 
  highcharter::hc_add_series(
    data = dcr_pct[["PCT_SITES_SELECT"]],
    color = "#011A70",
    name = "DCR",
    showInLegend = FALSE,
    threshold = 0, 
    negativeColor = "#D02D2D"
  ) %>% 
  highcharter::hc_tooltip(
    formatter = highcharter::JS("function() {return this.point.category + \' : <b>\' + this.y + \'<b>\'}")
  ) %>% 
  highcharter::hc_plotOptions(bar = list(dataLabels = list(enabled = TRUE)))

hc

# Line Chart --------------------------------------------------------------

# graphes d'évolution 
qual_evo <- data.frame(MOIS_ANNEE = c("decembre 2017", "janvier 2018", "fevrier 2018"),
                       NB_NR = c(300, 200, 400))


hc <-   highcharter::highchart() %>% 
  highcharter::hc_chart(type = "spline") %>%   # "line" pour une ligne
  highcharter::hc_title(text = "Line Chart") %>% 
  highcharter::hc_xAxis(categories = as.list(qual_evo[["MOIS_ANNEE"]])) %>% 
  highcharter::hc_yAxis(min = 0) %>% 
  highcharter::hc_add_series(
    data = qual_evo[["NB_NR"]],
    color = "#011A70",
    name = "MOIS_ANNEE",
    showInLegend = FALSE
  ) %>% 
  highcharter::hc_tooltip(
    formatter = highcharter::JS("function() {return this.point.category + \' : <b>\' + this.y + \'<b>\'}")
  ) %>% 
  highcharter::hc_plotOptions(bar = list(dataLabels = list(enabled = TRUE)))

hc

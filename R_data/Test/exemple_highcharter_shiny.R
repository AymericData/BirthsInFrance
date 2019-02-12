
library("shiny")
library("highcharter")



ui <- fluidPage(
  h1("Highcharter Demo"),
  fluidRow(
    column(width = 12,
           highchartOutput("hcontainer",height = "500px")
    )
  )
)

server = function(input, output) {
  
  output$hcontainer <- renderHighchart({
    
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
    hc
    
  })
  
}

shinyApp(ui = ui, server = server)

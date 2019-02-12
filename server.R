server = function(input, output, session) {
  
  # infobox
  output$box_title = renderInfoBox({
    if (input$carte == 1) {
      titre = "France"
    } else {
      titre = input$dep
    }
    infoBox(
      title = 'Niveau Géographique', value = titre, icon = icon("globe"), color = "light-blue")
  })
  
  # nombre de naissances
  output$Box1 <- renderValueBox({
    valueBox(
      naissances_total[which(naissances_total$Annee == input$slider1),"Nbre_naissance"], 
      "Nombre de naissances", icon = icon("child"),
      color = "light-blue"
    )
  })
  
  output$Box2 <- renderValueBox({
    valueBox(
      naissances[which(naissances$Annee == input$slider1 & naissances$Departement == input$dep),"Nbre_naissance"], 
      "Nombre de naissances", icon = icon("child"),
      color = "light-blue"
    )
  })
  
  # évolution des naissances
  output$Box3 <- renderValueBox({
    valueBox(
      paste(naissances_total[which(naissances_total$Annee == input$slider1),"Evo_naissance"],"%", sep = ""), 
      "% d'évolution", icon = icon("angle-double-up"),
      color = "light-blue"
    )
  })
  
  output$Box4 <- renderValueBox({
    valueBox(
      paste(naissances[which(naissances$Annee == input$slider1 & naissances$Departement == input$dep),
                       "Evo_naissance"],"%", sep = ""), "% d'évolution", icon = icon("angle-double-up"),
      color = "light-blue"
    )
  })
  
  # pic de naissances
  output$Box5  <- renderValueBox({
    valueBox(
      naissances_total[which.max(naissances_total$Nbre_naissance),"Annee"], 
      "Pic de naissances", icon = icon("thermometer-full"),
      color = "light-blue"
    )
  })
  
  output$Box6  <- renderValueBox({
    valueBox(
      naissances_total[which.max(naissances$Departement == input$dep),"Annee"], 
      "Pic de naissances", icon = icon("star"),
      color = "light-blue"
    )
  })
  
  # highcharter nombre de naissances
  output$plotFrance = renderHighchart({
    
    hc <- highchart() %>% #graph naissances_total
      hc_chart(type = "spline") %>%
      hc_xAxis(categories = as.list(naissances_total$Annee)) %>%
      hc_add_series(data = naissances_total$Nbre_naissance,
                    color = "#58ACFA",
                    name = "Nombre de naissances")
  })
  
  output$plotDepartement = renderHighchart({ #graph naissances par dep
    naissances2 = naissances[which(naissances$Departement == input$dep),]
    hc <-  highchart() %>%
      hc_chart(type = "spline") %>%
      hc_xAxis(categories = as.list(naissances2$Annee)) %>%
      hc_add_series(data = naissances2$Nbre_naissance,
                    color = "#58ACFA",
                    name = "Nombre de naissances")
  })
  
 
  
  # highcharter top
  output$BarChart = renderHighchart({
    
    top <- naissances[(which(naissances$Annee == input$slider1)),]
    top2 <- top %>%
      arrange(desc(Nbre_naissance)) %>%
      slice(1:5)
    
    hc <- highchart() %>% 
      hc_chart(type = "bar") %>%
      hc_xAxis(categories = as.list(top2$Departement)) %>%
      hc_add_series(data = top2$Nbre_naissance,
                    color = "#58ACFA",
                    name = "Nombre de naissances")
  })
   
  # highcharter flop
  output$BarChart2 = renderHighchart({
    
    flop <- naissances[(which(naissances$Annee == input$slider1)),]
    flop2 <- flop %>%
      arrange(Nbre_naissance) %>%
      slice(1:5)
    
    hc <- highchart() %>% 
      hc_chart(type = "bar") %>%
      hc_xAxis(categories = as.list(flop2$Departement)) %>%
      hc_add_series(data = flop2$Nbre_naissance,
                    color = "#58ACFA",
                    name = "Nombre de naissances")
  })
 

  # evolution negative chart France
  output$NegativChart = renderHighchart({
    
    hc <- highchart() %>% 
      hc_chart(type = "column") %>%
      hc_yAxis(title = list(text = "Pourcentage d'évolution")) %>%
      hc_xAxis(categories = as.list(naissances_total$Annee)) %>%
      hc_add_series(data = naissances_total$Evo_naissance,
                    color = "green",
                    negativeColor = "red",
                    name = "% d'évolution",
                    showInLegend = FALSE)
  })
  
  # evolution negative chart Departement
  output$NegativChart2 = renderHighchart({
    
    evodep <- naissances[(which(naissances$Departement == input$dep)),]
   
    hc <- highchart() %>% 
      hc_chart(type = "column") %>%
      hc_yAxis(title = list(text = "Pourcentage d'évolution")) %>%
      hc_xAxis(categories = as.list(evodep$Annee)) %>%
      hc_add_series(data = evodep$Evo_naissance,
                    color = "green",
                    negativeColor = "red",
                    name = "% d'évolution")
  })
 
  # map nombre de naissances
  output$mymap = renderLeaflet({
    
    
    naissances2 <- naissances_map[which(naissances_map$Annee == input$choixAnneeMap),]
    france_dept@data <- data.frame(france_dept@data, naissances2[match(france_dept@data[,"nom"], naissances2[,"Departement"]),])
    
    
    leaflet(data=france_dept) %>%
      
      addTiles() %>%
      setView(lng = 1.87528, lat = 46.60611, zoom = 6) %>% 
      addProviderTiles("Thunderforest.SpinalMap") %>%
      
      addPolygons(data = france_dept,stroke = TRUE, color="black", opacity = 3, weight= 1.2, smoothFactor = 1, fillOpacity =1,
                  fillColor = ~pal(france_dept@data$Classe),
                  highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE),
                  label = paste(naissances2$Departement, format(naissances2$Nbre_naissance, big.mark = ","), sep = " : ") )%>%
      addLegend("bottomright", pal = pal, values = france_dept@data$Classe,
                title = "Nombre de Naissances",
                opacity = 1)
  })
  
  datasetInput <- reactive({
    switch(input$dataset,
           "France" = naissances_total,
           "Departements" = naissancesChr)
  })
  
  output$table <- renderTable({
    datasetInput()
  })
  
  # download data
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$dataset, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(datasetInput(), file, row.names = FALSE)
    }
  )
  
  
  
}





# Tables qui apparaissent dans l'onglet Data
# output$data1 = 
#   renderDataTable(naissances[which(naissances$Annee >= input$choixAnnee[1] & naissances$Annee <= input$choixAnnee[2]),])
# 
# output$data2 = 
#   renderDataTable(naissances_total[which(naissances_total$Annee >= input$choixAnnee[1] & naissances_total$Annee <= input$choixAnnee[2]),])
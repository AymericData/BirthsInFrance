# Header ------------------------------------------------------------------------------------------------

header = dashboardHeader(title = "Naissances", dropdownMenuOutput("messageMenu"),titleWidth = 350)

 
# Sidebar -----------------------------------------------------------------------------------------------

sidebar = dashboardSidebar(
  sidebarMenu(id = "tabs",
    menuItem("Dashboard", 
             tabName = "dashboard",  
             icon = icon("dashboard")),
    
    menuItem("Carte", 
             tabName = "carte",  
             icon = icon("globe")),
             
    menuItem("Data", 
             tabName = "data",  
             icon = icon("database"))
    ),
  conditionalPanel(
    condition = "input.tabs == 'dashboard'",
    radioButtons("carte", label = h3("Afficher :"),
                 choices = list("France" = 1, "Departement" = 2), 
                 selected = 1),
    conditionalPanel(
      condition = "input.carte == '2'",
      selectizeInput(inputId = "dep", label = h3("Departements :"), 
                     choices = unique(naissances$Departement), selected = "Ain")
   )
  )
)
  

# Body -------------------------------------------------------------------------------------------------

body <- dashboardBody(
  tabItems(
    
    # dashboard
    tabItem("dashboard",
      fluidRow(
        
        # Les infosBox dans une colonne de 4
        column(4,
          infoBoxOutput("box_title", width = 12),
          
          conditionalPanel(condition = "input.carte == '1'",valueBoxOutput("Box1", width = 12)),
          conditionalPanel(condition = "input.carte == '1'",valueBoxOutput("Box3", width = 12)),
          conditionalPanel(condition = "input.carte == '2'",valueBoxOutput("Box2", width = 12)),
          conditionalPanel(condition = "input.carte == '2'",valueBoxOutput("Box4", width = 12)),
          conditionalPanel(condition = "input.carte == '1'",valueBoxOutput("Box5", width = 12)),
          conditionalPanel(condition = "input.carte == '2'",valueBoxOutput("Box6", width = 12))
          ),
    
        # Le graphique Highcharter dans une colonne de 8 
         box(title = "Nombre de naissances entre 2003 et 2014", status = "primary", width = 8,
             conditionalPanel(condition = "input.carte == '1'",
                                highchartOutput("plotFrance", width = "100%", height = "380")),
             conditionalPanel(condition = "input.carte == '2'",
                                highchartOutput("plotDepartement", width = "100%", height = "380")))
        ),
      
      # Top et Flop des départements
      fluidRow(
        box(title = "Top et Flop des départements", solidHeader = TRUE, status = "primary", height = 560,
            column(6,
                   radioButtons("radio2", label = h4("Voir les :"), choices = list("Top" = 1, "Flop" = 2),  
                                selected = 1, inline = TRUE)
            ),
            column(6,
                   sliderInput(inputId = "slider1", label = h4("Choix de l'année"), min = min(naissances$Annee), 
                               max = max(naissances$Annee), value = 2003, step = 1)
            ),
            conditionalPanel(condition = "input.radio2 == '1'",
                             highchartOutput("BarChart", height = "380")),
            conditionalPanel(condition = "input.radio2 == '2'",
                             highchartOutput("BarChart2", height = "380"))
        ),
        
        box(title = "Evolution du nombre de naissances", solidHeader = TRUE, status = "primary", height = 560, width = 6,
            conditionalPanel(condition = "input.carte == '1'",
                             highchartOutput("NegativChart", width = "100%", height = "500")),
            conditionalPanel(condition = "input.carte == '2'",
                             highchartOutput("NegativChart2", width = "100%", height = "500"))
        )
      )
      ),
        
    # map nombre de naissances
    tabItem(
            tabName = "carte",
            
            # Map + widget choix année 
            fluidRow(
              box(status = "primary", width = 12,
                  sliderInput(inputId = "choixAnneeMap", label = h4("Choix de l'année"), min = 2003, 
                              max = 2014, value = 2003, step = 1)),
              box(status = "primary", width = 12,
                  leafletOutput("mymap", height = 740))
            )
            ),
    
    
    
    #Troisième Page
    tabItem(
      tabName = "data",
      
      # L'onglet Data
      fluidRow(
        box(status = "primary", width = 12,
            selectInput("dataset", h4("Choix de la vue"), 
                        choices = c("France", "Departements")),
            downloadButton("downloadData", "Download"),
            tags$head(tags$style(".butt{background-color:#2E2E2E;} .butt{color: white;}"))),

        box(status = "primary", width = 12, title = "Tableau de données",
            tableOutput('table')
        )
        
      )
    )
  )
)




      
  

  




# Page -----------------------------------------------------------------------------------------------

dashboardPage(header = header, sidebar = sidebar, body = body, skin = "blue")
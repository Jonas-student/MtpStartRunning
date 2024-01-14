library(shiny)
library(shinydashboard)
library(toastui)

################################################################################
#----------------------------Create the dashboard page-------------------------#


ui <- dashboardPage(
  
    dashboardHeader(title = "Coach A pied"),
    skin="purple",
    #---------------------------------------------------------------------------
    
    dashboardSidebar(
      sidebarMenu(id = "sidebar",
        menuItem("Prédiction par 6min-VMA", tabName = "dashboard", icon = icon("flag-checkered")),
        menuItem("Calcule de charge", tabName = "hybride",icon=icon("calculator")),
        menuItem("S'entrainer ensemble", tabName = "ensemble",icon=icon("people-pulling")),
        menuItem("Cahier d'entrainement",tabName="cahier",icon=icon("calendar-days")),
        menuItem("Courbe de gestion compétition",tabName="gestion",icon=icon("stopwatch-20")),
        menuItem("Calculette",tabName="calc",icon=icon("calculator"))
    )
    ),
    #---------------------------------------------------------------------------
    
    dashboardBody(
    tabItems(
      
      tabItem(tabName = "dashboard",
              
              fluidPage(
                
                titlePanel("Prédiction de course"),
                h4("Comment estimer son chrono sur 5km, 10km, semi-marathon ou marathon ? Entrez votre sexe."),
                fluidRow(
                  column(3,
                         selectInput("gender:", label = "Sexe:",
                                     choices = c("M","F"))
                  )
                  ),
                
                  box(title="Prédiction basé sur un VMA-test (de 6 minute)",status="warning",solidHeader = TRUE,collapsible = TRUE,
                    h4("Choisissez la distance pour laquelle vous voulez faire une prédiction et entreze votre VMA de 6min."),
                    fluidRow(
                      column(4,
                             selectInput("VMA", label = "VMA:",
                                         choices = seq(10,24,0.5))
                      ),
                      column(4,
                             selectInput("distance:", label = "Distance pour la prediction (m):",
                                         choices = c(800,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400,2500,3000,5000,10000,15000,20000,42195/2,42195))
                      )),
                    h4("Vous trouverez ci-dessous une prédiction de votre allure et de votre temps."),
                  fluidRow(
                    column(3,
                    strong("Allure estimé (km/h):"),
                    verbatimTextOutput(outputId = "result1")
                    ),
                    column(6,
                    strong("Allure estimé interval de confiance (km/h):"),
                    verbatimTextOutput(outputId = "result1a")
                    )
                  ),
                  fluidRow(
                    column(3,
                    strong("Allure estimé (min/km):"),
                    verbatimTextOutput(outputId = "result1b")
                    ),
                    column(6,
                    strong("Allure estimé interval de confiance (min/km):"),
                    verbatimTextOutput(outputId = "result1c")
                    ),
                  ),
                  fluidRow(
                    column(3,
                    strong("Temps estimé:"),
                    verbatimTextOutput(outputId = "result2")
                    ),
                    column(6,
                    strong("Temps estimé interval de confiance:"),
                    verbatimTextOutput(outputId = "result2a")
                    )
                  )),
                
                box(title="Prédiction basé sur un course précédente",status="warning",solidHeader = TRUE,collapsible = TRUE,
                    selectInput("goaldist", label = "Pour quelle distance peut-on faire une prédiction ? (m):",choices = c(800,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400,2500,3000,5000,10000,15000,20000,42195/2,42195)),
                    fluidRow(
                      column(5,
                             selectInput("prevdist", label = "Distance d'une course précédent (m):",choices = c(800,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400,2500,3000,5000,10000,15000,20000,42195/2,42195))
                      ),
                      column(5,
                             numericInput("prevtime", label = "Temps d'une course précédente (min):",value = 24)
                      )
                    ),
                    mainPanel(
                      h4("Temps de course estimé par la formule de Peter Riegel. (1981) (min):"),
                      verbatimTextOutput(outputId = "result4")
                    ),
                    mainPanel(
                      h4("VMA estimé par Coach à pied"),
                      verbatimTextOutput(outputId = "result4a")
                    ),
                    
                    mainPanel(
                      h4("Temps de course estimé par Coach à pied. (min):"),
                      verbatimTextOutput(outputId = "result4b")
                    )
                ),
                
                  fluidRow(
                    
                    column(12,
                           h4(' Il est à nouveau basé sur le sexe/VMA précédemment entré. L\'axe horizontal indique la distance et l\'axe vertical la vitesse en km par heure.  Cliquez exactement sur la ligne du graphique ci-dessus et voyez la distance/allure en dessous. Notez que ce calcul n\'est pas aussi précis que  le calcul ci-dessus.'),
                           verbatimTextOutput("info")
                    ),
                    column(12,  
                    plotOutput("plot", click = "plot_click",width = 1500,height=700)
                    ))
                  )
      ),
      
      #-------------------------------------------------------------------------
      tabItem(tabName = "cahier",
              fluidPage(
              titlePanel("Cahier d'entrainement"),
              fluidRow(
                column(3,
                       selectInput("gendercahier:", label = "Sexe:",
                                   choices = c("M","F"))
                ),
                column(3,
                       selectInput("VMAcahier", label = "VMA test de 6 minutes (km/h):",
                                   choices = seq(10,24,0.5))
                )),
              fluidRow(
                h4("Quelles jours vous entrainez-vous?"),
                column(1,
                       checkboxInput("Lundi", "Lundi", value = FALSE, width = NULL)),
                column(1,
                       checkboxInput("Mardi", "Mardi", value = FALSE, width = NULL)),
                column(1,
                       checkboxInput("Mercredi", "Mercredi", value = FALSE, width = NULL)),
                column(1,
                       checkboxInput("Jeudi", "Jeudi", value = FALSE, width = NULL)),
                column(1,
                       checkboxInput("Vendredi", "Vendredi", value = FALSE, width = NULL)),
                column(1,
                       checkboxInput("Samedi", "Samedi", value = FALSE, width = NULL)),
                column(1,
                       checkboxInput("Dimanche", "Dimanche", value = FALSE, width = NULL))
              ),
              fluidRow(
                h4("Quelles jours faites vous vos fractionné?"),
                column(1,
                       checkboxInput("Lundi_frac", "Lundi", value = FALSE, width = NULL)),
                column(1,
                       checkboxInput("Mardi_frac", "Mardi", value = FALSE, width = NULL)),
                column(1,
                       checkboxInput("Mercredi_frac", "Mercredi", value = FALSE, width = NULL)),
                column(1,
                       checkboxInput("Jeudi_frac", "Jeudi", value = FALSE, width = NULL)),
                column(1,
                       checkboxInput("Vendred_frac", "Vendredi", value = FALSE, width = NULL)),
                column(1,
                       checkboxInput("Samedi_frac", "Samedi", value = FALSE, width = NULL)),
                column(1,
                       checkboxInput("Dimanche_frac", "Dimanche", value = FALSE, width = NULL))
              ),
              
              
                dataTableOutput('result5a'),
              
      )),
      #-------------------------------------------------------------------------
      tabItem(tabName = "ensemble",
              fluidPage(
                titlePanel("S'entrainer ensemble"),
                h4("Ce parti donne tout les combination possible sur une piste de 400m pour s'entrainer ensemble.
                   L'idée c'est de partir enseble (meme allure)! Le deuxième coureur se reposera plus vite, 
                   mais de manière a ce que (lorsque la récupération du premier coureur est terminée) 
                   ils sortent ensemble après le meme temps et au méme endroit sur la piste. 
                   On peut recommencer ensemble la répétition suivante! "),
                fluidRow(
                  column(3,
                         numericInput("all1", label ="Allure répétition ensemble:",value = 15)
                  ),
                  
                  column(3,
                         numericInput("allrecup1", label ="Allure de récup coureur 1:",value=11)
                  ),
                  column(4,
                         numericInput("allrecup2", label = "Allure de récup coureur 2 (moins de coureur 1):",value=10)
                  )
                
              )),
              dataTableOutput('result6')
      ),
      
      #-------------------------------------------------------------------------
      tabItem(tabName = "hybride",
              fluidPage(
                        titlePanel("Calcule de charge Séance classique/hybride"),
                        h4("Entrez votre sexe et votre VMA d'un test de 6 minutes."),
                        fluidRow(
                          column(4,
                                 selectInput("genderhyb", label = "Sexe:",
                                             choices = c("M","F"))
                          ),
                          
                          column(4,
                                 selectInput("VMAhyb", label = "VMA d'un test de 6 minutes (km/h):",
                                             choices = seq(10,24,0.5))
                          )
                        ),
                        
                        box(title="Block 1", status = "warning",solidHeader = TRUE,width = 10,
                            h4("Pour une séance d'entraînement classique (exemple 6*1000m récup 200m), utilisez seulement le premier bloc ci-desous."),
                            fluidRow( 
                              column(4,
                                     selectInput("distance1", label = "Allure pour quel racedistance (m):",
                                                 choices = c(800,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400,2500,3000,5000,10000,15000,20000,42195/2,42195))
                              ),
                              h4("Allure pour ce distance:"),
                              column(4,verbatimTextOutput(outputId = "result31")
                              )
                            ),
                            fluidRow(
                              column(3,
                                     selectInput("nrep1", label = "Nombre de répétitions:",
                                                 choices = seq(0,40,1))
                              ),
                              column(3,
                                     selectInput("distrep1", label = "Distance de répétitions (m):",
                                                 choices = c(100,200,300,400,500,600,700,800,900,1000,1200,1500,2000,3000,5000,10000,15000))
                              ),
                              column(3,
                                     selectInput("distrec1", label = "Distance of récuperations (m):",
                                                 choices = c(0,100,200,400))
                              ),
                              column(3,
                                     selectInput("vmarecup1", label = "Percentage de VMA pour le récup:",
                                                 choices = seq(0.6,0.8,0.01))
                              )
                            )
                            )
                        ,
              
                    fluidRow(
                          column(4,
                                 selectInput("distentre12", label = "Récuperation entre les blocks (m):",
                                             choices = seq(0,5000,100))
                          ),
                          column(4,
                                 selectInput("VMAentre12", label = "Percentage de VMA:",
                                             choices = seq(0.6,0.8,0.01))
                          )),
                                
              box(title="Block 2", status="warning",solidHeader = TRUE,width = 10,
                  h4("Pour une séance d'entraînement hybride (exemple 6*1000m-R=200m + 6*400m-R=200m), ajouté 6*400m-R=200m à ce bloc ci-desous. Maintient la première partie ci-dessus."),
                  fluidRow( 
                    column(4,
                           selectInput("distance2", label = "Allure pour quel racedistance (m):",
                                       choices = c(800,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400,2500,3000,5000,10000,15000,20000,42195/2,42195))
                    )
                  ),
                  fluidRow(
                    column(3,
                           selectInput("nrep2", label = "Nombre de répétitions:",
                                       choices = seq(0,40,1))
                    ),
                    column(3,
                           selectInput("distrep2", label = "Distance de répétitions (m):",
                                       choices = c(100,200,300,400,500,600,700,800,900,1000,1200,1500,2000,3000,5000,10000,15000))
                    ),
                    column(3,
                           selectInput("distrec2", label = "Distance de récuperations (m):",
                                       choices = c(0,100,200,400))
                    ),
                    column(3,
                           selectInput("vmarecup2", label = "Percentage de VMA pour le récup:",
                                       choices = seq(0.6,0.8,0.01))
                    )
                  )
                  )          
              ,
              
              fluidRow(
                column(4,
                       selectInput("distentre23", label = "Récupération entre les blocks (m):",
                                   choices = seq(0,5000,100))
                ),
                column(4,
                       selectInput("VMAentre23", label = "Percentage de VMA:",
                                   choices = seq(0.6,0.8,0.01))
                )),
              
              box(title="Block 3", status="warning",solidHeader = TRUE,width = 10,
                  h4("Pour une séance d'entraînement hybride (exemple 6*1000m-R=200m + 6*400m-R=200m + 6*200m-R=200m), ajouté 6*200m-R=200m à ce bloc ci-desous. Maintient la première/deuxième partie ci-dessus."),
                  fluidRow( 
                    column(3,
                           selectInput("distance3", label = "Allure pour quel racedistance (m):",
                                       choices = c(800,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400,2500,3000,5000,10000,15000,20000,42195/2,42195))
                    )
                  ),
                  fluidRow(
                    column(3,
                           selectInput("nrep3", label = "Nombre de répétitions:",
                                       choices = seq(0,40,1))
                    ),
                    column(3,
                           selectInput("distrep3", label = "Distance de répétitions (m):",
                                       choices = c(100,200,300,400,500,600,700,800,900,1000,1200,1500,2000,3000,5000,10000,15000))
                    ),
                    column(3,
                           selectInput("distrec3", label = "Distance de récupérations (m):",
                                       choices = c(0,100,200,400))
                    ),
                    column(3,
                           selectInput("vmarecup2", label = "Percentage de VMA pour le récup:",
                                       choices = seq(0.6,0.8,0.01))
                    )
                  )
                  )
              ,
                        h4(""),
                        mainPanel(
                          strong("Coefficient CaP:"),
                          verbatimTextOutput(outputId = "result3a")
                        ),
                )    
        
      ),
      #-------------------------------------------------------------------------
      tabItem(tabName = "gestion",
              fluidPage(
                box(title="Courbe de gestion compétition",solidHeader = TRUE, status="warning",width = 10,
                    fluidRow(
                    column(3,
                           selectInput("gestion_VMA", label = "VMA:",
                                       choices = seq(10,24,0.5)
                    )),
                    column(3,
                           selectInput("gestion_gender:", label = "Sexe:",
                                       choices = c("M","F"))),
                    column(4,
                           selectInput("gestion_dist:", label = "Distance pour la prediction (m):",
                                       choices = c(3000,5000,10000,15000,20000,42195/2,42195))
                    )
                )
                ),
                #
                column(3,
                       dataTableOutput("result8a")
                )
              )
      ),
      #-------------------------------------------------------------------------
      tabItem(tabName = "calc",
              fluidPage(
                titlePanel("Calculette:"),
                box(title="Calculer le temps en fonction de la vitesse et de la distance", status="warning",solidHeader = TRUE,width = 10,
                    column(3,
                           numericInput("calc_allure", label = "Allure (km/h):",
                                       value=12)
                    ),
                    column(3,
                           numericInput("calc_dist", label = "Distance (m):",value =10000 )
                    ),
                    column(3,
                           strong("Temps (s): "),
                           verbatimTextOutput(outputId = "result7a")
                    )
                ),
                box(title="Convertir les km/h (ou un pourcentage de cette allure) en min/km", status="warning",solidHeader = TRUE,width = 10,
                    column(3,
                           numericInput("calc_allure1", label = "Allure (km/h):",
                                        value=12)
                    ),
                    column(3,
                           numericInput("calc_per", label = "Pourcentage de cette allure (%):",
                                        value=100)
                    ),
                    column(3,
                           strong("Allure (min/km): "),
                           verbatimTextOutput(outputId = "result7b")
                    )
                )
                ),
              
      )
      )
    )
)



################################################################################
#-----------------------------Some functions!!!--------------------------------#

  # calculate the time given distance and speed
  temps<-function(allure,dist){
    # input:
    # - speed in km/h
    # - distance in m
    if (allure==0 | dist==0){
      return(0)
    }
    else {
      speed <- (allure * 1000)/3600
      return( dist / speed )
    }
  }

  # define VMA matrix
  VMApredic<-data.frame(rbind(c(3.6,	2.7,	2.3,	2,	1.7,	1.5,	1.3,	1,	0.8,	0.7,	0.5,	0.4,	0.32,	0.24,	0.16,	0.08,	0,	-0.4,	-1,	-1.9,	-2.2,	-2.4,	-2.45,	-3.45),
                              c(3.52,  2.62,  2.22,  1.92,  1.62,  1.42, 1.22,  0.92,  0.72,  0.62,  0.42,  0.32,  0.24,  0.16,  0.08,  0.00, -0.08,	-0.48,	-1.08,	-1.98,	-2.28,	-2.53,	-2.58,	-3.58),
                              c(3.52,  2.62,  2.22,  1.92,  1.62,  1.42, 1.22,  0.92,  0.72,  0.62,  0.42,  0.32,  0.24,  0.16,  0.08,  0.00,	-0.08,	-0.48,	-1.08,	-1.98,	-2.28,	-2.58,	-2.63,	-3.63),
                              c(3.44,  2.54,  2.14,  1.84,  1.54,  1.34,  1.14,  0.84,  0.64,  0.54,  0.34,  0.24,  0.16,  0.08,  0.00,	-0.08,	-0.16,	-0.56,	-1.16,	-2.06,	-2.36,	-2.71,	-2.76,	-3.76),
                              c(3.44,  2.54,  2.14,  1.84,  1.54,  1.34,  1.14,  0.84,  0.64,  0.54,  0.34,  0.24,  0.16,  0.08,  0.00,	-0.08,	-0.16,	-0.56,	-1.16,	-2.06,	-2.41,	-2.76,	-2.81,-3.81),
                              c(3.36,  2.46,  2.06,  1.76,  1.46,  1.26,  1.06,  0.76,  0.56,  0.46,  0.26,  0.16,  0.08,  0.00,	-0.08,	-0.16,	-0.24,	-0.64,	-1.24,	-2.14,	-2.49,-2.84,	-2.89,	-3.89),
                              c(3.36,  2.46,  2.06,  1.76,  1.46,  1.26,  1.06,  0.76,  0.56,  0.46,  0.26,  0.16,  0.08,	0.00, -0.08,	-0.16,	-0.24,	-0.64,	-1.24,	-2.14,	-2.54,	-2.89,	-2.94,	-3.94),
                              c(3.28,  2.38,  1.98,  1.68,  1.38,  1.18,  0.98,  0.68,  0.48,  0.38,  0.18,  0.08,  0.00,	-0.08,	-0.16,	-0.24,	-0.32,	-0.72,	-1.32,	-2.22,	-2.62,	-2.97,	-3.02,	-4.02),
                              c(3.28,  2.38,  1.98,  1.68,  1.38,  1.18,  0.98,  0.68,  0.48,  0.38,  0.18,  0.08,  0.00,	-0.08,	-0.16,	-0.24,	-0.32,	-0.72,	-1.32,	-2.22,	-2.62,	-3.02,	-3.07,	-4.07),
                              c(3.20, 2.30,	1.90,	    1.60,	1.30,	1.10,	0.90,	0.60,	    0.40,	 0.30,	0.10,	0.00,  -0.08,	-0.16,	-0.24,	-0.32,	-0.4,	-0.8,	-1.4,	-2.3,	-2.7,	-3.1,	-3.1,	-4.1),
                              c(3.20, 2.30,	1.90,	    1.60,	1.30,	1.10,	0.90,	0.60,	    0.40,	 0.30,	0.10,	0.00,	-0.08,	-0.16,	-0.24,	-0.32,	-0.4,	-0.8,	-1.4,	-2.3,	-2.75,	-3.2,	-3.25,	-4.25),
                              c(3.1,  2.2,  1.8,  1.5,  1.2,  1.0,  0.8,  0.5,  0.3,  0.2,  0.0,	-0.1,	-0.18,	-0.26,	-0.34,	-0.42,	-0.5,	-0.9,	-1.5,	-2.4,	-2.85,	-3.3,	-3.35,	-4.35),
                              c(3.1,  2.2,  1.8,  1.5,  1.2,  1.0,  0.8,  0.5,  0.3,  0.2,  0.0,	-0.1,	-0.18,	-0.26,	-0.34,	-0.42, -0.5,	-0.9,	-1.5,	-2.4,	-2.85,	-3.3	,-3.35	,-4.35),
                              c(2.9,  2.0,  1.6,  1.3,  1.0,  0.8,  0.6,  0.3,  0.1,  0.0,	-0.2,	-0.3,	-0.38,	-0.46,	-0.54,	-0.62,	-0.7	,-1.1,	-1.7,	-2.6	,-3.05,	-3.5	,-3.55,	-4.55),
                              c(2.9,  2.0,  1.6,  1.3,  1.0,  0.8,  0.6,  0.3,  0.1,  0.0,	-0.2,	-0.3,	-0.38,	-0.46,	-0.54,	-0.62	,-0.7,	-1.1,	-1.7	,-2.6,	-3.05,	-3.5	,-3.55,	-4.55),
                              c(3,	2,	1.6,	1.3,	1,	0.8,	0.5,	0.2, 0,	-0.1,	-0.3,	-0.4,	-0.48	,-0.56,	-0.64,	-0.72,	-0.9,	-1.3,	-1.9,	-2.8,	-3.25,	-3.7	,-3.75,	-4.85),
                              c(3,	2,	1.6,	1.3,	1,	0.8,	0.5,	0.2, 0,	-0.1,	-0.3,	-0.4,	-0.48,	-0.56,	-0.64,	-0.72,	-0.9	,-1.3,	-1.9,	-2.8,	-3.25,	-3.7,	-3.75,	-4.95),
                              c(2.5,  1.5,  1.1,  0.8,  0.5,  0.3,  0.0,	-0.3,	-0.5,	-0.6,	-0.8,	-0.9,	-0.98,	-1.06,	-1.14,	-1.22,	-1.4,	-1.8,	-2.4,	-3.3,	-3.75,	-4.2,	-4.25,	-5.55),
                              c(2.7,  1.6,  1.2,  0.9,  0.6,  0.4,  0.0,	-0.3,	-0.5,	-0.6,	-0.8,	-0.9,	-0.98,	-1.06,	-1.14,	-1.22,	-1.5,	-1.9,	-2.5,	-3.4,	-3.85,	-4.3,	-4.3,	-5.6),
                              c(2.3, 1.2, 0.8, 0.5, 0.2, 0.0,	-0.4,	-0.7,	-0.9,	-1	,-1.2,	-1.3,	-1.38,	-1.46,	-1.54,	-1.62,	-1.9,	-2.3	,-2.9,	-3.8,	-4.25,	-4.7,	-4.75,	-6.15),
                              c(2.3, 1.2, 0.8, 0.5, 0.2, 0.0,	-0.4,	-0.7,	-0.9,	-1,	-1.2,	-1.3,	-1.38,	-1.46,	-1.54,	-1.62,	-1.9,	-2.3,	-2.9,	-3.8,	-4.25,	-4.7,	-4.75,	-6.25),
                              c(2.1,  1.0,  0.6,  0.3,  0.0,	-0.2,	-0.6,	-0.9,	-1.1,	-1.2,	-1.4,	-1.5,	-1.58,	-1.66,	-1.74,	-1.82,	-2.1,	-2.5,	-3.1,	-4,	-4.45,	-4.9,	-4.95,	-6.55),
                              c(2.2,  1.0,  0.6,  0.3,  0.0,	-0.2,	-0.7,	-1,	-1.2,	-1.3,	-1.5,	-1.6,	-1.68,	-1.76,	-1.84,	-1.92,	-2.3,	-2.7,	-3.3,	-4.2,	-4.65,	-5.1,	-5.15,	-6.85),
                              c(1.9,	0.7,	0.3,	0,	-0.3,	-0.5,	-1,	-1.3,	-1.5,	-1.6,	-1.8,	-1.9,	-1.98,	-2.06,	-2.14,	-2.22,	-2.6,	-3,	-3.6,	-4.5,	-4.95,	-5.4,	-5.45,	-7.15),
                              c(1.9,	0.7,	0.3,	0,	-0.3,	-0.5,	-1,	-1.3,	-1.5,	-1.6,	-1.8,	-1.9,	-1.98,	-2.06,	-2.14,	-2.22,	-2.6,	-3,	-3.6,	-4.5,	-4.95,	-5.4,	-5.45,	-7.15),
                              c(1.6,	0.4,	0,	-0.3,	-0.6,	-0.8,	-1.3,	-1.6,	-1.8,	-1.9,	-2.1,	-2.2,	-2.28,	-2.36,	-2.44,	-2.52,	-2.9,	-3.3,	-3.9,	-4.8,	-5.25,	-5.7,	-5.75,	-7.45),
                              c(1.6,	0.4,	0,	-0.3,	-0.6,	-0.8,	-1.3,	-1.6,	-1.8,	-1.9,	-2.1,	-2.2,	-2.28,	-2.36,	-2.44,	-2.52,	-2.9,	-3.3,	-3.9,	-4.8,	-5.25,	-5.7,	-5.75,	-7.45),
                              c(1.3,	0,	-0.4,	-0.7,	-1,	-1.2,	-1.8,	-2.1,	-2.3,	-2.4,	-2.6,	-2.7,	-2.78,	-2.86,	-2.94,	-3.02,	-3.5,	-3.9,	-4.5,	-5.4,	-5.85,	-6.3,	-6.35,	-8.15),
                              c(1.3,	0,	-0.4,	-0.7,	-1,	-1.2,	-1.8,	-2.1,	-2.3,	-2.4,	-2.6,	-2.7,	-2.78,	-2.86,	-2.94,	-3.02,	-3.5,	-3.9,	-4.5,	-5.4,	-5.85,	-6.3,	-6.35,	-8.15)))
  rownames(VMApredic)<-c(24.0, 23.5, 23.0, 22.5, 22.0, 21.5, 21.0, 20.5, 20.0, 19.5, 19.0, 18.5, 18.0, 17.5, 17.0, 16.5, 16.0, 15.5, 15.0, 14.5, 14.0, 13.5, 13.0, 12.5, 12.0, 11.5, 11.0, 10.5, 10.0)
  colnames(VMApredic)<-c(800,	1000,	1100,	1200,	1300,	1400,	1500,	1600,	1700,1800,	1900,	2000,	2100,	2200,	2300,	2400,	2500,	3000,	5000,	10000,	15000,	20000,42195/2	,42195)
  
  # predict race speed
  goaltime<-function(goal, VMA, gender){
    if (gender=="M"){
      index<-data.frame(c(1),c(2),c(3),c(4),c(5),c(6),c(7),c(8),c(9),c(10),c(11),c(12),c(13),c(14),c(15),c(16),c(17),c(18),c(19),c(20),c(21),c(22),c(23),c(24),c(25),c(26),c(27),c(28),c(29))
      colnames(index)=as.vector(seq(24,10,-0.5))
      output<-(as.numeric(VMA) + VMApredic[as.character(goal)][index[,as.character(VMA)],])
      return(output)
    }
    else if (gender=="F"){
      return(1)
    }
    else {return(0)}
  }

  # volume function
  volume<-function(nrep,trep,goal,VMA,gender){
    return(nrep*trep/goaltime(goal,VMA,gender))
  }
  
  # VMA function
  vmamoyen<-function(nrep,distrep,nrec,distrec,goal,VMA,gender,VMArecup,VMAentre,distentre){
    extra<-goaltime(goal,VMA,gender)/VMA
    trep<-temps(goaltime(goal,VMA,gender),distrep)
    trec<-temps(VMArecup*VMA,distrec)
    pre<-temps(VMAentre*VMA,distentre)
    output <- (( pre*(VMAentre/extra)^2+(nrep * trep) )   /temps(goaltime(goal,VMA,gender),goal)) *  ((nrep *trep)+(nrec*(VMArecup/extra)*trec))/((nrep * trep)+(nrec*trec*(1+trec/trep)))
    if (nrep==0  & nrec==0){output<-0}
    return (output)
  }

  # onzekerheid voor voorspellingen
  incertitude<-function(VMA,goaldist){
    help<-VMA*6/60*1000
    if (help<=800){
      if (goaldist<=1500){out<-0.005}
      else if (goaldist>1500 && goaldist<=2000){out<-0.01}
      else if (goaldist>2000 && goaldist<=3000){out<-0.015}
      else {out<-0.02}
    }
    else if (help>800 && help<=1000){
      if (goaldist<=1800){out<-0.005}
      else if (goaldist>1800 && goaldist<=2000){out<-0.01}
      else if (goaldist>2000 && goaldist<=5000){out<-0.015}
      else {out<-0.02}
    }
    else if (help>1000 && help<=1500){
      if (goaldist<=2000){out<-0.005}
      else if (goaldist>2000 && goaldist<=5000){out<-0.01}
      else if (goaldist>5000 && goaldist<=10000){out<-0.015}
      else {out<-0.02}
    }
    else if (help>1500 && help<=1800){
      if (goaldist<=2000){out<-0.005}
      else if (goaldist>2000 && goaldist<=5000){out<-0.01}
      else if (goaldist>5000 && goaldist<=15000){out<-0.015}
      else {out<-0.02}
    }
    else if (help>1800 && help<=2500){
      if (goaldist<=3000){out<-0.005}
      else if (goaldist>3000 && goaldist<=5000){out<-0.01}
      else if (goaldist>5000 && goaldist<=15000){out<-0.015}
      else {out<-0.02}
    }
    return(out)
  }
  
  # Function to generate interval combinations
  generate_interval_combinations <- function(all1,allrecup1,allrecup2){
    option<-c()
    for(i1 in seq(200,3000,100)){
      for(i2 in seq(100,i1,100)){
        if(i1!=i2){
          for(recup1 in seq(100,i1,100)){
            recup2<-i1+recup1-i2
            
            for(j in 1:floor(recup2/400)){
              A<-temps(all1,i1)+temps(allrecup1,recup1)
              B<-temps(all1,i2)+temps(allrecup2,recup2-j*400)
              
              if(A>=B-3 & A<=B+3 & B>=A-3 & B<=A+3){
                option<-rbind(option,c(round(abs(A-B)),i1,recup1,i2,recup2-j*400))
              }
            }
          }
        }
      }
    }
    out<-as.data.frame(option)
    names(out)<-c("Différence (s)","Distance répétition coureur 1 (m)","Distance récup coureur 1 (m)","Distance répétition coureur 2 (m)","Distance récup coureur 2 (m)")
    
    return(out)
  }
  

################################################################################
#----------------------Server, output functions!-------------------------------#
  
server<-function(input, output){  
  #-----------------------------------------------------------------------------
  result1<-reactive({
    if (input$gender=="M"){
      index<-data.frame(c(1),c(2),c(3),c(4),c(5),c(6),c(7),c(8),c(9),c(10),c(11),c(12),c(13),c(14),c(15),c(16),c(17),c(18),c(19),c(20),c(21),c(22),c(23),c(24),c(25),c(26),c(27),c(28),c(29))
      colnames(index)=as.vector(seq(24,10,-0.5))
      output<-(as.numeric(input$VMA) + VMApredic[as.character(input$distance)][index[,as.character(input$VMA)],])
      return(output)
    }
    else if (input$gender=="F"){
      
    }
    })
  #-----------------------------------------------------------------------------
  result1a<-reactive({
    output<-c(result1()*(1-incertitude(as.numeric(input$VMA),as.numeric(input$distance))),result1()*(1+incertitude(as.numeric(input$VMA),as.numeric(input$distance))))
    return(output)
  })
  #-----------------------------------------------------------------------------
  result1b<-reactive({
    # Calculate the hours, minutes, and remaining seconds
    seconds<-3600/result1()
    hours <- seconds %/% 3600
    minutes <- (seconds %% 3600) %/% 60
    remaining_seconds <- seconds %% 60
    
    # Format the time string
    time_string <- sprintf("%02d:%02d:%02d", as.integer(hours), as.integer(minutes), as.integer(remaining_seconds))
    return(time_string)
  })
  #-----------------------------------------------------------------------------
  result1c<-reactive({
    # Calculate the hours, minutes, and remaining seconds
    seconds<-3600/result1a()
    hours <- seconds %/% 3600
    minutes <- (seconds %% 3600) %/% 60
    remaining_seconds <- seconds %% 60
    
    # Format the time string
    time_string <- sprintf("%02d:%02d:%02d", as.integer(hours), as.integer(minutes), as.integer(remaining_seconds))
    return(time_string)
  })
  
    #---------------------------------------------------------------------------
    result2<-reactive({
      seconds <- temps(result1(),as.numeric(input$distance))  # example number of seconds
      
      # Calculate the hours, minutes, and remaining seconds
      hours <- seconds %/% 3600
      minutes <- (seconds %% 3600) %/% 60
      remaining_seconds <- seconds %% 60
      
      # Format the time string
      time_string <- sprintf("%02d:%02d:%02d", as.integer(hours), as.integer(minutes), as.integer(remaining_seconds))
      return(time_string)
    })
    #---------------------------------------------------------------------------
  result2a<-reactive({
    secondsl <- temps(result1(),as.numeric(input$distance)) * (1-incertitude(as.numeric(input$VMA),as.numeric(input$distance)))
    secondsr <- temps(result1(),as.numeric(input$distance)) * (1+incertitude(as.numeric(input$VMA),as.numeric(input$distance))) 
    
    # Calculate the hours, minutes, and remaining seconds
    hours <- secondsl %/% 3600
    minutes <- (secondsl %% 3600) %/% 60
    remaining_seconds <- secondsl %% 60
    
    # Format the time string
    time_string1 <- sprintf("%02d:%02d:%02d", as.integer(hours), as.integer(minutes), as.integer(remaining_seconds))
    
    # Calculate the hours, minutes, and remaining seconds
    hours <- secondsr %/% 3600
    minutes <- (secondsr %% 3600) %/% 60
    remaining_seconds <- secondsr %% 60
    
    # Format the time string
    time_string2 <- sprintf("%02d:%02d:%02d", as.integer(hours), as.integer(minutes), as.integer(remaining_seconds))
    return(c(time_string1,time_string2))
  })
    #---------------------------------------------------------------------------
    result3<-reactive({
      
      x<-vmamoyen(as.numeric(input$nrep),as.numeric(input$distrep),as.numeric(input$nrec),as.numeric(input$distrec),as.numeric(input$distance),
                  as.numeric(input$VMA),input$gender)
      return( x )
    })
    #---------------------------------------------------------------------------  
    result3a<-reactive({
      x1<-vmamoyen(as.numeric(input$nrep1),as.numeric(input$distrep1),if(as.numeric(input$nrep1)-1<0){ 0} else (as.numeric(input$nrep1)-1)
                   ,as.numeric(input$distrec1),as.numeric(input$distance1),
                  as.numeric(input$VMAhyb),input$genderhyb,as.numeric(input$vmarecup1),
                  0,0)
      
      x2<-vmamoyen(as.numeric(input$nrep2),as.numeric(input$distrep2),if(as.numeric(input$nrep2)-1<0){ 0} else (as.numeric(input$nrep1)-1)
                   ,as.numeric(input$distrec2),as.numeric(input$distance2),
                   as.numeric(input$VMAhyb),input$genderhyb,as.numeric(input$vmarecup1),
                   as.numeric(input$VMAentre12),as.numeric(input$distentre12))
      
      x3<-vmamoyen(as.numeric(input$nrep3),as.numeric(input$distrep3),if(as.numeric(input$nrep3)-1<0){ 0} else (as.numeric(input$nrep1)-1)
                   ,as.numeric(input$distrec3),as.numeric(input$distance3),
                   as.numeric(input$VMAhyb),input$genderhyb,as.numeric(input$vmarecup1),
                   as.numeric(input$VMAentre23),as.numeric(input$distentre23))
      
      return(x1+x2+x3)
    })
    #---------------------------------------------------------------------------
    
    result4<-reactive({
      seconds<-as.numeric(input$prevtime)*(as.numeric(input$goaldist)/as.numeric(input$prevdist))^1.06*60
      
      # Calculate the hours, minutes, and remaining seconds
      hours <- seconds %/% 3600
      minutes <- (seconds %% 3600) %/% 60
      remaining_seconds <- seconds %% 60
      
      # Format the time string
      time_string <- sprintf("%02d:%02d:%02d", as.integer(hours), as.integer(minutes), as.integer(remaining_seconds))
      return(time_string)
    })
  #---------------------------------------------------------------------------
  
  result4a<-reactive({
    
    vma<-seq(24,10,-0.5)
    diff<-c()
    for (i in vma){
      
      if (input$gender=="M"){
        index<-data.frame(c(1),c(2),c(3),c(4),c(5),c(6),c(7),c(8),c(9),c(10),c(11),c(12),c(13),c(14),c(15),c(16),c(17),c(18),c(19),c(20),c(21),c(22),c(23),c(24),c(25),c(26),c(27),c(28),c(29))
        colnames(index)=as.vector(seq(24,10,-0.5))
        output<-(as.numeric(i) + VMApredic[as.character(input$prevdist)][index[,as.character(i)],])
      }
      else if (input$gender=="F"){
        
      }
      diff<-c(diff,abs(as.numeric(input$prevtime)*60-temps(output,as.numeric(input$prevdist))))
      
    }
    a<-which.min(diff)
    VMA<-vma[which.min(diff)]
    return(VMA)
    
})
  #-----------------------------------------------------------------------------
  result4b<-reactive({
    VMA<-result4a()
    if (input$gender=="M"){
      index<-data.frame(c(1),c(2),c(3),c(4),c(5),c(6),c(7),c(8),c(9),c(10),c(11),c(12),c(13),c(14),c(15),c(16),c(17),c(18),c(19),c(20),c(21),c(22),c(23),c(24),c(25),c(26),c(27),c(28),c(29))
      colnames(index)=as.vector(seq(24,10,-0.5))
      output<-(as.numeric(VMA) + VMApredic[as.character(input$goaldist)][index[,as.character(VMA)],])
    }
    else if (input$gender=="F"){
      
    }
    
    seconds<-temps(output,as.numeric(input$goaldist))
    # Calculate the hours, minutes, and remaining seconds
    hours <- seconds %/% 3600
    minutes <- (seconds %% 3600) %/% 60
    remaining_seconds <- seconds %% 60
    
    # Format the time string
    time_string <- sprintf("%02d:%02d:%02d", as.integer(hours), as.integer(minutes), as.integer(remaining_seconds))
    return(time_string)
  })
    
    #---------------------------------------------------------------------------
  result31<-reactive({
    if (input$genderhyb=="M"){
      index<-data.frame(c(1),c(2),c(3),c(4),c(5),c(6),c(7),c(8),c(9),c(10),c(11),c(12),c(13),c(14),c(15),c(16),c(17),c(18),c(19),c(20),c(21),c(22),c(23),c(24),c(25),c(26),c(27),c(28),c(29))
      colnames(index)=as.vector(seq(24,10,-0.5))
      output<-(as.numeric(input$VMAhyb) + VMApredic[as.character(input$distance1)][index[,as.character(input$VMAhyb)],])

    }
    else if (input$genderhyb=="F"){
      
    }
    seconds<-3600/output
    hours <- seconds %/% 3600
    minutes <- (seconds %% 3600) %/% 60
    remaining_seconds <- seconds %% 60
    
    # Format the time string
    time_string <- sprintf("%02d:%02d:%02d", as.integer(hours), as.integer(minutes), as.integer(remaining_seconds))
    return(time_string)
  })
  
  #-----------------------------------------------------------------------------
  result5a<-reactive({
    #entrain<- read.csv2("~/Montpellier StaRt Running/Semaines.csv")
    entrain<- read.csv2("Semaines.csv")
    colnames(entrain)<-c("VMA","Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi","Dimanche")
    
    VMA<-iconv(entrain$VMA, from = "UTF-8", to = "latin1")
    Lundi<-iconv(entrain$Lundi, from = "UTF-8", to = "latin1")
    Mardi<-iconv(entrain$Mardi, from = "UTF-8", to = "latin1")
    Mercredi<-iconv(entrain$Mercredi, from = "UTF-8", to = "latin1")
    Jeudi<-iconv(entrain$Jeudi, from = "UTF-8", to = "latin1")
    Vendredi<-iconv(entrain$Vendredi, from = "UTF-8", to = "latin1")
    Samedi<-iconv(entrain$Samedi, from = "UTF-8", to = "latin1")
    Dimanche<-iconv(entrain$Dimanche, from = "UTF-8", to = "latin1")
    
    entrain<-data.frame(VMA,Lundi,Mardi,Mercredi,Jeudi,Vendredi,Samedi,Dimanche)
      
      if (input$Lundi==TRUE){
        entrain<-entrain[which(entrain$Lundi != 'x'),]
      }
      if (input$Mardi==TRUE){
        entrain<-entrain[which(entrain$Mardi != 'x'),]
      }
      if (input$Mercredi==TRUE){
        entrain<-entrain[which(entrain$Mercredi != 'x'),]
      }
      if (input$Jeudi==TRUE){
        entrain<-entrain[which(entrain$Jeudi != 'x'),]
      }
      if (input$Vendredi==TRUE){
        entrain<-entrain[which(entrain$Vendredi != 'x'),]
      }
      if (input$Samedi==TRUE){
        entrain<-entrain[which(entrain$Samedi != 'x'),]
      }
      if (input$Dimanche==TRUE){
        entrain<-entrain[which(entrain$Dimanche != 'x'),]
      }
      if (input$Lundi==FALSE){
        entrain<-entrain[which(entrain$Lundi == 'x'),]
      }
      if (input$Mardi==FALSE){
        entrain<-entrain[which(entrain$Mardi == 'x'),]
      }
      if (input$Mercredi==FALSE){
        entrain<-entrain[which(entrain$Mercredi == 'x'),]
      }
      if (input$Jeudi==FALSE){
        entrain<-entrain[which(entrain$Jeudi == 'x'),]
      }
      if (input$Vendredi==FALSE){
        entrain<-entrain[which(entrain$Vendredi == 'x'),]
      }
      if (input$Samedi==FALSE){
        entrain<-entrain[which(entrain$Samedi == 'x'),]
      }
      if (input$Dimanche==FALSE){
        entrain<-entrain[which(entrain$Dimanche == 'x'),]
      }
    
      # filter franctionn
      #if (input$Lundi_frac==TRUE){
      #  entrain<-entrain[which(entrain$Lundi == 'Fractionné'),]
      #}
      #if (input$Mardi_frac==TRUE){
      #  entrain<-entrain[which(entrain$Mardi == 'Fractionné'),]
      #}
      #if (input$Mercredi_frac==TRUE){
      #  entrain<-entrain[which(entrain$Mercredi == 'Fractionné'),]
      #}
      #if (input$Jeudi_frac==TRUE){
      #  entrain<-entrain[which(entrain$Jeudi == 'Fractionné'),]
      #}
      #if (input$Vendredi_frac==TRUE){
      #  entrain<-entrain[which(entrain$Vendredi == 'Fractionné'),]
      #}
      #if (input$Samedi_frac==TRUE){
      #  entrain<-entrain[which(entrain$Samedi == 'Fractionné'),]
      #}
      #if (input$Dimanche_frac==TRUE){
      #  entrain<-entrain[which(entrain$Dimanche == 'Fractionné'),]
      #}
    
      return(entrain) 
  })
  
  result6<-reactive({
    return(generate_interval_combinations(input$all1,input$allrecup1,input$allrecup2))
  })
  
  result7a <- reactive({
    s<-temps(input$calc_allure,input$calc_dist)
    
    # Calculate the hours, minutes, and remaining seconds
    hours <- s %/% 3600
    minutes <- (s %% 3600) %/% 60
    remaining_seconds <- s %% 60
    
    # Format the time string
    time_string1 <- sprintf("%02d:%02d:%02d", as.integer(hours), as.integer(minutes), as.integer(remaining_seconds))
    
    return(time_string1)
  })
  
  result7b <- reactive({
    
    s<-3600/(input$calc_allure1/100*input$calc_per)
    
    # Calculate the hours, minutes, and remaining seconds
    hours <- s %/% 3600
    minutes <- (s %% 3600) %/% 60
    remaining_seconds <- s %% 60
    
    # Format the time string
    time_string1 <- sprintf("%02d:%02d:%02d", as.integer(hours), as.integer(minutes), as.integer(remaining_seconds))
    
    return(time_string1)
  })
  
  result8a <- reactive({
    # calculate speed for the racedistance
    if (input$gestion_gender=="M"){
      index<-data.frame(c(1),c(2),c(3),c(4),c(5),c(6),c(7),c(8),c(9),c(10),c(11),c(12),c(13),c(14),c(15),c(16),c(17),c(18),c(19),c(20),c(21),c(22),c(23),c(24),c(25),c(26),c(27),c(28),c(29))
      colnames(index)=as.vector(seq(24,10,-0.5))
      output<-(as.numeric(input$gestion_VMA) + VMApredic[as.character(input$gestion_dist)][index[,as.character(input$gestion_VMA)],])
    }
    else if (input$gestion_gender=="F"){
      
    }
    
    # 
    secondsl <- 3600/output * (1-incertitude(as.numeric(input$gestion_VMA),as.numeric(input$gestion_dist)))
    secondsr <- 3600/output * (1+incertitude(as.numeric(input$gestion_VMA),as.numeric(input$gestion_dist))) 
    
    # divide now over the distance
    gestion<-vector(length=ceiling(as.numeric(input$gestion_dist)/1000))
    diff<-(secondsr-secondsl)/( ceiling(as.numeric(input$gestion_dist)/1000)-1 )
    
    for(j in 1:( ceiling(as.numeric(input$gestion_dist)/1000)-1 )){
      s<-secondsr-diff*j
      
      # Calculate the hours, minutes, and remaining seconds
      hours <- s %/% 3600
      minutes <- (s %% 3600) %/% 60
      remaining_seconds <- s %% 60
      
      # Format the time string
      time_string1 <- sprintf("%02d:%02d:%02d", as.integer(hours), as.integer(minutes), as.integer(remaining_seconds))
      
      gestion[j+1]<-time_string1
    }
    
    # Calculate the hours, minutes, and remaining seconds
    hours <- secondsr %/% 3600
    minutes <- (secondsr %% 3600) %/% 60
    remaining_seconds <- secondsr %% 60
    
    # Format the time string
    gestion[1] <- sprintf("%02d:%02d:%02d", as.integer(hours), as.integer(minutes), as.integer(remaining_seconds))
    
    df<-as.data.frame(t(gestion))
    colnames(df)<-seq(1,ceiling(as.numeric(input$gestion_dist)/1000),1)
    
    return(df)
    
  })

  
################################################################################    
#-------------------------------Render Outpout---------------------------------#
  
    output$result1 <- renderPrint({
      result1()
    })
    output$result1a <- renderPrint({
      result1a()
    })
    output$result1b <- renderPrint({
      result1b()
    })
    output$result1c <- renderPrint({
      result1c()
    })
    
    output$plot <- renderPlot({
      allure<-c()
      afstand<-c(800,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400,2500,3000,5000,10000,15000,20000,42195/2,42195)
      for (i in afstand){
        if (input$genderhyb=="M"){
          index<-data.frame(c(1),c(2),c(3),c(4),c(5),c(6),c(7),c(8),c(9),c(10),c(11),c(12),c(13),c(14),c(15),c(16),c(17),c(18),c(19),c(20),c(21),c(22),c(23),c(24),c(25),c(26),c(27),c(28),c(29))
          colnames(index)=as.vector(seq(24,10,-0.5))
          output<-(as.numeric(input$VMA) + VMApredic[as.character(i)][index[,as.character(input$VMA)],])
          
        }
        else if (input$genderhyb=="F"){
          
        }
        allure<-c(allure,output)
      }
      
      plot(afstand, allure,xlab="Distance (m)",ylab="Allure (km/h)",type='o')
    }, res = 50)
    
    output$info <- renderPrint({
      allure<-c()
      afstand<-c(800,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400,2500,3000,5000,10000,15000,20000,42195/2,42195)
      for (i in afstand){
        if (input$genderhyb=="M"){
          index<-data.frame(c(1),c(2),c(3),c(4),c(5),c(6),c(7),c(8),c(9),c(10),c(11),c(12),c(13),c(14),c(15),c(16),c(17),c(18),c(19),c(20),c(21),c(22),c(23),c(24),c(25),c(26),c(27),c(28),c(29))
          colnames(index)=as.vector(seq(24,10,-0.5))
          output<-(as.numeric(input$VMA) + VMApredic[as.character(i)][index[,as.character(input$VMA)],])
          
        }
        else if (input$genderhyb=="F"){
          
        }
        allure<-c(allure,output)
      }
      req(input$plot_click)
      x<-round(input$plot_click$x)
      y <- 3600/round(input$plot_click$y,1)
      hours <- y %/% 3600
      minutes <- (y %% 3600) %/% 60
      remaining_seconds <- y %% 60
      
      # Format the time string
      time_string2 <- sprintf("%02d:%02d", as.integer(minutes), as.integer(remaining_seconds))
      cat(x, "m  ", time_string2, "min/km", sep = "")
    })
    
    output$result2<- renderPrint({
      result2()
    })
    output$result2a <- renderPrint({
      result2a()
    })
    output$result3<- renderPrint({
      result3()
    })
    output$result3a<- renderPrint({
      result3a()
    })
    output$result31<- renderPrint({
      result31()
    })
    output$result4<- renderPrint({
      result4()
    })
    output$result4a<- renderPrint({
      result4a()
    })
    output$result4b<- renderPrint({
      result4b()
    })
    output$result5a <- renderDataTable(result5a())
    output$result6 <- renderDataTable(result6())
    output$result7a <- renderPrint({result7a()})
    output$result7b <- renderPrint({result7b()})
    output$result8a <- renderDataTable(result8a())
}


shinyApp(ui = ui, server = server)
